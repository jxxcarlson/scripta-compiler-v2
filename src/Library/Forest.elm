module Library.Forest exposing
    ( data
    , fListListApp
    , fRepl
    , forestReplSTATIC
    , lev
    , list2
    , listListApp
    , listListRepl
    , makeForest
    , nodesRepl
    , print
    , tList2
    , test
    , test1
    , test2
    , test3
    , test4
    , toForestTOCNodeValue
    , toListList
    )

import Array
import Dict
import Either exposing (Either(..))
import Generic.Language exposing (Expr(..), Heading(..))
import Library.Tree
import RoseTree.Tree exposing (Tree)



---- FOREST ------


makeForest : (a -> Int) -> List a -> List (Tree a)
makeForest getLevel input =
    input
        |> toListList getLevel
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
    { currentLevel = 1
    , input = input
    , currentList = []
    , output = []
    }


toListList : (a -> Int) -> List a -> List (List a)
toListList getLevel input =
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
            if level == 1 && state.currentLevel >= 1 then
                Loop
                    { state
                        | input = xs
                        , currentLevel = 1
                        , currentList = [ x ]
                        , output =
                            if state.currentList == [] then
                                state.output

                            else
                                List.reverse state.currentList :: state.output
                    }

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



--|> Debug.log "@@::DONE"
-- TESTS


test1 =
    makeForest .level testData1
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
    , { level = 2, name = "A" }
    , { level = 2, name = "B" }
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
            String.toInt level |> Maybe.withDefault 0

        Nothing ->
            0


