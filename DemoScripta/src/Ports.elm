port module Ports exposing 
    ( OutgoingMsg(..)
    , IncomingMsg(..)
    , send
    , receive
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


-- INCOMING MESSAGES (JS -> Elm)


type IncomingMsg
    = DocumentsLoaded (List Document)
    | DocumentLoaded Document
    | ThemeLoaded String
    | UserNameLoaded String


-- PORTS


port outgoing : Encode.Value -> Cmd msg
port incoming : (Encode.Value -> msg) -> Sub msg


-- PUBLIC API


send : OutgoingMsg -> Cmd msg
send msg =
    outgoing (encodeOutgoing msg)


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

        _ ->
            Decode.fail ("Unknown tag: " ++ tag)