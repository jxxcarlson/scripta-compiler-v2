module Storage.SQLite exposing
    ( State
    , init
    , storage
    , subscriptions
    )

import Document exposing (Document)
import Json.Decode as Decode
import Json.Encode as Encode
import Ports
import Storage.Interface exposing (StorageInterface, StorageMsg(..))


type alias State =
    { initialized : Bool
    , dbReady : Bool
    }


init : State
init =
    { initialized = False
    , dbReady = False
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
    Ports.sqliteExecute <|
        Encode.object
            [ ( "type", Encode.string "saveDocument" )
            , ( "document", Document.encodeDocument doc )
            ]


loadDocument : (StorageMsg -> msg) -> String -> Cmd msg
loadDocument toMsg id =
    Ports.sqliteExecute <|
        Encode.object
            [ ( "type", Encode.string "loadDocument" )
            , ( "id", Encode.string id )
            ]


deleteDocument : (StorageMsg -> msg) -> String -> Cmd msg
deleteDocument toMsg id =
    Ports.sqliteExecute <|
        Encode.object
            [ ( "type", Encode.string "deleteDocument" )
            , ( "id", Encode.string id )
            ]


listDocuments : (StorageMsg -> msg) -> Cmd msg
listDocuments toMsg =
    Ports.sqliteExecute <|
        Encode.object
            [ ( "type", Encode.string "listDocuments" )
            ]


loadUserName : (StorageMsg -> msg) -> Cmd msg
loadUserName toMsg =
    Ports.sqliteExecute <|
        Encode.object
            [ ( "type", Encode.string "loadUserName" )
            ]


saveUserName : (StorageMsg -> msg) -> String -> Cmd msg
saveUserName toMsg name =
    Ports.sqliteExecute <|
        Encode.object
            [ ( "type", Encode.string "saveUserName" )
            , ( "name", Encode.string name )
            ]


initStorage : (StorageMsg -> msg) -> Cmd msg
initStorage toMsg =
    Ports.sqliteExecute <|
        Encode.object
            [ ( "type", Encode.string "init" )
            ]


subscriptions : (StorageMsg -> msg) -> Sub msg
subscriptions toMsg =
    Ports.sqliteResult (decodeSQLiteResult >> toMsg)


decodeSQLiteResult : Decode.Value -> StorageMsg
decodeSQLiteResult value =
    case Decode.decodeValue sqliteResultDecoder value of
        Ok msg ->
            msg

        Err err ->
            DocumentsListed (Err (Decode.errorToString err))


sqliteResultDecoder : Decode.Decoder StorageMsg
sqliteResultDecoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\msgType ->
                case msgType of
                    "documentSaved" ->
                        Decode.map DocumentSaved <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.field "document" Document.documentDecoder |> Decode.map Ok
                                ]

                    "documentLoaded" ->
                        Decode.map DocumentLoaded <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.field "document" Document.documentDecoder |> Decode.map Ok
                                ]

                    "documentDeleted" ->
                        Decode.map DocumentDeleted <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.field "id" Decode.string |> Decode.map Ok
                                ]

                    "documentsListed" ->
                        Decode.map DocumentsListed <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.field "documents" (Decode.list Document.documentDecoder) |> Decode.map Ok
                                ]

                    "userNameLoaded" ->
                        Decode.map UserNameLoaded <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.field "userName" (Decode.nullable Decode.string) |> Decode.map Ok
                                ]

                    "userNameSaved" ->
                        Decode.map UserNameSaved <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.field "name" Decode.string |> Decode.map Ok
                                ]

                    "initialized" ->
                        Decode.map StorageInitialized <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.succeed (Ok ())
                                ]

                    _ ->
                        Decode.fail ("Unknown message type: " ++ msgType)
            )