module DebugImageCaptioned exposing (main)

import Html exposing (Html, div, pre, text, h3)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S
import Debug


main : Html msg
main =
    let
        latex = """\\imagecentercaptioned{https://www.realsimple.com/thmb/7xn0oIF6a9eJ-y_4OO5vN0lJhCg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/humming-bird-flowers-GettyImages-1271839175-b515cb4f06a34e66b084ba617995f00a.jpg}{0.51\\textwidth,keepaspectratio}{Humming bird}
"""
        forest = L2S.parseL latex
        result = L2S.renderS forest

        debugInfo =
            "Input:\n" ++ latex ++ "\n\n" ++
            "Parsed Forest Structure:\n" ++ Debug.toString forest ++ "\n\n" ++
            "Output:\n" ++ result
    in
    div [ style "padding" "20px" ]
        [ h3 [] [ text "Debug imagecentercaptioned parsing:" ]
        , pre [ style "white-space" "pre-wrap", style "font-size" "10px" ] [ text debugInfo ]
        ]