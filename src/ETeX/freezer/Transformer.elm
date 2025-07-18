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
                    AlphaNum macro |> Debug.log "macroIze (1)"

                Nothing ->
                    expr |> Debug.log "macroIze (2)"

        Arg args ->
            Arg (List.map macroIze args)
                |> Debug.log "macroIze (3)"

        Macro name exprs ->
            Macro name (List.map macroIze exprs)
                |> Debug.log "macroIze (4)"

        _ ->
            expr |> Debug.log "macroIze (5)"


transformWord : String -> Result (List (DeadEnd Context Problem)) String
transformWord word =
    word
        |> parse
        |> Debug.log "(1)"
        |> Result.map (List.map macroIze)
        |> Debug.log "(2)"
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
