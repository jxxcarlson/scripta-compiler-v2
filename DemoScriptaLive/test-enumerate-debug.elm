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
            """AAA

\\begin{enumerate}

\\item{First}

\\item{Second}

\\end{enumerate}

BBB"""

        output =
            L2S.translate input

        expected =
            """AAA

. First

. Second

BBB"""

        -- Debug: show the actual characters
        showChars s =
            s |> String.toList |> List.map (\c ->
                if c == '\n' then
                    "\\n"
                else
                    String.fromChar c
            ) |> String.join ""
    in
    div
        [ style "padding" "20px"
        , style "font-family" "monospace"
        ]
        [ h2 [] [ text "Enumerate Debug Test" ]
        , div []
            [ h2 [] [ text "Input:" ]
            , pre [] [ text input ]
            ]
        , div []
            [ h2 [] [ text "Expected Output:" ]
            , pre [] [ text expected ]
            , div [] [ text ("As chars: " ++ showChars expected) ]
            ]
        , div []
            [ h2 [] [ text "Actual Output:" ]
            , pre [] [ text output ]
            , div [] [ text ("As chars: " ++ showChars output) ]
            ]
        , div []
            [ h2 [] [ text "Result:" ]
            , if output == expected then
                div [ style "color" "green" ] [ text "✓ PASS" ]
              else
                div [ style "color" "red" ] [ text "✗ FAIL" ]
            ]
        ]