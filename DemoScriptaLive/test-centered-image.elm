module Main exposing (main)

import Browser
import Html exposing (Html, div, pre, text, h2)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    {}


type Msg
    = NoOp


init : Model
init =
    {}


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html Msg
view model =
    let
        input =
            """\\begin{center}
\\includegraphics[width=0.51\\textwidth]{https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/83fdbf6c-79d5-44e7-6ac6-00cdc7785000/public-b515cb4f06a34e66b084ba617995f00a.jpg}
\\end{center}"""

        output =
            L2S.translate input

        expected =
            """| image
https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/83fdbf6c-79d5-44e7-6ac6-00cdc7785000/public-b515cb4f06a34e66b084ba617995f00a.jpg"""
    in
    div
        [ style "padding" "20px"
        , style "font-family" "monospace"
        ]
        [ h2 [] [ text "Centered Image Test" ]
        , div []
            [ h2 [] [ text "Input:" ]
            , pre [] [ text input ]
            ]
        , div []
            [ h2 [] [ text "Expected Output:" ]
            , pre [] [ text expected ]
            ]
        , div []
            [ h2 [] [ text "Actual Output:" ]
            , pre [] [ text output ]
            ]
        , div []
            [ h2 [] [ text "Result:" ]
            , if output == expected then
                div [ style "color" "green" ] [ text "✓ PASS" ]
              else
                div [ style "color" "red" ] [ text "✗ FAIL" ]
            ]
        ]