module TestDirect exposing (main)

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
    let
        -- Build the test string manually to see where it breaks
        tests =
            [ ("Test 1", Test.test1)
            , ("Test 2", Test.test2)
            , ("Test 3", Test.test3)
            , ("Test 4", Test.test4)
            , ("Test 5", Test.test5)
            , ("Test 6", Test.test6)
            , ("Test 7", Test.test7)
            , ("Test 8", Test.test8)
            , ("Test 9", Test.test9)
            , ("Test 10", Test.test10)
            , ("Test 11", Test.test11)
            , ("Test 12", Test.test12)
            , ("Test 13", Test.test13)
            , ("Test 14", Test.test14)
            , ("Test 15", Test.test15)
            ]

        testDivs =
            tests
                |> List.map (\(label, content) ->
                    div []
                        [ h2 [] [ text label ]
                        , pre
                            [ style "background" "#f0f0f0"
                            , style "padding" "10px"
                            , style "white-space" "pre-wrap"
                            , style "max-height" "300px"
                            , style "overflow" "auto"
                            ]
                            [ text content ]
                        , div [] [ text "========================================" ]
                        ])
    in
    div
        [ style "padding" "20px"
        , style "font-family" "monospace"
        ]
        (h1 [] [ text "LaTeX to Scripta Translation Tests (Direct)" ] :: testDivs)