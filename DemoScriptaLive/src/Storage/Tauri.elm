module Storage.Tauri exposing
    ( storage
    , subscriptions
    )

import Document exposing (Document)
import Json.Decode as Decode
import Json.Encode as Encode
import Ports
import Storage.Interface exposing (StorageInterface, StorageMsg(..))


storage : (StorageMsg -> msg) -> StorageInterface msg
storage toMsg =
    { saveDocument = saveDocument toMsg
    , loadDocument = loadDocument toMsg
    , deleteDocument = deleteDocument toMsg
    , listDocuments = listDocuments toMsg
    , loadUserName = loadUserName toMsg
    , saveUserName = saveUserName toMsg
    , saveLastDocumentId = saveLastDocumentId toMsg
    , loadLastDocumentId = loadLastDocumentId toMsg
    , init = initStorage toMsg
    }


saveDocument : (StorageMsg -> msg) -> Document -> Cmd msg
saveDocument toMsg doc =
    Ports.tauriCommand <|
        Encode.object
            [ ( "cmd", Encode.string "saveDocument" )
            , ( "document", Document.encodeDocument doc )
            ]


loadDocument : (StorageMsg -> msg) -> String -> Cmd msg
loadDocument toMsg id =
    Ports.tauriCommand <|
        Encode.object
            [ ( "cmd", Encode.string "loadDocument" )
            , ( "id", Encode.string id )
            ]


deleteDocument : (StorageMsg -> msg) -> String -> Cmd msg
deleteDocument toMsg id =
    Ports.tauriCommand <|
        Encode.object
            [ ( "cmd", Encode.string "deleteDocument" )
            , ( "id", Encode.string id )
            ]


listDocuments : (StorageMsg -> msg) -> Cmd msg
listDocuments toMsg =
    Ports.tauriCommand <|
        Encode.object
            [ ( "cmd", Encode.string "listDocuments" )
            ]


loadUserName : (StorageMsg -> msg) -> Cmd msg
loadUserName toMsg =
    Ports.tauriCommand <|
        Encode.object
            [ ( "cmd", Encode.string "loadUserName" )
            ]


saveUserName : (StorageMsg -> msg) -> String -> Cmd msg
saveUserName toMsg name =
    Ports.tauriCommand <|
        Encode.object
            [ ( "cmd", Encode.string "saveUserName" )
            , ( "name", Encode.string name )
            ]


saveLastDocumentId : (StorageMsg -> msg) -> String -> Cmd msg
saveLastDocumentId toMsg id =
    Ports.tauriCommand <|
        Encode.object
            [ ( "cmd", Encode.string "saveLastDocumentId" )
            , ( "id", Encode.string id )
            ]


loadLastDocumentId : (StorageMsg -> msg) -> Cmd msg
loadLastDocumentId toMsg =
    Ports.tauriCommand <|
        Encode.object
            [ ( "cmd", Encode.string "loadLastDocumentId" )
            ]


initStorage : (StorageMsg -> msg) -> Cmd msg
initStorage toMsg =
    Ports.tauriCommand <|
        Encode.object
            [ ( "cmd", Encode.string "initDatabase" )
            ]


subscriptions : (StorageMsg -> msg) -> Sub msg
subscriptions toMsg =
    Ports.tauriResult (decodeTauriResult >> toMsg)


decodeTauriResult : Decode.Value -> StorageMsg
decodeTauriResult value =
    case Decode.decodeValue tauriResultDecoder value of
        Ok msg ->
            msg

        Err err ->
            DocumentsListed (Err (Decode.errorToString err))


tauriResultDecoder : Decode.Decoder StorageMsg
tauriResultDecoder =
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

                    "lastDocumentIdLoaded" ->
                        Decode.map LastDocumentIdLoaded <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.field "lastDocumentId" (Decode.nullable Decode.string) |> Decode.map Ok
                                ]
                                
                    "lastDocumentIdSaved" ->
                        Decode.map LastDocumentIdSaved <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.field "id" Decode.string |> Decode.map Ok
                                ]
                    
                    "databaseInitialized" ->
                        Decode.map StorageInitialized <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.succeed (Ok ())
                                ]

                    -- Handle file operation responses
                    "fileSaved" ->
                        Decode.map FileSaved <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.field "name" Decode.string |> Decode.map Ok
                                ]

                    "fileCancelled" ->
                        Decode.succeed (FileSaved (Ok ""))

                    "pdfGenerated" ->
                        Decode.map PdfGenerated <|
                            Decode.oneOf
                                [ Decode.field "error" Decode.string |> Decode.map Err
                                , Decode.field "name" Decode.string |> Decode.map Ok
                                ]

                    "pdfCancelled" ->
                        Decode.succeed (PdfGenerated (Ok ""))

                    "fileOpened" ->
                        Decode.map
                            (\content ->
                                FileOpened content
                            )
                            (Decode.field "content" Decode.string)

                    "fileOpenCancelled" ->
                        Decode.succeed (StorageInitialized (Ok ()))

                    _ ->
                        Decode.fail ("Unknown message type: " ++ msgType)
            )