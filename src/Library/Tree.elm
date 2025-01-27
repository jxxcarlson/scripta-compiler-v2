module Library.Tree exposing (depth, makeTree, print, ta, tb, tc, test1, test2)

import RoseTree.Tree as T exposing (Tree)


makeTree : (a -> Int) -> List a -> Maybe (Tree a)
makeTree getLevel input =
    let
        initialState =
            initTree input
    in
    loop initialState (nextStepTree getLevel)


depth : Tree a -> Int
depth tree =
    case T.children tree of
        [] ->
            1

        children ->
            (List.maximum (List.map depth children) |> Maybe.withDefault 0) + 1



-- PRINTING


print : (a -> String) -> Tree a -> String
print f tree =
    print_ 0 f tree


print_ : Int -> (a -> String) -> Tree a -> String
print_ level f tree =
    let
        eol =
            "\n"

        g : Int -> a -> String
        g level_ x =
            eol ++ String.repeat level_ "  " ++ f x
    in
    g level (T.value tree) ++ (List.map (print_ (level + 1) f) (T.children tree) |> String.join "")



-- INTERNALS


type alias StateTree a =
    { pathToActiveNode : Maybe (List Int)
    , input : List a
    , output : Maybe (T.Tree a)
    , n : Int
    }


initTree : List a -> StateTree a
initTree input =
    { pathToActiveNode = Nothing
    , input = input
    , output = Nothing
    , n = 0
    }


nextStepTree : (a -> Int) -> StateTree a -> Step (StateTree a) (Maybe (Tree a))
nextStepTree getLevel state =
    case state.input of
        [] ->
            Done state.output

        [ lastItem ] ->
            case state.pathToActiveNode of
                Nothing ->
                    Just (T.branch lastItem []) |> Done

                Just path ->
                    Maybe.map (T.pushChildFor path (T.leaf lastItem)) state.output |> Done

        currentItem :: nextItem :: rest ->
            let
                newPath : Maybe (List Int)
                newPath =
                    getNewPath currentItem nextItem

                getNewPath : a -> a -> Maybe (List Int)
                getNewPath currentItem_ nextItem_ =
                    case compare (getLevel nextItem_) (getLevel currentItem_) of
                        GT ->
                            case state.pathToActiveNode of
                                Nothing ->
                                    Just []

                                Just _ ->
                                    Maybe.map2 append indexToActiveNode state.pathToActiveNode

                        EQ ->
                            state.pathToActiveNode

                        LT ->
                            Maybe.map dropLast state.pathToActiveNode

                newOutput : Maybe (Tree a)
                newOutput =
                    case state.pathToActiveNode of
                        Nothing ->
                            Just (T.branch currentItem [])

                        Just path ->
                            Maybe.map (T.pushChildFor path (T.leaf currentItem)) state.output

                indexToActiveNode =
                    Maybe.map (T.children >> List.length >> (\i -> i - 1)) newOutput

                dropLast : List Int -> List Int
                dropLast list =
                    List.take (List.length list - 1) list

                append : Int -> List Int -> List Int
                append k list =
                    list ++ [ k ]
            in
            Loop
                { input = nextItem :: rest
                , pathToActiveNode = newPath
                , output = newOutput
                , n = state.n + 1
                }


type Step state output
    = Loop state
    | Done output


loop : state -> (state -> Step state block) -> block
loop s f =
    case f s of
        Loop s_ ->
            loop s_ f

        Done b ->
            b



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
