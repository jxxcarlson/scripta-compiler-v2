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
    | ViewMsg Common.View.Msg


-- INIT


init : Common.Flags -> ( Model, Cmd Msg )
init flags =
    let
        common =
            Common.initCommon flags

        storage =
            Storage.Local.storage StorageMsg

        -- Initialize with sample document content
        initialContent =
            AppData.defaultDocumentText

        editRecord =
            ScriptaV2.DifferentialCompiler.init Dict.empty common.currentLanguage initialContent

        compilerOutput =
            ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput 
                (Theme.mapTheme common.theme) 
                ScriptaV2.Compiler.SuppressDocumentBlocks 
                common.displaySettings 
                editRecord

        updatedCommon =
            { common 
                | sourceText = initialContent
                , editRecord = editRecord
                , compilerOutput = compilerOutput
                , showDocumentList = True
            }
    in
    ( { common = updatedCommon
      , storageState = Storage.Local.init
      }
    , Cmd.batch
        [ Ports.send Ports.LoadDocuments
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

        ViewMsg viewMsg ->
            case viewMsg of
                Common.View.CommonMsg commonMsg ->
                    updateCommon commonMsg model


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

                newCompilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput
                        (Theme.mapTheme common.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        common.displaySettings
                        newEditRecord

                newCommon =
                    { common
                        | sourceText = str
                        , editRecord = newEditRecord
                        , compilerOutput = newCompilerOutput
                        , lastChanged = common.currentTime
                        , count = common.count + 1
                    }
            in
            ( { model | common = newCommon }, Cmd.none )

        Common.Render markupMsg ->
            case markupMsg of
                ScriptaV2.Msg.SendLineNumber { begin, end } ->
                    ( { model | common = { common | selectedId = String.fromInt begin } }
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
                        | windowWidth = width
                    }

                newCommon =
                    { common 
                        | windowWidth = width
                        , windowHeight = height
                        , displaySettings = newDisplaySettings
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
                    }
            in
            ( { model | common = newCommon }
            , Ports.send (Ports.SaveDocument newDoc)
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
                            }
                    in
                    ( { model | common = newCommon }
                    , Ports.send (Ports.SaveDocument updatedDoc)
                    )

                Nothing ->
                    update (CommonMsg Common.CreateNewDocument) model

        Common.LoadDocument id ->
            ( model
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
                    Render.Settings.makeSettings (Theme.mapTheme common.theme) "-" Nothing 1.0 common.windowWidth Dict.empty

                exportText =
                    Render.Export.LaTeX.export common.currentTime settings common.editRecord.tree

                fileName =
                    common.title ++ ".tex"
            in
            ( model
            , File.Download.string fileName "application/x-latex" exportText
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
                        , loadDocumentIntoEditor = True
                        , lastLoadedDocumentId = Just doc.id
                    }
            in
            ( { model | common = newCommon }
            , Cmd.none  -- Editor content is loaded via loadDocumentIntoEditor flag
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


handleStorageMsg : Storage.StorageMsg -> Model -> ( Model, Cmd Msg )
handleStorageMsg msg model =
    -- Since we're using Ports directly, we don't need to handle these
    ( model, Cmd.none )


-- VIEW


view : Model -> Html Msg
view model =
    Common.View.view model.common
        |> Html.map ViewMsg


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


-- ID GENERATION


generateId : Random.Generator String
generateId =
    Random.int 100000 999999
        |> Random.map (\n -> "doc-" ++ String.fromInt n)