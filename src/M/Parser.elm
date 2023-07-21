module M.Parser exposing (f, toExpressionBlockForestFromStringlist, toExpressionBlocksFromString)

import Generic.Forest exposing (Forest)
import Generic.ForestTransform exposing (Error)
import Generic.Language exposing (ExpressionBlock)
import Generic.Pipeline
import M.Expression
import M.PrimitiveBlock
import ScriptaV2.Config as Config


{-|

    For testing things and working in the repl

-}
f : String -> Result Error (Forest Generic.Language.SimpleExpressionBlock)
f str =
    str
        |> String.lines
        |> toExpressionBlockForestFromStringlist
        |> Result.map (Generic.Forest.map Generic.Language.simplifyExpressionBlock)


toExpressionBlockForestFromStringlist : List String -> Result Error (Forest ExpressionBlock)
toExpressionBlockForestFromStringlist lines =
    lines
        |> Generic.Pipeline.toExpressionBlockForestFromStringlist Config.expressionIdPrefix 0 M.Expression.parse


toExpressionBlocksFromString : Int -> String -> List ExpressionBlock
toExpressionBlocksFromString lineNumber str =
    str
        |> String.lines
        |> M.PrimitiveBlock.parse "!!" lineNumber
        |> List.map (Generic.Pipeline.toExpressionBlock M.Expression.parse)
