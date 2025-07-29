module Main exposing (main)

import AppData
import Browser
import Browser.Dom
import Browser.Events
import Constants exposing (constants)
import Dict
import Document exposing (Document)
import Editor
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import File.Download
import Html exposing (Html)
import Html.Attributes
import Keyboard
import Model exposing (Model, Msg(..))
import Ports
import Random
import Render.Export.LaTeX
import Render.Settings
import ScriptaV2.API
import ScriptaV2.Compiler
import ScriptaV2.DifferentialCompiler
import ScriptaV2.Language
import ScriptaV2.Msg exposing (MarkupMsg)
import Style
import Task
import Theme
import Time
import Widget


main =
    Browser.element
        { init = Model.init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Browser.Events.onResize GotNewWindowDimensions
        , Sub.map KeyMsg Keyboard.subscriptions
        , Ports.receive PortMsgReceived
        , Time.every (30 * 1000) AutoSave -- Auto-save every 30 seconds
        , Time.every 1000 Tick -- Update time every second
        ]



--
--getTitle : String -> String
--getTitle str =
--    str
--        |> String.lines
--        |> List.map String.trim
--        |> List.Extra.dropWhile (\line -> line == "" || String.startsWith "|" line)
--        |> List.head
--        |> Maybe.withDefault "No title yet"
--


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
                , initialText = doc.content -- Set initialText when loading a document
                , title = doc.title
                , editRecord = editRecord
                , lastSaved = doc.modifiedAt
                , lastLoadedDocumentId = Just doc.id
                , loadDocumentIntoEditor = True -- Trigger load
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
                , title = Model.getTitle str
                , lastChanged = model.currentTime
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

        InputText2 { position, source } ->
            let
                editRecord =
                    ScriptaV2.DifferentialCompiler.update model.editRecord source

                oldDisplaySettings =
                    model.displaySettings

                newDisplaySettings =
                    { oldDisplaySettings
                        | counter = model.count + 1
                        , selectedId = model.selectId
                    }
            in
            ( { model
                | sourceText = source
                , count = model.count + 1
                , displaySettings = newDisplaySettings
                , title = Model.getTitle source
                , lastChanged = model.currentTime
                , editRecord = editRecord
                , loadDocumentIntoEditor = False -- Turn off loading after edit
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
            -- Save current document before creating new one
            case model.currentDocument of
                Just doc ->
                    if model.sourceText /= doc.content then
                        -- Current document has unsaved changes, save it first
                        let
                            ( newModel, saveCmd ) =
                                update SaveDocument model
                        in
                        ( newModel
                        , Cmd.batch
                            [ saveCmd
                            , Random.generate GeneratedId generateId
                            ]
                        )

                    else
                        -- No unsaved changes
                        ( model
                        , Random.generate GeneratedId generateId
                        )

                Nothing ->
                    -- No current document
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
                , initialText = newDocumentContent -- Set initialText for new document
                , title = "New Document"
                , editRecord = editRecord
                , lastLoadedDocumentId = Just id
                , loadDocumentIntoEditor = True -- Trigger load for new document
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
            -- Save current document before loading new one
            case model.currentDocument of
                Just doc ->
                    if model.sourceText /= doc.content then
                        -- Current document has unsaved changes, save it first
                        let
                            updatedDoc =
                                { doc
                                    | content = model.sourceText
                                    , title = model.title
                                    , modifiedAt = model.currentTime
                                    , theme = model.theme
                                }

                            ( newModel, saveCmd ) =
                                update SaveDocument model
                        in
                        ( newModel
                        , Cmd.batch
                            [ saveCmd
                            , Ports.send (Ports.LoadDocument id)
                            ]
                        )

                    else
                        -- No unsaved changes, just load the new document
                        ( model, Ports.send (Ports.LoadDocument id) )

                Nothing ->
                    -- No current document, just load the new one
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
            let
                timeSinceLastChange =
                    (Time.posixToMillis time - Time.posixToMillis model.lastChanged) // 1000

                shouldAutoSave =
                    case model.currentDocument of
                        Just doc ->
                            model.sourceText /= doc.content && timeSinceLastChange >= constants.maxUnsavedDuration

                        Nothing ->
                            False
            in
            if shouldAutoSave then
                update SaveDocument { model | currentTime = time, count = model.count + 1 }

            else
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

        _ ->
            ( model, Cmd.none )



-- VIEW
--


view : Model -> Html Msg
view model =
    layoutWith { options = [ Element.focusStyle noFocus ] }
        [ Style.background_ model.theme
        , Element.htmlAttribute (Html.Attributes.style "height" "100vh")
        ]
        (mainColumn model)



-- GEOMETRY


appWidth : Model -> Int
appWidth model =
    model.windowWidth


sidebarWidth =
    260


panelWidth : Model -> Int
panelWidth model =
    (appWidth model - sidebarWidth - 16 - 4 - 16) // 2


headerHeight =
    90


mainColumn : Model -> Element Msg
mainColumn model =
    column (Style.background_ model.theme :: mainColumnStyle)
        [ column
            [ width fill
            , height fill
            , Element.htmlAttribute (Html.Attributes.style "display" "flex")
            , Element.htmlAttribute (Html.Attributes.style "flex-direction" "column")
            ]
            [ header model
            , Element.el
                [ width fill
                , height (px 1)
                , Background.color (Style.borderColor model.theme)
                ]
                Element.none
            , row
                [ width fill
                , height fill
                , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
                ]
                [ Editor.view model

                -- inputText model
                , Element.el
                    [ width (px 1)
                    , height fill
                    , Background.color (Style.borderColor model.theme)
                    ]
                    Element.none
                , displayRenderedText model |> Element.map Render
                , Element.el
                    [ width (px 1)
                    , height fill
                    , Background.color (Style.borderColor model.theme)
                    ]
                    Element.none
                , sidebar model
                ]
            ]
        ]


sidebar : Model -> Element.Element Msg
sidebar model =
    Element.column
        [ Element.width <| px <| sidebarWidth
        , height fill
        , Font.color (Style.textColor model.theme)
        , Font.size 14
        , Style.rightPanelBackground_ model.theme
        , Style.forceColorStyle model.theme
        , Border.widthEach { left = 1, right = 0, top = 0, bottom = 0 }
        , Border.color (Element.rgb 0.5 0.5 0.5)
        ]
        [ -- Documents section that can grow
          Element.column
            Style.innerColumn
            [ -- User name section
              case model.userName of
                Just name ->
                    if String.trim name /= "" then
                        -- Show just the username when it's filled
                        Widget.inputTextWidget model.theme name InputUserName

                    else
                        -- Show label and input when empty
                        Element.column [ spacing 8 ]
                            [ Element.el [ Font.bold, paddingEach { top = 0, bottom = 8, left = 0, right = 0 } ]
                                (Element.text "Your Name")
                            , Widget.inputTextWidget model.theme name InputUserName
                            ]

                Nothing ->
                    -- Show label and input when Nothing
                    Element.column [ spacing 8 ]
                        [ Element.el [ Font.bold, paddingEach { top = 0, bottom = 8, left = 0, right = 0 } ]
                            (Element.text "Your Name")
                        , Widget.inputTextWidget model.theme "" InputUserName
                        ]

            -- Theme toggle and Document management section
            , Element.row
                [ paddingEach { top = 16, bottom = 8, left = 0, right = 0 }
                , width fill
                , spacing 8
                ]
                [ -- Theme toggle button
                  Element.row
                    [ Border.width 1
                    , Border.color (Element.rgb 0.7 0.7 0.7)
                    , Border.rounded 4
                    , height (px 30)
                    ]
                    [ Input.button
                        [ paddingXY 12 6
                        , Background.color
                            (if model.theme == Theme.Dark then
                                Style.buttonBackgroundColor model.theme

                             else
                                Element.rgb255 230 230 230
                            )
                        , Font.color
                            (if model.theme == Theme.Dark then
                                Style.buttonTextColor model.theme

                             else
                                Element.rgb255 100 100 100
                            )
                        , Border.roundEach { topLeft = 4, bottomLeft = 4, topRight = 0, bottomRight = 0 }
                        , Font.size 14
                        , Font.bold
                        ]
                        { onPress = Just ToggleTheme
                        , label = Element.text "Dark"
                        }
                    , Widget.sidebarButton model.theme (Just ToggleTheme) "Light"
                    ]
                ]
            , Element.row [ spacing 8, width fill ]
                []
            , crudButtons model

            -- , lastSaveInfo model  -- Now shown per document
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
                [ Background.color (Style.buttonBackgroundColor model.theme)
                , Font.color (Style.electricBlueColor model.theme)
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
    Widget.sidebarButton model.theme (Just CreateNewDocument) "New"


saveButton model =
    Widget.sidebarButton model.theme (Just SaveDocument) "Save"


listButton model =
    Widget.sidebarButton model.theme (Just ToggleDocumentList) "List"


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


exportStuff model =
    Element.row [ spacing 8, width fill ]
        [ Widget.sidebarButton model.theme (Just ExportToLaTeX) "LaTeX"
        , Widget.sidebarButton model.theme (Just ExportToRawLaTeX) "Raw LaTeX"
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
                    , Element.el
                        [ Font.size 11
                        , Font.color
                            (case model.theme of
                                Theme.Light ->
                                    Element.rgb 0.4 0.4 0.4

                                -- Darker gray for light mode
                                Theme.Dark ->
                                    Element.rgb 0.7 0.7 0.7
                             -- Original lighter gray for dark mode
                            )
                        ]
                        (text <| Style.formatRelativeTime model.currentTime doc.modifiedAt)
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


noFocus : Element.FocusStyle
noFocus =
    { borderColor = Nothing
    , backgroundColor = Nothing
    , shadow = Nothing
    }


displayRenderedText : Model -> Element MarkupMsg
displayRenderedText model =
    Element.el
        [ alignTop
        , height fill
        , width (px <| panelWidth model)
        , Element.scrollbarY
        ]
        (column [ Font.size 14, padding 16, spacing 24, width fill ]
            [ column
                [ Style.background_ model.theme
                , spacing 24
                , width fill
                , Style.htmlId "rendered-text"
                , alignTop
                , centerX
                , Font.color (Style.textColor model.theme)
                , Style.forceColorStyle model.theme
                ]
                [ container model model.compilerOutput.body ]
            ]
        )


container : Model -> List (Element msg) -> Element msg
container model elements_ =
    Element.column (Style.background_ model.theme :: [ Element.centerX, spacing 24 ]) elements_


header : Model -> Element msg
header model =
    Element.row
        [ Element.height <| Element.px <| headerHeight
        , Element.width <| Element.fill
        , Element.spacing 32
        , Element.centerX
        , Background.color (Style.backgroundColor model.theme)
        , paddingEach { left = 18, right = 18, top = 0, bottom = 0 }
        , Style.forceColorStyle model.theme
        , Border.widthEach { left = 0, right = 0, top = 0, bottom = 1 }
        , Border.color (Style.borderColor model.theme)
        ]
        [ Element.el
            [ centerX
            , centerY
            , Font.color (Style.debugTextColor model.theme)
            , Font.size 18
            , Font.semiBold
            , Style.forceColorStyle model.theme
            ]
            (Element.text <| "Scripta Live: " ++ model.title)
        ]


inputText : Model -> Element Msg
inputText model =
    Element.el
        [ alignTop
        , height fill
        , width (px <| panelWidth model)
        , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
        , Element.htmlAttribute (Html.Attributes.style "position" "relative")
        , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
        ]
        (Element.el
            (Style.multiline Element.width Element.height)
            (Input.multiline (Style.innerMultiline model.theme)
                { onChange = InputText
                , text = model.sourceText
                , placeholder = Nothing
                , label = Input.labelAbove [] <| el [] (text "")
                , spellcheck = False
                }
            )
        )



-- STYLE


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
