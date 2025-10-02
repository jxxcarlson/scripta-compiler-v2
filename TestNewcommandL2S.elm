module TestNewcommandL2S exposing (main)

import Html exposing (Html)
import Html.Attributes
import Render.Export.LaTeXToScripta as L2S


main : Html msg
main =
    let
        latex =
            """\\newcommand{\\N}{\\mathbb{N}}

$\\N$"""

        result =
            L2S.translate latex

        expected =
            """| mathmacros
N: mathbb N

"""

        passes =
            result == expected
    in
    Html.div []
        [ Html.h2 [] [ Html.text "LaTeX to Scripta - newcommand Test" ]
        , Html.h3 [] [ Html.text "Input LaTeX:" ]
        , Html.pre [] [ Html.text latex ]
        , Html.h3 [] [ Html.text "Expected Scripta:" ]
        , Html.pre [] [ Html.text expected ]
        , Html.h3 [] [ Html.text "Actual Result:" ]
        , Html.pre [] [ Html.text result ]
        , Html.h3
            [ Html.Attributes.style "color" (if passes then "green" else "red") ]
            [ Html.text (if passes then "✓ PASS" else "✗ FAIL") ]
        , Html.h3 [] [ Html.text "Debug Info:" ]
        , Html.pre []
            [ Html.text <| "Result length: " ++ String.fromInt (String.length result)
            , Html.br [] []
            , Html.text <| "Expected length: " ++ String.fromInt (String.length expected)
            ]
        ]
