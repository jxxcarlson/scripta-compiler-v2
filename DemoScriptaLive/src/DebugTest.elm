module DebugTest exposing (main)

import Html exposing (Html, div, pre, text)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S
import Debug


main : Html msg
main =
    let
        latex = "Hello world"
        forest = L2S.parseL latex
        result = L2S.renderS forest

        debugInfo =
            "Input: " ++ latex ++ "\n" ++
            "Forest length: " ++ String.fromInt (List.length forest) ++ "\n" ++
            "Forest: " ++ Debug.toString forest ++ "\n\n" ++
            "Output: " ++ result
    in
    div [ style "padding" "20px" ]
        [ pre [ style "white-space" "pre-wrap" ] [ text debugInfo ]
        ]