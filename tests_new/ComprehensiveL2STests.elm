module ComprehensiveL2STests exposing (main)

import Html exposing (Html)
import Html.Attributes as HA
import Render.Export.LaTeXToScripta as L2S


main : Html msg
main =
    let
        allTests =
            [  test1_simpleParagraph
            , test2_sectionWithContent
            , test3_nestedSections
            , test4_mathAndFormatting
            , test5_lists
            , test6_equationBlocks
            , test7_alignBlocks
            , test8_theoremDefinition
            , test9_linksCitationsFootnotes
            , test10_exampleRemarkNote
            , test11_abstractQuoteCenter
            , test12_figureTable
            , test13_verbatimUnderline
            , test14_compactItem
            , test15_imageCaptioned
            , test16_newcommandMacros
            , test17_multipleNewcommands
            , test18_nestedFormatting
            , test19_complexMath
            ]

        passedTests =
            allTests |> List.filter (\t -> t.status == Pass)

        failedTests =
            allTests |> List.filter (\t -> t.status == Fail)

        whitespaceFailedTests =
            allTests |> List.filter (\t -> t.status == WhitespaceFail)

        totalCount =
            List.length allTests

        passCount =
            List.length passedTests
    in
    Html.div
        [ HA.style "font-family" "monospace"
        , HA.style "padding" "20px"
        , HA.style "max-width" "1400px"
        ]
        [ Html.h1 [] [ Html.text "LaTeX to Scripta Comprehensive Test Suite" ]
        , Html.div [ HA.style "margin-bottom" "20px" ]
            [ Html.h2
                [ HA.style "color"
                    (if passCount == totalCount then
                        "green"

                     else
                        "red"
                    )
                ]
                [ Html.text <|
                    String.fromInt passCount
                        ++ "/"
                        ++ String.fromInt totalCount
                        ++ " tests passed"
                ]
            , Html.p []
                [ Html.text <| "✓ Passed: " ++ String.fromInt (List.length passedTests)
                , Html.br [] []
                , Html.text <| "✗ Failed: " ++ String.fromInt (List.length failedTests)
                , Html.br [] []
                , Html.text <| "≈ Whitespace only: " ++ String.fromInt (List.length whitespaceFailedTests)
                ]
            ]
        , Html.div [] (List.map renderTest allTests)
        ]


type TestStatus
    = Pass
    | Fail
    | WhitespaceFail


type alias TestCase =
    { name : String
    , description : String
    , input : String
    , expected : String
    , actual : String
    , status : TestStatus
    }


renderTest : TestCase -> Html msg
renderTest test =
    let
        backgroundColor =
            case test.status of
                Pass ->
                    "#f0fff0"

                Fail ->
                    "#fff0f0"

                WhitespaceFail ->
                    "#fff0ff"

        statusText =
            case test.status of
                Pass ->
                    "✓ PASS"

                Fail ->
                    "✗ FAIL"

                WhitespaceFail ->
                    "≈ FAIL (whitespace only)"
    in
    Html.div
        [ HA.style "margin" "20px 0"
        , HA.style "padding" "15px"
        , HA.style "border" "2px solid #ccc"
        , HA.style "background-color" backgroundColor
        ]
        [ Html.h3 []
            [ Html.text <| test.name ++ " - " ++ statusText ]
        , Html.p [ HA.style "color" "#666", HA.style "font-style" "italic" ]
            [ Html.text test.description ]
        , Html.div [ HA.style "display" "grid", HA.style "grid-template-columns" "1fr 1fr 1fr", HA.style "gap" "10px" ]
            [ Html.div []
                [ Html.h4 [ HA.style "margin-top" "0" ] [ Html.text "Input:" ]
                , Html.pre
                    [ HA.style "background" "#f5f5f5"
                    , HA.style "padding" "10px"
                    , HA.style "border" "1px solid #ddd"
                    , HA.style "overflow-x" "auto"
                    , HA.style "white-space" "pre-wrap"
                    ]
                    [ Html.text test.input ]
                ]
            , Html.div []
                [ Html.h4 [ HA.style "margin-top" "0" ] [ Html.text "Expected:" ]
                , Html.pre
                    [ HA.style "background" "#f5f5f5"
                    , HA.style "padding" "10px"
                    , HA.style "border" "1px solid #ddd"
                    , HA.style "overflow-x" "auto"
                    , HA.style "white-space" "pre-wrap"
                    ]
                    [ Html.text test.expected ]
                ]
            , Html.div []
                [ Html.h4 [ HA.style "margin-top" "0" ] [ Html.text "Actual:" ]
                , Html.pre
                    [ HA.style "background" "#f5f5f5"
                    , HA.style "padding" "10px"
                    , HA.style "border" "1px solid #ddd"
                    , HA.style "overflow-x" "auto"
                    , HA.style "white-space" "pre-wrap"
                    ]
                    [ Html.text test.actual ]
                ]
            ]
        ]


