module Generic.Compiler exposing (parse_)

import Generic.Forest
import Generic.ForestTransform
import Generic.Language exposing (ExpressionBlock)
import Generic.Pipeline
import RoseTree.Tree
import ScriptaV2.Language exposing (Language)


{-|

    This is a generic compiler from source text to a forest
    of expression blocks that takes two parsers as arguments.
    The first parser parses the primitive blocks, and the second
    parser parses the expressions in the blocks.

-}
parse_ :
    (String -> Int -> List String -> List Generic.Language.PrimitiveBlock)
    -> (Int -> String -> List Generic.Language.Expression)
    -> String
    -> Int
    -> List String
    -> List (RoseTree.Tree.Tree ExpressionBlock)
parse_ primitiveBlockParser exprParser idPrefix outerCount lines =
    lines
        |> primitiveBlockParser idPrefix outerCount
        |> Generic.ForestTransform.forestFromBlocks .indent
        |> Generic.Forest.map (Generic.Pipeline.toExpressionBlock exprParser)
