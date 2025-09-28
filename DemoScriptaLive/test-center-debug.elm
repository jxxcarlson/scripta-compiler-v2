module Main exposing (main)

import Browser
import Html exposing (Html, div, pre, text, h2)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta2 as L2S
import Generic.Language exposing (ExpressionBlock)
import Generic.Forest exposing (Forest)


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

        -- Parse to AST
        forest : Forest ExpressionBlock
        forest =
            L2S.parseL input

        -- Show the AST structure
        forestStr =
            Debug.toString forest

        -- Then render to Scripta
        output =
            L2S.renderS [] forest

        expected =
            """| image
https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/83fdbf6c-79d5-44e7-6ac6-00cdc7785000/public-b515cb4f06a34e66b084ba617995f00a.jpg"""
    in
    div
        [ style "padding" "20px"
        , style "font-family" "monospace"
        ]
        [ h2 [] [ text "Center Debug Test" ]
        , div []
            [ h2 [] [ text "Input:" ]
            , pre [] [ text input ]
            ]
        , div []
            [ h2 [] [ text "Parsed AST:" ]
            , pre [ style "font-size" "10px", style "white-space" "pre-wrap" ] [ text forestStr ]
            ]
        , div []
            [ h2 [] [ text "Expected Output:" ]
            , pre [] [ text expected ]
            ]
        , div []
            [ h2 [] [ text "Actual Output:" ]
            , pre [] [ text output ]
            ]
        ]