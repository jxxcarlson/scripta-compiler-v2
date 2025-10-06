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
import List.Extra
import Model exposing (Model, Msg(..))
import Ports
import Process
import Random
import Render.Export.LaTeX
import Render.Settings
import ScriptaV2.API
import ScriptaV2.Compiler
import ScriptaV2.DifferentialCompiler
import ScriptaV2.Helper
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
                    List.length docs
            in
            if List.isEmpty docs then
                -- No documents in storage, create default document
                ( { model | documents = docs }
                , Random.generate
                    (InitialDocumentId AppData.defaultDocumentText "Announcement" model.currentTime model.theme)
                    generateId
                )

            else
                ( { model | documents = docs }, Cmd.none )

        Ports.DocumentLoaded doc ->
            let
                _ =
                    doc.title

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
                    name
            in
            ( { model | userName = Just name }
            , Cmd.none
            )
            
        Ports.LastDocumentIdLoaded id ->
            -- Main.elm doesn't use localStorage, so we ignore this message
            ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotNewWindowDimensions width height ->
            let
                oldDisplaySettings =
                    model.displaySettings

                newDisplaySettings =
                    { oldDisplaySettings | windowWidth = width // 3 }

                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme model.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        newDisplaySettings
                        model.editRecord
            in
            ( { model
                | windowWidth = width
                , windowHeight = height
                , displaySettings = newDisplaySettings
                , compilerOutput = newCompilerOutput
              }
            , Cmd.none
            )

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
                                Render.Settings.makeSettings model.displaySettings (Theme.mapTheme model.theme) model.selectId Nothing 1.0 model.windowWidth Dict.empty

                            publicationData =
                                { title = model.title
                                , authorList = []
                                , kind = "article"
                                }

                            exportText =
                                Render.Export.LaTeX.export model.currentTime publicationData settings model.editRecord.tree
                        in
                        File.Download.string (model.title ++ ".tex") "application/x-latex" exportText

                    else if List.member Keyboard.Control pressedKeys && List.member (Keyboard.Character "R") pressedKeys then
                        let
                            settings =
                                Render.Settings.makeSettings model.displaySettings (Theme.mapTheme model.theme) model.selectId Nothing 1.0 model.windowWidth Dict.empty

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

                ScriptaV2.Msg.SendLineNumber editorData ->
                    case model.currentDocument of
                        Nothing ->
                            ( model, Cmd.none )

                        Just doc ->
                            let
                                target : Maybe String
                                target =
                                    Maybe.map (.content >> String.lines) model.currentDocument
                                        -- acquire the target lines
                                        |> Maybe.map (List.Extra.removeIfIndex (\k -> k < editorData.begin - 1 || k > editorData.end))
                                        |> Maybe.map (String.join "\n")
                                        |> Maybe.map (String.split "\n\n")
                                        |> Maybe.andThen List.head

                                targetData : Maybe Document.EditorTargetData
                                targetData =
                                    case target of
                                        Nothing ->
                                            Nothing

                                        Just target_ ->
                                            Just { target = target_, editorData = editorData }
                            in
                            -- FOR NOW: disable open-editor-on-click-in-rendered-text:
                            -- it interferes with the normal operation of other features
                            -- activated by a click in the rendered text.
                            --
                            --if model.showEditor == False && model.lastMarkupMsg == Nothing then
                            --    Frontend.Editor.openEditor doc { model | targetData = targetData }
                            --
                            --else
                            -- Ports.getSelectionForAnchor_ () will attempt to refine the selection
                            -- Compute id_ to highlight the rendered text that was clicked on
                            let
                                foundIds_ =
                                    ScriptaV2.Helper.matchingIdsInAST (target |> Maybe.withDefault "--xx--") model.editRecord.tree

                                id_ =
                                    List.head foundIds_ |> Maybe.withDefault "(nothing)"

                                _ =
                                    ()
                            in
                            ( { model
                                | editorData = editorData

                                -- BELOW: Disable for now so that rendered text is not highlighted
                                --, selectedId = id_
                                , targetData = targetData
                              }
                              --, Ports.getSelectionForAnchor_ ()
                            , Cmd.none
                            )

                _ ->
                    let
                        _ =
                            msg_
                    in
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
                    Render.Settings.makeSettings model.displaySettings (Theme.mapTheme model.theme) model.selectId Nothing 1.0 model.windowWidth Dict.empty

                publicationData =
                    { title = model.title
                    , authorList = []
                    , kind = "article"
                    }

                exportText =
                    Render.Export.LaTeX.export model.currentTime publicationData settings model.editRecord.tree
            in
            ( model, File.Download.string (model.title ++ ".tex") "application/x-latex" exportText )

        ExportToRawLaTeX ->
            let
                settings =
                    Render.Settings.makeSettings model.displaySettings (Theme.mapTheme model.theme) model.selectId Nothing 1.0 model.windowWidth Dict.empty

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

                editRecord =
                    ScriptaV2.DifferentialCompiler.init Dict.empty model.currentLanguage content
            in
            ( { model
                | currentDocument = Just initialDoc
                , sourceText = content
                , initialText = content
                , title = title
                , editRecord = editRecord
                , loadDocumentIntoEditor = True
                , compilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme model.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        model.displaySettings
                        editRecord
              }
            , Ports.send (Ports.SaveDocument initialDoc)
            )

        InputUserName name ->
            ( { model | userName = Just name }
            , Ports.send (Ports.SaveUserName name)
            )

        LoadUserNameDelayed ->
            ( model
            , Ports.send Ports.LoadUserName
            )

        PortMsgReceived result ->
            case result of
                Ok incomingMsg ->
                    handleIncomingPortMsg incomingMsg model

                Err error ->
                    let
                        _ =
                            error
                    in
                    ( model, Cmd.none )

        GetSelection str ->
            --( { model | messages = Message.prepend model.messages { txt = "Selection: " ++ str, status = MSWhite } }, Cmd.none )
            ( model, Cmd.none )

        -- SYNC, PORTS
        RequestAnchorOffset ->
            --( model, Ports.getSelectionForAnchor_ () )
            ( model, Cmd.none )

        ReceiveAnchorOffset maybeSelectionOffset ->
            ( { model | maybeSelectionOffset = maybeSelectionOffset }, Cmd.none )

        StartSync ->
            ( { model | doSync = not model.doSync }, Cmd.none )

        SelectedText str ->
            let
                _ = str

                foundIds =
                    ScriptaV2.Helper.matchingIdsInAST str model.editRecord.tree
                        |> List.filter (\id -> id /= "")

                firstId =
                    List.head foundIds |> Maybe.withDefault ""

                -- Update displaySettings with new selectedId
                oldDisplaySettings = model.displaySettings
                newDisplaySettings = { oldDisplaySettings | selectedId = firstId }

                -- Re-render with updated settings
                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme model.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        newDisplaySettings
                        model.editRecord

                newModel =
                    { model
                        | selectId = firstId
                        , selectedId = firstId
                        , foundIds = foundIds
                        , foundIdIndex = if List.isEmpty foundIds then 0 else 1
                        , displaySettings = newDisplaySettings
                        , compilerOutput = newCompilerOutput
                    }
            in
            ( newModel
            , if firstId /= "" then
                -- Add a delay to ensure DOM is updated with new elements
                Process.sleep 100
                    |> Task.perform (\_ -> LRSync firstId)
              else
                Cmd.none
            )

        LRSync target ->
            -- This is called after a delay to ensure DOM has updated
            ( model, jumpToId target )

        NextSync ->
            --Frontend.EditorSync.nextSyncLR model
            ( model, Cmd.none )

        SyncText _ ->
            --Frontend.EditorSync.firstSyncLR model ""
            ( model, Cmd.none )



-- VIEW
--


view : Model -> Html Msg
view model =
    layoutWith { options = [ Element.focusStyle noFocus ] }
        [ Style.background_ model.theme
        , Element.htmlAttribute (Html.Attributes.style "height" "100vh")
        , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
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
    max 200 ((appWidth model - sidebarWidth - 16 - 4 - 16) // 2)


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
                , Element.htmlAttribute (Html.Attributes.style "flex" "1")
                , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
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
              Widget.nameElement model
            , Element.el [ Element.paddingXY 0 8, Element.width Element.fill ] (Element.text "")
            , Widget.toggleTheme model
            , crudButtons model
            , exportStuff model
            , Element.el [ Element.paddingXY 0 8, Element.width Element.fill ] (Element.text "")
            , Element.column
                [ spacing 4
                , width fill
                , height (px 300)
                , scrollbarY
                , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
                , Element.htmlAttribute (Html.Attributes.style "overflow-x" "hidden")
                ]
                (List.map (documentItem model) (List.sortBy (\d -> d.title) model.documents))
            ]
        ]


crudButtons : Model -> Element Msg
crudButtons model =
    Element.row [ spacing 8, width fill ]
        [ newButton model
        , saveButton model
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
        model.displaySettings
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
        , height (px (max 100 (model.windowHeight - headerHeight - 1))) -- Match editor height
        , width (px <| panelWidth model)
        , Element.clipY
        , Element.scrollbarY
        , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
        , Element.htmlAttribute (Html.Attributes.style "overflow-x" "hidden")
        , Style.htmlId "rendered-text-container"
        ]
        (column
            [ Font.size 14
            , padding 16
            , spacing 24
            , width fill
            , Style.htmlId "rendered-text"
            , Style.background_ model.theme
            , alignTop
            , centerX
            , Font.color (Style.textColor model.theme)
            , Style.forceColorStyle model.theme
            ]
            [ container model model.compilerOutput.body ]
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
            (Element.text model.title)
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


jumpToId : String -> Cmd Msg
jumpToId id =
    if String.isEmpty id then
        Cmd.none
    else
        -- Get both the target element and container element
        Task.map3 (\a b c -> (a, b, c))
            (Browser.Dom.getElement id)
            (Browser.Dom.getElement "rendered-text-container")
            (Browser.Dom.getViewportOf "rendered-text-container")
            |> Task.andThen (\(targetEl, containerEl, viewport) ->
                let
                    -- Calculate the position of the target relative to the page
                    targetPageY = targetEl.element.y
                    containerPageY = containerEl.element.y

                    -- The target's position relative to the container's top
                    relativeY = targetPageY - containerPageY

                    -- Add current scroll to get absolute position in scrollable content
                    absoluteY = relativeY + viewport.viewport.y

                    -- Calculate where to scroll to center the element
                    elementHeight = targetEl.element.height
                    viewportHeight = viewport.viewport.height
                    scrollY = absoluteY - (viewportHeight / 2) + (elementHeight / 2)

                    -- Clamp to valid range
                    finalScrollY = max 0 scrollY
                in
                -- Scroll the container
                Browser.Dom.setViewportOf "rendered-text-container" 0 finalScrollY
            )
            |> Task.attempt (\_ -> NoOp)



-- ID GENERATION


generateId : Random.Generator String
generateId =
    Random.int 100000 999999
        |> Random.map (\n -> "doc-" ++ String.fromInt n)
