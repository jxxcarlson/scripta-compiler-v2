module MainLocal exposing (main)

import AppData
import Browser
import Browser.Dom
import Browser.Events
import Common.Model as Common
import Common.View
import Constants exposing (constants)
import Dict
import Document exposing (Document)
import Editor
import Element exposing (..)
import File
import File.Download
import File.Select
import Frontend.PDF
import Html exposing (Html)
import Json.Decode as Decode
import Keyboard
import List.Extra
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
import Storage.Interface as Storage
import Storage.Local
import Task
import Theme
import Time


-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- MODEL


type alias Model =
    { common : Common.CommonModel
    , storageState : Storage.Local.State
    }


type Msg
    = CommonMsg Common.CommonMsg
    | StorageMsg Storage.StorageMsg
    | FileSelected File.File
    | FileLoaded String


-- INIT


init : Common.Flags -> ( Model, Cmd Msg )
init flags =
    let
        common =
            Common.initCommon flags

        storage =
            Storage.Local.storage StorageMsg

        updatedCommon =
            { common 
                | showDocumentList = True
            }
    in
    ( { common = updatedCommon
      , storageState = Storage.Local.init
      }
    , Cmd.batch
        [ storage.init
        , Task.perform (CommonMsg << Common.Tick) Time.now
        , Process.sleep 100
            |> Task.perform (always (CommonMsg Common.LoadUserNameDelayed))
        ]
    )


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CommonMsg commonMsg ->
            updateCommon commonMsg model

        StorageMsg storageMsg ->
            handleStorageMsg storageMsg model

        FileSelected file ->
            ( model
            , Task.perform FileLoaded (File.toString file)
            )

        FileLoaded content ->
            let
                -- First update the content in the editor
                ( modelWithContent, cmdFromUpdate ) = updateCommon (Common.InputText content) model

                -- Extract the title from the content
                title = Common.getTitleFromContent content

                -- Generate a new document ID
                newId = "imported-" ++ String.fromInt (Time.posixToMillis modelWithContent.common.currentTime // 1)

                -- Create a new document
                newDoc = Document.newDocument
                    newId
                    title
                    (Maybe.withDefault "" modelWithContent.common.userName)
                    content
                    modelWithContent.common.theme
                    modelWithContent.common.currentTime

                -- Update the model with the new document
                updatedCommon =
                    let
                        oldCommon = modelWithContent.common
                    in
                    { oldCommon
                        | currentDocument = Just newDoc
                        , documents = newDoc :: modelWithContent.common.documents
                        , lastLoadedDocumentId = Just newId
                        , sourceText = content
                        , initialText = content
                        , loadDocumentIntoEditor = True
                    }

                updatedModel = { modelWithContent | common = updatedCommon }

                -- Get the storage command to save the document
                storage = Storage.Local.storage StorageMsg
            in
            ( updatedModel
            , Cmd.batch
                [ cmdFromUpdate
                , storage.saveDocument newDoc
                , Process.sleep 100
                    |> Task.perform (always (CommonMsg Common.ResetLoadFlag))
                ]
            )


updateCommon : Common.CommonMsg -> Model -> ( Model, Cmd Msg )
updateCommon msg model =
    let
        storage =
            Storage.Local.storage StorageMsg

        common =
            model.common
    in
    case msg of
        Common.NoOp ->
            ( model, Cmd.none )

        Common.InputText str ->
            let
                newEditRecord =
                    ScriptaV2.DifferentialCompiler.update common.editRecord str

                newCount =
                    common.count + 1

                updatedDisplaySettings =
                    let
                        oldSettings = common.displaySettings
                        -- Calculate actual panel width for rendered text
                        -- When TOC is hidden (window < 1000px), don't subtract its width
                        tocSpace = if common.windowWidth >= 1000 then 220 + 1 else 0
                        actualPanelWidth = max 350 ((common.windowWidth - 230 - tocSpace - 3) // 2)
                    in
                    { oldSettings | counter = newCount, windowWidth = actualPanelWidth }

                -- IMPORTANT: Must use updated display settings with new counter for keyed rendering
                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme common.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        updatedDisplaySettings
                        newEditRecord

                newCommon =
                    { common
                        | sourceText = str
                        , title = Common.getTitleFromContent str
                        , editRecord = newEditRecord
                        , compilerOutput = newCompilerOutput
                        , lastChanged = common.currentTime
                        , count = newCount
                        , displaySettings = updatedDisplaySettings
                    }
            in
            ( { model | common = newCommon }, Cmd.none )

        Common.InputText2 { position, source } ->
            let
                newEditRecord =
                    ScriptaV2.DifferentialCompiler.update common.editRecord source

                newCount =
                    common.count + 1

                updatedDisplaySettings =
                    let
                        oldSettings = common.displaySettings
                        -- Calculate actual panel width for rendered text
                        -- When TOC is hidden (window < 1000px), don't subtract its width
                        tocSpace = if common.windowWidth >= 1000 then 220 + 1 else 0
                        actualPanelWidth = max 350 ((common.windowWidth - 230 - tocSpace - 3) // 2)
                    in
                    { oldSettings | counter = newCount, windowWidth = actualPanelWidth }

                -- IMPORTANT: Must use updated display settings with new counter for keyed rendering
                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme common.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        updatedDisplaySettings
                        newEditRecord

                newCommon =
                    { common
                        | sourceText = source
                        , title = Common.getTitleFromContent source
                        , editRecord = newEditRecord
                        , compilerOutput = newCompilerOutput
                        , lastChanged = common.currentTime
                        , count = newCount
                        , displaySettings = updatedDisplaySettings
                        , loadDocumentIntoEditor = False  -- Turn off loading after edit
                    }
            in
            ( { model | common = newCommon }, Cmd.none )

        Common.Render markupMsg ->
            case markupMsg of
                ScriptaV2.Msg.SendLineNumber editorData ->
                    ( { model | common = { common | editorData = editorData } }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        Common.GotNewWindowDimensions width height ->
            let
                displaySettings =
                    common.displaySettings

                newDisplaySettings =
                    { displaySettings 
                        | windowWidth = width // 3
                    }

                newEditRecord =
                    ScriptaV2.DifferentialCompiler.update common.editRecord common.sourceText

                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme common.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        newDisplaySettings
                        newEditRecord

                newCommon =
                    { common 
                        | windowWidth = width
                        , windowHeight = height
                        , displaySettings = newDisplaySettings
                        , editRecord = newEditRecord
                        , compilerOutput = newCompilerOutput
                    }
            in
            ( { model | common = newCommon }, Cmd.none )

        Common.KeyMsg keyMsg ->
            let
                newCommon =
                    { common | pressedKeys = Keyboard.update keyMsg common.pressedKeys }
            in
            ( { model | common = newCommon }, Cmd.none )

        Common.ToggleTheme ->
            let
                newTheme =
                    if common.theme == Theme.Dark then
                        Theme.Light
                    else
                        Theme.Dark

                newEditRecord =
                    ScriptaV2.DifferentialCompiler.update common.editRecord common.sourceText

                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme newTheme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        common.displaySettings
                        newEditRecord

                newCommon =
                    { common 
                        | theme = newTheme
                        , editRecord = newEditRecord
                        , compilerOutput = newCompilerOutput
                    }
            in
            ( { model | common = newCommon }
            , Ports.send (Ports.SaveTheme 
                (case newTheme of
                    Theme.Light ->
                        "light"
                    
                    Theme.Dark ->
                        "dark"
                )
            )
            )

        Common.CreateNewDocument ->
            case common.currentDocument of
                Just doc ->
                    if common.sourceText /= doc.content then
                        -- Save current document first
                        let
                            ( newModel, saveCmd ) =
                                update (CommonMsg Common.SaveDocument) model
                        in
                        ( newModel
                        , Cmd.batch
                            [ saveCmd
                            , Random.generate (CommonMsg << Common.GeneratedId) generateId
                            ]
                        )
                    else
                        ( model
                        , Random.generate (CommonMsg << Common.GeneratedId) generateId
                        )

                Nothing ->
                    ( model
                    , Random.generate (CommonMsg << Common.GeneratedId) generateId
                    )

        Common.GeneratedId id ->
            let
                newDocumentContent =
                    "| title\nNew Document\n"

                newDoc =
                    Document.newDocument id "New Document" (Maybe.withDefault "" common.userName) newDocumentContent common.theme common.currentTime

                editRecord =
                    ScriptaV2.DifferentialCompiler.init Dict.empty common.currentLanguage newDocumentContent

                compilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme common.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        common.displaySettings
                        editRecord

                newCommon =
                    { common
                        | currentDocument = Just newDoc
                        , sourceText = newDocumentContent
                        , initialText = newDocumentContent
                        , title = "New Document"
                        , editRecord = editRecord
                        , lastLoadedDocumentId = Just id
                        , loadDocumentIntoEditor = True
                        , compilerOutput = compilerOutput
                        , printingState = Common.PrintWaiting
                        , pdfLink = ""
                    }
            in
            ( { model | common = { newCommon | lastSavedDocumentId = Just newDoc.id } }
            , Cmd.batch
                [ Ports.send (Ports.SaveDocument newDoc)
                , Ports.send (Ports.SaveLastDocumentId newDoc.id)
                ]
            )

        Common.SaveDocument ->
            case common.currentDocument of
                Just doc ->
                    let
                        updatedDoc =
                            { doc
                                | content = common.sourceText
                                , title = common.title
                                , modifiedAt = common.currentTime
                                , theme = common.theme
                            }

                        newCommon =
                            { common
                                | currentDocument = Just updatedDoc
                                , lastSaved = common.currentTime
                                , lastSavedDocumentId = Just doc.id
                            }
                    in
                    ( { model | common = newCommon }
                    , Cmd.batch
                        [ Ports.send (Ports.SaveDocument updatedDoc)
                        , Ports.send (Ports.SaveLastDocumentId doc.id)
                        ]
                    )

                Nothing ->
                    update (CommonMsg Common.CreateNewDocument) model

        Common.LoadDocument id ->
            ( { model | common = { common | printingState = Common.PrintWaiting, pdfLink = "" } }
            , Ports.send (Ports.LoadDocument id)
            )

        Common.DeleteDocument id ->
            let
                newCommon =
                    if common.currentDocument |> Maybe.map .id |> (==) (Just id) then
                        { common | currentDocument = Nothing, sourceText = "" }
                    else
                        common
            in
            ( { model | common = newCommon }
            , Ports.send (Ports.DeleteDocument id)
            )

        Common.ToggleDocumentList ->
            ( { model | common = { common | showDocumentList = not common.showDocumentList } }
            , Cmd.none
            )

        Common.ToggleSortOrder ->
            let
                newSortOrder =
                    case common.sortOrder of
                        Common.Alphabetical ->
                            Common.Recent

                        Common.Recent ->
                            Common.Alphabetical
            in
            ( { model | common = { common | sortOrder = newSortOrder } }
            , Cmd.none
            )

        Common.InputDocumentSearchText text ->
            ( { model | common = { common | documentSearchText = text } }
            , Cmd.none
            )

        Common.AutoSave time ->
            let
                shouldSave =
                    Time.posixToMillis time - Time.posixToMillis common.lastSaved > 30000
                        && common.sourceText /= ""
                        && common.lastChanged /= common.lastSaved
            in
            if shouldSave then
                update (CommonMsg Common.SaveDocument) model
            else
                ( model, Cmd.none )

        Common.Tick time ->
            ( { model | common = { common | currentTime = time } }
            , Cmd.none
            )

        Common.LoadUserNameDelayed ->
            ( model
            , Ports.send Ports.LoadUserName
            )

        Common.InputUserName name ->
            ( { model | common = { common | userName = Just name } }
            , Ports.send (Ports.SaveUserName name)
            )

        Common.PortMsgReceived result ->
            case result of
                Ok incomingMsg ->
                    handleIncomingPortMsg incomingMsg model

                Err _ ->
                    ( model, Cmd.none )

        Common.UpdateFileName name ->
            ( { model | common = { common | title = name } }
            , Cmd.none
            )

        Common.ExportToLaTeX ->
            let
                settings =
                    Render.Settings.makeSettings common.displaySettings (Theme.mapTheme common.theme) "-" Nothing 1.0 common.windowWidth Dict.empty

                publicationData =
                    { title = common.title
                    , authorList = []
                    , kind = "article"
                    }

                exportText =
                    Render.Export.LaTeX.export common.currentTime publicationData settings common.editRecord.tree

                fileName =
                    common.title ++ ".tex"
            in
            ( model
            , File.Download.string fileName "application/x-latex" exportText
            )

        Common.ExportToRawLaTeX ->
            let
                settings =
                    Render.Settings.makeSettings common.displaySettings (Theme.mapTheme common.theme) "-" Nothing 1.0 common.windowWidth Dict.empty

                exportText =
                    Render.Export.LaTeX.rawExport settings common.editRecord.tree

                fileName =
                    common.title ++ ".tex"
            in
            ( model
            , File.Download.string fileName "application/x-latex" exportText
            )

        Common.ExportScriptaFile ->
            let
                fileName =
                    if String.trim common.title == "" then
                        "document.scripta"
                    else
                        common.title ++ ".scripta"
            in
            ( model
            , File.Download.string fileName "text/plain" common.sourceText
            )

        Common.ImportScriptaFile ->
            ( model
            , File.Select.file ["text/plain", ".scripta", ".txt"] FileSelected
            )

        Common.PrintToPDF ->
            let
                settings =
                    Render.Settings.makeSettings common.displaySettings (Theme.mapTheme common.theme) "-" Nothing 1.0 common.windowWidth Dict.empty

                publicationData =
                    { title = common.title
                    , authorList = []
                    , kind = "article"
                    }

                exportText =
                    Render.Export.LaTeX.export common.currentTime publicationData settings common.editRecord.tree

                exportData =
                    { title = common.title
                    , content = exportText
                    , sourceText = common.sourceText
                    , language = common.currentLanguage
                    }
            in
            ( { model | common = { common | printingState = Common.PrintProcessing } }
            , Cmd.map CommonMsg (Frontend.PDF.requestPDF exportData)
            )

        Common.GotPdfLink result ->
            case result of
                Ok pdfLink ->
                    ( { model | common = { common | printingState = Common.PrintReady, pdfLink = pdfLink } }
                    , Cmd.none
                    )

                Err _ ->
                    ( { model | common = { common | printingState = Common.PrintWaiting } }
                    , Cmd.none
                    )

        Common.SelectedText str ->
            let
                foundIds =
                    ScriptaV2.Helper.matchingIdsInAST str common.editRecord.tree
                        |> List.filter (\id -> id /= "")
                
                firstId =
                    List.head foundIds |> Maybe.withDefault ""
                
                newCommon =
                    { common
                        | selectedId = firstId
                        , foundIds = foundIds
                        , foundIdIndex = if List.isEmpty foundIds then 0 else 1
                    }
            in
            ( { model | common = newCommon }
            , if firstId /= "" then
                jumpToId firstId
              else
                Cmd.none
            )

        Common.LoadContentIntoEditorDelayed ->
            ( { model | common = { common | loadDocumentIntoEditor = True } }
            , Process.sleep 100
                |> Task.perform (always (CommonMsg Common.ResetLoadFlag))
            )

        Common.ResetLoadFlag ->
            ( { model | common = { common | loadDocumentIntoEditor = False } }
            , Cmd.none
            )

        Common.StartSync ->
            ( { model | common = { common | doSync = not common.doSync } }
            , Cmd.none
            )

        Common.InitialDocumentId content title currentTime theme id ->
            let
                initialDoc =
                    Document.newDocument id title (Maybe.withDefault "" common.userName) content theme currentTime

                editRecord =
                    ScriptaV2.DifferentialCompiler.init Dict.empty common.currentLanguage content

                compilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme common.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        common.displaySettings
                        editRecord

                newCommon =
                    { common
                        | currentDocument = Just initialDoc
                        , sourceText = content
                        , initialText = content
                        , title = title
                        , editRecord = editRecord
                        , loadDocumentIntoEditor = True
                        , compilerOutput = compilerOutput
                    }
            in
            ( { model | common = { newCommon | lastSavedDocumentId = Just initialDoc.id } }
            , Cmd.batch
                [ Ports.send (Ports.SaveDocument initialDoc)
                , Ports.send (Ports.SaveLastDocumentId initialDoc.id)
                ]
            )

        _ ->
            -- Handle other messages with no-op for now
            ( model, Cmd.none )


handleIncomingPortMsg : Ports.IncomingMsg -> Model -> ( Model, Cmd Msg )
handleIncomingPortMsg msg model =
    let
        common =
            model.common
    in
    case msg of
        Ports.DocumentsLoaded docs ->
            if List.isEmpty docs then
                -- No documents in storage, create default document
                ( { model | common = { common | documents = docs } }
                , Random.generate
                    (CommonMsg << Common.InitialDocumentId AppData.defaultDocumentText "Announcement" common.currentTime common.theme)
                    generateId
                )
            else
                ( { model | common = { common | documents = docs } }
                , Cmd.none
                )

        Ports.DocumentLoaded doc ->
            let
                editRecord =
                    ScriptaV2.DifferentialCompiler.init Dict.empty common.currentLanguage doc.content

                compilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme common.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        common.displaySettings
                        editRecord

                newCommon =
                    { common
                        | currentDocument = Just doc
                        , sourceText = doc.content
                        , initialText = doc.content
                        , title = doc.title
                        , editRecord = editRecord
                        , compilerOutput = compilerOutput
                        , loadDocumentIntoEditor = True  -- Set to True immediately for initial load
                        , lastLoadedDocumentId = Just doc.id
                        , printingState = Common.PrintWaiting
                        , pdfLink = ""
                    }
            in
            ( { model | common = newCommon }
            , Process.sleep 500
                |> Task.perform (always (CommonMsg Common.ResetLoadFlag))
            )

        Ports.ThemeLoaded themeStr ->
            let
                theme =
                    case themeStr of
                        "dark" ->
                            Theme.Dark
                        
                        _ ->
                            Theme.Light
                newCommon =
                    { common | theme = theme }
            in
            ( { model | common = newCommon }
            , Cmd.none
            )

        Ports.UserNameLoaded name ->
            ( { model | common = { common | userName = Just name } }
            , Cmd.none
            )
        
        Ports.LastDocumentIdLoaded id ->
            let
                newCommon = { common | lastSavedDocumentId = Just id }
            in
            if id /= "" then
                ( { model | common = newCommon }
                -- Delay loading the document to ensure editor is ready
                , Process.sleep 1000
                    |> Task.perform (always (CommonMsg (Common.LoadDocument id)))
                )
            else
                ( { model | common = newCommon }
                , Cmd.none
                )


handleStorageMsg : Storage.StorageMsg -> Model -> ( Model, Cmd Msg )
handleStorageMsg msg model =
    -- Since we're using Ports directly, we don't need to handle these
    ( model, Cmd.none )


-- VIEW


view : Model -> Html Msg
view model =
    Common.View.view CommonMsg (CommonMsg << Common.Render) model.common


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize (\w h -> CommonMsg (Common.GotNewWindowDimensions w h))
        , Keyboard.subscriptions |> Sub.map (CommonMsg << Common.KeyMsg)
        , Time.every (30 * 1000) (CommonMsg << Common.AutoSave)
        , Time.every constants.autoSaveCheckInterval (CommonMsg << Common.Tick)
        , Ports.receive (CommonMsg << Common.PortMsgReceived)
        ]


-- HELPERS


jumpToId : String -> Cmd Msg
jumpToId id =
    Task.map3 (\a b c -> (a, b, c))
        (Browser.Dom.getElement id)
        (Browser.Dom.getElement "rendered-text-container")
        (Browser.Dom.getViewportOf "rendered-text-container")
        |> Task.andThen (\(targetEl, containerEl, viewport) ->
            let
                -- Calculate the target position relative to the container
                targetRelativeY = targetEl.element.y - containerEl.element.y

                -- Calculate position to center the element in viewport
                -- We want the element to appear in the middle of the visible area
                targetHeight = targetEl.element.height
                viewportHeight = viewport.viewport.height
                centeredY = targetRelativeY - (viewportHeight / 2) + (targetHeight / 2)

                -- Ensure we don't scroll past the top
                scrollY = max 0 centeredY
            in
            -- Scroll the container to center the target element
            Browser.Dom.setViewportOf "rendered-text-container" 0 scrollY
        )
        |> Task.attempt (\_ -> CommonMsg Common.NoOp)


-- ID GENERATION


generateId : Random.Generator String
generateId =
    Random.int 100000 999999
        |> Random.map (\n -> "doc-" ++ String.fromInt n)