checkTest : String -> String -> TestStatus
checkTest expected actual =
    if expected == actual then
        Pass

    else if String.trim expected == String.trim actual then
        WhitespaceFail

    else
        Fail


test1_simpleParagraph : TestCase
test1_simpleParagraph =
    let
        input =
            "Hello world\n"

        expected =
            "Hello world"

        actual =
            L2S.translate input
    in
    { name = "Test 1"
    , description = "Simple paragraph - basic text should pass through"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test2_sectionWithContent : TestCase
test2_sectionWithContent =
    let
        input =
            """\\section{Introduction}

This is some text.
"""

        expected =
            """# Introduction

This is some text."""

        actual =
            L2S.translate input
    in
    { name = "Test 2"
    , description = "Section heading with content"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test3_nestedSections : TestCase
test3_nestedSections =
    let
        input =
            """\\section{Main}

Some content here.

\\subsection{Sub}

More content.
"""

        expected =
            """# Main

Some content here.

## Sub

More content."""

        actual =
            L2S.translate input
    in
    { name = "Test 3"
    , description = "Nested section structure"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test4_mathAndFormatting : TestCase
test4_mathAndFormatting =
    let
        input =
            """The formula $E = mc^2$ is famous.

This is \\textbf{bold} and \\emph{italic} text.
"""

        expected =
            """The formula $E = mc^2$ is famous.

This is [b bold] and [i italic] text."""

        actual =
            L2S.translate input
    in
    { name = "Test 4"
    , description = "Inline math and text formatting"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test5_lists : TestCase
test5_lists =
    let
        input =
            """\\begin{itemize}

\\item First item

\\item Second item

\\end{itemize}

\\begin{enumerate}

\\item First numbered

\\item Second numbered

\\end{enumerate}
"""

        expected =
            """- First item

- Second item

. First numbered

. Second numbered"""

        actual =
            L2S.translate input
    in
    { name = "Test 5"
    , description = "Itemize and enumerate lists"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test6_equationBlocks : TestCase
test6_equationBlocks =
    let
        input =
            """\\begin{equation}
E = mc^2
\\end{equation}
"""

        expected =
            """| equation
E = mc^2"""

        actual =
            L2S.translate input
    in
    { name = "Test 6"
    , description = "Equation environment"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test7_alignBlocks : TestCase
test7_alignBlocks =
    let
        input =
            """\\begin{align}
a &= b + c \\\\
x &= y + z
\\end{align}
"""

        expected =
            """| aligned
a &= b + c \\\\
x &= y + z"""

        actual =
            L2S.translate input
    in
    { name = "Test 7"
    , description = "Aligned equations with line breaks"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test8_theoremDefinition : TestCase
test8_theoremDefinition =
    let
        input =
            """\\begin{theorem}[Pythagorean]
For a right triangle with legs $a$ and $b$ and hypotenuse $c$,
we have $a^2 + b^2 = c^2$.
\\end{theorem}
"""

        expected =
            """| theorem Pythagorean
For a right triangle with legs $a$ and $b$ and hypotenuse $c$, we have $a^2 + b^2 = c^2$."""

        actual =
            L2S.translate input
    in
    { name = "Test 8"
    , description = "Theorem environment with optional argument"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test9_linksCitationsFootnotes : TestCase
test9_linksCitationsFootnotes =
    let
        input =
            """This is a \\href{https://example.com}{link to a website}.

See \\cite{knuth1984} for more details.
"""

        expected =
            """This is a [link link to a website https://example.com].

See [cite knuth1984] for more details."""

        actual =
            L2S.translate input
    in
    { name = "Test 9"
    , description = "Hyperlinks and citations"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test10_exampleRemarkNote : TestCase
test10_exampleRemarkNote =
    let
        input =
            """\\begin{example}
Consider the function $f(x) = x^2$.
\\end{example}
"""

        expected =
            """| example
Consider the function $f(x) = x^2$."""

        actual =
            L2S.translate input
    in
    { name = "Test 10"
    , description = "Example environment"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test11_abstractQuoteCenter : TestCase
test11_abstractQuoteCenter =
    let
        input =
            """\\begin{abstract}
This paper discusses mathematics.
\\end{abstract}
"""

        expected =
            """| abstract
This paper discusses mathematics."""

        actual =
            L2S.translate input
    in
    { name = "Test 11"
    , description = "Abstract environment"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test12_figureTable : TestCase
test12_figureTable =
    let
        input =
            """\\begin{verbatim}
code here
\\end{verbatim}
"""

        expected =
            """| code
code here"""

        actual =
            L2S.translate input
    in
    { name = "Test 12"
    , description = "Verbatim/code block"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test13_verbatimUnderline : TestCase
test13_verbatimUnderline =
    let
        input =
            """This is \\underline{underlined text} here.
"""

        expected =
            """This is [u underlined text] here."""

        actual =
            L2S.translate input
    in
    { name = "Test 13"
    , description = "Underline formatting"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test14_compactItem : TestCase
test14_compactItem =
    let
        input =
            """\\compactItem{First item}
\\compactItem{Second item}
"""

        expected =
            """- First item
- Second item"""

        actual =
            L2S.translate input
    in
    { name = "Test 14"
    , description = "CompactItem formatting"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test15_imageCaptioned : TestCase
test15_imageCaptioned =
    let
        input =
            """\\imagecentercaptioned{https://example.com/image.jpg}{0.5\\textwidth}{A caption}
"""

        expected =
            """| image caption:A caption
https://example.com/image.jpg"""

        actual =
            L2S.translate input
    in
    { name = "Test 15"
    , description = "Centered captioned image"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test16_newcommandMacros : TestCase
test16_newcommandMacros =
    let
        input =
            """\\newcommand{\\N}{\\mathbb{N}}

$\\N$"""

        expected =
            """| mathmacros
N: mathbb N

"""

        actual =
            L2S.translate input
    in
    { name = "Test 16"
    , description = "Single newcommand to mathmacros"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test17_multipleNewcommands : TestCase
test17_multipleNewcommands =
    let
        input =
            """\\newcommand{\\N}{\\mathbb{N}}
\\newcommand{\\R}{\\mathbb{R}}
\\newcommand{\\Z}{\\mathbb{Z}}
"""

        expected =
            """| mathmacros
N: mathbb N
R: mathbb R
Z: mathbb Z

"""

        actual =
            L2S.translate input
    in
    { name = "Test 17"
    , description = "Multiple newcommands"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test18_nestedFormatting : TestCase
test18_nestedFormatting =
    let
        input =
            """This is \\textbf{bold with \\emph{italic} inside}.
"""

        expected =
            """This is [b bold with [i italic] inside]."""

        actual =
            L2S.translate input
    in
    { name = "Test 18"
    , description = "Nested text formatting"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }


test19_complexMath : TestCase
test19_complexMath =
    let
        input =
            """$$\\int_0^\\infty e^{-x^2} dx = \\frac{\\sqrt{\\pi}}{2}$$
"""

        expected =
            """$$\\int_0^\\infty e^{-x^2} dx = \\frac{\\sqrt{\\pi}}{2}$$"""

        actual =
            L2S.translate input
    in
    { name = "Test 19"
    , description = "Complex display math"
    , input = input
    , expected = expected
    , actual = actual
    , status = checkTest expected actual
    }
