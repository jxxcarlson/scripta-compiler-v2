module Render.Pretty exposing (..)

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
                |> Debug.log "@@ PRINTED !!"

        _ ->
            str


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
        |> forestMap Generic.Language.printBlock


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


thm =
    """
| theorem (Euclid) width:200
There are infnitely many primes $p$.
"""


cd =
    """
| code
a := 1
b := 1
a + b
"""


s =
    """
This is a test - a test
- a test - a test - a test 

| equation
a^2 + b^2 = c^2

another test
[b and another] 
[i and another]"""


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


li1 =
    """
. (a) As you edit a document, the rendered version is updated as you type.
(b) As you edit a document, the rendered version is updated as you type.
(c) As you edit a document, the rendered version is updated as you type.
"""


li =
    """
. [b Real-time rendering:] [i As you edit a document], the rendered version is updated as you type.  In real time, [u instantaneosly], along
with cross-references and the automatically generated table of [u contents].
"""
