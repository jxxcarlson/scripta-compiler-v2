module Library.TestForest1 exposing (..)

import Array
import Dict
import Either exposing (Either(..))
import Generic.Language exposing (Expr(..), Heading(..))
import Library.Forest exposing (depths, makeForest, print, toListList)
import Library.Tree
import Render.TOCTree exposing (TOCNodeValue)
import RoseTree.Tree exposing (Tree(..))



--|> Debug.log "@@::DONE"
-- TESTS


hottDataApp : List TOCNodeValue
hottDataApp =
    [ { block = { args = [ "1" ], body = Right [ Text " Path Space of " { begin = 1275, end = 1289, id = "xye-41.0", index = 0 }, VFun "math" "\\nat" { begin = 1290, end = 1290, id = "xye-41.1", index = 1 } ], firstLine = "# Path Space of $\\nat$", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 41, messages = [], numberOfLines = 1, position = 1275, sourceText = "# Path Space of $\\nat$" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "path-space-of-nat" ) ], style = Nothing }, visible = True }
    , { block = { args = [ "1" ], body = Right [ Text " Types that are not Sets" { begin = 1930, end = 1953, id = "xye-69.0", index = 0 } ], firstLine = "# Types that are not Sets", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-11", lineNumber = 69, messages = [], numberOfLines = 1, position = 1930, sourceText = "# Types that are not Sets" }, properties = Dict.fromList [ ( "id", "@-11" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "types-that-are-not-sets" ) ], style = Nothing }, visible = True }
    , { block = { args = [ "1" ], body = Right [ Text " Higher Inductive Types" { begin = 3168, end = 3190, id = "xye-102.0", index = 0 } ], firstLine = "# Higher Inductive Types", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-19", lineNumber = 102, messages = [], numberOfLines = 1, position = 3168, sourceText = "# Higher Inductive Types" }, properties = Dict.fromList [ ( "id", "@-19" ), ( "label", "3" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "higher-inductive-types" ) ], style = Nothing }, visible = True }
    , { block = { args = [ "2" ], body = Right [ Text " The circle" { begin = 3194, end = 3204, id = "xye-104.0", index = 0 } ], firstLine = "## The circle", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-20", lineNumber = 104, messages = [], numberOfLines = 1, position = 3194, sourceText = "## The circle" }, properties = Dict.fromList [ ( "id", "@-20" ), ( "label", "3.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "the-circle" ) ], style = Nothing }, visible = True }
    , { block = { args = [ "2" ], body = Right [ Text " " { begin = 3317, end = 3317, id = "xye-109.0", index = 0 }, VFun "math" "\\integers" { begin = 3318, end = 3318, id = "xye-109.1", index = 1 }, Text " (Notes)" { begin = 3329, end = 3336, id = "xye-109.4", index = 4 } ], firstLine = "## $\\integers$ (Notes)", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-22", lineNumber = 109, messages = [], numberOfLines = 1, position = 3317, sourceText = "## $\\integers$ (Notes)" }, properties = Dict.fromList [ ( "id", "@-22" ), ( "label", "3.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers-notes" ) ], style = Nothing }, visible = True }
    , { block = { args = [ "2" ], body = Right [ Text " " { begin = 3539, end = 3539, id = "xye-117.0", index = 0 }, VFun "math" "\\integers" { begin = 3540, end = 3540, id = "xye-117.1", index = 1 }, Text " (Mortberg)" { begin = 3551, end = 3561, id = "xye-117.4", index = 4 } ], firstLine = "## $\\integers$ (Mortberg)", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-24", lineNumber = 117, messages = [], numberOfLines = 1, position = 3539, sourceText = "## $\\integers$ (Mortberg)" }, properties = Dict.fromList [ ( "id", "@-24" ), ( "label", "3.3" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers-mortberg" ) ], style = Nothing }, visible = True }
    , { block = { args = [ "2" ], body = Right [ Text " " { begin = 6503, end = 6503, id = "xye-203.0", index = 0 }, VFun "math" "\\integers" { begin = 6504, end = 6504, id = "xye-203.1", index = 1 } ], firstLine = "## $\\integers$", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-27", lineNumber = 203, messages = [], numberOfLines = 1, position = 6503, sourceText = "## $\\integers$" }, properties = Dict.fromList [ ( "id", "@-27" ), ( "label", "3.4" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers" ) ], style = Nothing }, visible = True }
    , { block = { args = [ "2" ], body = Right [ Text " " { begin = 7029, end = 7029, id = "xye-225.0", index = 0 }, VFun "math" "\\integers/N" { begin = 7030, end = 7030, id = "xye-225.1", index = 1 } ], firstLine = "## $\\integers/N$", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-29", lineNumber = 225, messages = [], numberOfLines = 1, position = 7029, sourceText = "## $\\integers/N$" }, properties = Dict.fromList [ ( "id", "@-29" ), ( "label", "3.5" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers-n" ) ], style = Nothing }, visible = True }
    , { block = { args = [ "1" ], body = Right [ Text " References" { begin = 7879, end = 7889, id = "xye-263.0", index = 0 } ], firstLine = "# References", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-34", lineNumber = 263, messages = [], numberOfLines = 1, position = 7879, sourceText = "# References" }, properties = Dict.fromList [ ( "id", "@-34" ), ( "label", "4" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "references" ) ], style = Nothing }, visible = True }
    ]


hottForestOfTOCNodeValue : List (Tree TOCNodeValue)
hottForestOfTOCNodeValue =
    makeForest lev hottDataApp


hottForestOfExpressionBlocks : List (Tree Generic.Language.ExpressionBlock)
hottForestOfExpressionBlocks =
    hottForestOfTOCNodeValue |> List.map (RoseTree.Tree.mapValues .block)


depthsFromHottDataApp =
    { actual = makeForest lev hottDataApp |> depths, ffDepths = depths ff, goal = [ 1, 1, 2, 1 ] }


{-| ff == hottForest
-}
ff : List (Tree TOCNodeValue)
ff =
    [ RoseTree.Tree.Tree { block = { args = [ "1" ], body = Right [ Text " Path Space of " { begin = 1275, end = 1289, id = "xye-41.0", index = 0 }, VFun "math" "\\nat" { begin = 1290, end = 1290, id = "xye-41.1", index = 1 } ], firstLine = "# Path Space of $\\nat$", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 41, messages = [], numberOfLines = 1, position = 1275, sourceText = "# Path Space of $\\nat$" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "path-space-of-nat" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "1" ], body = Right [ Text " Types that are not Sets" { begin = 1930, end = 1953, id = "xye-69.0", index = 0 } ], firstLine = "# Types that are not Sets", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-11", lineNumber = 69, messages = [], numberOfLines = 1, position = 1930, sourceText = "# Types that are not Sets" }, properties = Dict.fromList [ ( "id", "@-11" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "types-that-are-not-sets" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "1" ], body = Right [ Text " Higher Inductive Types" { begin = 3168, end = 3190, id = "xye-102.0", index = 0 } ], firstLine = "# Higher Inductive Types", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-19", lineNumber = 102, messages = [], numberOfLines = 1, position = 3168, sourceText = "# Higher Inductive Types" }, properties = Dict.fromList [ ( "id", "@-19" ), ( "label", "3" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "higher-inductive-types" ) ], style = Nothing }, visible = True } (Array.fromList [ RoseTree.Tree.Tree { block = { args = [ "2" ], body = Right [ Text " The circle" { begin = 3194, end = 3204, id = "xye-104.0", index = 0 } ], firstLine = "## The circle", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-20", lineNumber = 104, messages = [], numberOfLines = 1, position = 3194, sourceText = "## The circle" }, properties = Dict.fromList [ ( "id", "@-20" ), ( "label", "3.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "the-circle" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "2" ], body = Right [ Text " " { begin = 3317, end = 3317, id = "xye-109.0", index = 0 }, VFun "math" "\\integers" { begin = 3318, end = 3318, id = "xye-109.1", index = 1 }, Text " (Notes)" { begin = 3329, end = 3336, id = "xye-109.4", index = 4 } ], firstLine = "## $\\integers$ (Notes)", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-22", lineNumber = 109, messages = [], numberOfLines = 1, position = 3317, sourceText = "## $\\integers$ (Notes)" }, properties = Dict.fromList [ ( "id", "@-22" ), ( "label", "3.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers-notes" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "2" ], body = Right [ Text " " { begin = 3539, end = 3539, id = "xye-117.0", index = 0 }, VFun "math" "\\integers" { begin = 3540, end = 3540, id = "xye-117.1", index = 1 }, Text " (Mortberg)" { begin = 3551, end = 3561, id = "xye-117.4", index = 4 } ], firstLine = "## $\\integers$ (Mortberg)", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-24", lineNumber = 117, messages = [], numberOfLines = 1, position = 3539, sourceText = "## $\\integers$ (Mortberg)" }, properties = Dict.fromList [ ( "id", "@-24" ), ( "label", "3.3" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers-mortberg" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "2" ], body = Right [ Text " " { begin = 6503, end = 6503, id = "xye-203.0", index = 0 }, VFun "math" "\\integers" { begin = 6504, end = 6504, id = "xye-203.1", index = 1 } ], firstLine = "## $\\integers$", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-27", lineNumber = 203, messages = [], numberOfLines = 1, position = 6503, sourceText = "## $\\integers$" }, properties = Dict.fromList [ ( "id", "@-27" ), ( "label", "3.4" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "2" ], body = Right [ Text " " { begin = 7029, end = 7029, id = "xye-225.0", index = 0 }, VFun "math" "\\integers/N" { begin = 7030, end = 7030, id = "xye-225.1", index = 1 } ], firstLine = "## $\\integers/N$", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-29", lineNumber = 225, messages = [], numberOfLines = 1, position = 7029, sourceText = "## $\\integers/N$" }, properties = Dict.fromList [ ( "id", "@-29" ), ( "label", "3.5" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers-n" ) ], style = Nothing }, visible = True } (Array.fromList []) ]), RoseTree.Tree.Tree { block = { args = [ "1" ], body = Right [ Text " References" { begin = 7879, end = 7889, id = "xye-263.0", index = 0 } ], firstLine = "# References", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-34", lineNumber = 263, messages = [], numberOfLines = 1, position = 7879, sourceText = "# References" }, properties = Dict.fromList [ ( "id", "@-34" ), ( "label", "4" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "references" ) ], style = Nothing }, visible = True } (Array.fromList []) ]


depthsFF =
    ff |> List.map Library.Tree.depth


hottData =
    [ ( 1, "# Path Space of $\\nat$" )
    , ( 1, "# Types that are not Sets" )
    , ( 1, "# Higher Inductive Types" )
    , ( 2, "## The circle" )
    , ( 2, "## $\\integers$ (Notes)" )
    , ( 2, "## $\\integers$ (Mortberg)" )
    , ( 2, "## $\\integers$" )
    , ( 2, "## $\\integers/N$" )
    , ( 1, "# References" )
    ]


hottData2 =
    [ ( 1, "# Types that are not Sets" )
    , ( 2, "## The circle" )
    , ( 2, "## $\\integers$ (Notes)" )
    , ( 2, "## $\\integers$ (Mortberg)" )
    , ( 2, "## $\\integers$" )
    , ( 2, "## $\\integers/N$" )
    , ( 1, "# References" )
    ]


testHott1 =
    toListList Tuple.first hottData
        |> List.map (List.map Tuple.second)


testHott2 =
    makeForest Tuple.first hottData


test1 =
    toListList .level testData1
        |> List.map (List.map .name)


ll1 =
    toListList .level testData1b
        |> List.map (List.map .name)


ll2 =
    toListList .level testData1b
        |> List.map (List.map .name)


tt1 =
    makeForest .level testData1
        |> print .name


tt2 =
    makeForest .level testData1b
        |> print .name


ll3 =
    toListList .level testData1c
        |> List.map (List.map .name)


tt3 =
    makeForest .level testData1c
        |> print .name


test1b =
    makeForest .level testData1b
        |> print .name


test1c =
    makeForest .level testData1c
        |> print .name


test2 =
    makeForest .level testData2
        |> print .name


test3 =
    makeForest .level testData3
        |> print .name


test4 =
    makeForest .level testData4
        |> print .name


testData1 =
    [ { level = 1, name = "I" }
    , { level = 2, name = "A" }
    , { level = 2, name = "B" }
    , { level = 1, name = "II" }
    , { level = 2, name = "C" }
    , { level = 2, name = "D" }
    ]


testData1b =
    [ { level = 0, name = "I" }
    , { level = 1, name = "A" }
    , { level = 1, name = "B" }
    , { level = 0, name = "II" }
    , { level = 1, name = "C" }
    , { level = 1, name = "D" }
    ]


testData1c =
    [ { level = 0, name = "I" }
    , { level = 2, name = "A" }
    , { level = 2, name = "B" }
    , { level = 0, name = "II" }
    , { level = 2, name = "C" }
    , { level = 2, name = "D" }
    ]


testData2 =
    [ { level = 1, name = "I" }
    , { level = 2, name = "A" }
    , { level = 2, name = "B" }
    , { level = 1, name = "II" }
    , { level = 2, name = "A" }
    , { level = 3, name = "a" }
    , { level = 3, name = "b" }
    , { level = 3, name = "c" }
    , { level = 2, name = "B" }
    , { level = 2, name = "C" }
    ]


testData3 =
    [ { level = 1, name = "A" }
    , { level = 1, name = "B" }
    ]


testData4 =
    [ { level = 1, name = "A" }
    , { level = 1, name = "B" }
    , { level = 1, name = "C" }
    ]


data =
    [ { block = { args = [ "1" ], body = Right [ Text " Intro" { begin = 46, end = 51, id = "xye-6.0", index = 0 } ], firstLine = "# Intro", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-2", lineNumber = 6, messages = [], numberOfLines = 1, position = 46, sourceText = "# Intro" }, properties = Dict.fromList [ ( "id", "@-2" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "intro" ) ] }, visible = True }, { block = { args = [ "1" ], body = Right [ Text " Particles" { begin = 67, end = 76, id = "xye-10.0", index = 0 } ], firstLine = "# Particles", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-4", lineNumber = 10, messages = [], numberOfLines = 1, position = 67, sourceText = "# Particles" }, properties = Dict.fromList [ ( "id", "@-4" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "particles" ) ] }, visible = True }, { block = { args = [ "2" ], body = Right [ Text " Fermions" { begin = 80, end = 88, id = "xye-12.0", index = 0 } ], firstLine = "## Fermions", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-5", lineNumber = 12, messages = [], numberOfLines = 1, position = 80, sourceText = "## Fermions" }, properties = Dict.fromList [ ( "id", "@-5" ), ( "label", "2.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "fermions" ) ] }, visible = True }, { block = { args = [ "2" ], body = Right [ Text " Bosons" { begin = 93, end = 99, id = "xye-14.0", index = 0 } ], firstLine = "## Bosons", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-6", lineNumber = 14, messages = [], numberOfLines = 1, position = 93, sourceText = "## Bosons" }, properties = Dict.fromList [ ( "id", "@-6" ), ( "label", "2.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "bosons" ) ] }, visible = True } ]


lev : { a | block : { b | properties : Dict.Dict String String } } -> Int
lev { block } =
    case Dict.get "level" block.properties of
        Just level ->
            String.toInt level |> Maybe.withDefault 1 |> (\x -> x - 1)

        Nothing ->
            0
