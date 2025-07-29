module Model exposing
    ( Model
    , Msg(..)
    , getTitle
    , init
    )

import AppData
import Dict
import Document exposing (Document)
import Generic.Compiler
import Json.Decode as Decode
import Keyboard
import List.Extra
import Ports
import Process
import ScriptaV2.Compiler
import ScriptaV2.DifferentialCompiler
import ScriptaV2.Language
import ScriptaV2.Msg exposing (MarkupMsg(..))
import Sync
import Task
import Theme
import Time


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
    , lastChanged : Time.Posix
    , userName : Maybe String

    -- EDITOR
    , editorData : { begin : Int, end : Int }
    , doSync : Bool
    , maybeSelectionOffset : Maybe Sync.SelectionOffsets
    , lastLoadedDocumentId : Maybe String
    , initialText : String
    , loadDocumentIntoEditor : Bool
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
    | SelectedText String
    | PortMsgReceived (Result Decode.Error Ports.IncomingMsg)


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
      , lastChanged = currentTime
      , userName = Nothing

      -- EDITOR
      , editorData = { begin = 0, end = 0 }
      , doSync = False
      , maybeSelectionOffset = Nothing
      , lastLoadedDocumentId = Nothing
      , initialText = normalizedTex  -- Use the actual initial document content
      , loadDocumentIntoEditor = True  -- Load initial document
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
