module TestMathMacros exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style)
import Render.Export.LaTeXToScripta as L2S

main =
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "Math Macros Conversion Test" ]
        , testCase test1Input "Test 1: Basic macros"
        , testCase test2Input "Test 2: Complex frac macro"
        , testCase test3Input "Test 3: Multiple macros"
        , testCase test4Input "Test 4: Empty input"
        , testCase test5Input "Test 5: Mixed content with non-macros"
        ]

testCase : String -> String -> Html msg
testCase input title =
    let
        output = L2S.mathMacros input

        expected =
            if input == test1Input then
                expectedOutput1
            else if input == test2Input then
                expectedOutput2
            else if input == test3Input then
                expectedOutput3
            else if input == test4Input then
                expectedOutput4
            else if input == test5Input then
                expectedOutput5
            else
                ""

        isCorrect = output == expected

        statusColor = if isCorrect then "green" else "red"
        statusText = if isCorrect then "✓ PASS" else "✗ FAIL"
    in
    div [ style "border" "1px solid #ccc", style "padding" "10px", style "margin" "10px 0" ]
        [ h3 [] [ text title, span [ style "color" statusColor, style "margin-left" "10px" ] [ text statusText ] ]
        , div [ style "background" "#f0f0f0", style "padding" "10px" ]
            [ strong [] [ text "Input:" ]
            , pre [] [ text input ]
            ]
        , div [ style "background" "#f0f0f0", style "padding" "10px", style "margin-top" "10px" ]
            [ strong [] [ text "Expected:" ]
            , pre [] [ text expected ]
            ]
        , div [ style "background" (if isCorrect then "#f0f0f0" else "#ffe0e0"), style "padding" "10px", style "margin-top" "10px" ]
            [ strong [] [ text "Actual Output:" ]
            , pre [] [ text output ]
            ]
        ]

-- Test inputs
test1Input =
    """\\newcommand{\\ket}[1]{| #1 \\rangle}
\\newcommand{\\bra}[1]{\\langle #1 |}"""

test2Input =
    """\\newcommand{\\od}[2]{\\frac{d #1}{d #2}}"""

test3Input =
    """\\newcommand{\\ket}[1]{| #1 \\rangle}
\\newcommand{\\bra}[1]{\\langle #1 |}
\\newcommand{\\bracket}[2]{\\langle #1 | #2 \\rangle}
\\newcommand{\\ketbra}[2]{| #1 \\rangle \\langle #2 |}
\\newcommand{\\diag}[1]{| #1 \\rangle \\langle #1 |}
\\newcommand{\\od}[2]{\\frac{d #1}{d #2}}"""

test4Input =
    ""

test5Input =
    """Some random text
\\newcommand{\\ket}[1]{| #1 \\rangle}
This should be ignored
\\newcommand{\\bra}[1]{\\langle #1 |}
More text"""

-- Expected outputs
expectedOutput1 =
    """| mathmacros
ket: | #1 rangle
bra: langle #1 |"""

expectedOutput2 =
    """| mathmacros
od: frac(d #1, d #2)"""

expectedOutput3 =
    """| mathmacros
ket: | #1 rangle
bra: langle #1 |
bracket: langle #1 | #2 rangle
ketbra: | #1 rangle langle #2 |
diag: | #1 rangle langle #1 |
od: frac(d #1, d #2)"""

expectedOutput4 =
    ""

expectedOutput5 =
    """| mathmacros
ket: | #1 rangle
bra: langle #1 |"""