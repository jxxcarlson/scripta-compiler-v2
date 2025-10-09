module Model exposing
    ( Model
    , Msg(..)
    , getTitle
    , init
    )

import AppData
import Dict
import Document exposing (Document)
import Json.Decode as Decode
import Keyboard
import List.Extra
import Ports
import Process
import ScriptaV2.Compiler
import ScriptaV2.DifferentialCompiler
import ScriptaV2.Language
import ScriptaV2.Msg exposing (MarkupMsg(..))
import ScriptaV2.Settings
import ScriptaV2.Types
import Sync
import Task
import Theme
import Time


type alias Model =
    { displaySettings : ScriptaV2.Settings.DisplaySettings
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
    , lastChanged : Time.Posix
    , userName : Maybe String

    -- EDITOR
    , editorData : { begin : Int, end : Int }
    , doSync : Bool
    , maybeSelectionOffset : Maybe Sync.SelectionOffsets
    , lastLoadedDocumentId : Maybe String
    , initialText : String
    , loadDocumentIntoEditor : Bool
    , targetData : Maybe Document.EditorTargetData
    , selectedId : String

    --, syncState = SyncText sourceText
    , foundIds : List String
    , foundIdIndex : Int
    , searchCount : Int
    }


type alias Flags =
    { window : { windowWidth : Int, windowHeight : Int }
    , currentTime : Int
    , theme : Maybe String
    }


type Msg
    = NoOp
    | InputText String
    | InputText2 { position : Int, source : String }
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
      -- Editor
    | SelectedText String
    | GetSelection String
    | ReceiveAnchorOffset (Maybe Sync.SelectionOffsets)
    | RequestAnchorOffset
    | StartSync
    | LRSync String
    | NextSync
    | SyncText String


initialDisplaySettings flags =
    { windowWidth = flags.window.windowWidth // 3
    , counter = 0
    , selectedId = "nada"
    , selectedSlug = Nothing
    , scale = 1.0
    , longEquationLimit = flags.window.windowWidth |> toFloat
    , data = Dict.empty
    , idsOfOpenNodes = []
    , numberToLevel = 0
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

        params =
            ScriptaV2.Types.defaultCompilerParameters

        displaySettings =
            initialDisplaySettings flags

        -- Start with empty content to avoid flash
        normalizedTex =
            ""

        title_ =
            "Loading..."

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
            ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput { params | filter = ScriptaV2.Types.SuppressDocumentBlocks } editRecord
      , editRecord = editRecord
      , documents = []
      , currentDocument = Nothing
      , showDocumentList = True
      , lastSaved = currentTime
      , lastChanged = currentTime
      , userName = Nothing

      -- EDITOR
      , editorData = { begin = 0, end = 0 }
      , doSync = False
      , maybeSelectionOffset = Nothing
      , lastLoadedDocumentId = Nothing
      , initialText = normalizedTex -- Use the actual initial document content
      , loadDocumentIntoEditor = True -- Load initial document
      , targetData = Nothing
      , selectedId = ""

      --, syncState = SyncText sourceText
      , foundIds = []
      , foundIdIndex = 0
      , searchCount = 0
      }
    , Cmd.batch
        [ Ports.send Ports.LoadDocuments
        , Task.perform Tick Time.now
        , Process.sleep 100
            |> Task.perform (always LoadUserNameDelayed)
        ]
    )


normalize : String -> String
normalize input =
    input
        |> String.lines
        |> List.map String.trim
        |> String.join "\n"


getTitle : String -> String
getTitle str =
    str
        |> String.lines
        |> List.map String.trim
        |> List.Extra.dropWhile (\line -> line == "" || String.startsWith "|" line)
        |> List.head
        |> Maybe.withDefault "No title yet"
