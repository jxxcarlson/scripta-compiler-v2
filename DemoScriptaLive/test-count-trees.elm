module TestCountTrees exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import Render.Export.LaTeX as LaTeX
import Render.Settings
import Render.Theme
import ScriptaV2.Compiler as Compiler
import ScriptaV2.Language exposing (Language(..))


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

        actualOutput =
            LaTeX.rawExport settings ast

        treeCount =
            List.length ast

        lines =
            String.lines actualOutput

        lineCount =
            List.length lines
    in
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "Tree Count Debug" ]
        , h2 [] [ text "Source (Scripta):" ]
        , pre [ style "background" "#f0f0f0", style "padding" "10px" ] [ text sourceText ]
        , h2 [] [ text ("Number of trees in AST: " ++ String.fromInt treeCount) ]
        , h2 [] [ text ("Number of lines in output: " ++ String.fromInt lineCount) ]
        , h2 [] [ text "Actual LaTeX Output:" ]
        , pre
            [ style "background" "#ffe0e0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text actualOutput ]
        ]