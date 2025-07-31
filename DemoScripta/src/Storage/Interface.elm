module Storage.Interface exposing
    ( StorageInterface
    , StorageMsg(..)
    , StorageResult(..)
    )

import Document exposing (Document)
import Json.Decode as Decode


type alias StorageInterface msg =
    { saveDocument : Document -> Cmd msg
    , loadDocument : String -> Cmd msg
    , deleteDocument : String -> Cmd msg
    , listDocuments : Cmd msg
    , loadUserName : Cmd msg
    , saveUserName : String -> Cmd msg
    , init : Cmd msg
    }


type StorageMsg
    = DocumentSaved (Result String Document)
    | DocumentLoaded (Result String Document)
    | DocumentDeleted (Result String String)
    | DocumentsListed (Result String (List Document))
    | UserNameLoaded (Result String (Maybe String))
    | UserNameSaved (Result String String)
    | StorageInitialized (Result String ())


type StorageResult
    = Success String
    | Error String