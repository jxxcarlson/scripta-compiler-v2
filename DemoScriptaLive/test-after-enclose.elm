module TestAfterEnclose exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import RoseTree.Tree as Tree exposing (Tree(..))
import ScriptaV2.Compiler as Compiler
import ScriptaV2.Language exposing (Language(..))
import Generic.BlockUtilities
import Generic.Language exposing (ExpressionBlock)
import Generic.Forest
import Render.Export.LaTeX as LaTeX


sourceText =
    """AAA

- Outer 1

  - Inner 1

  - Inner 2

- Outer 2

BBB"""


main =
    let
        -- Parse the source text
        ast =
            Compiler.parseFromString SMarkdownLang sourceText

        -- Show structure before encloseLists
        beforeDebug =
            ast
                |> List.indexedMap (\i tree -> "Tree " ++ String.fromInt i ++ ":\n" ++ debugTree tree)
                |> String.join "\n\n"

        -- Now let's manually call the processing that rawExport does
        afterEnclose =
            ast
                |> Generic.Forest.map Generic.BlockUtilities.condenseUrls
                |> encloseLists_exposed

        afterDebug =
            afterEnclose
                |> List.indexedMap (\i tree -> "Tree " ++ String.fromInt i ++ ":\n" ++ debugTree tree)
                |> String.join "\n\n"
    in
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "Before and After encloseLists" ]
        , h2 [] [ text "Source (Scripta):" ]
        , pre [ style "background" "#f0f0f0", style "padding" "10px" ] [ text sourceText ]
        , h2 [] [ text "BEFORE encloseLists:" ]
        , pre
            [ style "background" "#e0f0e0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text beforeDebug ]
        , h2 [] [ text "AFTER encloseLists:" ]
        , pre
            [ style "background" "#ffe0e0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text afterDebug ]
        ]


-- Expose encloseLists for testing (copy from LaTeX.elm)
encloseLists_exposed = LaTeX.encloseLists_forDebug


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

        children =
            Tree.children tree

        childrenDebug =
            case children of
                [] ->
                    ""

                _ ->
                    "\n"
                        ++ (children
                                |> List.map (debugTreeHelper (depth + 1))
                                |> String.join "\n"
                           )
    in
    indent ++ blockName ++ " (indent=" ++ blockIndent ++ ")" ++ childrenDebug