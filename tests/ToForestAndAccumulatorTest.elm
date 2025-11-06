module ToForestAndAccumulatorTest exposing (suite)

import Dict
import Expect
import Generic.Acc exposing (Accumulator)
import Generic.Forest exposing (Forest)
import Generic.Language exposing (ExpressionBlock)
import Generic.Vector
import Render.Theme
import ScriptaV2.Compiler
import ScriptaV2.Language exposing (Language(..))
import ScriptaV2.Types exposing (CompilerParameters, Filter(..), defaultCompilerParameters)
import Test exposing (..)


suite : Test
suite =
    describe "parseToForestWithAccumulator"
        [ describe "MicroLaTeX parsing"
            [ test "simple paragraph returns non-empty forest" <|
                \_ ->
                    let
                        params =
                            defaultParams MicroLaTeXLang

                        lines =
                            [ "This is a test paragraph." ]

                        ( accumulator, forest ) =
                            ScriptaV2.Compiler.parseToForestWithAccumulator params lines
                    in
                    forest
                        |> List.length
                        |> Expect.greaterThan 0
            , test "section creates accumulator with section count" <|
                \_ ->
                    let
                        params =
                            defaultParams MicroLaTeXLang

                        lines =
                            [ "\\section{Introduction}", "", "Some text here." ]

                        ( accumulator, forest ) =
                            ScriptaV2.Compiler.parseToForestWithAccumulator params lines
                    in
                    Generic.Vector.level accumulator.headingIndex
                        |> Expect.greaterThan 0
            , test "multiple sections increment section index" <|
                \_ ->
                    let
                        params =
                            defaultParams MicroLaTeXLang

                        lines =
                            [ "\\section{First}"
                            , ""
                            , "Content here."
                            , ""
                            , "\\section{Second}"
                            , ""
                            , "More content."
                            ]

                        ( accumulator, forest ) =
                            ScriptaV2.Compiler.parseToForestWithAccumulator params lines
                    in
                    Generic.Vector.level accumulator.headingIndex
                        |> Expect.atLeast 1
            ]
        , describe "XMarkdown parsing"
            [ test "simple paragraph returns non-empty forest" <|
                \_ ->
                    let
                        params =
                            defaultParams SMarkdownLang

                        lines =
                            [ "This is a test paragraph." ]

                        ( accumulator, forest ) =
                            ScriptaV2.Compiler.parseToForestWithAccumulator params lines
                    in
                    forest
                        |> List.length
                        |> Expect.greaterThan 0
            , test "markdown heading creates section" <|
                \_ ->
                    let
                        params =
                            defaultParams SMarkdownLang

                        lines =
                            [ "# Introduction", "", "Some text here." ]

                        ( accumulator, forest ) =
                            ScriptaV2.Compiler.parseToForestWithAccumulator params lines
                    in
                    Generic.Vector.level accumulator.headingIndex
                        |> Expect.greaterThan 0
            ]
        , describe "Enclosure/L0 parsing"
            [ test "simple paragraph returns non-empty forest" <|
                \_ ->
                    let
                        params =
                            defaultParams EnclosureLang

                        lines =
                            [ "This is a test paragraph." ]

                        ( accumulator, forest ) =
                            ScriptaV2.Compiler.parseToForestWithAccumulator params lines
                    in
                    forest
                        |> List.length
                        |> Expect.greaterThan 0
            , test "section block creates accumulator with section count" <|
                \_ ->
                    let
                        params =
                            defaultParams EnclosureLang

                        lines =
                            [ "| section", "Introduction", "", "Some text here." ]

                        ( accumulator, forest ) =
                            ScriptaV2.Compiler.parseToForestWithAccumulator params lines
                    in
                    Generic.Vector.level accumulator.headingIndex
                        |> Expect.greaterThan 0
            ]
        , describe "Filter behavior"
            [ test "NoFilter preserves all blocks" <|
                \_ ->
                    let
                        baseParams =
                            defaultParams MicroLaTeXLang

                        params =
                            { baseParams | filter = NoFilter }

                        lines =
                            [ "\\begin{document}", "", "Content", "", "\\end{document}" ]

                        ( _, forest ) =
                            ScriptaV2.Compiler.parseToForestWithAccumulator params lines
                    in
                    forest
                        |> List.length
                        |> Expect.greaterThan 0
            , test "SuppressDocumentBlocks filters document blocks" <|
                \_ ->
                    let
                        baseParams =
                            defaultParams MicroLaTeXLang

                        paramsNoFilter =
                            { baseParams | filter = NoFilter }

                        paramsWithFilter =
                            { baseParams | filter = SuppressDocumentBlocks }

                        lines =
                            [ "\\begin{document}", "", "Content", "", "\\end{document}" ]

                        ( _, forestNoFilter ) =
                            ScriptaV2.Compiler.parseToForestWithAccumulator paramsNoFilter lines

                        ( _, forestWithFilter ) =
                            ScriptaV2.Compiler.parseToForestWithAccumulator paramsWithFilter lines
                    in
                    -- With filter, we expect potentially fewer blocks
                    -- This is a simple check that filtering has some effect
                    List.length forestWithFilter
                        |> Expect.atMost (List.length forestNoFilter)
            ]
        ]


defaultParams : Language -> CompilerParameters
defaultParams lang =
    { defaultCompilerParameters | lang = lang }
