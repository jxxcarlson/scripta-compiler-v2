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
            """\\item{red}
\\item{white}
\\item{blue}"""

        output =
            L2S.translate input
    in
    div
        [ style "padding" "20px"
        , style "font-family" "monospace"
        ]
        [ h2 [] [ text "LaTeX to Scripta Item Test" ]
        , div []
            [ h2 [] [ text "Input:" ]
            , pre [] [ text input ]
            ]
        , div []
            [ h2 [] [ text "Output:" ]
            , pre [] [ text output ]
            ]
        ]