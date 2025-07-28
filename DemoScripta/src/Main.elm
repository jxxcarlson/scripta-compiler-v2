module Main exposing (main)

import AppData
import Browser
import Browser.Dom
import Browser.Events
import Dict
import Document exposing (Document)
import Download
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import File.Download
import Generic.Compiler
import Html exposing (Html)
import Html.Attributes
import Json.Decode as Decode
import Json.Encode as Encode
import Keyboard
import List.Extra
import Ports
import Process
import Random
import Render.Export.LaTeX
import Render.Settings exposing (getThemedElementColor)
import ScriptaV2.API
import ScriptaV2.Compiler
import ScriptaV2.DifferentialCompiler
import ScriptaV2.Language
import ScriptaV2.Msg exposing (MarkupMsg)
import Task
import Theme
import Time


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize GotNewWindowDimensions
        , Sub.map KeyMsg Keyboard.subscriptions
        , Ports.receive PortMsgReceived
        , Time.every (30 * 1000) AutoSave -- Auto-save every 30 seconds
        , Time.every 1000 Tick -- Update time every second
        ]


type alias Model =
    { displaySettings : Generic.Compiler.DisplaySettings
    , sourceText : String
    , count : Int
    , windowWidth : Int
    , windowHeight : Int
    , currentLanguage : ScriptaV2.Language.Language
    , selectId : String
    , title : String
    , theme : Theme.Theme
    , pressedKeys : List Keyboard.Key
    , currentTime : Time.Posix
    , compilerOutput : ScriptaV2.Compiler.CompilerOutput
    , editRecord : ScriptaV2.DifferentialCompiler.EditRecord
    , documents : List Document
    , currentDocument : Maybe Document
    , showDocumentList : Bool
    , lastSaved : Time.Posix
    , userName : Maybe String
    }


textColor : Theme.Theme -> Element.Color
textColor theme =
    case theme of
        Theme.Light ->
            Element.rgb255 33 33 33

        -- Dark gray for light mode
        Theme.Dark ->
            Element.rgb255 240 240 240


backgroundColor : Theme.Theme -> Element.Color
backgroundColor theme =
    case theme of
        Theme.Light ->
            getThemedElementColor .background (Theme.mapTheme theme)

        Theme.Dark ->
            Element.rgb255 48 54 59


buttonTextColor : Theme.Theme -> Element.Color
buttonTextColor theme =
    case theme of
        Theme.Light ->
            Element.rgb255 255 165 0

        -- Darker orange for light mode
        Theme.Dark ->
            Element.rgb255 255 165 0


electricBlueColor : Theme.Theme -> Element.Color
electricBlueColor theme =
    case theme of
        Theme.Light ->
            Element.rgb255 20 123 255

        -- Bright electric blue for light mode
        Theme.Dark ->
            Element.rgb255 0 191 255


buttonBackgroundColor : Theme.Theme -> Element.Color
buttonBackgroundColor theme =
    case theme of
        Theme.Light ->
            Element.rgb255 25 25 35

        -- Light gray for light mode
        Theme.Dark ->
            backgroundColor theme


rightPanelBackgroundColor : Theme.Theme -> Element.Color
rightPanelBackgroundColor theme =
    case theme of
        Theme.Light ->
            Element.rgb255 230 230 230

        -- Light gray for light mode
        Theme.Dark ->
            backgroundColor theme



-- Brighter orange for dark mode


type Msg
    = NoOp
    | InputText String
    | Render MarkupMsg
    | GotNewWindowDimensions Int Int
    | KeyMsg Keyboard.Msg
    | ToggleTheme
    | CreateNewDocument
    | SaveDocument
    | LoadDocument String
    | DeleteDocument String
    | ToggleDocumentList
    | AutoSave Time.Posix
    | Tick Time.Posix
    | GeneratedId String
    | InitialDocumentId String String Time.Posix Theme.Theme String
    | ExportToLaTeX
    | ExportToRawLaTeX
    | DownloadScript
    | InputUserName String
    | LoadUserNameDelayed
    | PortMsgReceived (Result Decode.Error Ports.IncomingMsg)


type alias Flags =
    { window : { windowWidth : Int, windowHeight : Int }
    , currentTime : Int
    , theme : Maybe String
    }


