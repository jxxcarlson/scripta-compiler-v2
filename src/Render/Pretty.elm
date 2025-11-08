module Render.Pretty exposing (..)

import Generic.Forest
import Generic.Language
import RoseTree.Tree as Tree exposing (Tree)
import ScriptaV2.Compiler
import ScriptaV2.Language


print : ScriptaV2.Language.Language -> String -> String
print lang str =
    case lang of
        ScriptaV2.Language.ScriptaLang ->
            printToForest str
                |> reduceForestToString

        _ ->
            str



-- printExpressionBlock : String -> String


reduceForestToString : List (Tree String) -> String
reduceForestToString forest =
    forest
        |> List.map treeToString
        |> String.join "\n\n"


printToForest : String -> List (Tree String)
printToForest str =
    str
        |> String.lines
        |> ScriptaV2.Compiler.parseScripta "@@" 0
        |> forestMap expressionBlockToString


forestMap : (a -> b) -> List (Tree a) -> List (Tree b)
forestMap f forest =
    List.map (treeMap f) forest


treeMap : (a -> b) -> Tree a -> Tree b
treeMap f tree =
    let
        newValue =
            f (Tree.value tree)

        treeChildren =
            Tree.children tree

        newChildren =
            List.map (treeMap f) treeChildren
    in
    Tree.branch newValue newChildren


expressionBlockToString : Generic.Language.ExpressionBlock -> String
expressionBlockToString block =
    block
        |> getMetaFromBlock
        |> Maybe.map (\meta -> meta.sourceText)
        |> Maybe.withDefault ""


getMetaFromBlock : Generic.Language.ExpressionBlock -> Maybe Generic.Language.BlockMeta
getMetaFromBlock block =
    case block.heading of
        Generic.Language.Paragraph ->
            Just block.meta

        _ ->
            Nothing


treeToString : Tree String -> String
treeToString tree =
    treeToStringHelper 0 tree


treeToStringHelper : Int -> Tree String -> String
treeToStringHelper level tree =
    let
        indent =
            String.repeat level "  "

        currentLabel =
            Tree.value tree

        treeChildren =
            Tree.children tree

        currentLine =
            indent ++ currentLabel

        childLines =
            List.map (treeToStringHelper (level + 1)) treeChildren
                |> String.join "\n"
    in
    if List.isEmpty treeChildren then
        currentLine

    else
        currentLine ++ "\n" ++ childLines


t : Tree String
t =
    Tree.branch "I"
        [ Tree.branch "A"
            [ Tree.leaf "1"
            , Tree.leaf "2"
            , Tree.leaf "3"
            ]
        , Tree.branch "B"
            [ Tree.leaf "1"
            , Tree.leaf "2"
            , Tree.leaf "3"
            ]
        ]
