module TestImageCaptioned exposing (main)

import Browser
import Html exposing (Html, div, h1, h2, pre, text)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S


main : Program () () ()
main =
    Browser.sandbox
        { init = ()
        , update = \_ model -> model
        , view = view
        }


view : () -> Html ()
view _ =
    let
        -- Test with complex URL
        input1 =
            """\\imagecentercaptioned{https://www.realsimple.com/thmb/7xn0oIF6a9eJ-y_4OO5vN0lJhCg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/humming-bird-flowers-GettyImages-1271839175-b515cb4f06a34e66b084ba617995f00a.jpg}{0.51\\textwidth,keepaspectratio}{Humming bird}
"""

        -- Test with simple URL
        input2 =
            """\\imagecentercaptioned{https://example.com/bird.jpg}{0.51\\textwidth}{Humming bird}
"""

        input = input2  -- Start with simple test

        expectedOutput =
            """| image caption:Humming bird
https://example.com/bird.jpg"""

        actualOutput =
            L2S.translate input

        isCorrect =
            String.trim actualOutput == String.trim expectedOutput
    in
    div
        [ style "padding" "20px"
        , style "font-family" "monospace"
        ]
        [ h1 [] [ text "Test: \\imagecentercaptioned" ]
        , h2 [] [ text "Input:" ]
        , pre
            [ style "background" "#f0f0f0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            , style "word-break" "break-all"
            ]
            [ text input ]
        , h2 [] [ text "Expected Output:" ]
        , pre
            [ style "background" "#e0ffe0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            , style "word-break" "break-all"
            ]
            [ text expectedOutput ]
        , h2 [] [ text "Actual Output:" ]
        , pre
            [ style "background" (if isCorrect then "#e0ffe0" else "#ffe0e0")
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            , style "word-break" "break-all"
            ]
            [ text actualOutput ]
        , h2
            [ style "color" (if isCorrect then "green" else "red") ]
            [ text (if isCorrect then "✓ Test Passed" else "✗ Test Failed") ]
        ]