nodesRepl =
    [ { block = { args = [ "1" ], body = Right [ Text " Intro " { begin = 46, end = 52, id = "xye-6.0", index = 0 } ], firstLine = "# Intro ", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-2", lineNumber = 6, messages = [], numberOfLines = 1, position = 46, sourceText = "# Intro " }, properties = Dict.fromList [ ( "id", "@-2" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "intro" ) ] }, visible = True }
    , { block = { args = [ "1" ], body = Right [ Text " Particles" { begin = 56, end = 65, id = "xye-8.0", index = 0 } ], firstLine = "# Particles", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 8, messages = [], numberOfLines = 1, position = 56, sourceText = "# Particles" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "particles" ) ] }, visible = True }
    , { block = { args = [ "2" ], body = Right [ Text " Bosons" { begin = 69, end = 75, id = "xye-10.0", index = 0 } ], firstLine = "## Bosons", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-4", lineNumber = 10, messages = [], numberOfLines = 1, position = 69, sourceText = "## Bosons" }, properties = Dict.fromList [ ( "id", "@-4" ), ( "label", "2.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "bosons" ) ] }, visible = True }
    , { block = { args = [ "2" ], body = Right [ Text " Fermions" { begin = 80, end = 88, id = "xye-12.0", index = 0 } ], firstLine = "## Fermions", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-5", lineNumber = 12, messages = [], numberOfLines = 1, position = 80, sourceText = "## Fermions" }, properties = Dict.fromList [ ( "id", "@-5" ), ( "label", "2.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "fermions" ) ] }, visible = True }
    ]


fRepl =
    makeForest lev nodesRepl


listListRepl : List (List TOCNodeValue)
listListRepl =
    --> List.map (List.map lev) prep
    --[[1],[1,2,2]]
    [ [ { block = { args = [ "1" ], body = Right [ Text " Intro " { begin = 46, end = 52, id = "xye-6.0", index = 0 } ], firstLine = "# Intro ", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-2", lineNumber = 6, messages = [], numberOfLines = 1, position = 46, sourceText = "# Intro " }, properties = Dict.fromList [ ( "id", "@-2" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "intro" ) ] }, visible = True } ]
    , [ { block = { args = [ "1" ], body = Right [ Text " Particles" { begin = 56, end = 65, id = "xye-8.0", index = 0 } ], firstLine = "# Particles", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 8, messages = [], numberOfLines = 1, position = 56, sourceText = "# Particles" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "particles" ) ] }, visible = True }, { block = { args = [ "2" ], body = Right [ Text " Bosons" { begin = 69, end = 75, id = "xye-10.0", index = 0 } ], firstLine = "## Bosons", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-4", lineNumber = 10, messages = [], numberOfLines = 1, position = 69, sourceText = "## Bosons" }, properties = Dict.fromList [ ( "id", "@-4" ), ( "label", "2.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "bosons" ) ] }, visible = True }, { block = { args = [ "2" ], body = Right [ Text " Fermions" { begin = 80, end = 88, id = "xye-12.0", index = 0 } ], firstLine = "## Fermions", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-5", lineNumber = 12, messages = [], numberOfLines = 1, position = 80, sourceText = "## Fermions" }, properties = Dict.fromList [ ( "id", "@-5" ), ( "label", "2.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "fermions" ) ] }, visible = True } ]
    ]


list2 =
    [ { block = { args = [ "1" ], body = Right [ Text " Particles" { begin = 56, end = 65, id = "xye-8.0", index = 0 } ], firstLine = "# Particles", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 8, messages = [], numberOfLines = 1, position = 56, sourceText = "# Particles" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "particles" ) ] }, visible = True }, { block = { args = [ "2" ], body = Right [ Text " Bosons" { begin = 69, end = 75, id = "xye-10.0", index = 0 } ], firstLine = "## Bosons", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-4", lineNumber = 10, messages = [], numberOfLines = 1, position = 69, sourceText = "## Bosons" }, properties = Dict.fromList [ ( "id", "@-4" ), ( "label", "2.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "bosons" ) ] }, visible = True }, { block = { args = [ "2" ], body = Right [ Text " Fermions" { begin = 80, end = 88, id = "xye-12.0", index = 0 } ], firstLine = "## Fermions", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-5", lineNumber = 12, messages = [], numberOfLines = 1, position = 80, sourceText = "## Fermions" }, properties = Dict.fromList [ ( "id", "@-5" ), ( "label", "2.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "fermions" ) ] }, visible = True } ]


tList2 =
    list2
        |> Library.Tree.makeTree lev


toForestTOCNodeValue : List (List TOCNodeValue) -> List (Tree TOCNodeValue)
toForestTOCNodeValue listList_ =
    --> processPrep prep |> List.map Library.Tree.depth
    --[1,2] : List Int
    listList_
        |> List.map (Library.Tree.makeTree lev)
        |> List.filterMap identity


type alias TOCNodeValue =
    { block : Generic.Language.ExpressionBlock, visible : Bool }


listListApp : List (List TOCNodeValue)
listListApp =
    --> prep == prepApp
    --True : Bool
    [ [ { block = { args = [ "1" ], body = Right [ Text " Intro " { begin = 46, end = 52, id = "xye-6.0", index = 0 } ], firstLine = "# Intro ", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-2", lineNumber = 6, messages = [], numberOfLines = 1, position = 46, sourceText = "# Intro " }, properties = Dict.fromList [ ( "id", "@-2" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "intro" ) ] }, visible = True } ], [ { block = { args = [ "1" ], body = Right [ Text " Particles" { begin = 56, end = 65, id = "xye-8.0", index = 0 } ], firstLine = "# Particles", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 8, messages = [], numberOfLines = 1, position = 56, sourceText = "# Particles" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "particles" ) ] }, visible = True }, { block = { args = [ "2" ], body = Right [ Text " Bosons" { begin = 69, end = 75, id = "xye-10.0", index = 0 } ], firstLine = "## Bosons", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-4", lineNumber = 10, messages = [], numberOfLines = 1, position = 69, sourceText = "## Bosons" }, properties = Dict.fromList [ ( "id", "@-4" ), ( "label", "2.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "bosons" ) ] }, visible = True }, { block = { args = [ "2" ], body = Right [ Text " Fermions" { begin = 80, end = 88, id = "xye-12.0", index = 0 } ], firstLine = "## Fermions", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-5", lineNumber = 12, messages = [], numberOfLines = 1, position = 80, sourceText = "## Fermions" }, properties = Dict.fromList [ ( "id", "@-5" ), ( "label", "2.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "fermions" ) ] }, visible = True } ] ]


fListListApp : List (Tree TOCNodeValue)
fListListApp =
    toForestTOCNodeValue listListApp


fListListRepl2 : List (Tree TOCNodeValue)
fListListRepl2 =
    toForestTOCNodeValue listListRepl


test =
    makeForest lev nodesRepl == forestReplSTATIC


forestReplSTATIC : List (Tree TOCNodeValue)
forestReplSTATIC =
    -- This is the recorded result in the Elm repl of
    -- Library.Forest.makeForest Library.Forest.lev nodesRepl
    [ RoseTree.Tree.Tree
        { block = { args = [ "1" ], body = Right [ Text " Intro " { begin = 46, end = 52, id = "xye-6.0", index = 0 } ], firstLine = "# Intro ", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-2", lineNumber = 6, messages = [], numberOfLines = 1, position = 46, sourceText = "# Intro " }, properties = Dict.fromList [ ( "id", "@-2" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "intro" ) ] }
        , visible = True
        }
        (Array.fromList [])
    , RoseTree.Tree.Tree
        { block = { args = [ "1" ], body = Right [ Text " Particles" { begin = 56, end = 65, id = "xye-8.0", index = 0 } ], firstLine = "# Particles", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 8, messages = [], numberOfLines = 1, position = 56, sourceText = "# Particles" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "particles" ) ] }
        , visible = True
        }
        (Array.fromList
            [ RoseTree.Tree.Tree
                { block = { args = [ "2" ], body = Right [ Text " Bosons" { begin = 69, end = 75, id = "xye-10.0", index = 0 } ], firstLine = "## Bosons", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-4", lineNumber = 10, messages = [], numberOfLines = 1, position = 69, sourceText = "## Bosons" }, properties = Dict.fromList [ ( "id", "@-4" ), ( "label", "2.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "bosons" ) ] }
                , visible = True
                }
                (Array.fromList [])
            , RoseTree.Tree.Tree
                { block = { args = [ "2" ], body = Right [ Text " Fermions" { begin = 80, end = 88, id = "xye-12.0", index = 0 } ], firstLine = "## Fermions", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-5", lineNumber = 12, messages = [], numberOfLines = 1, position = 80, sourceText = "## Fermions" }, properties = Dict.fromList [ ( "id", "@-5" ), ( "label", "2.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "fermions" ) ] }
                , visible = True
                }
                (Array.fromList [])
            ]
        )
    ]
