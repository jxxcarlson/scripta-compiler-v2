module TestLaTeXToScriptaSuite exposing (main)

import Html exposing (Html)
import Html.Attributes
import Render.Export.LaTeXToScripta as L2S


main : Html msg
main =
    let
        tests =
            [ test1, test2, test3 ]

        allPassed =
            List.all .passed tests

        passCount =
            List.filter .passed tests |> List.length

        totalCount =
            List.length tests
    in
    Html.div []
        [ Html.h2 [] [ Html.text "LaTeX to Scripta Comprehensive Tests" ]
        , Html.h3
            [ Html.Attributes.style "color" (if allPassed then "green" else "red") ]
            [ Html.text <|
                if allPassed then
                    "✓ ALL TESTS PASSED (" ++ String.fromInt passCount ++ "/" ++ String.fromInt totalCount ++ ")"

                else
                    "✗ SOME TESTS FAILED (" ++ String.fromInt passCount ++ "/" ++ String.fromInt totalCount ++ ")"
            ]
        , Html.div [] (List.map renderTest tests)
        ]


type alias TestResult =
    { name : String
    , passed : Bool
    , expected : String
    , actual : String
    }


renderTest : TestResult -> Html msg
renderTest test =
    Html.div
        [ Html.Attributes.style "margin" "20px 0"
        , Html.Attributes.style "padding" "10px"
        , Html.Attributes.style "border" "1px solid #ccc"
        ]
        [ Html.h4
            [ Html.Attributes.style "color" (if test.passed then "green" else "red") ]
            [ Html.text <| (if test.passed then "✓ " else "✗ ") ++ test.name ]
        , if test.passed then
            Html.text ""

          else
            Html.div []
                [ Html.h5 [] [ Html.text "Expected:" ]
                , Html.pre [] [ Html.text test.expected ]
                , Html.h5 [] [ Html.text "Actual:" ]
                , Html.pre [] [ Html.text test.actual ]
                ]
        ]


test1 : TestResult
test1 =
    let
        latex =
            """\\begin{align}
a &= b + c \\\\
x &= y + z
\\end{align}"""

        result =
            L2S.translate latex

        expected =
            """| aligned
a &= b + c \\\\
x &= y + z"""
    in
    { name = "align environment with line breaks"
    , passed = result == expected
    , expected = expected
    , actual = result
    }


test2 : TestResult
test2 =
    let
        latex =
            """\\newcommand{\\N}{\\mathbb{N}}

$\\N$"""

        result =
            L2S.translate latex

        expected =
            """| mathmacros
N: mathbb N

"""
    in
    { name = "newcommand to mathmacros block"
    , passed = result == expected
    , expected = expected
    , actual = result
    }


test3 : TestResult
test3 =
    let
        latex =
            "Hello world"

        result =
            L2S.translate latex

        expected =
            "Hello world"
    in
    { name = "Simple paragraph"
    , passed = result == expected
    , expected = expected
    , actual = result
    }
