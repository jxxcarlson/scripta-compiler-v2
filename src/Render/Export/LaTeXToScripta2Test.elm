module Render.Export.LaTeXToScripta2Test exposing (runTests, test1, test2, test3, test4, test5, test6, test7)

import Render.Export.LaTeXToScripta2 as L2S


{-| Run all tests and return results as a string
-}
runTests : String
runTests =
    [ test1
    , test2
    , test3
    , test4
    , test5
    , test6
    , test7
    ]
        |> String.join "\n\n========================================\n\n"


{-| Test 1: Simple paragraph
-}
test1 : String
test1 =
    let
        latex =
            "Hello world\n"

        result =
            L2S.translate latex
    in
    "Test 1: Simple paragraph\n"
        ++ "Input:  "
        ++ latex
        ++ "\n"
        ++ "Output: "
        ++ result


{-| Test 2: Section with content
-}
test2 : String
test2 =
    let
        latex =
            """\\section{Introduction}

This is some text.

"""

        result =
            L2S.translate latex
    in
    "Test 2: Section with content\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 3: Nested sections
-}
test3 : String
test3 =
    let
        latex =
            """\\section{Main}

Some content here.

\\subsection{Sub}

More content.

"""

        result =
            L2S.translate latex
    in
    "Test 3: Nested sections\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 4: Math and formatting
-}
test4 : String
test4 =
    let
        latex =
            """The formula $E = mc^2$ is famous.

\\begin{equation}
\\int_0^\\infty e^{-x} dx = 1
\\end{equation}

This is \\textbf{bold} and \\emph{italic} text.

"""

        result =
            L2S.translate latex
    in
    "Test 4: Math and formatting\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 5: Lists
-}
test5 : String
test5 =
    let
        latex =
            """\\begin{itemize}

\\item First item

\\item Second item

\\end{itemize}

\\begin{enumerate}

\\item First numbered

\\item Second numbered

\\end{enumerate}
"""

        result =
            L2S.translate latex
    in
    "Test 5: Lists\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 6: Equation block
-}
test6 : String
test6 =
    let
        latex =
            """Here is an important equation:

\\begin{equation}
E = mc^2
\\end{equation}

And another one:

\\begin{equation}
\\nabla \\cdot \\vec{E} = \\frac{\\rho}{\\epsilon_0}
\\end{equation}
"""

        result =
            L2S.translate latex
    in
    "Test 6: Equation blocks\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 7: Align block
-}
test7 : String
test7 =
    let
        latex =
            """Multiple aligned equations:

\\begin{align}
x + y &= 5 \\\\
2x - y &= 1 \\\\
x &= 2
\\end{align}

This shows the solution step by step.
"""

        result =
            L2S.translate latex
    in
    "Test 7: Align blocks\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result
