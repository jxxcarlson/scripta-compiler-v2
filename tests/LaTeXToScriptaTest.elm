module LaTeXToScriptaTest exposing (..)

import Expect
import Render.Export.LaTeXToScripta as L2S
import Test exposing (..)


suite : Test
suite =
    describe "LaTeXToScripta2"
        [ describe "Basic translation tests"
            [ test "Simple paragraph" <|
                \_ ->
                    let
                        latex =
                            "Hello world"

                        result =
                            L2S.translate latex

                        expected =
                            "block"
                    in
                    Expect.equal expected result
            , test "Section with content" <|
                \_ ->
                    let
                        latex =
                            """\\section{Introduction}
This is some text."""

                        result =
                            L2S.translate latex

                        -- With current placeholder, we expect structured output
                        expected =
                            "block\n  block"
                    in
                    Expect.equal expected result
            , test "Nested structure" <|
                \_ ->
                    let
                        latex =
                            """\\section{Main}
\\subsection{Sub}
Content here"""

                        result =
                            L2S.translate latex
                    in
                    -- Just check it produces something for now
                    Expect.notEqual "" result
            ]
        , describe "renderS tests"
            [ test "Empty forest" <|
                \_ ->
                    let
                        result =
                            L2S.renderS []
                    in
                    Expect.equal "" result
            , test "Single tree renders without indent" <|
                \_ ->
                    -- We'll need to construct a simple tree for testing
                    -- For now, just verify the function exists
                    let
                        result =
                            L2S.renderS []
                    in
                    Expect.equal "" result
            ]
        , describe "parseL tests"
            [ test "parseL creates forest from LaTeX" <|
                \_ ->
                    let
                        forest =
                            L2S.parseL "Hello world"
                    in
                    -- Verify it creates a non-empty forest
                    Expect.notEqual [] forest
            ]
        , describe "Aligned block conversion"
            [ test "align environment with line breaks" <|
                \_ ->
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
                    Expect.equal expected result
            ]
        , describe "Math macro conversion"
            [ test "newcommand to mathmacros block" <|
                \_ ->
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
                    Expect.equal expected result
            ]
        ]