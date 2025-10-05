module TestAligned exposing (main)

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
        [ Html.h2 [] [ Html.text "Aligned Export Test" ]
        , Html.pre [] [ Html.text result ]
        ]


testAlignedExport : String
testAlignedExport =
    let
        -- Test case 1: Multiple lines
        inputString1 =
            "nat &= set(\"positive whole numbers and zero\")\nnat &= sett(n \" is a whole number\", n > 0)"

        mathMacroDict =
            Dict.empty

        lines1 =
            inputString1
                |> String.lines
                |> List.map String.trim
                |> List.filter (\line -> not (String.isEmpty line))
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
            "\\begin{align}\nnat &= set(\"positive whole numbers and zero\")\\\\\nnat &= sett(n \" is a whole number\", n > 0)\n\\end{align}"

        test1Result =
            if output1 == expected1 then
                "✓ Test 1 PASSED: Multiple lines with \\\\ between them"

            else
                "✗ Test 1 FAILED\nExpected:\n"
                    ++ expected1
                    ++ "\n\nGot:\n"
                    ++ output1

        -- Test case 2: Single line
        inputString2 =
            "x = 1"

        lines2 =
            inputString2
                |> String.lines
                |> List.map String.trim
                |> List.filter (\line -> not (String.isEmpty line))
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
            "\\begin{align}\nx = 1\n\\end{align}"

        test2Result =
            if output2 == expected2 then
                "✓ Test 2 PASSED: Single line without trailing \\\\"

            else
                "✗ Test 2 FAILED\nExpected:\n"
                    ++ expected2
                    ++ "\n\nGot:\n"
                    ++ output2
    in
    test1Result ++ "\n\n" ++ test2Result
