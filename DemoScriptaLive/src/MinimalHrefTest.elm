module MinimalHrefTest exposing (main)

import Html exposing (Html, div, h3, pre, text)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S


main : Html msg
main =
    let
        -- Test just href alone (with newline)
        latex1 = """\\href{https://example.com}{link to a website}
"""
        result1 = L2S.translate latex1

        -- Test href in a sentence (with newline)
        latex2 = """This is a \\href{https://example.com}{link to a website}.
"""
        result2 = L2S.translate latex2

        -- Test multiple hrefs (with newline)
        latex3 = """Check \\href{https://example.com}{example} and \\href{https://google.com}{google}.
"""
        result3 = L2S.translate latex3
    in
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h3 [] [ text "Minimal href test" ]
        , div []
            [ text "Test 1 (href alone):"
            , pre [] [ text ("Input:  " ++ latex1) ]
            , pre [] [ text ("Output: " ++ result1) ]
            ]
        , div []
            [ text "Test 2 (href in sentence):"
            , pre [] [ text ("Input:  " ++ latex2) ]
            , pre [] [ text ("Output: " ++ result2) ]
            ]
        , div []
            [ text "Test 3 (multiple hrefs):"
            , pre [] [ text ("Input:  " ++ latex3) ]
            , pre [] [ text ("Output: " ++ result3) ]
            ]
        ]