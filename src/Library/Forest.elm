module Library.Forest exposing (makeForest, print, test1, test2)

import Library.Tree
import RoseTree.Tree as T exposing (Tree)



---- FOREST ------


makeForest : (a -> Int) -> List a -> List (Tree a)
makeForest getLevel input =
    input
        |> prepare getLevel
        |> List.map (Library.Tree.makeTree getLevel)
        |> List.filterMap identity



-- PRINTING


print : (a -> String) -> List (Tree a) -> String
print toText list =
    List.map (Library.Tree.print toText) list |> String.join "\n"



-- INTERNALS


type alias State a =
    { currentLevel : Int
    , currentList : List a
    , input : List a
    , output : List (List a)
    }


init : List a -> State a
init input =
    { currentLevel = 0
    , input = input
    , currentList = []
    , output = []
    }


prepare : (a -> Int) -> List a -> List (List a)
prepare getLevel input =
    let
        initialState =
            init input
    in
    loop initialState (nextStep getLevel)


nextStep : (a -> Int) -> State a -> Step (State a) (List (List a))
nextStep getLevel state =
    case state.input of
        [] ->
            Done (List.reverse state.currentList :: state.output |> List.reverse)

        x :: xs ->
            let
                level =
                    getLevel x
            in
            if level == 1 && state.currentLevel == 0 then
                -- start new currentList
                Loop { state | input = xs, currentLevel = level, currentList = [ x ] }

            else if level == 1 && state.currentLevel > 1 then
                -- new level one item: initialize currentList with it, push reversed currentList onto output
                Loop { state | input = xs, currentLevel = 0, currentList = [ x ], output = List.reverse state.currentList :: state.output }

            else
                -- new item, push it onto the current list
                Loop { state | input = xs, currentLevel = level, currentList = x :: state.currentList }


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
    makeForest .level testData1
        |> print .name


test2 =
    makeForest .level testData2
        |> print .name


testData1 =
    [ { level = 1, name = "I" }
    , { level = 2, name = "A" }
    , { level = 2, name = "B" }
    , { level = 1, name = "II" }
    , { level = 2, name = "A" }
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
