module Generic.Table exposing (..)

import Dict exposing (Dict)
import Either exposing (Either(..))
import Generic.Language exposing (Expr(..), Expression)
import List.Extra
import M.Expression
import Tools.Utility


tableBody block =
    let
        t1 : List Expression
        t1 =
            prepareTable (M.Expression.parse 0) (String.join "\n" block.body) |> Debug.log "PREPARED TABLE"
    in
    Right t1


fixTable : List Expression -> List Expression
fixTable exprs =
    case List.head exprs of
        Just (Fun "table" innerExprs meta) ->
            let
                foo2 : List Expression
                foo2 =
                    fixInner innerExprs
            in
            [ Fun "table" (fixInner innerExprs |> List.map fixRow) meta ]

        _ ->
            exprs


fixInner : List Expression -> List Expression
fixInner exprs =
    List.filter
        (\e ->
            case e of
                Text str _ ->
                    if compress str == "" then
                        False

                    else
                        True

                _ ->
                    True
        )
        exprs


fixRow : Expression -> Expression
fixRow expr =
    case expr of
        Fun "row" innerExprs meta ->
            Fun "row" (fixInner innerExprs) meta

        _ ->
            expr


prepareTable : (String -> List Expression) -> String -> List Expression
prepareTable parse str =
    let
        inner : String -> String
        inner row =
            String.split "&" row
                |> List.filter (\s -> compress s /= "")
                |> List.map (\cell -> "[cell " ++ cell ++ "]")
                |> String.join " "

        cells : String
        cells =
            str
                |> String.split "\\\\\n"
                |> List.filter (\s -> compress s /= "")
                |> List.map (\r -> "[row " ++ inner r ++ " ]")
                |> (\rows -> "[table " ++ String.join " " rows ++ "]")
                |> Debug.log "CELLS"
    in
    parse cells
        -- M.Expression.parse 0 cells
        |> fixTable


textWidthWithPixelsPerCharacter : Float -> String -> Float
textWidthWithPixelsPerCharacter pixelsPerCharacter str =
    textWidth_ str * pixelsPerCharacter


textWidth_ : String -> Float
textWidth_ str__ =
    let
        str_ =
            compress str__
    in
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
        |> Tools.Utility.userReplace "\\\\[a-z].*[^a-zA-Z0-9]" (\_ -> "a")
        |> Tools.Utility.userReplace "\\[A-Z].*[^a-zA-Z0-9]" (\_ -> "A")
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
