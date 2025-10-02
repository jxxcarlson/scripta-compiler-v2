port module TestAlignedConsole exposing (main)

import Dict
import ETeX.Transform
import MicroLaTeX.Util
import Platform


port output : String -> Cmd msg


main : Program () () ()
main =
    Platform.worker
        { init = \_ -> ( (), output testAlignedExport )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


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
                    ++ String.replace "\\" "\\\\" expected1
                    ++ "\n\nGot:\n"
                    ++ String.replace "\\" "\\\\" output1

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
                    ++ String.replace "\\" "\\\\" expected2
                    ++ "\n\nGot:\n"
                    ++ String.replace "\\" "\\\\" output2

        -- Test case 3: Three lines
        inputString3 =
            "a = 1\nb = 2\nc = 3"

        lines3 =
            inputString3
                |> String.lines
                |> List.map String.trim
                |> List.filter (\line -> not (String.isEmpty line))
                |> List.map (ETeX.Transform.transformETeX mathMacroDict)
                |> List.map MicroLaTeX.Util.transformLabel

        processedLines3 =
            case List.reverse lines3 of
                [] ->
                    ""

                lastLine :: restReversed ->
                    (List.reverse restReversed |> List.map (\line -> line ++ "\\\\"))
                        ++ [ lastLine ]
                        |> String.join "\n"

        output3 =
            [ "\\begin{align}", processedLines3, "\\end{align}" ] |> String.join "\n"

        expected3 =
            "\\begin{align}\na = 1\\\\\nb = 2\\\\\nc = 3\n\\end{align}"

        test3Result =
            if output3 == expected3 then
                "✓ Test 3 PASSED: Three lines with \\\\ between them"

            else
                "✗ Test 3 FAILED\nExpected:\n"
                    ++ String.replace "\\" "\\\\" expected3
                    ++ "\n\nGot:\n"
                    ++ String.replace "\\" "\\\\" output3
    in
    test1Result ++ "\n\n" ++ test2Result ++ "\n\n" ++ test3Result
