module Library.TestTree exposing (..)

import Library.Tree exposing (makeTree, print)



-- TESTS


test1 =
    makeTree (\a -> a.level) testData1 |> Maybe.map (print (\a -> a.name))


test2 =
    makeTree (\a -> a.level) testData2 |> Maybe.map (print (\a -> a.name))


ta =
    makeTree (\a -> a.level) tDA |> Maybe.map (print (\a -> a.name))


tb =
    makeTree (\a -> a.level) tDB |> Maybe.map (print (\a -> a.name))


tc =
    makeTree (\a -> a.level) tDC |> Maybe.map (print (\a -> a.name))


tDA =
    [ { level = 0, name = "I" }
    , { level = 1, name = "A" }
    , { level = 1, name = "B" }
    , { level = 2, name = "x" }
    , { level = 2, name = "y" }
    , { level = 1, name = "P" }
    , { level = 1, name = "Q" }
    ]


tDB =
    [ { level = 1, name = "I" }
    , { level = 2, name = "A" }
    , { level = 2, name = "B" }
    , { level = 3, name = "x" }
    , { level = 3, name = "y" }
    , { level = 2, name = "P" }
    , { level = 2, name = "Q" }
    ]


tDC =
    [ { level = 0, name = "I" }
    , { level = 2, name = "A" }
    , { level = 2, name = "B" }
    , { level = 4, name = "x" }
    , { level = 4, name = "y" }
    , { level = 2, name = "P" }
    , { level = 0, name = "QQ" }
    ]


testData1 =
    [ { level = 0, name = "I" }
    , { level = 1, name = "A" }
    , { level = 2, name = "a" }
    , { level = 2, name = "b" }
    , { level = 3, name = "i" }
    , { level = 3, name = "ii" }
    , { level = 2, name = "c" }
    , { level = 1, name = "B" }
    , { level = 1, name = "C" }
    ]


testData2 =
    [ { level = 0, name = "I" }
    , { level = 1, name = "A" }
    , { level = 2, name = "i" }
    , { level = 2, name = "ii" }
    , { level = 1, name = "B" }
    , { level = 1, name = "P" }
    , { level = 2, name = "i" }
    , { level = 2, name = "ii" }
    , { level = 1, name = "Q" }
    ]
