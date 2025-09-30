module TestNestedExport exposing (main)

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

BBB
"""


expectedOutput =
    """AAA

\\begin{itemize}
\\item Outer 1
  \\begin{itemize}
  \\item Inner 1
  \\item Inner 2
  \\end{itemize}
\\item Outer 2
\\end{itemize}

BBB"""


main =
    let
        -- Parse the source text (SMarkdownLang for list syntax with -)
        ast =
            Compiler.parseFromString SMarkdownLang sourceText

        -- Export to LaTeX using default settings
        displaySettings =
            Render.Settings.defaultDisplaySettings

        theme =
            Render.Theme.Light

        settings =
            Render.Settings.default displaySettings theme "" 500

        actualOutput =
            LaTeX.rawExport settings ast

        -- Compare
        matches =
            String.trim actualOutput == String.trim expectedOutput
    in
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "Nested List LaTeX Export Test" ]
        , h2 [] [ text "Source (Scripta):" ]
        , pre [ style "background" "#f0f0f0", style "padding" "10px" ] [ text sourceText ]
        , h2 [] [ text "Expected LaTeX Output:" ]
        , pre [ style "background" "#e0f0e0", style "padding" "10px" ] [ text expectedOutput ]
        , h2 [] [ text "Actual LaTeX Output:" ]
        , pre
            [ style "background" (if matches then "#e0f0e0" else "#ffe0e0")
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text actualOutput ]
        , h2
            [ style "color" (if matches then "green" else "red") ]
            [ text
                (if matches then
                    "✓ PASS"

                 else
                    "✗ FAIL"
                )
            ]
        ]