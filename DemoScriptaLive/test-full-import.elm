module Main exposing (main)

import Browser
import Html exposing (Html, div, pre, text, h2, h3, textarea, button)
import Html.Attributes exposing (style, value, rows, cols)
import Html.Events exposing (onInput, onClick)
import Render.Export.LaTeXToScripta as L2S


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { input : String
    , output : String
    }


type Msg
    = InputChanged String
    | Convert


init : Model
init =
    { input = """\\item{It provides a natural emergence of classical behavior from quantum mechanics}

\\item{The measurement problem is partially resolved - definite outcomes emerge through environmental interaction}

\\item{It explains why certain observables (like position) appear classical while others remain quantum}"""
    , output = ""
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        InputChanged newInput ->
            { model | input = newInput }

        Convert ->
            { model | output = L2S.translate model.input }


view : Model -> Html Msg
view model =
    div
        [ style "padding" "20px"
        , style "font-family" "monospace"
        ]
        [ h2 [] [ text "Full LaTeX Import Test" ]
        , h3 [] [ text "Input LaTeX:" ]
        , textarea
            [ value model.input
            , onInput InputChanged
            , rows 10
            , cols 80
            , style "font-family" "monospace"
            ]
            []
        , div []
            [ button [ onClick Convert ] [ text "Convert to Scripta" ]
            ]
        , h3 [] [ text "Output Scripta:" ]
        , pre [ style "background" "#f0f0f0", style "padding" "10px" ]
            [ text model.output ]
        ]