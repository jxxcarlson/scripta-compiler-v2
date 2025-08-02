module MainTauri exposing (main)

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
import File.Download
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
import Storage.Tauri
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
    }


type Msg
    = CommonMsg Common.CommonMsg
    | StorageMsg Storage.StorageMsg


-- INIT


init : Common.Flags -> ( Model, Cmd Msg )
init flags =
    let
        common =
            Common.initCommon flags

        storage =
            Storage.Tauri.storage StorageMsg

        updatedCommon =
            { common 
                | showDocumentList = True
            }
    in
    ( { common = updatedCommon
      }
    , Cmd.batch
        [ storage.init
        , Task.perform (CommonMsg << Common.Tick) Time.now
        , Process.sleep 100
            |> Task.perform (always (CommonMsg Common.LoadUserNameDelayed))
        , Process.sleep 200
            |> Task.perform (always (StorageMsg (Storage.StorageInitialized (Ok ()))))
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


updateCommon : Common.CommonMsg -> Model -> ( Model, Cmd Msg )
updateCommon msg model =
    let
        storage =
            Storage.Tauri.storage StorageMsg

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

                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme common.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        common.displaySettings
                        newEditRecord

                newCommon =
                    { common
                        | sourceText = str
                        , title = Common.getTitleFromContent str
                        , editRecord = newEditRecord
                        , compilerOutput = newCompilerOutput
                        , lastChanged = common.currentTime
                        , count = common.count + 1
                    }
            in
            ( { model | common = newCommon }, Cmd.none )

        Common.InputText2 { position, source } ->
            let
                newEditRecord =
                    ScriptaV2.DifferentialCompiler.update common.editRecord source

                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme common.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        common.displaySettings
                        newEditRecord

                newCommon =
                    { common
                        | sourceText = source
                        , title = Common.getTitleFromContent source
                        , editRecord = newEditRecord
                        , compilerOutput = newCompilerOutput
                        , lastChanged = common.currentTime
                        , count = common.count + 1
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
            , Cmd.none  -- Theme is saved with each document
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
            ( model
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
                    Render.Settings.makeSettings (Theme.mapTheme common.theme) "-" Nothing 1.0 common.windowWidth Dict.empty

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
                    Render.Settings.makeSettings (Theme.mapTheme common.theme) "-" Nothing 1.0 common.windowWidth Dict.empty

                exportText =
                    Render.Export.LaTeX.rawExport settings common.editRecord.tree

                fileName =
                    common.title ++ ".tex"
            in
            ( model
            , File.Download.string fileName "application/x-latex" exportText
            )

        Common.SelectedText str ->
            let
                foundIds =
                    ScriptaV2.Helper.matchingIdsInAST str common.editRecord.tree
                        |> List.filter (\id -> id /= "")
                
                firstId =
                    List.head foundIds |> Maybe.withDefault ""
                
                -- Update displaySettings with new selectedId
                oldDisplaySettings = common.displaySettings
                newDisplaySettings = { oldDisplaySettings | selectedId = firstId }
                
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
                        , foundIdIndex = if List.isEmpty foundIds then 0 else 1
                        , displaySettings = newDisplaySettings
                        , compilerOutput = newCompilerOutput
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
                [ storage.saveDocument initialDoc
                , storage.saveLastDocumentId initialDoc.id
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
                    (CommonMsg << Common.InitialDocumentId AppData.defaultDocumentText "Announcement" common.currentTime common.theme)
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
                        (Theme.mapTheme doc.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        common.displaySettings
                        editRecord

                newCommon =
                    { common
                        | currentDocument = Just doc
                        , sourceText = doc.content
                        , initialText = doc.content
                        , title = doc.title
                        , theme = doc.theme
                        , editRecord = editRecord
                        , compilerOutput = compilerOutput
                        , loadDocumentIntoEditor = True
                        , lastLoadedDocumentId = Just doc.id
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
                newCommon = { common | lastSavedDocumentId = maybeId }
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
            ( model
            , Cmd.batch
                [ Storage.Tauri.storage StorageMsg |> .listDocuments
                , Storage.Tauri.storage StorageMsg |> .loadLastDocumentId
                ]
            )

        Storage.StorageInitialized (Err error) ->
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
        , Storage.Tauri.subscriptions StorageMsg
        ]


-- HELPERS


jumpToId : String -> Cmd Msg
jumpToId id =
    Task.map2 Tuple.pair
        (Browser.Dom.getElement id)
        (Browser.Dom.getElement "rendered-text-container")
        |> Task.andThen (\(targetEl, containerEl) ->
            let
                -- Calculate the target position relative to the container
                targetY = targetEl.element.y - containerEl.element.y
            in
            -- Scroll the container to show the target element at the top
            Browser.Dom.setViewportOf "rendered-text-container" 0 targetY
        )
        |> Task.attempt (\_ -> CommonMsg Common.NoOp)


-- ID GENERATION


generateId : Random.Generator String
generateId =
    Random.int 100000 999999
        |> Random.map (\n -> "doc-" ++ String.fromInt n)