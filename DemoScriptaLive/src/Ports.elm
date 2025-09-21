port module Ports exposing 
    ( OutgoingMsg(..)
    , IncomingMsg(..)
    , send
    , receive
    , sendMsg
    , listDocuments
    , sqliteExecute
    , sqliteResult
    , tauriCommand
    , tauriResult
    )

import Json.Encode as Encode
import Json.Decode as Decode exposing (Decoder)
import Document exposing (Document)
import Theme


-- OUTGOING MESSAGES (Elm -> JS)


type OutgoingMsg
    = SaveDocument Document
    | LoadDocuments
    | LoadDocument String
    | DeleteDocument String
    | SaveTheme String
    | LoadTheme
    | SaveUserName String
    | LoadUserName
    | SaveLastDocumentId String
    | LoadLastDocumentId
    | SaveFile { fileName : String, content : String, mimeType : String }


-- INCOMING MESSAGES (JS -> Elm)


type IncomingMsg
    = DocumentsLoaded (List Document)
    | DocumentLoaded Document
    | ThemeLoaded String
    | UserNameLoaded String
    | LastDocumentIdLoaded String


-- Special export for compatibility
listDocuments : OutgoingMsg
listDocuments = LoadDocuments


-- PORTS


port outgoing : Encode.Value -> Cmd msg
port incoming : (Encode.Value -> msg) -> Sub msg

-- SQLite-specific ports
port sqliteExecute : Encode.Value -> Cmd msg
port sqliteResult : (Encode.Value -> msg) -> Sub msg

-- Tauri-specific ports
port tauriCommand : Encode.Value -> Cmd msg
port tauriResult : (Encode.Value -> msg) -> Sub msg


-- PUBLIC API


send : OutgoingMsg -> Cmd msg
send msg =
    outgoing (encodeOutgoing msg)


sendMsg : OutgoingMsg -> Cmd msg
sendMsg = send


receive : (Result Decode.Error IncomingMsg -> msg) -> Sub msg
receive toMsg =
    incoming (\value -> toMsg (decodeIncoming value))


-- ENCODERS


encodeOutgoing : OutgoingMsg -> Encode.Value
encodeOutgoing msg =
    case msg of
        SaveDocument doc ->
            Encode.object
                [ ( "tag", Encode.string "SaveDocument" )
                , ( "data", Document.encodeDocument doc )
                ]

        LoadDocuments ->
            Encode.object
                [ ( "tag", Encode.string "LoadDocuments" )
                ]

        LoadDocument id ->
            Encode.object
                [ ( "tag", Encode.string "LoadDocument" )
                , ( "data", Encode.string id )
                ]

        DeleteDocument id ->
            Encode.object
                [ ( "tag", Encode.string "DeleteDocument" )
                , ( "data", Encode.string id )
                ]

        SaveTheme theme ->
            Encode.object
                [ ( "tag", Encode.string "SaveTheme" )
                , ( "data", Encode.string theme )
                ]

        LoadTheme ->
            Encode.object
                [ ( "tag", Encode.string "LoadTheme" )
                ]

        SaveUserName name ->
            Encode.object
                [ ( "tag", Encode.string "SaveUserName" )
                , ( "data", Encode.string name )
                ]

        LoadUserName ->
            Encode.object
                [ ( "tag", Encode.string "LoadUserName" )
                ]

        SaveLastDocumentId id ->
            Encode.object
                [ ( "tag", Encode.string "SaveLastDocumentId" )
                , ( "data", Encode.string id )
                ]

        LoadLastDocumentId ->
            Encode.object
                [ ( "tag", Encode.string "LoadLastDocumentId" )
                ]

        SaveFile data ->
            Encode.object
                [ ( "tag", Encode.string "SaveFile" )
                , ( "fileName", Encode.string data.fileName )
                , ( "content", Encode.string data.content )
                , ( "mimeType", Encode.string data.mimeType )
                ]


-- DECODERS


decodeIncoming : Encode.Value -> Result Decode.Error IncomingMsg
decodeIncoming value =
    Decode.decodeValue incomingDecoder value


incomingDecoder : Decoder IncomingMsg
incomingDecoder =
    Decode.field "tag" Decode.string
        |> Decode.andThen decodeByTag


decodeByTag : String -> Decoder IncomingMsg
decodeByTag tag =
    case tag of
        "DocumentsLoaded" ->
            Decode.map DocumentsLoaded
                (Decode.field "data" (Decode.list Document.documentDecoder))

        "DocumentLoaded" ->
            Decode.map DocumentLoaded
                (Decode.field "data" Document.documentDecoder)

        "ThemeLoaded" ->
            Decode.map ThemeLoaded
                (Decode.field "data" Decode.string)

        "UserNameLoaded" ->
            Decode.map UserNameLoaded
                (Decode.field "data" Decode.string)

        "LastDocumentIdLoaded" ->
            Decode.map LastDocumentIdLoaded
                (Decode.field "data" Decode.string)

        _ ->
            Decode.fail ("Unknown tag: " ++ tag)