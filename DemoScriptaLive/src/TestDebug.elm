module TestDebug exposing (main)

import Browser
import Html exposing (Html, div, h1, text)
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
    div []
        [ h1 [] [ text "Individual Tests:" ]
        , div [] [ text "Test 9 output:" ]
        , div [ style "border" "1px solid black", style "padding" "10px", style "margin" "10px" ]
            [ text (String.left 200 Test.test9) ]
        , div [] [ text "Test 10 output:" ]
        , div [ style "border" "1px solid black", style "padding" "10px", style "margin" "10px" ]
            [ text (String.left 200 Test.test10) ]
        , div [] [ text "Test 11 output:" ]
        , div [ style "border" "1px solid black", style "padding" "10px", style "margin" "10px" ]
            [ text (String.left 200 Test.test11) ]
        , div [] [ text "Test 12 output:" ]
        , div [ style "border" "1px solid black", style "padding" "10px", style "margin" "10px" ]
            [ text (String.left 200 Test.test12) ]
        , div [] [ text "Test 13 output:" ]
        , div [ style "border" "1px solid black", style "padding" "10px", style "margin" "10px" ]
            [ text (String.left 200 Test.test13) ]
        , div [] [ text "Test 14 output:" ]
        , div [ style "border" "1px solid black", style "padding" "10px", style "margin" "10px" ]
            [ text (String.left 200 Test.test14) ]
        ]