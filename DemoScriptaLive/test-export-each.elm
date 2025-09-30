module TestExportEach exposing (main)

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

BBB"""


main =
    let
        -- Parse the source text
        ast =
            Compiler.parseFromString SMarkdownLang sourceText

        displaySettings =
            Render.Settings.defaultDisplaySettings

        theme =
            Render.Theme.Light

        settings =
            Render.Settings.default displaySettings theme "" 500

        -- Export each tree individually to see what we get
        individualExports =
            ast
                |> List.indexedMap (\i tree ->
                    let
                        blockName =
                            Tree.value tree
                                |> Generic.BlockUtilities.getExpressionBlockName
                                |> Maybe.withDefault "(no name)"

                        exported =
                            LaTeX.rawExport settings [tree]
                    in
                    "Tree " ++ String.fromInt i ++ " (" ++ blockName ++ "):\n" ++ exported
                )
                |> String.join "\n\n========\n\n"

        -- Full export
        fullExport =
            LaTeX.rawExport settings ast
    in
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "Individual Tree Exports" ]
        , h2 [] [ text "Source (Scripta):" ]
        , pre [ style "background" "#f0f0f0", style "padding" "10px" ] [ text sourceText ]
        , h2 [] [ text "Each tree exported individually:" ]
        , pre
            [ style "background" "#e0f0e0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text individualExports ]
        , h2 [] [ text "Full export (all trees together):" ]
        , pre
            [ style "background" "#ffe0e0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text fullExport ]
        ]