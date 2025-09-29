module DebugSection exposing (main)

import Html exposing (Html, div, pre, text)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S
import Debug


main : Html msg
main =
    let
        latex = """\\section{Introduction}

This is some text.

"""
        forest = L2S.parseL latex
        result = L2S.renderS forest

        debugInfo =
            "Input:\n" ++ latex ++ "\n\n" ++
            "Forest structure:\n" ++ Debug.toString forest ++ "\n\n" ++
            "Output:\n" ++ result
    in
    div [ style "padding" "20px" ]
        [ pre [ style "white-space" "pre-wrap", style "font-size" "12px" ] [ text debugInfo ]
        ]