module Render.Export.LaTeXToScriptaTest exposing (runTests, test1, test10, test11, test12, test13, test14, test15, test2, test3, test4, test5, test6, test7, test8, test9)

import Render.Export.LaTeXToScripta as L2S


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
    , test8
    , test9
    , test10
    , test11
    , test12
    , test13
    , test14
    , test15
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


{-| Test 8: Theorem and Definition blocks
-}
test8 : String
test8 =
    let
        latex =
            """\\begin{theorem}[Pythagorean]
For a right triangle with legs $a$ and $b$ and hypotenuse $c$,
we have $a^2 + b^2 = c^2$.
\\end{theorem}

\\begin{definition}
A prime number is a natural number greater than 1 that has no positive divisors other than 1 and itself.
\\end{definition}
"""

        result =
            L2S.translate latex
    in
    "Test 8: Theorem and Definition blocks\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 9: Links, citations, and footnotes
-}
test9 : String
test9 =
    let
        latex =
            """This is a \\href{https://example.com}{link to a website}.

See \\cite{knuth1984} for more details.

This statement needs clarification\\footnote{This is the footnote text.}.

As shown in Figure \\ref{fig:example}.
"""

        result =
            L2S.translate latex
    in
    "Test 9: Links, citations, and footnotes\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 10: Example, remark, and note environments
-}
test10 : String
test10 =
    let
        latex =
            """\\begin{example}
Consider the function $f(x) = x^2$. For $x = 3$, we have $f(3) = 9$.
\\end{example}

\\begin{remark}
This function is always non-negative.
\\end{remark}

\\begin{note}
Remember to check the domain of the function.
\\end{note}
"""

        result =
            L2S.translate latex
    in
    "Test 10: Example, remark, and note environments\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 11: Abstract, quote, and center environments
-}
test11 : String
test11 =
    let
        latex =
            """\\begin{abstract}
This paper discusses the fundamental principles of mathematics.
\\end{abstract}

\\begin{quote}
"Mathematics is the language of the universe." - Galileo
\\end{quote}

\\begin{center}
Centered Text
\\end{center}
"""

        result =
            L2S.translate latex
    in
    "Test 11: Abstract, quote, and center environments\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 12: Figure and table environments
-}
test12 : String
test12 =
    let
        latex =
            """\\begin{figure}
\\includegraphics{diagram.png}
\\caption{A sample diagram}
\\end{figure}

\\begin{table}
\\begin{tabular}{cc}
A & B \\\\
C & D
\\end{tabular}
\\caption{Sample table}
\\end{table}
"""

        result =
            L2S.translate latex
    in
    "Test 12: Figure and table environments\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 13: Verbatim blocks and underline formatting
-}
test13 : String
test13 =
    let
        latex =
            """\\begin{verbatim}
function hello() {
  console.log("Hello, world!");
}
\\end{verbatim}

This is \\underline{underlined text} in the middle of a sentence.

\\begin{lstlisting}
for i in range(10):
    print(i)
\\end{lstlisting}
"""

        result =
            L2S.translate latex
    in
    "Test 13: Verbatim blocks and underline formatting\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 14: CompactItem formatting
-}
test14 : String
test14 =
    let
        latex =
            """Here are some compact items:

\\compactItem{First item}
\\compactItem{Second item}
\\compactItem{Third item with longer text}

And a list with compact items:

\\begin{itemize}
\\compactItem{Compact item in list}
\\compactItem{Another compact item}
\\end{itemize}
"""

        result =
            L2S.translate latex
    in
    "Test 14: CompactItem formatting\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Output:\n"
        ++ result


{-| Test 15: imagecentercaptioned command
-}
test15 : String
test15 =
    let
        latex =
            """\\imagecentercaptioned{https://www.realsimple.com/thmb/7xn0oIF6a9eJ-y_4OO5vN0lJhCg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/humming-bird-flowers-GettyImages-1271839175-b515cb4f06a34e66b084ba617995f00a.jpg}{0.51\\textwidth,keepaspectratio}{Humming bird}
"""

        result =
            L2S.translate latex
    in
    "Test 15: imagecentercaptioned command\n"
        ++ "Input:\n"
        ++ latex
        ++ "\n"
        ++ "Expected Output:\n"
        ++ "| image caption:Humming bird\n"
        ++ "https://www.realsimple.com/thmb/7xn0oIF6a9eJ-y_4OO5vN0lJhCg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/humming-bird-flowers-GettyImages-1271839175-b515cb4f06a34e66b084ba617995f00a.jpg\n"
        ++ "\n"
        ++ "Actual Output:\n"
        ++ result
