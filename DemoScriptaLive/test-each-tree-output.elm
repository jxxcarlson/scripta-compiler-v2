module TestEachTreeOutput exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import Render.Export.LaTeX as LaTeX
import Render.Settings
import Render.Theme
import ScriptaV2.Compiler as Compiler
import ScriptaV2.Language exposing (Language(..))
import Generic.BlockUtilities
import RoseTree.Tree as Tree


sourceText =
    """AAA

- Outer 1

  - Inner 1

  - Inner 2

- Outer 2

BBB
"""


main =
    let
        ast =
            Compiler.parseFromString SMarkdownLang sourceText

        displaySettings =
            Render.Settings.defaultDisplaySettings

        theme =
            Render.Theme.Light

        settings =
            Render.Settings.default displaySettings theme "" 500

        -- Export each tree to see what we get
        treeExports =
            ast
                |> List.indexedMap (\i tree ->
                    let
                        blockName =
                            Tree.value tree
                                |> Generic.BlockUtilities.getExpressionBlockName
                                |> Maybe.withDefault "(paragraph)"

                        exported =
                            LaTeX.exportTree LaTeX.emptyMathMacroDict settings tree
                    in
                    "Tree " ++ String.fromInt i ++ " [" ++ blockName ++ "]: '" ++ exported ++ "'"
                )
                |> String.join "\n"
    in
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "Each Tree Export" ]
        , pre
            [ style "background" "#f0f0f0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text treeExports ]
        ]