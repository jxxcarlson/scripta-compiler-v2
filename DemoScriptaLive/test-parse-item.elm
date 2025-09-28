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
            """\\item{red}

\\item{white}

\\item{blue}"""

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
    in
    div
        [ style "padding" "20px"
        , style "font-family" "monospace"
        , style "white-space" "pre-wrap"
        ]
        [ h2 [] [ text "LaTeX to Scripta Item Debug" ]
        , div []
            [ h2 [] [ text "Input:" ]
            , pre [] [ text input ]
            ]
        , div []
            [ h2 [] [ text "Parsed AST:" ]
            , pre [ style "font-size" "10px" ] [ text forestStr ]
            ]
        , div []
            [ h2 [] [ text "Output:" ]
            , pre [] [ text output ]
            ]
        ]