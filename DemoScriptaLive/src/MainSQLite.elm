module MainSQLite exposing (main)

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
import Http
import Json.Decode as Decode
import Keyboard
import List.Extra
import Ports
import Process
import Random
import Render.Export.LaTeX
import Render.Export.LaTeXToScripta
import Render.Settings
import ScriptaV2.API
import ScriptaV2.Compiler
import ScriptaV2.DifferentialCompiler
import ScriptaV2.Helper
import ScriptaV2.Language
import ScriptaV2.Msg exposing (MarkupMsg)
import Storage.Interface as Storage
import Storage.SQLite
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
    , storageState : Storage.SQLite.State
    }


type Msg
    = CommonMsg Common.CommonMsg
    | StorageMsg Storage.StorageMsg
    | FileSelected File.File
    | FileLoaded String
    | LaTeXFileSelected File.File
    | LaTeXFileLoaded { filename : String, content : String }



-- INIT


init : Common.Flags -> ( Model, Cmd Msg )
init flags =
    let
        common =
            Common.initCommon flags

        storage =
            Storage.SQLite.storage StorageMsg

        updatedCommon =
            { common
                | showDocumentList = True
            }
    in
    ( { common = updatedCommon
      , storageState = Storage.SQLite.init
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
                storage = Storage.SQLite.storage StorageMsg
            in
            ( updatedModel
            , Cmd.batch
                [ cmdFromUpdate
                , storage.saveDocument newDoc
                , Process.sleep 100
                    |> Task.perform (always (CommonMsg Common.ResetLoadFlag))
                ]
            )

        LaTeXFileSelected file ->
            ( model
            , Task.perform (\content -> LaTeXFileLoaded { filename = File.name file, content = content }) (File.toString file)
            )

        LaTeXFileLoaded { filename, content } ->
            let
                -- Extract basename from filename (remove .tex extension if present)
                basename =
                    if String.endsWith ".tex" filename then
                        String.dropRight 4 filename
                    else
                        filename

                -- Translate LaTeX to Scripta
                translatedContent = Render.Export.LaTeXToScripta.translate content

                -- Add title block at the top
                scriptaContent =
                    "| title\n" ++ basename ++ "\n\n" ++ translatedContent

                -- First update the content in the editor
                ( modelWithContent, cmdFromUpdate ) = updateCommon (Common.InputText scriptaContent) model

                -- Generate a new document ID with .scripta extension indication
                newId = "latex-import-" ++ String.fromInt (Time.posixToMillis modelWithContent.common.currentTime // 1000)

                -- Create a new document
                newDoc = Document.newDocument
                    newId
                    basename
                    (Maybe.withDefault "" modelWithContent.common.userName)
                    scriptaContent
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
                        , sourceText = scriptaContent
                        , initialText = scriptaContent
                        , loadDocumentIntoEditor = True
                    }

                updatedModel = { modelWithContent | common = updatedCommon }

                -- Get the storage command to save the document
                storage = Storage.SQLite.storage StorageMsg
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
            Storage.SQLite.storage StorageMsg

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
                        oldSettings =
                            common.displaySettings

                        -- Calculate the actual panel width first
                        panelWidth =
                            max 350
                                ((common.windowWidth
                                    - 230  -- sidebar
                                    - (if common.windowWidth >= 1000 then
                                        221  -- TOC + border
                                       else
                                        0
                                      )
                                    - 3  -- borders
                                 )
                                    // 2
                                )

                        -- Subtract padding and extra margin for actual content width
                        -- We need more buffer: 20px padding each side + extra margin
                        contentWidth = panelWidth - 40  -- Reduced padding experiment
                    in
                    { oldSettings
                        | counter = newCount
                        , windowWidth = max 310 contentWidth  -- Minimum 310px for content
                    }

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
                        oldSettings =
                            common.displaySettings

                        -- Calculate the actual panel width first
                        panelWidth =
                            max 350
                                ((common.windowWidth
                                    - 230  -- sidebar
                                    - (if common.windowWidth >= 1000 then
                                        221  -- TOC + border
                                       else
                                        0
                                      )
                                    - 3  -- borders
                                 )
                                    // 2
                                )

                        -- Subtract padding and extra margin for actual content width
                        -- We need more buffer: 20px padding each side + extra margin
                        contentWidth = panelWidth - 40  -- Reduced padding experiment
                    in
                    { oldSettings
                        | counter = newCount
                        , windowWidth = max 310 contentWidth  -- Minimum 310px for content
                    }

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
                        , loadDocumentIntoEditor = False -- Turn off loading after edit
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

                panelWidth = max 350 ((width - 230 - (if width >= 1000 then 221 else 0) - 3) // 2)

                contentWidth = panelWidth - 40  -- Reduced padding experiment

                newDisplaySettings =
                    { displaySettings
                        | windowWidth = max 310 contentWidth
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
            , Cmd.none
              -- Theme is saved with each document
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
                [ storage.saveDocument newDoc
                , storage.saveLastDocumentId newDoc.id
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
                        [ storage.saveDocument updatedDoc
                        , storage.saveLastDocumentId doc.id
                        ]
                    )

                Nothing ->
                    update (CommonMsg Common.CreateNewDocument) model

        Common.LoadDocument id ->
            ( { model | common = { common | printingState = Common.PrintWaiting, pdfLink = "" } }
            , storage.loadDocument id
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
            , storage.deleteDocument id
            )

        Common.ToggleDocumentList ->
            ( { model | common = { common | showDocumentList = not common.showDocumentList } }
            , Cmd.none
            )

        Common.AutoSave time ->
            let
                shouldSave =
                    Time.posixToMillis time
                        - Time.posixToMillis common.lastSaved
                        > 30000
                        && common.sourceText
                        /= ""
                        && common.lastChanged
                        /= common.lastSaved
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
            , storage.loadUserName
            )

        Common.InputUserName name ->
            ( { model | common = { common | userName = Just name } }
            , storage.saveUserName name
            )

        Common.UpdateFileName name ->
            ( { model | common = { common | title = name } }
            , Cmd.none
            )

        Common.ExportToLaTeX ->
            let
                settings =
                    Render.Settings.makeSettings common.displaySettings (Theme.mapTheme common.theme) "-" Nothing 1.0 common.windowWidth Dict.empty

                exportText =
                    Render.Export.LaTeX.export common.currentTime settings common.editRecord.tree

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

        Common.ImportLaTeXFile ->
            ( model
            , File.Select.file ["text/x-tex", "text/x-latex", ".tex", "application/x-tex"] LaTeXFileSelected
            )

        Common.PrintToPDF ->
            let
                settings =
                    Render.Settings.makeSettings common.displaySettings (Theme.mapTheme common.theme) "-" Nothing 1.0 common.windowWidth Dict.empty

                exportText =
                    Render.Export.LaTeX.export common.currentTime settings common.editRecord.tree

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
            -- This is kept for backwards compatibility but should not be used
            case result of
                Ok pdfLink ->
                    ( { model | common = { common | printingState = Common.PrintReady, pdfLink = pdfLink } }
                    , Cmd.none
                    )

                Err httpError ->
                    ( { model | common = { common | printingState = Common.PrintWaiting } }
                    , Cmd.none
                    )

        Common.GotPdfResponse result ->
            case result of
                Ok pdfResponse ->
                    ( { model | common = { common | printingState = Common.PrintReady, pdfResponse = Just pdfResponse } }
                    , Cmd.none
                    )

                Err httpError ->
                    let
                        -- Extract error message and filter out geometry warnings if it's a BadBody error
                        errorMsg =
                            case httpError of
                                Http.BadBody body ->
                                    body
                                        |> String.lines
                                        |> List.filter (\line -> not (String.contains "*geometry* driver" line))
                                        |> String.join "\n"

                                _ ->
                                    "HTTP Error"
                    in
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

                -- Update displaySettings with new selectedId
                oldDisplaySettings =
                    common.displaySettings

                newDisplaySettings =
                    { oldDisplaySettings | selectedId = firstId }

                -- Re-render with updated settings
                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme common.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        newDisplaySettings
                        common.editRecord

                newCommon =
                    { common
                        | selectedId = firstId
                        , foundIds = foundIds
                        , foundIdIndex =
                            if List.isEmpty foundIds then
                                0

                            else
                                1
                        , displaySettings = newDisplaySettings
                        , compilerOutput = newCompilerOutput
                    }
            in
            ( { model | common = newCommon }
            , if firstId /= "" then
                -- Add a delay to ensure DOM is updated with new elements
                -- Using 100ms to give more time for rendering to complete
                Process.sleep 100
                    |> Task.perform (\_ -> CommonMsg (Common.SelectId firstId))

              else
                Cmd.none
            )

        Common.LoadContentIntoEditorDelayed ->
            ( { model | common = { common | loadDocumentIntoEditor = True } }
            , Process.sleep 300
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

        Common.SelectId id ->
            -- Jump to the id after DOM has had time to update
            ( model, jumpToId id )

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
                        , documents = initialDoc :: common.documents
                        , sourceText = content
                        , initialText = content
                        , title = title
                        , editRecord = editRecord
                        , loadDocumentIntoEditor = False  -- Will be set by LoadContentIntoEditorDelayed
                        , compilerOutput = compilerOutput
                    }
            in
            ( { model | common = { newCommon | lastSavedDocumentId = Just initialDoc.id } }
            , Cmd.batch
                [ storage.saveDocument initialDoc
                , storage.saveLastDocumentId initialDoc.id
                , Process.sleep 500
                    |> Task.perform (always (CommonMsg Common.LoadContentIntoEditorDelayed))
                ]
            )

        _ ->
            -- Handle other messages with no-op for now
            ( model, Cmd.none )


handleStorageMsg : Storage.StorageMsg -> Model -> ( Model, Cmd Msg )
handleStorageMsg msg model =
    let
        common =
            model.common
    in
    case msg of
        Storage.DocumentsListed (Ok docs) ->
            if List.isEmpty docs then
                -- No documents in storage, create default document
                ( { model | common = { common | documents = docs } }
                , Random.generate
                    (CommonMsg << Common.InitialDocumentId (String.trim AppData.defaultDocumentText) "Announcement" common.currentTime common.theme)
                    generateId
                )

            else
                ( { model | common = { common | documents = docs } }
                , Cmd.none
                )

        Storage.DocumentsListed (Err error) ->
            ( model, Cmd.none )

        Storage.DocumentLoaded (Ok doc) ->
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
                        , loadDocumentIntoEditor = True
                        , lastLoadedDocumentId = Just doc.id
                        , printingState = Common.PrintWaiting
                        , pdfLink = ""
                    }
            in
            ( { model | common = newCommon }
            , Cmd.none
            )

        Storage.DocumentLoaded (Err error) ->
            ( model, Cmd.none )

        Storage.DocumentSaved (Ok doc) ->
            let
                updatedDocs =
                    doc :: List.filter (\d -> d.id /= doc.id) common.documents
            in
            ( { model | common = { common | documents = updatedDocs } }
            , Cmd.none
            )

        Storage.DocumentSaved (Err error) ->
            ( model, Cmd.none )

        Storage.DocumentDeleted (Ok id) ->
            let
                updatedDocs =
                    List.filter (\d -> d.id /= id) common.documents
            in
            ( { model | common = { common | documents = updatedDocs } }
            , Cmd.none
            )

        Storage.DocumentDeleted (Err error) ->
            ( model, Cmd.none )

        Storage.UserNameLoaded (Ok maybeName) ->
            ( { model | common = { common | userName = maybeName } }
            , Cmd.none
            )

        Storage.UserNameLoaded (Err error) ->
            ( model, Cmd.none )

        Storage.UserNameSaved _ ->
            ( model, Cmd.none )

        Storage.LastDocumentIdLoaded (Ok maybeId) ->
            let
                newCommon =
                    { common | lastSavedDocumentId = maybeId }
            in
            case maybeId of
                Just id ->
                    ( { model | common = newCommon }
                    , Process.sleep 1000
                        |> Task.perform (always (CommonMsg (Common.LoadDocument id)))
                    )

                Nothing ->
                    ( { model | common = newCommon }
                    , Cmd.none
                    )

        Storage.LastDocumentIdLoaded (Err _) ->
            ( model, Cmd.none )

        Storage.LastDocumentIdSaved _ ->
            ( model, Cmd.none )

        Storage.StorageInitialized (Ok _) ->
            ( { model | storageState = { initialized = True, dbReady = True } }
            , Cmd.batch
                [ Storage.SQLite.storage StorageMsg |> .listDocuments
                , Storage.SQLite.storage StorageMsg |> .loadLastDocumentId
                ]
            )

        Storage.StorageInitialized (Err error) ->
            ( model, Cmd.none )

        Storage.FileOpened content ->
            -- Handle file opened from native dialog
            let
                newCommon =
                    { common | sourceText = content }
            in
            ( { model | common = newCommon }
            , Cmd.none
            )

        Storage.FileSaved _ ->
            -- File saved via native dialog
            ( model, Cmd.none )

        Storage.PdfGenerated _ ->
            -- PDF generation result
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
        , Storage.SQLite.subscriptions StorageMsg
        ]



-- HELPERS


jumpToId : String -> Cmd Msg
jumpToId id =
    if String.isEmpty id then
        Cmd.none

    else
        -- Get both the target element and container element
        Task.map3 (\a b c -> ( a, b, c ))
            (Browser.Dom.getElement id)
            (Browser.Dom.getElement "rendered-text-container")
            (Browser.Dom.getViewportOf "rendered-text-container")
            |> Task.andThen
                (\( targetEl, containerEl, viewport ) ->
                    let
                        -- Calculate the position of the target relative to the page
                        targetPageY =
                            targetEl.element.y

                        containerPageY =
                            containerEl.element.y

                        -- The target's position relative to the container's top
                        relativeY =
                            targetPageY - containerPageY

                        -- Add current scroll to get absolute position in scrollable content
                        absoluteY =
                            relativeY + viewport.viewport.y

                        -- Calculate where to scroll to center the element
                        elementHeight =
                            targetEl.element.height

                        viewportHeight =
                            viewport.viewport.height

                        scrollY =
                            absoluteY - (viewportHeight / 2) + (elementHeight / 2)

                        -- Clamp to valid range
                        finalScrollY =
                            max 0 scrollY
                    in
                    -- Scroll the container
                    Browser.Dom.setViewportOf "rendered-text-container" 0 finalScrollY
                )
            |> Task.attempt (\_ -> CommonMsg Common.NoOp)



-- ID GENERATION


generateId : Random.Generator String
generateId =
    Random.int 100000 999999
        |> Random.map (\n -> "doc-" ++ String.fromInt n)
