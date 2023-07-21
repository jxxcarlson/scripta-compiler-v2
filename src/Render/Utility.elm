module Render.Utility exposing
    ( argString
    , elementAttribute
    , getArg
    , getVerbatimContent
    , hspace
    , idAttribute
    , idAttributeFromInt
    , internalLink
    , leftPadding
    , makeId
    , textWidth
    , vspace
    )

import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element, paddingEach)
import Generic.ASTTools
import Generic.Language exposing (Expr(..))
import Html.Attributes
import List.Extra
import Render.Settings
import Tools.Utility as Utility


argString : List String -> String
argString args =
    List.filter (\arg -> not <| String.contains "label:" arg) args |> String.join " "


leftPadding p =
    Element.paddingEach { left = p, right = 0, top = 0, bottom = 0 }


textWidth : Render.Settings.Display -> String -> Float
textWidth display str =
    let
        pixelsPerCharacter =
            case display of
                Render.Settings.DefaultDisplay ->
                    8.0

                Render.Settings.PhoneDisplay ->
                    7.0
    in
    textWidth_ str * pixelsPerCharacter


textWidth_ : String -> Float
textWidth_ str_ =
    if String.contains "\\\\" str_ then
        str_
            |> String.split "\\\\"
            |> List.map basicTextWidth
            |> List.maximum
            -- TODO: is 30.0 the correct value?
            |> Maybe.withDefault 30.0

    else
        basicTextWidth str_


basicTextWidth : String -> Float
basicTextWidth str_ =
    let
        -- \\[a-z]*([^a-z])
        str =
            str_ |> String.words |> List.map compress |> String.join " "

        letters =
            String.split "" str
    in
    letters |> List.map charWidth |> List.sum


charWidth : String -> Float
charWidth c =
    Dict.get c charDict |> Maybe.withDefault 1.0


compress string =
    string
        ++ " "
        |> Utility.userReplace "\\\\[a-z].*[^a-zA-Z0-9]" (\_ -> "a")
        |> Utility.userReplace "\\[A-Z].*[^a-zA-Z0-9]" (\_ -> "A")
        |> String.trim


charDict : Dict String Float
charDict =
    Dict.fromList
        [ ( "a", 1.0 )
        , ( "b", 1.0 )
        , ( "c", 1.0 )
        , ( "d", 1.0 )
        , ( "e", 1.0 )
        , ( "f", 1.0 )
        , ( "g", 1.0 )
        , ( "h", 1.0 )
        , ( "i", 1.0 )
        , ( "j", 1.0 )
        , ( "k", 1.0 )
        , ( "l", 1.0 )
        , ( "m", 1.0 )
        , ( "n", 1.0 )
        , ( "o", 1.0 )
        , ( "p", 1.0 )
        , ( "q", 1.0 )
        , ( "r", 1.0 )
        , ( "s", 1.0 )
        , ( "t", 1.0 )
        , ( "u", 1.0 )
        , ( "v", 1.0 )
        , ( "w", 1.0 )
        , ( "x", 1.0 )
        , ( "y", 1.0 )
        , ( "z", 1.0 )
        , ( "A", 2.0 )
        , ( "B", 2.0 )
        , ( "C", 2.0 )
        , ( "D", 2.0 )
        , ( "E", 2.0 )
        , ( "F", 2.0 )
        , ( "G", 2.0 )
        , ( "H", 2.0 )
        , ( "I", 2.0 )
        , ( "J", 2.0 )
        , ( "K", 2.0 )
        , ( "L", 2.0 )
        , ( "M", 2.0 )
        , ( "N", 2.0 )
        , ( "O", 2.0 )
        , ( "P", 2.0 )
        , ( "Q", 2.0 )
        , ( "R", 2.0 )
        , ( "S", 2.0 )
        , ( "T", 2.0 )
        , ( "U", 2.0 )
        , ( "V", 2.0 )
        , ( "W", 2.0 )
        , ( "X", 2.0 )
        , ( "Y", 2.0 )
        , ( "Z", 2.0 )
        , ( "$", 1.0 )
        ]


getVerbatimContent : Generic.Language.ExpressionBlock -> String
getVerbatimContent { body } =
    case body of
        Either.Left str ->
            str

        Either.Right _ ->
            ""


idAttributeFromInt : Int -> Element.Attribute msg
idAttributeFromInt k =
    elementAttribute "id" (String.fromInt k)


idAttribute : String -> Element.Attribute msg
idAttribute s =
    elementAttribute "id" s


getArg : String -> Int -> List String -> String
getArg default index args =
    case List.Extra.getAt index args of
        Nothing ->
            default

        Just a ->
            a


vspace : Int -> Int -> Element.Attribute msg
vspace top bottom =
    paddingEach { left = 0, right = 0, top = top, bottom = bottom }


hspace : Int -> Int -> Element.Attribute msg
hspace left right =
    paddingEach { left = left, right = right, top = 0, bottom = 0 }


internalLink : String -> String
internalLink str =
    "#" ++ str |> makeSlug


makeId : List Generic.Language.Expression -> Element.Attribute msg
makeId exprs =
    elementAttribute "id"
        (Generic.ASTTools.stringValueOfList exprs |> String.trim |> makeSlug)


makeSlug : String -> String
makeSlug str =
    str |> String.toLower |> String.replace " " ""


elementAttribute : String -> String -> Element.Attribute msg
elementAttribute key value =
    Element.htmlAttribute (Html.Attributes.attribute key value)
