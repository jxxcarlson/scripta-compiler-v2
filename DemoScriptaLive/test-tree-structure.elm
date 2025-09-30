module TestTreeStructure exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import RoseTree.Tree as Tree exposing (Tree(..))
import ScriptaV2.Compiler as Compiler
import ScriptaV2.Language exposing (Language(..))
import Generic.BlockUtilities
import Generic.Language exposing (ExpressionBlock)


sourceText =
    """AAA

- Outer 1

  - Inner 1

  - Inner 2

- Outer 2

BBB"""


main =
    let
        -- Parse the source text (SMarkdownLang for list syntax with -)
        ast =
            Compiler.parseFromString SMarkdownLang sourceText

        -- Debug: show tree structure
        treeDebug =
            ast
                |> List.indexedMap (\i tree -> ( i, debugTree tree ))
                |> List.map (\( i, str ) -> "Tree " ++ String.fromInt i ++ ":\n" ++ str)
                |> String.join "\n\n"
    in
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "Tree Structure Debug" ]
        , h2 [] [ text "Source (Scripta):" ]
        , pre [ style "background" "#f0f0f0", style "padding" "10px" ] [ text sourceText ]
        , h2 [] [ text "AST Tree Structure:" ]
        , pre
            [ style "background" "#e0f0e0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text treeDebug ]
        ]


debugTree : Tree ExpressionBlock -> String
debugTree tree =
    debugTreeHelper 0 tree


debugTreeHelper : Int -> Tree ExpressionBlock -> String
debugTreeHelper depth tree =
    let
        indent =
            String.repeat (depth * 2) " "

        blockName =
            Tree.value tree
                |> Generic.BlockUtilities.getExpressionBlockName
                |> Maybe.withDefault "(no name)"

        blockIndent =
            String.fromInt (Tree.value tree).indent

        childrenDebug =
            case Tree.children tree of
                [] ->
                    ""

                children ->
                    "\n"
                        ++ (children
                                |> List.map (debugTreeHelper (depth + 1))
                                |> String.join "\n"
                           )
    in
    indent ++ blockName ++ " (indent=" ++ blockIndent ++ ")" ++ childrenDebug