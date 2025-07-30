module Document exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode
import Theme
import Time


type alias Document =
    { id : String
    , title : String
    , author : String
    , content : String
    , theme : Theme.Theme
    , createdAt : Time.Posix
    , modifiedAt : Time.Posix
    }


{-| Record containing source text and a position within it.
-}
type alias SourceTextRecord =
    { position : Int, source : String }


type alias EditorTargetData =
    { target : String, editorData : { begin : Int, end : Int } }



-- ENCODERS


encodeDocument : Document -> Encode.Value
encodeDocument doc =
    Encode.object
        [ ( "id", Encode.string doc.id )
        , ( "title", Encode.string doc.title )
        , ( "author", Encode.string doc.author )
        , ( "content", Encode.string doc.content )
        , ( "theme", encodeTheme doc.theme )
        , ( "createdAt", Encode.int (Time.posixToMillis doc.createdAt) )
        , ( "modifiedAt", Encode.int (Time.posixToMillis doc.modifiedAt) )
        ]


encodeTheme : Theme.Theme -> Encode.Value
encodeTheme theme =
    case theme of
        Theme.Light ->
            Encode.string "light"

        Theme.Dark ->
            Encode.string "dark"



-- DECODERS


documentDecoder : Decode.Decoder Document
documentDecoder =
    Decode.map7 Document
        (Decode.field "id" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "author" Decode.string)
        (Decode.field "content" Decode.string)
        (Decode.field "theme" themeDecoder)
        (Decode.field "createdAt" (Decode.int |> Decode.map Time.millisToPosix))
        (Decode.field "modifiedAt" (Decode.int |> Decode.map Time.millisToPosix))


themeDecoder : Decode.Decoder Theme.Theme
themeDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "light" ->
                        Decode.succeed Theme.Light

                    "dark" ->
                        Decode.succeed Theme.Dark

                    _ ->
                        Decode.fail "Unknown theme"
            )



-- HELPERS


newDocument : String -> String -> String -> String -> Theme.Theme -> Time.Posix -> Document
newDocument id title author content theme now =
    { id = id
    , title = title
    , author = author
    , content = content
    , theme = theme
    , createdAt = now
    , modifiedAt = now
    }


defaultDocument : Time.Posix -> Document
defaultDocument now =
    newDocument "default" "Untitled Document" "" "" Theme.Dark now
