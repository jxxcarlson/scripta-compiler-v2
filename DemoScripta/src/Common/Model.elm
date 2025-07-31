module Common.Model exposing
    ( CommonModel
    , CommonMsg(..)
    , Flags
    , getTitle
    , getTitleFromContent
    , initCommon
    )

import Browser.Dom
import Dict
import Document exposing (Document)
import Element
import Generic.Compiler
import Json.Decode as Decode
import Keyboard
import List.Extra
import Ports
import ScriptaV2.Msg exposing (MarkupMsg)
import ScriptaV2.Compiler
import ScriptaV2.DifferentialCompiler
import ScriptaV2.Language
import Sync
import Theme
import Time


type alias CommonModel =
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
    , targetData : Maybe Document.EditorTargetData
    , selectedId : String
    , foundIds : List String
    , foundIdIndex : Int
    , searchCount : Int
    }


type CommonMsg
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
    | LoadContentIntoEditorDelayed
    | ResetLoadFlag
    | PortMsgReceived (Result Decode.Error Ports.IncomingMsg)
      -- Editor
    | SelectedText String
    | GetSelection String
    | ReceiveAnchorOffset (Maybe Sync.SelectionOffsets)
    | RequestAnchorOffset
    | StartSync
    | SyncContent String String
    | MakeSearchForId String
    | MarkSelection (Maybe ( Int, Int ))
    | SelectId String
    | UpdateFileName String
    | UpdateFileDescription String
    | Export String
    | ReceiveFileContents String
    | AskForFileNameAndSave
    | AskForInitialFileNameAndLoad
    | ToggleEditMode
    | MarkCurrentDocumentDirty
    | SetCurrentDocument Document
    | ApplyEditorData ( Int, Int )
    | GotViewPort (Result Browser.Dom.Error Browser.Dom.Viewport)


type alias Flags =
    { window : { windowWidth : Int, windowHeight : Int }
    , currentTime : Int
    , theme : Maybe String
    }


initCommon : Flags -> CommonModel
initCommon flags =
    let
        theme =
            case flags.theme of
                Just "dark" ->
                    Theme.Dark

                _ ->
                    Theme.Light

        currentTime =
            Time.millisToPosix flags.currentTime
    in
    { displaySettings = 
        { windowWidth = flags.window.windowWidth // 3
        , longEquationLimit = 100.0
        , counter = 0
        , selectedId = "-"
        , selectedSlug = Nothing
        , scale = 1.0
        , data = Dict.empty
        , idsOfOpenNodes = []
        }
    , sourceText = ""
    , count = 0
    , windowWidth = flags.window.windowWidth
    , windowHeight = flags.window.windowHeight
    , currentLanguage = ScriptaV2.Language.EnclosureLang
    , selectId = ""
    , title = ""
    , theme = theme
    , pressedKeys = []
    , currentTime = currentTime
    , compilerOutput = 
        { body = []
        , banner = Nothing
        , toc = []
        , title = Element.text ""
        }
    , editRecord = ScriptaV2.DifferentialCompiler.init Dict.empty ScriptaV2.Language.EnclosureLang ""
    , documents = []
    , currentDocument = Nothing
    , showDocumentList = False
    , lastSaved = currentTime
    , lastChanged = currentTime
    , userName = Nothing

    -- EDITOR
    , editorData = { begin = 0, end = 0 }
    , doSync = False
    , maybeSelectionOffset = Nothing
    , lastLoadedDocumentId = Nothing
    , initialText = ""
    , loadDocumentIntoEditor = False
    , targetData = Nothing
    , selectedId = ""
    , foundIds = []
    , foundIdIndex = 0
    , searchCount = 0
    }


getTitle : CommonModel -> String
getTitle model =
    case model.currentDocument of
        Nothing ->
            "Scripta (No document)"

        Just doc ->
            "Scripta: " ++ doc.title


getTitleFromContent : String -> String
getTitleFromContent str =
    str
        |> String.lines
        |> List.map String.trim
        |> List.Extra.dropWhile (\line -> line == "" || String.startsWith "|" line)
        |> List.head
        |> Maybe.withDefault "No title yet"