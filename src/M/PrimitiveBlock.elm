module M.PrimitiveBlock exposing (ib, l, ll, p, parse, py)

import Dict exposing (Dict)
import Generic.Language exposing (Heading(..), PrimitiveBlock)
import Generic.Line exposing (HeadingData, HeadingError(..), Line)
import Generic.PrimitiveBlock exposing (ParserFunctions)
import M.Regex
import Tools.KV as KV


xx =
    """
| table ccl
1 & 2 & 3.1234
4 & 5 & 6.11
"""


l =
    """- Eggs
 """


ll =
    """- Eggs
- Milk
- Bread
 """


ib =
    """
| indent
1234Vivamus dignissim tristique enim, et fringilla enim vulputate at. Vestibulum ornare, odio vitae pharetra laoreet, elit nibh iaculis augue, sit amet sodales massa quam sit amet sem.
In et placerat neque, eget faucibus nisl.
"""


py =
    """
| code python
for i = 12 to n:
  x = x + 3*i
print(x)
"""


p str =
    parse "0" 0 (String.lines str)


{-| Parse a list of strings into a list of primitive blocks given
a function for determining when a string is the first line
of a verbatim block

NOTE (TODO) for the moment we assume that the input ends with
a blank line.

-}
parse : String -> Int -> List String -> List PrimitiveBlock
parse initialId outerCount lines =
    Generic.PrimitiveBlock.parse functionData initialId outerCount lines


functionData =
    { isVerbatimBlock = isVerbatimLine
    , getHeadingData = getHeadingData
    , findSectionPrefix = M.Regex.findSectionPrefix
    }


isVerbatimLine : String -> Bool
isVerbatimLine str =
    (String.left 2 str == "||")
        || (String.left 3 str == "```")
        || (String.left 2 str == "$$")


getHeadingData : String -> Result HeadingError HeadingData
getHeadingData line_ =
    let
        line =
            String.trim line_

        ( args1, properties ) =
            KV.argsAndProperties (String.words line)
    in
    case M.Regex.findSectionType line of
        M.Regex.Numbered prefixSection ->
            { heading = Ordinary "section", args = [ String.length (String.trim prefixSection) |> String.fromInt ], properties = Dict.singleton "section-type" "markdown" }
                |> Ok

        M.Regex.Unnumbered unnumberedPrefix ->
            { heading = Ordinary "section*", args = [ String.length (String.trim unnumberedPrefix) |> String.fromInt ], properties = Dict.singleton "section-type" "markdown" }
                |> Ok

        M.Regex.Unknown ->
            case args1 of
                [] ->
                    --Err <| HEMissingPrefix
                    { heading = Paragraph, args = [], properties = Dict.empty }
                        |> Ok

                prefix :: args ->
                    case prefix of
                        "||" ->
                            case args of
                                [] ->
                                    Err <| HEMissingName

                                name :: args2 ->
                                    Ok <| { heading = Verbatim name, args = args2, properties = properties }

                        "|" ->
                            case args of
                                [] ->
                                    Err <| HEMissingName

                                name :: args2 ->
                                    -- coerce the block to a verbatim block if
                                    -- the prefix is "|" and the name is in the list of
                                    -- of verbatim blocks
                                    -- coerceToVerbatim line args name args2 properties
                                    Ok <|
                                        if List.member name verbatimWords then
                                            { heading = Verbatim name
                                            , args = args2
                                            , properties = properties
                                            }

                                        else
                                            { heading = Ordinary name, args = args2, properties = properties }

                        "-" ->
                            let
                                reducedLine =
                                    String.replace "- " "" line
                            in
                            if String.isEmpty reducedLine then
                                Err HENoContent

                            else
                                Ok <|
                                    { heading = Ordinary "item"
                                    , args = []
                                    , properties = Dict.singleton "firstLine" (String.replace "- " "" line)
                                    }

                        "." ->
                            let
                                reducedLine =
                                    String.replace ". " "" line
                            in
                            if String.isEmpty reducedLine then
                                Err HENoContent

                            else
                                Ok <|
                                    { heading = Ordinary "numbered"
                                    , args = []
                                    , properties = Dict.singleton "firstLine" (String.replace ". " "" line)
                                    }

                        "```" ->
                            Ok <|
                                { heading = Verbatim "code"
                                , args = []
                                , properties = Dict.empty
                                }

                        "$$" ->
                            Ok <| { heading = Verbatim "math", args = [], properties = Dict.empty }

                        _ ->
                            Ok <| { heading = Paragraph, args = [], properties = Dict.empty }


coerceToVerbatim line args name args2 properties =
    case hasVerbatimWord line of
        Just element ->
            Ok <| coerceToVerbatim_ line args element

        Nothing ->
            Ok <| { heading = Ordinary name, args = args2, properties = properties }


hasVerbatimWord : String -> Maybe String
hasVerbatimWord line =
    case mElementWord line of
        Nothing ->
            Nothing

        Just word ->
            if List.member word verbatimWords then
                Just word

            else
                Nothing


verbatimWords =
    [ "math"
    , "chem"
    , "compute"
    , "equation"
    , "aligned"
    , "array"
    , "textarray"
    , "table"
    , "code"
    , "verse"
    , "verbatim"
    , "load"
    , "load-data"
    , "hide"
    , "texComment"
    , "docinfo"
    , "mathmacros"
    , "textmacros"
    , "csvtable"
    , "table"
    , "chart"
    , "svg"
    , "quiver"
    , "image"
    , "tikz"
    , "load-files"
    , "include"
    , "setup"
    , "iframe"
    , "settings"
    ]


mElementWord line =
    line
        |> String.dropLeft 2
        |> String.trim
        |> String.split " "
        |> List.head
        |> Maybe.map String.trim



--String.contains "code" line
--    || String.contains "equation" line
--    || String.contains "verse" line
--    || String.contains "aligned" line


coerceToVerbatim_ line args2 element =
    { heading = Verbatim element
    , args = args2
    , properties = Dict.singleton "firstLine" (String.replace "| " "" line)
    }
