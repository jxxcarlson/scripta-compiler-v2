module ETeX.Transformer exposing (transform, transformWord)

import Dict exposing (Dict)
import ETeX.Dictionary exposing (symbolDict)
import ETeX.Parser exposing (..)
import Parser.Advanced exposing (DeadEnd)
import Result.Extra


macroIze : MathExpr -> MathExpr
macroIze expr =
    case expr of
        AlphaNum word ->
            case Dict.get word symbolDict of
                Just macro ->

                Nothing ->

        Arg args ->
            Arg (List.map macroIze args)

        Macro name exprs ->
            Macro name (List.map macroIze exprs)

        _ ->


transformWord : String -> Result (List (DeadEnd Context Problem)) String
transformWord word =
    word
        |> parse
        |> Result.map (List.map macroIze)
        |> Result.map printList


transform : String -> Result (List (DeadEnd Context Problem)) String
transform input =
    let
        words =
            String.words input

        transformedWords =
            List.map transformWord words
    in
    transformedWords
        |> Result.Extra.combine
        |> Result.map (String.join " ")
