module AlignedExportTest exposing (suite)

import Dict
import ETeX.MathMacros
import ETeX.Transform
import Expect
import MicroLaTeX.Util
import Test exposing (..)


suite : Test
suite =
    describe "Aligned Block Export"
        [ test "aligned block adds \\\\ line breaks between lines" <|
            \_ ->
                let
                    -- The input string as it appears in the verbatim block body
                    -- (without \\ because the parser doesn't preserve them)
                    inputString =
                        "nat &= set(\"positive whole numbers and zero\")\nnat &= sett(n \" is a whole number\", n > 0)"

                    -- Empty math macro dict for testing
                    mathMacroDict =
                        Dict.empty

                    -- Strip trailing \\ from a line if present
                    stripTrailingBackslashes : String -> String
                    stripTrailingBackslashes line =
                        if String.endsWith "\\\\" line then
                            String.dropRight 2 line |> String.trimRight

                        else
                            line

                    -- Process the aligned block with the new logic
                    lines =
                        inputString
                            |> String.lines
                            |> List.map String.trim
                            |> List.filter (\line -> not (String.isEmpty line))
                            |> List.map stripTrailingBackslashes
                            |> List.map (ETeX.Transform.transformETeX mathMacroDict)
                            |> List.map MicroLaTeX.Util.transformLabel

                    -- Add \\ to the end of all lines except the last
                    processedLines =
                        case List.reverse lines of
                            [] ->
                                ""

                            lastLine :: restReversed ->
                                (List.reverse restReversed |> List.map (\line -> line ++ "\\\\"))
                                    ++ [ lastLine ]
                                    |> String.join "\n"

                    output =
                        [ "\\begin{align}", processedLines, "\\end{align}" ] |> String.join "\n"

                    expected =
                        "\\begin{align}\nnat &= set(\"positive whole numbers and zero\")\\\\\nnat &= sett(n \" is a whole number\", n > 0)\n\\end{align}"
                in
                output
                    |> Expect.equal expected
        , test "aligned block handles single line correctly" <|
            \_ ->
                let
                    inputString =
                        "x = 1"

                    mathMacroDict =
                        Dict.empty

                    stripTrailingBackslashes : String -> String
                    stripTrailingBackslashes line =
                        if String.endsWith "\\\\" line then
                            String.dropRight 2 line |> String.trimRight

                        else
                            line

                    lines =
                        inputString
                            |> String.lines
                            |> List.map String.trim
                            |> List.filter (\line -> not (String.isEmpty line))
                            |> List.map stripTrailingBackslashes
                            |> List.map (ETeX.Transform.transformETeX mathMacroDict)
                            |> List.map MicroLaTeX.Util.transformLabel

                    processedLines =
                        case List.reverse lines of
                            [] ->
                                ""

                            lastLine :: restReversed ->
                                (List.reverse restReversed |> List.map (\line -> line ++ "\\\\"))
                                    ++ [ lastLine ]
                                    |> String.join "\n"

                    output =
                        [ "\\begin{align}", processedLines, "\\end{align}" ] |> String.join "\n"

                    expected =
                        "\\begin{align}\nx = 1\n\\end{align}"
                in
                output
                    |> Expect.equal expected
        , test "aligned block with trailing \\\\ doesn't double them" <|
            \_ ->
                let
                    -- Input with \\ already at the end of the first line
                    inputString =
                        "a &= b + c \\\\\nx &= y + z"

                    mathMacroDict =
                        Dict.empty

                    stripTrailingBackslashes : String -> String
                    stripTrailingBackslashes line =
                        if String.endsWith "\\\\" line then
                            String.dropRight 2 line |> String.trimRight

                        else
                            line

                    lines =
                        inputString
                            |> String.lines
                            |> List.map String.trim
                            |> List.filter (\line -> not (String.isEmpty line))
                            |> List.map stripTrailingBackslashes
                            |> List.map (ETeX.Transform.transformETeX mathMacroDict)
                            |> List.map MicroLaTeX.Util.transformLabel

                    processedLines =
                        case List.reverse lines of
                            [] ->
                                ""

                            lastLine :: restReversed ->
                                (List.reverse restReversed |> List.map (\line -> line ++ "\\\\"))
                                    ++ [ lastLine ]
                                    |> String.join "\n"

                    output =
                        [ "\\begin{align}", processedLines, "\\end{align}" ] |> String.join "\n"

                    expected =
                        "\\begin{align}\na &= b + c\\\\\nx &= y + z\n\\end{align}"
                in
                output
                    |> Expect.equal expected
        ]