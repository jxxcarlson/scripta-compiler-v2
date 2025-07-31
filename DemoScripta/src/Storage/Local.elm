module Storage.Local exposing
    ( State
    , init
    , storage
    )

import Document exposing (Document)
import Json.Decode as Decode
import Json.Encode as Encode
import Ports
import Storage.Interface exposing (StorageInterface, StorageMsg(..))


type alias State =
    { initialized : Bool
    }


init : State
init =
    { initialized = False
    }


storage : (StorageMsg -> msg) -> StorageInterface msg
storage toMsg =
    { saveDocument = saveDocument toMsg
    , loadDocument = loadDocument toMsg
    , deleteDocument = deleteDocument toMsg
    , listDocuments = listDocuments toMsg
    , loadUserName = loadUserName toMsg
    , saveUserName = saveUserName toMsg
    , init = initStorage toMsg
    }


saveDocument : (StorageMsg -> msg) -> Document -> Cmd msg
saveDocument toMsg doc =
    Ports.sendMsg (Ports.SaveDocument doc)


loadDocument : (StorageMsg -> msg) -> String -> Cmd msg
loadDocument toMsg id =
    Ports.sendMsg (Ports.LoadDocument id)


deleteDocument : (StorageMsg -> msg) -> String -> Cmd msg
deleteDocument toMsg id =
    Ports.sendMsg (Ports.DeleteDocument id)


listDocuments : (StorageMsg -> msg) -> Cmd msg
listDocuments toMsg =
    Ports.sendMsg Ports.LoadDocuments


loadUserName : (StorageMsg -> msg) -> Cmd msg
loadUserName toMsg =
    Ports.sendMsg Ports.LoadUserName


saveUserName : (StorageMsg -> msg) -> String -> Cmd msg
saveUserName toMsg name =
    Ports.sendMsg (Ports.SaveUserName name)


initStorage : (StorageMsg -> msg) -> Cmd msg
initStorage toMsg =
    Cmd.batch
        [ listDocuments toMsg
        , loadUserName toMsg
        ]