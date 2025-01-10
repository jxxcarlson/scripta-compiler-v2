module Render.TOCTree exposing (..)

import Generic.ASTTools
import Generic.Forest exposing (Forest)
import Generic.Language exposing (ExpressionBlock)
import Library.Forest
import List.Extra
import RoseTree.Tree as T exposing (Tree)


rawToc : Forest ExpressionBlock -> List (Tree ExpressionBlock)
rawToc ast =
    Generic.ASTTools.tableOfContents 8 ast
        |> Library.Forest.makeForest tocLevel


tocLevel : ExpressionBlock -> Int
tocLevel { args } =
    List.Extra.getAt 0 args |> Maybe.andThen String.toInt |> Maybe.withDefault 1
