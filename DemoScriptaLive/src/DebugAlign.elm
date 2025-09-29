module DebugAlign exposing (main)

import Html exposing (Html, div, pre, text, h3)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S
import Render.Export.LaTeXToScriptaTest as Test
import Generic.Language exposing (Expr(..), Expression)
import Debug


main : Html msg
main =
    let
        latex = """This is a \\href{https://example.com}{link to a website}."""
        forest = L2S.parseL latex
        result = L2S.renderS forest

        -- Let's manually test the rendering
        testExpr = Fun "href" [Text "https://example.com" { begin = 0, end = 0, id = "", index = 0 }, Text "link to a website" { begin = 0, end = 0, id = "", index = 0 }] { begin = 0, end = 0, id = "", index = 0 }
        manualResult = L2S.renderExpression testExpr

        debugInfo =
            "Input:\n" ++ latex ++ "\n\n" ++
            "Manual test of Fun href [url, text]:\n" ++ manualResult ++ "\n\n" ++
            "Full Output:\n" ++ result ++ "\n\n" ++
            "Parsed Forest Structure:\n" ++ Debug.toString forest
    in
    div [ style "padding" "20px" ]
        [ h3 [] [ text "Debug href parsing:" ]
        , pre [ style "white-space" "pre-wrap", style "font-size" "10px" ] [ text debugInfo ]
        , h3 [] [ text "Test 9 output:" ]
        , pre [ style "white-space" "pre-wrap", style "font-size" "12px" ] [ text Test.test9 ]
        ]