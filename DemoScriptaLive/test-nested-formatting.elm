module TestNestedFormatting exposing (main)

import Html
import Render.Export.LaTeX
import ScriptaV2.Compiler
import ScriptaV2.Language exposing (Language(..))
import Render.Settings
import Time

main =
    let
        sourceText = """
[b [i Bold Italic Text]]

[i [b Italic Bold Text]]

[b Normal bold [i with italic inside] and more bold]
"""

        -- Compile to AST
        ast =
            ScriptaV2.Compiler.ps sourceText

        -- Export to LaTeX
        settings =
            Render.Settings.defaultSettings Render.Settings.defaultDisplaySettings

        latexOutput =
            Render.Export.LaTeX.export (Time.millisToPosix 0) settings ast
    in
    Html.div []
        [ Html.h2 [] [ Html.text "Source:" ]
        , Html.pre [] [ Html.text sourceText ]
        , Html.h2 [] [ Html.text "LaTeX Output:" ]
        , Html.pre [] [ Html.text latexOutput ]
        ]