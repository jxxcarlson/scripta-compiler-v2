module MainSQLite exposing (main)

import AppData
import Browser
import Browser.Dom
import Browser.Events
import Common.Model as Common
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
import Ports
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
import Storage.SQLite
import Style
import Task
import Theme
import Time
import Widget


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


-- INIT


init : Common.Flags -> ( Model, Cmd Msg )
init flags =
    let
        common =
            Common.initCommon flags

        storage =
            Storage.SQLite.storage StorageMsg
    in
    ( { common = common
      , storageState = Storage.SQLite.init
      }
    , Cmd.batch
        [ storage.init
        , Task.perform (CommonMsg << Common.Tick) Time.now
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
            Storage.SQLite.storage StorageMsg
    in
    case msg of
        Common.NoOp ->
            ( model, Cmd.none )

        Common.InputText str ->
            updateSourceText model str

        Common.InputText2 data ->
            updateSourceText2 model data

        Common.Render markupMsg ->
            handleRender model markupMsg

        Common.GotNewWindowDimensions width height ->
            handleWindowResize model width height

        Common.KeyMsg keyMsg ->
            handleKeyMsg model keyMsg

        Common.ToggleTheme ->
            toggleTheme model

        Common.CreateNewDocument ->
            createNewDocument model

        Common.SaveDocument ->
            saveDocument model storage

        Common.LoadDocument id ->
            loadDocument model storage id

        Common.DeleteDocument id ->
            deleteDocument model storage id

        Common.ToggleDocumentList ->
            toggleDocumentList model

        Common.AutoSave time ->
            autoSave model storage time

        Common.Tick time ->
            ( { model | common = { common = model.common | currentTime = time } model.common }
            , Cmd.none
            )

        Common.GeneratedId id ->
            handleGeneratedId model id

        Common.InitialDocumentId initialDocId content time theme name ->
            handleInitialDocument model initialDocId content time theme name

        Common.ExportToLaTeX ->
            exportToLaTeX model

        Common.ExportToRawLaTeX ->
            exportToRawLaTeX model

        Common.DownloadScript ->
            downloadScript model

        Common.InputUserName name ->
            handleInputUserName model storage name

        Common.LoadUserNameDelayed ->
            ( model, storage.loadUserName )

        Common.PortMsgReceived result ->
            handlePortMsg model result

        -- Editor messages
        Common.SelectedText str ->
            handleSelectedText model str

        Common.GetSelection str ->
            handleGetSelection model str

        Common.ReceiveAnchorOffset offset ->
            handleReceiveAnchorOffset model offset

        Common.RequestAnchorOffset ->
            ( model, Editor.requestAnchorOffset )

        Common.StartSync ->
            handleStartSync model

        Common.SyncContent str1 str2 ->
            handleSyncContent model str1 str2

        Common.MakeSearchForId id ->
            handleMakeSearchForId model id

        Common.MarkSelection selection ->
            handleMarkSelection model selection

        Common.SelectId id ->
            handleSelectId model id

        Common.UpdateFileName name ->
            handleUpdateFileName model name

        Common.UpdateFileDescription desc ->
            handleUpdateFileDescription model desc

        Common.Export format ->
            handleExport model format

        Common.ReceiveFileContents contents ->
            handleReceiveFileContents model contents

        Common.AskForFileNameAndSave ->
            handleAskForFileNameAndSave model

        Common.AskForInitialFileNameAndLoad ->
            handleAskForInitialFileNameAndLoad model

        Common.ToggleEditMode ->
            handleToggleEditMode model

        Common.MarkCurrentDocumentDirty ->
            handleMarkCurrentDocumentDirty model

        Common.SetCurrentDocument doc ->
            handleSetCurrentDocument model doc

        Common.ApplyEditorData data ->
            handleApplyEditorData model data

        Common.GotViewPort result ->
            handleGotViewPort model result


handleStorageMsg : Storage.StorageMsg -> Model -> ( Model, Cmd Msg )
handleStorageMsg msg model =
    case msg of
        Storage.DocumentSaved result ->
            case result of
                Ok doc ->
                    ( { model | common = updateDocumentInList model.common doc }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )

        Storage.DocumentLoaded result ->
            case result of
                Ok doc ->
                    loadDocumentIntoModel model doc

                Err error ->
                    ( model, Cmd.none )

        Storage.DocumentDeleted result ->
            case result of
                Ok id ->
                    ( { model | common = removeDocumentFromList model.common id }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )

        Storage.DocumentsListed result ->
            case result of
                Ok docs ->
                    ( { model | common = { common = model.common | documents = docs } model.common }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )

        Storage.UserNameLoaded result ->
            case result of
                Ok maybeUserName ->
                    ( { model | common = { common = model.common | userName = maybeUserName } model.common }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )

        Storage.UserNameSaved result ->
            ( model, Cmd.none )

        Storage.StorageInitialized result ->
            case result of
                Ok () ->
                    ( { model | storageState = { initialized = True, dbReady = True } }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )


-- Helper functions (implement all the handlers referenced above)
-- These would contain the logic extracted from the original Main.elm update function

updateSourceText : Model -> String -> ( Model, Cmd Msg )
updateSourceText model str =
    -- Implementation here
    ( model, Cmd.none )

updateSourceText2 : Model -> { position : Int, source : String } -> ( Model, Cmd Msg )
updateSourceText2 model data =
    -- Implementation here
    ( model, Cmd.none )

-- ... (implement all other helper functions)


-- VIEW


view : Model -> Html Msg
view model =
    -- Extract view logic from original Main.elm
    Html.div [] [ Html.text "MainSQLite View" ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize (\w h -> CommonMsg (Common.GotNewWindowDimensions w h))
        , Keyboard.subscriptions |> Sub.map (CommonMsg << Common.KeyMsg)
        , Time.every constants.autosaveInterval (CommonMsg << Common.AutoSave)
        , Time.every constants.tickInterval (CommonMsg << Common.Tick)
        , Ports.receive (CommonMsg << Common.PortMsgReceived)
        , Storage.SQLite.subscriptions StorageMsg
        ]


-- Helper functions for model updates

updateDocumentInList : Common.CommonModel -> Document -> Common.CommonModel
updateDocumentInList common doc =
    { common | documents = List.Extra.updateIf (\d -> d.id == doc.id) (always doc) common.documents }


removeDocumentFromList : Common.CommonModel -> String -> Common.CommonModel
removeDocumentFromList common id =
    { common | documents = List.filter (\d -> d.id /= id) common.documents }


loadDocumentIntoModel : Model -> Document -> ( Model, Cmd Msg )
loadDocumentIntoModel model doc =
    -- Implementation to load document into editor
    ( model, Cmd.none )