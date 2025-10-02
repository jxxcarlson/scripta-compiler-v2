module TestAlignedDoubleBackslash exposing (main)

import Dict
import ETeX.Transform
import Html exposing (Html)
import MicroLaTeX.Util


main : Html msg
main =
    let
        result =
            testAlignedExport
    in
    Html.div []
        [ Html.h2 [] [ Html.text "Aligned Export Test - Double Backslash Fix" ]
        , Html.pre [] [ Html.text result ]
        ]


testAlignedExport : String
testAlignedExport =
    let
        mathMacroDict =
            Dict.empty

        -- Helper to strip trailing backslashes
        stripTrailingBackslashes : String -> String
        stripTrailingBackslashes line =
            if String.endsWith "\\\\" line then
                String.dropRight 2 line |> String.trimRight

            else
                line

        -- Test case 1: Input with trailing \\ (should not double them)
        inputString1 =
            "a &= b + c \\\\\nx &= y + z"

        lines1 =
            inputString1
                |> String.lines
                |> List.map String.trim
                |> List.filter (\line -> not (String.isEmpty line))
                |> List.map stripTrailingBackslashes
                |> List.map (ETeX.Transform.transformETeX mathMacroDict)
                |> List.map MicroLaTeX.Util.transformLabel

        processedLines1 =
            case List.reverse lines1 of
                [] ->
                    ""

                lastLine :: restReversed ->
                    (List.reverse restReversed |> List.map (\line -> line ++ "\\\\"))
                        ++ [ lastLine ]
                        |> String.join "\n"

        output1 =
            [ "\\begin{align}", processedLines1, "\\end{align}" ] |> String.join "\n"

        expected1 =
            "\\begin{align}\na &= b + c\\\\\nx &= y + z\n\\end{align}"

        test1Result =
            if output1 == expected1 then
                "✓ Test 1 PASSED: Input with \\\\ doesn't double them"

            else
                "✗ Test 1 FAILED\nExpected:\n"
                    ++ expected1
                    ++ "\n\nGot:\n"
                    ++ output1

        -- Test case 2: Input without trailing \\
        inputString2 =
            "x = 1\ny = 2"

        lines2 =
            inputString2
                |> String.lines
                |> List.map String.trim
                |> List.filter (\line -> not (String.isEmpty line))
                |> List.map stripTrailingBackslashes
                |> List.map (ETeX.Transform.transformETeX mathMacroDict)
                |> List.map MicroLaTeX.Util.transformLabel

        processedLines2 =
            case List.reverse lines2 of
                [] ->
                    ""

                lastLine :: restReversed ->
                    (List.reverse restReversed |> List.map (\line -> line ++ "\\\\"))
                        ++ [ lastLine ]
                        |> String.join "\n"

        output2 =
            [ "\\begin{align}", processedLines2, "\\end{align}" ] |> String.join "\n"

        expected2 =
            "\\begin{align}\nx = 1\\\\\ny = 2\n\\end{align}"

        test2Result =
            if output2 == expected2 then
                "✓ Test 2 PASSED: Input without \\\\ adds them correctly"

            else
                "✗ Test 2 FAILED\nExpected:\n"
                    ++ expected2
                    ++ "\n\nGot:\n"
                    ++ output2
    in
    test1Result ++ "\n\n" ++ test2Result
