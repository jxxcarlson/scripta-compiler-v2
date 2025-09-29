module TestLaTeXToScripta exposing (main)

import Browser
import Html exposing (Html, div, h1, h2, pre, text)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScriptaTest as Test


main : Program () () ()
main =
    Browser.sandbox
        { init = ()
        , update = \_ model -> model
        , view = view
        }


view : () -> Html ()
view _ =
    div
        [ style "padding" "20px"
        , style "font-family" "monospace"
        ]
        [ h1 [] [ text "LaTeX to Scripta Translation Tests" ]
        , div []
            [ h2 [] [ text "Test Results:" ]
            , pre
                [ style "background" "#f0f0f0"
                , style "padding" "10px"
                , style "white-space" "pre-wrap"
                ]
                [ text Test.runTests ]
            ]
        ]