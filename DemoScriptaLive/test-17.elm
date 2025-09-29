module Test17 exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S

main =
    let
        input = "\\begin{equation}\nM_\\text{cluster} \\sim 10^{14}-10^{15} M_\\odot.\n\\end{equation}\n"
        expected = "| equation\nM_\"cluster\" sim 10^{14}-10^{15} M_{odot}."
        output = L2S.translate input
        passed = output == expected
        -- Check if the difference is only whitespace
        normalizeWhitespace s =
            s |> String.words |> String.join " " |> String.trim
        whitespaceOnly =
            not passed && (normalizeWhitespace output == normalizeWhitespace expected)
        backgroundColor =
            if passed then
                "#e0f0e0"
            else if whitespaceOnly then
                "#f0d0f0"  -- Light magenta for whitespace differences
            else
                "#ffe0e0"
    in
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "Test 17: Equation with subscript text" ]
        , div [ style "border" "1px solid #ccc", style "padding" "10px", style "margin" "10px 0" ]
            [ div [ style "background" "#f0f0f0", style "padding" "10px" ]
                [ strong [] [ text "LaTeX Input:" ]
                , pre [] [ text input ]
                ]
            , div [ style "background" "#e0f0e0", style "padding" "10px" ]
                [ strong [] [ text "Expected:" ]
                , pre [] [ text expected ]
                ]
            , div [ style "background" backgroundColor, style "padding" "10px" ]
                [ strong [] [ text "Actual Output:" ]
                , pre [] [ text (if String.isEmpty output then "(empty string)" else output) ]
                , div []
                    [ if passed then
                        span [ style "color" "green", style "font-weight" "bold" ] [ text " ✓ PASS" ]
                      else if whitespaceOnly then
                        span [ style "color" "purple", style "font-weight" "bold" ] [ text " ✗ FAIL: WHITE SPACE" ]
                      else
                        span [ style "color" "red", style "font-weight" "bold" ] [ text " ✗ FAIL" ]
                    ]
                ]
            ]
        ]