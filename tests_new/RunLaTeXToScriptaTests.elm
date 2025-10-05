module RunLaTeXToScriptaTests exposing (main)

import Html exposing (Html)
import Html.Attributes
import Render.Export.LaTeXToScripta as L2S


main : Html msg
main =
    let
        tests =
            [ test1_simpleParagraph
            , test2_sectionWithContent
            , test3_nestedStructure
            , test4_emptyForest
            , test5_parseLCreatesForest
            , test6_alignEnvironment
            , test7_newcommandToMathmacros
            ]

        allPassed =
            List.all .passed tests

        passCount =
            List.filter .passed tests |> List.length

        totalCount =
            List.length tests
    in
    Html.div [ Html.Attributes.style "font-family" "monospace", Html.Attributes.style "padding" "20px" ]
        [ Html.h2 [] [ Html.text "LaTeX to Scripta Test Suite" ]
        , Html.h3
            [ Html.Attributes.style "color"
                (if allPassed then
                    "green"

                 else
                    "red"
                )
            ]
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
    , description : String
    }


renderTest : TestResult -> Html msg
renderTest test =
    Html.div
        [ Html.Attributes.style "margin" "20px 0"
        , Html.Attributes.style "padding" "10px"
        , Html.Attributes.style "border" "1px solid #ccc"
        , Html.Attributes.style "background-color"
            (if test.passed then
                "#f0fff0"

             else
                "#fff0f0"
            )
        ]
        [ Html.h4
            [ Html.Attributes.style "color"
                (if test.passed then
                    "green"

                 else
                    "red"
                )
            ]
            [ Html.text <| (if test.passed then "✓ " else "✗ ") ++ test.name ]
        , Html.p [ Html.Attributes.style "color" "#666" ] [ Html.text test.description ]
        , if test.passed then
            Html.text ""

          else
            Html.div []
                [ Html.h5 [] [ Html.text "Expected:" ]
                , Html.pre [ Html.Attributes.style "background" "#f5f5f5", Html.Attributes.style "padding" "10px" ] [ Html.text test.expected ]
                , Html.h5 [] [ Html.text "Actual:" ]
                , Html.pre [ Html.Attributes.style "background" "#f5f5f5", Html.Attributes.style "padding" "10px" ] [ Html.text test.actual ]
                ]
        ]


test1_simpleParagraph : TestResult
test1_simpleParagraph =
    let
        latex =
            "Hello world"

        result =
            L2S.translate latex

        expected =
            "Hello world"
    in
    { name = "Simple paragraph"
    , description = "Basic text should pass through unchanged"
    , passed = result == expected
    , expected = expected
    , actual = result
    }


test2_sectionWithContent : TestResult
test2_sectionWithContent =
    let
        latex =
            """\\section{Introduction}
This is some text."""

        result =
            L2S.translate latex

        -- We need to check what the actual output is
        passed =
            not (String.isEmpty result)
    in
    { name = "Section with content"
    , description = "Section heading followed by content"
    , passed = passed
    , expected = "(produces non-empty output)"
    , actual = result
    }


test3_nestedStructure : TestResult
test3_nestedStructure =
    let
        latex =
            """\\section{Main}
\\subsection{Sub}
Content here"""

        result =
            L2S.translate latex

        passed =
            not (String.isEmpty result)
    in
    { name = "Nested structure"
    , description = "Section with subsection and content"
    , passed = passed
    , expected = "(produces non-empty output)"
    , actual = result
    }


test4_emptyForest : TestResult
test4_emptyForest =
    let
        result =
            L2S.renderS [] []

        expected =
            ""
    in
    { name = "Empty forest"
    , description = "renderS with empty forest returns empty string"
    , passed = result == expected
    , expected = expected
    , actual = result
    }


test5_parseLCreatesForest : TestResult
test5_parseLCreatesForest =
    let
        forest =
            L2S.parseL "Hello world"

        passed =
            not (List.isEmpty forest)
    in
    { name = "parseL creates forest"
    , description = "parseL should create a non-empty forest from text"
    , passed = passed
    , expected = "(non-empty forest)"
    , actual =
        if passed then
            "Created forest with " ++ String.fromInt (List.length forest) ++ " elements"

        else
            "Empty forest"
    }


test6_alignEnvironment : TestResult
test6_alignEnvironment =
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
    , description = "LaTeX align environment should convert to Scripta aligned block"
    , passed = result == expected
    , expected = expected
    , actual = result
    }


test7_newcommandToMathmacros : TestResult
test7_newcommandToMathmacros =
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
    , description = "LaTeX newcommand should convert to Scripta mathmacros format"
    , passed = result == expected
    , expected = expected
    , actual = result
    }