initialDisplaySettings flags =
    { windowWidth = flags.window.windowWidth // 3
    , counter = 0
    , selectedId = "nada"
    , selectedSlug = Nothing
    , scale = 1.0
    , longEquationLimit = flags.window.windowWidth |> toFloat
    , data = Dict.empty
    , idsOfOpenNodes = []
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        theme =
            case flags.theme of
                Just "light" ->
                    Theme.Light

                Just "dark" ->
                    Theme.Dark

                _ ->
                    Theme.Dark

        displaySettings =
            initialDisplaySettings flags

        normalizedTex =
            normalize AppData.defaultDocumentText

        title_ =
            getTitle normalizedTex

        editRecord =
            ScriptaV2.DifferentialCompiler.init Dict.empty ScriptaV2.Language.EnclosureLang normalizedTex

        currentTime =
            Time.millisToPosix flags.currentTime
    in
    ( { displaySettings = displaySettings
      , sourceText = normalizedTex
      , count = 1
      , windowWidth = flags.window.windowWidth
      , windowHeight = flags.window.windowHeight
      , currentLanguage = ScriptaV2.Language.EnclosureLang
      , selectId = "@InitID"
      , title = title_
      , theme = theme
      , pressedKeys = []
      , currentTime = currentTime
      , compilerOutput =
            ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput (Theme.mapTheme theme) ScriptaV2.Compiler.SuppressDocumentBlocks displaySettings editRecord
      , editRecord = editRecord
      , documents = []
      , currentDocument = Nothing
      , showDocumentList = True
      , lastSaved = currentTime
      , userName = Nothing
      }
    , Cmd.batch
        [ Ports.send Ports.LoadDocuments
        , Task.perform Tick Time.now
        , Process.sleep 100
            |> Task.perform (always LoadUserNameDelayed)
        ]
    )



--type alias CompilerOutput =
--    { body : List (Element MarkupMsg)
--    , banner : Maybe (Element MarkupMsg)
--    , toc : List (Element MarkupMsg)
--    , title : Element MarkupMsg
--    }
--titleData : Maybe ExpressionBlock
--titleData =
--        Generic.ASTTools.getBlockByName "title" editRecord.tree
--
--properties =
--    Maybe.map .properties titleData |> Maybe.withDefault Dict.empty


getTitle : String -> String
getTitle str =
    str
        |> String.lines
        |> List.map String.trim
        |> List.Extra.dropWhile (\line -> line == "" || String.startsWith "|" line)
        |> List.head
        |> Maybe.withDefault "No title yet"


handleIncomingPortMsg : Ports.IncomingMsg -> Model -> ( Model, Cmd Msg )
handleIncomingPortMsg msg model =
    case msg of
        Ports.DocumentsLoaded docs ->
            let
                _ =
                    Debug.log "@@!!@@ Documents loaded from localStorage" (List.length docs)
            in
            ( { model | documents = docs }, Cmd.none )

        Ports.DocumentLoaded doc ->
            let
                _ =
                    Debug.log "@@!!@@ Loaded document" doc.title

                editRecord =
                    ScriptaV2.DifferentialCompiler.init Dict.empty model.currentLanguage doc.content
            in
            ( { model
                | currentDocument = Just doc
                , sourceText = doc.content
                , title = doc.title
                , editRecord = editRecord
                , lastSaved = doc.modifiedAt
                , compilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme model.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        model.displaySettings
                        editRecord
              }
            , Cmd.none
            )

        Ports.ThemeLoaded themeStr ->
            let
                newTheme =
                    case themeStr of
                        "light" ->
                            Theme.Light

                        _ ->
                            Theme.Dark

                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme newTheme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        model.displaySettings
                        model.editRecord
            in
            ( { model
                | theme = newTheme
                , compilerOutput = newCompilerOutput
              }
            , Cmd.none
            )

        Ports.UserNameLoaded name ->
            let
                _ =
                    Debug.log "@@!!@@ UserNameLoaded received" name
            in
            ( { model | userName = Just name }
            , Cmd.none
            )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotNewWindowDimensions width height ->
            ( { model | windowWidth = width, windowHeight = height }, Cmd.none )

        InputText str ->
            let
                editRecord =
                    ScriptaV2.DifferentialCompiler.update model.editRecord str

                oldDisplaySettings =
                    model.displaySettings

                newDisplaySettings =
                    { oldDisplaySettings
                        | --windowWidth = model.windowWidth
                          counter = model.count + 1
                        , selectedId = model.selectId
                    }
            in
            ( { model
                | sourceText = str
                , count = model.count + 1
                , displaySettings = newDisplaySettings
                , title = getTitle str
                , editRecord =
                    editRecord
                , compilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput (Theme.mapTheme model.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        newDisplaySettings
                        editRecord
              }
            , Cmd.none
            )

        KeyMsg keyMsg ->
            let
                pressedKeys =
                    Keyboard.update keyMsg model.pressedKeys

                cmd =
                    if List.member Keyboard.Control pressedKeys && List.member (Keyboard.Character "T") pressedKeys then
                        Task.perform (always ToggleTheme) (Task.succeed ())

                    else if List.member Keyboard.Control pressedKeys && List.member (Keyboard.Character "E") pressedKeys then
                        let
                            settings =
                                Render.Settings.makeSettings (Theme.mapTheme model.theme) "-" Nothing 1.0 model.windowWidth Dict.empty

                            exportText =
                                Render.Export.LaTeX.export model.currentTime settings model.editRecord.tree
                        in
                        File.Download.string (model.title ++ ".tex") "application/x-latex" exportText

                    else if List.member Keyboard.Control pressedKeys && List.member (Keyboard.Character "R") pressedKeys then
                        let
                            settings =
                                Render.Settings.makeSettings (Theme.mapTheme model.theme) "-" Nothing 1.0 model.windowWidth Dict.empty

                            exportText =
                                Render.Export.LaTeX.rawExport settings model.editRecord.tree
                        in
                        File.Download.string (model.title ++ ".tex") "application/x-latex" exportText

                    else
                        Cmd.none
            in
            ( { model
                | pressedKeys =
                    if List.length pressedKeys > 1 then
                        []

                    else
                        pressedKeys
              }
            , cmd
            )

        Render msg_ ->
            case msg_ of
                ScriptaV2.Msg.SelectId id ->
                    if id == "title" then
                        ( { model | selectId = id }, jumpToTopOf "rendered-text" )

                    else
                        ( { model | selectId = id }, Cmd.none )

                ScriptaV2.Msg.SendLineNumber line ->
                    ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ToggleTheme ->
            let
                newTheme =
                    case model.theme of
                        Theme.Light ->
                            Theme.Dark

                        Theme.Dark ->
                            Theme.Light

                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme newTheme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        model.displaySettings
                        model.editRecord
            in
            ( { model
                | theme = newTheme
                , compilerOutput = newCompilerOutput
                , count = model.count + 1
              }
            , Ports.send
                (Ports.SaveTheme
                    (case newTheme of
                        Theme.Light ->
                            "light"

                        Theme.Dark ->
                            "dark"
                    )
                )
            )

        CreateNewDocument ->
            ( model
            , Random.generate GeneratedId generateId
            )

        GeneratedId id ->
            let
                newDocumentContent =
                    "| title\nNew Document\n"

                newDoc =
                    Document.newDocument id "New Document" (Maybe.withDefault "" model.userName) newDocumentContent model.theme model.currentTime

                editRecord =
                    ScriptaV2.DifferentialCompiler.init Dict.empty model.currentLanguage newDocumentContent
            in
            ( { model
                | currentDocument = Just newDoc
                , sourceText = newDocumentContent
                , title = "New Document"
                , editRecord = editRecord
                , compilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme model.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        model.displaySettings
                        editRecord
              }
            , Ports.send (Ports.SaveDocument newDoc)
            )

        SaveDocument ->
            case model.currentDocument of
                Just doc ->
                    let
                        updatedDoc =
                            { doc
                                | content = model.sourceText
                                , title = model.title
                                , modifiedAt = model.currentTime
                                , theme = model.theme
                            }
                    in
                    ( { model
                        | currentDocument = Just updatedDoc
                        , lastSaved = model.currentTime
                      }
                    , Ports.send (Ports.SaveDocument updatedDoc)
                    )

                Nothing ->
                    -- Create a new document if none exists
                    update CreateNewDocument model

        LoadDocument id ->
            ( model, Ports.send (Ports.LoadDocument id) )

        DeleteDocument id ->
            let
                updatedDocuments =
                    List.filter (\d -> d.id /= id) model.documents

                needNewDoc =
                    case model.currentDocument of
                        Just doc ->
                            doc.id == id

                        Nothing ->
                            False
            in
            ( { model
                | documents = updatedDocuments
                , currentDocument =
                    if needNewDoc then
                        Nothing

                    else
                        model.currentDocument
                , sourceText =
                    if needNewDoc then
                        ""

                    else
                        model.sourceText
                , title =
                    if needNewDoc then
                        "Untitled Document"

                    else
                        model.title
              }
            , Ports.send (Ports.DeleteDocument id)
            )

        ToggleDocumentList ->
            ( { model | showDocumentList = not model.showDocumentList }, Cmd.none )

        AutoSave _ ->
            case model.currentDocument of
                Just doc ->
                    if model.sourceText /= doc.content then
                        update SaveDocument model

                    else
                        ( model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        Tick time ->
            ( { model | currentTime = time, count = model.count + 1 }, Cmd.none )

        ExportToLaTeX ->
            let
                settings =
                    Render.Settings.makeSettings (Theme.mapTheme model.theme) "-" Nothing 1.0 model.windowWidth Dict.empty

                exportText =
                    Render.Export.LaTeX.export model.currentTime settings model.editRecord.tree
            in
            ( model, File.Download.string (model.title ++ ".tex") "application/x-latex" exportText )

        ExportToRawLaTeX ->
            let
                settings =
                    Render.Settings.makeSettings (Theme.mapTheme model.theme) "-" Nothing 1.0 model.windowWidth Dict.empty

                exportText =
                    Render.Export.LaTeX.rawExport settings model.editRecord.tree
            in
            ( model, File.Download.string (model.title ++ ".tex") "application/x-latex" exportText )

        DownloadScript ->
            ( model, File.Download.string "process_images.sh" "application/x-sh" AppData.processImagesText )

        InitialDocumentId content title currentTime theme id ->
            let
                initialDoc =
                    Document.newDocument id title (Maybe.withDefault "" model.userName) content theme currentTime
            in
            ( { model | currentDocument = Just initialDoc }
            , Ports.send (Ports.SaveDocument initialDoc)
            )

        InputUserName name ->
            ( { model | userName = Just name }
            , Ports.send (Ports.SaveUserName name)
            )

        LoadUserNameDelayed ->
            ( model
            , Ports.send Ports.LoadUserName
                |> Debug.log "@@!!@@ Loading username after delay"
            )

        PortMsgReceived result ->
            case result of
                Ok incomingMsg ->
                    handleIncomingPortMsg incomingMsg model

                Err error ->
                    let
                        _ =
                            Debug.log "@@!!@@ Port decoding error" error
                    in
                    ( model, Cmd.none )



-- VIEW
--


background_ model =
    Background.color <| backgroundColor model.theme


rightPanelBackground_ model =
    Background.color <| rightPanelBackgroundColor model.theme


view : Model -> Html Msg
view model =
    layoutWith { options = [ Element.focusStyle noFocus ] }
        [ background_ model
        , Element.htmlAttribute (Html.Attributes.style "height" "100vh")
        , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
        ]
        (mainColumn model)



-- GEOMETRY


appWidth : Model -> Int
appWidth model =
    model.windowWidth


appHeight : Model -> Int
appHeight model =
    model.windowHeight - headerHeight


sidebarWidth =
    260


marginWidth =
    16


panelWidth : Model -> Int
panelWidth model =
    (appWidth model - sidebarWidth - 16 - 4 - 16) // 2



-- 16 for padding, 4 for spacing, 16 for padding


panelHeight : Model -> Attribute msg
panelHeight model =
    height (px <| model.windowHeight - 100)


margin =
    { left = 0, right = 0, top = 2, bottom = 0, between = 4 }


headerHeight =
    90


mainColumn : Model -> Element Msg
mainColumn model =
    column (background_ model :: mainColumnStyle)
        [ column
            [ width fill
            , height fill
            , clipY
            , Element.htmlAttribute (Html.Attributes.style "display" "flex")
            , Element.htmlAttribute (Html.Attributes.style "flex-direction" "column")
            ]
            [ header model
            , Element.el
                [ width fill
                , height (px 1)
                , Background.color (borderColor model)
                ]
                Element.none
            , row
                [ width fill
                , height fill
                , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
                , paddingXY 0 0
                ]
                [ inputText model
                , Element.el
                    [ width (px 1)
                    , height fill
                    , Background.color (borderColor model)
                    ]
                    Element.none
                , displayRenderedText model |> Element.map Render
                , Element.el
                    [ width (px 1)
                    , height fill
                    , Background.color (borderColor model)
                    ]
                    Element.none
                , sidebar model
                ]
            ]
        ]


sidebar : Model -> Element.Element Msg
sidebar model =
    let
        forceColorStyle =
            case model.theme of
                Theme.Light ->
                    Element.htmlAttribute (Html.Attributes.style "color" "black")

                Theme.Dark ->
                    Element.htmlAttribute (Html.Attributes.style "color" "white")
    in
    Element.column
        [ Element.width <| px <| sidebarWidth
        , height fill
        , Font.color (textColor model.theme)
        , Font.size 14
        , rightPanelBackground_ model
        , forceColorStyle
        , Border.widthEach { left = 1, right = 0, top = 0, bottom = 0 }
        , Border.color (Element.rgb 0.5 0.5 0.5)
        ]
        [ -- Documents section that can grow
          Element.column
            [ width fill
            , height fill
            , Element.paddingXY 16 16
            , Element.spacing 12
            , scrollbarY
            , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
            , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
            , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
            ]
            [ -- User name section
              Element.el [ Font.bold, paddingEach { top = 0, bottom = 8, left = 0, right = 0 } ]
                (Element.text "Your Name")
            , Input.text
                [ width fill
                , paddingXY 8 4
                , Border.width 1
                , Border.rounded 4
                , Border.color (Element.rgba 0.5 0.5 0.5 0.3)
                , Background.color (backgroundColor model.theme)
                , Font.color (textColor model.theme)
                , Font.size 14
                ]
                { onChange = InputUserName
                , text = Maybe.withDefault "" model.userName
                , placeholder = Just (Input.placeholder [] (text "Enter your name"))
                , label = Input.labelHidden "Your name"
                }

            -- Document management section
            , Element.el [ Font.bold, paddingEach { top = 16, bottom = 8, left = 0, right = 0 } ]
                (Element.text "Documents")
            , Element.row [ spacing 8, width fill ]
                []
            , crudButtons model
            , lastSaveInfo model
            , exportStuff model
            , if model.showDocumentList then
                Element.column
                    [ spacing 4
                    , paddingEach { top = 12, bottom = 0, left = 0, right = 0 }
                    , width fill
                    , height (px 300)
                    , scrollbarY
                    , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
                    , Element.htmlAttribute (Html.Attributes.style "overflow-x" "hidden")
                    ]
                    (List.map (documentItem model) model.documents)

              else
                Element.none
            ]

        -- Tools section at the bottom
        , Element.column
            [ width fill
            , alignBottom
            , Element.paddingXY 16 16
            , Element.spacing 12
            , Border.widthEach { left = 0, right = 0, top = 1, bottom = 0 }
            , Border.color (Element.rgb 0.5 0.5 0.5)
            ]
            [ Element.el [ Font.bold, paddingEach { top = 0, bottom = 8, left = 0, right = 0 } ]
                (Element.text "Tools:")
            , Input.button
                [ Background.color (buttonBackgroundColor model.theme)
                , Font.color (electricBlueColor model.theme)
                , paddingXY 12 8
                , Border.rounded 4
                , Border.width 1
                , Border.color (Element.rgba 0.5 0.5 0.5 0.3)
                , mouseOver
                    [ Background.color (Element.rgba 0.5 0.5 0.5 0.2)
                    , Border.color (Element.rgba 0.5 0.5 0.5 0.5)
                    ]
                , mouseDown
                    [ Background.color (Element.rgba 0.5 0.5 0.5 0.3)
                    , Border.color (Element.rgba 0.5 0.5 0.5 0.7)
                    ]
                , Element.htmlAttribute
                    (Html.Attributes.style "color"
                        (case model.theme of
                            Theme.Light ->
                                "rgb(0, 123, 255)"

                            Theme.Dark ->
                                "rgb(0, 191, 255)"
                        )
                    )
                , width fill
                ]
                { onPress = Just DownloadScript
                , label = text "Download script"
                }
            ]
        ]


crudButtons : Model -> Element Msg
crudButtons model =
    Element.row [ spacing 8, width fill ]
        [ newButton model
        , saveButton model
        , listButton model
        ]


newButton model =
    Input.button
        [ Background.color (buttonBackgroundColor model.theme)
        , Font.color (buttonTextColor model.theme)
        , paddingXY 12 8
        , Border.rounded 4
        , Border.width 1
        , Border.color (Element.rgba 0.5 0.5 0.5 0.3)
        , mouseOver
            [ Background.color (Element.rgba 0.5 0.5 0.5 0.2)
            , Border.color (Element.rgba 0.5 0.5 0.5 0.5)
            ]
        , mouseDown
            [ Background.color (Element.rgba 0.5 0.5 0.5 0.3)
            , Border.color (Element.rgba 0.5 0.5 0.5 0.7)
            ]
        , Element.htmlAttribute
            (Html.Attributes.style "color"
                (case model.theme of
                    Theme.Light ->
                        "rgb(255, 140, 0)"

                    Theme.Dark ->
                        "rgb(255, 165, 0)"
                )
            )
        ]
        { onPress = Just CreateNewDocument
        , label = text "New"
        }


saveButton model =
    Input.button
        [ Background.color (buttonBackgroundColor model.theme)
        , Font.color (buttonTextColor model.theme)
        , paddingXY 12 8
        , Border.rounded 4
        , Border.width 1
        , Border.color (Element.rgba 0.5 0.5 0.5 0.3)
        , mouseOver
            [ Background.color (Element.rgba 0.5 0.5 0.5 0.2)
            , Border.color (Element.rgba 0.5 0.5 0.5 0.5)
            ]
        , mouseDown
            [ Background.color (Element.rgba 0.5 0.5 0.5 0.3)
            , Border.color (Element.rgba 0.5 0.5 0.5 0.7)
            ]
        , Element.htmlAttribute
            (Html.Attributes.style "color"
                (case model.theme of
                    Theme.Light ->
                        "rgb(255, 140, 0)"

                    Theme.Dark ->
                        "rgb(255, 165, 0)"
                )
            )
        ]
        { onPress = Just SaveDocument
        , label = text "Save"
        }


lastSaveInfo model =
    case model.currentDocument of
        Just doc ->
            Element.el [ paddingEach { top = 12, bottom = 0, left = 0, right = 0 }, Font.size 14 ]
                (text <| "Last saved: " ++ formatRelativeTime model.currentTime model.lastSaved)

        Nothing ->
            Element.none


listButton model =
    Input.button
        [ Background.color (buttonBackgroundColor model.theme)
        , Font.color (buttonTextColor model.theme)
        , paddingXY 12 8
        , Border.rounded 4
        , Border.width 1
        , Border.color (Element.rgba 0.5 0.5 0.5 0.3)
        , mouseOver
            [ Background.color (Element.rgba 0.5 0.5 0.5 0.2)
            , Border.color (Element.rgba 0.5 0.5 0.5 0.5)
            ]
        , mouseDown
            [ Background.color (Element.rgba 0.5 0.5 0.5 0.3)
            , Border.color (Element.rgba 0.5 0.5 0.5 0.7)
            ]
        , Element.htmlAttribute
            (Html.Attributes.style "color"
                (case model.theme of
                    Theme.Light ->
                        "rgb(255, 140, 0)"

                    Theme.Dark ->
                        "rgb(255, 165, 0)"
                )
            )
        ]
        { onPress = Just ToggleDocumentList
        , label = text "List"
        }


exportStuff model =
    Element.row [ spacing 8, width fill ]
        [ Input.button
            [ Background.color (buttonBackgroundColor model.theme)
            , Font.color (buttonTextColor model.theme)
            , paddingXY 12 8
            , Border.rounded 4
            , Border.width 1
            , Border.color (Element.rgba 0.5 0.5 0.5 0.3)
            , mouseOver
                [ Background.color (Element.rgba 0.5 0.5 0.5 0.2)
                , Border.color (Element.rgba 0.5 0.5 0.5 0.5)
                ]
            , mouseDown
                [ Background.color (Element.rgba 0.5 0.5 0.5 0.3)
                , Border.color (Element.rgba 0.5 0.5 0.5 0.7)
                ]
            , Element.htmlAttribute
                (Html.Attributes.style "color"
                    (case model.theme of
                        Theme.Light ->
                            "rgb(255, 140, 0)"

                        Theme.Dark ->
                            "rgb(255, 165, 0)"
                    )
                )
            ]
            { onPress = Just ExportToLaTeX
            , label = text "LaTeX"
            }
        , Input.button
            [ Background.color (buttonBackgroundColor model.theme)
            , Font.color (buttonTextColor model.theme)
            , paddingXY 12 8
            , Border.rounded 4
            , Border.width 1
            , Border.color (Element.rgba 0.5 0.5 0.5 0.3)
            , mouseOver
                [ Background.color (Element.rgba 0.5 0.5 0.5 0.2)
                , Border.color (Element.rgba 0.5 0.5 0.5 0.5)
                ]
            , mouseDown
                [ Background.color (Element.rgba 0.5 0.5 0.5 0.3)
                , Border.color (Element.rgba 0.5 0.5 0.5 0.7)
                ]
            , Element.htmlAttribute
                (Html.Attributes.style "color"
                    (case model.theme of
                        Theme.Light ->
                            "rgb(255, 140, 0)"

                        Theme.Dark ->
                            "rgb(255, 165, 0)"
                    )
                )
            ]
            { onPress = Just ExportToRawLaTeX
            , label = text "Raw LaTeX"
            }
        ]


documentItem : Model -> Document -> Element Msg
documentItem model doc =
    let
        isActive =
            case model.currentDocument of
                Just currentDoc ->
                    currentDoc.id == doc.id

                Nothing ->
                    False

        borderAttrs =
            if isActive then
                [ Border.width 1
                , Border.color
                    (case model.theme of
                        Theme.Light ->
                            Element.rgb255 64 64 64

                        -- Dark gray for light mode
                        Theme.Dark ->
                            Element.rgb255 220 220 220
                     -- Almost white for dark mode
                    )
                ]

            else
                []
    in
    Element.row
        ([ width fill
         , padding 8
         , Border.rounded 4
         , spacing 8
         , mouseOver [ Background.color (Element.rgba 0.5 0.5 0.5 0.2) ]
         ]
            ++ borderAttrs
        )
        [ Input.button
            [ width fill ]
            { onPress = Just (LoadDocument doc.id)
            , label =
                Element.column [ spacing 2 ]
                    [ Element.el [ Font.size 13 ] (text doc.title)
                    , Element.el [ Font.size 11, Font.color (Element.rgb 0.7 0.7 0.7) ]
                        (text <| formatRelativeTime model.currentTime doc.modifiedAt)
                    ]
            }
        , Input.button
            [ Font.color (Element.rgb 1 0.5 0.5)
            , mouseOver [ Font.color (Element.rgb 1 0.3 0.3) ]
            , mouseDown [ Font.color (Element.rgb 1 0.2 0.2) ]
            ]
            { onPress = Just (DeleteDocument doc.id)
            , label = text "×"
            }
        ]


formatTime : Time.Posix -> String
formatTime time =
    let
        millis =
            Time.posixToMillis time

        seconds =
            millis // 1000

        minutes =
            seconds // 60

        hours =
            minutes // 60
    in
    if millis == 0 then
        "Never"

    else if seconds < 60 then
        "Just now"

    else if minutes < 60 then
        String.fromInt minutes ++ " min ago"

    else if hours < 24 then
        String.fromInt hours ++ " hr ago"

    else
        String.fromInt (hours // 24) ++ " days ago"


formatRelativeTime : Time.Posix -> Time.Posix -> String
formatRelativeTime currentTime savedTime =
    let
        currentMillis =
            Time.posixToMillis currentTime

        savedMillis =
            Time.posixToMillis savedTime

        diffMillis =
            currentMillis - savedMillis

        seconds =
            diffMillis // 1000

        minutes =
            seconds // 60

        hours =
            minutes // 60
    in
    if savedMillis == 0 then
        "Never"

    else if seconds < 5 then
        "Just now"

    else if seconds < 60 then
        String.fromInt seconds ++ " seconds ago"

    else if minutes < 60 then
        String.fromInt minutes
            ++ " minute"
            ++ (if minutes == 1 then
                    ""

                else
                    "s"
               )
            ++ " ago"

    else if hours < 24 then
        String.fromInt hours
            ++ " hour"
            ++ (if hours == 1 then
                    ""

                else
                    "s"
               )
            ++ " ago"

    else
        String.fromInt (hours // 24)
            ++ " day"
            ++ (if hours // 24 == 1 then
                    ""

                else
                    "s"
               )
            ++ " ago"


noFocus : Element.FocusStyle
noFocus =
    { borderColor = Nothing
    , backgroundColor = Nothing
    , shadow = Nothing
    }


titleElement : String -> Element msg
titleElement str =
    row [ centerX, Font.bold, fontGray 0.9 ] [ text str ]


displayRenderedText : Model -> Element MarkupMsg
displayRenderedText model =
    let
        forceColorStyle =
            case model.theme of
                Theme.Light ->
                    Element.htmlAttribute (Html.Attributes.style "color" "black")

                Theme.Dark ->
                    Element.htmlAttribute (Html.Attributes.style "color" "white")
    in
    Element.el
        [ alignTop
        , height fill
        , width (px <| panelWidth model)
        , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
        , Element.htmlAttribute (Html.Attributes.style "position" "relative")
        , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
        ]
        (Element.el
            [ width fill
            , height fill
            , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
            , Element.htmlAttribute (Html.Attributes.style "overflow-x" "hidden")
            , Element.htmlAttribute (Html.Attributes.style "position" "absolute")
            , Element.htmlAttribute (Html.Attributes.style "top" "0")
            , Element.htmlAttribute (Html.Attributes.style "left" "0")
            , Element.htmlAttribute (Html.Attributes.style "right" "0")
            , Element.htmlAttribute (Html.Attributes.style "bottom" "0")
            , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
            ]
            (column [ Font.size 14, height fill, width fill ]
                [ column
                    [ background_ model
                    , spacing 24
                    , width fill
                    , htmlId "rendered-text"
                    , alignTop
                    , centerX
                    , Font.color (textColor model.theme)
                    , forceColorStyle
                    , Element.htmlAttribute (Html.Attributes.style "padding" "16px")
                    , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
                    ]
                    [ container model model.compilerOutput.body ]
                ]
            )
        )



--container : (a -> List (Element msg)) -> a -> Element msg


container : Model -> List (Element msg) -> Element msg
container model elements_ =
    Element.column (background_ model :: [ Element.centerX, spacing 24 ]) elements_


compile : Model -> List (Element MarkupMsg)
compile model =
    ScriptaV2.API.compileStringWithTitle
        (Theme.mapTheme model.theme)
        ""
        { filter = ScriptaV2.Compiler.SuppressDocumentBlocks
        , lang = ScriptaV2.Language.EnclosureLang
        , docWidth = panelWidth model - 200 --5 * xPadding
        , editCount = model.count
        , selectedId = model.selectId
        , idsOfOpenNodes = []
        }
        model.sourceText


htmlId str =
    Element.htmlAttribute (Html.Attributes.id str)


header : Model -> Element msg
header model =
    let
        debugTextColor =
            case model.theme of
                Theme.Light ->
                    Element.rgb255 0 0 0

                -- Black for light mode
                Theme.Dark ->
                    Element.rgb255 255 255 255

        -- Pure white for dark mode
        themeLabel =
            case model.theme of
                Theme.Light ->
                    "Light Mode"

                Theme.Dark ->
                    "Dark Mode"

        -- Force color with HTML style attribute
        forceColorStyle =
            case model.theme of
                Theme.Light ->
                    Element.htmlAttribute (Html.Attributes.style "color" "black")

                Theme.Dark ->
                    Element.htmlAttribute (Html.Attributes.style "color" "white")
    in
    Element.row
        [ Element.height <| Element.px <| headerHeight
        , Element.width <| Element.fill

        -- , Element.width <| Element.px <| appWidth model
        , Element.spacing 32
        , Element.centerX
        , Background.color (backgroundColor model.theme)
        , paddingEach { left = 18, right = 18, top = 0, bottom = 0 }
        , forceColorStyle
        , Border.widthEach { left = 0, right = 0, top = 0, bottom = 1 }
        , Border.color (borderColor model)
        ]
        [ Element.el
            [ centerX
            , centerY
            , Font.color debugTextColor
            , Font.size 18
            , Font.semiBold
            , forceColorStyle
            ]
            (Element.text <| "Scripta Live: " ++ model.title)
        ]


borderColor model =
    case model.theme of
        Theme.Light ->
            Element.rgb 0.5 0.5 0.5

        Theme.Dark ->
            Element.rgb 0.5 0.5 0.5


innerMarginWidth =
    16


inputText : Model -> Element Msg
inputText model =
    let
        forceColorStyle =
            case model.theme of
                Theme.Light ->
                    Element.htmlAttribute (Html.Attributes.style "color" "black")

                Theme.Dark ->
                    Element.htmlAttribute (Html.Attributes.style "color" "white")
    in
    Element.el
        [ alignTop
        , height fill
        , width (px <| panelWidth model)
        , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
        , Element.htmlAttribute (Html.Attributes.style "position" "relative")
        , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
        ]
        (Element.el
            [ width fill
            , height fill
            , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
            , Element.htmlAttribute (Html.Attributes.style "overflow-x" "hidden")
            , Element.htmlAttribute (Html.Attributes.style "position" "absolute")
            , Element.htmlAttribute (Html.Attributes.style "top" "0")
            , Element.htmlAttribute (Html.Attributes.style "left" "0")
            , Element.htmlAttribute (Html.Attributes.style "right" "0")
            , Element.htmlAttribute (Html.Attributes.style "bottom" "0")
            , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
            ]
            (Input.multiline
                [ width fill
                , height fill
                , Font.size 14
                , Element.alignTop
                , Font.color (textColor model.theme)
                , Background.color (backgroundColor model.theme)
                , forceColorStyle
                , Element.htmlAttribute (Html.Attributes.id "source-text-input")
                , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
                , Element.htmlAttribute (Html.Attributes.style "padding" "8px 8px 24px 8px")
                ]
                { onChange = InputText
                , text = model.sourceText
                , placeholder = Nothing
                , label = Input.labelAbove [] <| el [] (text "")
                , spellcheck = False
                }
            )
        )


fontGray g =
    Font.color (Element.rgb g g g)


bgGray g =
    Background.color (Element.rgb g g g)


mainColumnStyle =
    [ width fill
    , height fill
    ]



-- HELPER FUNCTIONS


normalize : String -> String
normalize input =
    input
        |> String.lines
        |> List.map String.trim
        |> String.join "\n"


scrollToTop : Cmd Msg
scrollToTop =
    Browser.Dom.setViewport 0 0 |> Task.perform (\() -> NoOp)


jumpToTopOf : String -> Cmd Msg
jumpToTopOf id =
    Browser.Dom.getViewportOf id
        |> Task.andThen (\info -> Browser.Dom.setViewportOf id 0 0)
        |> Task.attempt (\_ -> NoOp)



-- ID GENERATION


generateId : Random.Generator String
generateId =
    Random.int 100000 999999
        |> Random.map (\n -> "doc-" ++ String.fromInt n)
