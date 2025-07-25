module Download exposing (downloadButton)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes as HtmlAttr


{-| Creates a download button using elm-ui that downloads a string as a file when clicked.

    downloadButton "Download Data" "data.txt" "text/plain" "Hello, World!"

-}
downloadButton : String -> String -> String -> String -> Element msg
downloadButton buttonTitle fileName mimeType content =
    Element.html <|
        Html.a
            [ HtmlAttr.href (dataUrl mimeType content)
            , HtmlAttr.download fileName
            , HtmlAttr.style "text-decoration" "none"
            ]
            [ Element.layout [] <|
                Element.el
                    [ Background.color (Element.rgb 0.2 0.2 0.2)
                    , Font.color (Element.rgb 0.8 0.8 0.8)
                    , Element.paddingXY 16 8
                    , Border.rounded 4
                    , Element.pointer
                    , Font.size 12
                    , Font.family [ Font.sansSerif ]
                    , Element.mouseOver
                        [ Background.color (Element.rgb255 0 105 217) ]
                    ]
                    (Element.text buttonTitle)
            ]


{-| Alternative pure elm-ui approach using Input.button
This requires handling the download via ports or JavaScript interop
-}
downloadButtonWithMsg : String -> String -> String -> String -> msg -> Element msg
downloadButtonWithMsg buttonTitle fileName mimeType content msg =
    Input.button
        [ Background.color (Element.rgb255 0 123 255)
        , Font.color (Element.rgb255 255 255 255)
        , Element.paddingXY 16 8
        , Border.rounded 4
        , Font.size 14
        , Font.family [ Font.sansSerif ]
        , Element.mouseOver
            [ Background.color (Element.rgb255 0 105 217) ]
        ]
        { onPress = Just msg
        , label = Element.text buttonTitle
        }


{-| Creates a data URL from content and MIME type
-}
dataUrl : String -> String -> String
dataUrl mimeType content =
    "data:" ++ mimeType ++ ";charset=utf-8," ++ percentEncode content


{-| URL encodes a string for use in a data URL
-}
percentEncode : String -> String
percentEncode string =
    string
        |> String.toList
        |> List.map encodeChar
        |> String.concat


encodeChar : Char -> String
encodeChar char =
    case char of
        ' ' ->
            "%20"

        '\n' ->
            "%0A"

        '\u{000D}' ->
            "%0D"

        '"' ->
            "%22"

        '#' ->
            "%23"

        '%' ->
            "%25"

        '&' ->
            "%26"

        '+' ->
            "%2B"

        ',' ->
            "%2C"

        '/' ->
            "%2F"

        ':' ->
            "%3A"

        ';' ->
            "%3B"

        '<' ->
            "%3C"

        '=' ->
            "%3D"

        '>' ->
            "%3E"

        '?' ->
            "%3F"

        '@' ->
            "%40"

        '[' ->
            "%5B"

        '\\' ->
            "%5C"

        ']' ->
            "%5D"

        '^' ->
            "%5E"

        '`' ->
            "%60"

        '{' ->
            "%7B"

        '|' ->
            "%7C"

        '}' ->
            "%7D"

        '~' ->
            "%7E"

        _ ->
            if Char.toCode char > 127 then
                percentEncodeUtf8 char

            else
                String.fromChar char


{-| Percent encode UTF-8 characters
-}
percentEncodeUtf8 : Char -> String
percentEncodeUtf8 char =
    char
        |> String.fromChar
        |> String.toList
        |> List.map Char.toCode
        |> List.map toUtf8Bytes
        |> List.concat
        |> List.map byteToHex
        |> String.concat


toUtf8Bytes : Int -> List Int
toUtf8Bytes code =
    if code < 0x80 then
        [ code ]

    else if code < 0x0800 then
        [ 0xC0 + (code // 64)
        , 0x80 + modBy 64 code
        ]

    else if code < 0x00010000 then
        [ 0xE0 + (code // 4096)
        , 0x80 + modBy 64 (code // 64)
        , 0x80 + modBy 64 code
        ]

    else
        [ 0xF0 + (code // 262144)
        , 0x80 + modBy 64 (code // 4096)
        , 0x80 + modBy 64 (code // 64)
        , 0x80 + modBy 64 code
        ]


byteToHex : Int -> String
byteToHex byte =
    "%" ++ String.toUpper (toHex byte)


toHex : Int -> String
toHex n =
    let
        toHexChar x =
            if x < 10 then
                String.fromInt x

            else
                String.fromChar (Char.fromCode (x - 10 + Char.toCode 'A'))
    in
    toHexChar (n // 16) ++ toHexChar (modBy 16 n)
