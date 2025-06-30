module M.PrimitiveBlock exposing (..)

import Dict exposing (Dict)
import Generic.Language exposing (Heading(..), PrimitiveBlock)
import Generic.Line exposing (HeadingData, HeadingError(..), Line)
import Generic.PrimitiveBlock exposing (ParserFunctions)
import M.Regex
import Parser exposing ((|.), (|=), Parser)
import Tools.KV as KV


xx =
    """
| table ccl
1 & 2 & 3.1234
4 & 5 & 6.11
"""


x3 =
    """
| equation
\\int_0^1 x^n dx = \\frac{1}{n+1}
"""


x4 =
    """
| aligned
& a  = b^2    \\
& c  = d^2    \\
"""


x3b =
    """
|| equation
\\int_0^1 x^n dx = \\frac{1}{n+1}
"""


ex1 =
    """
| code
$$
\\int_0^1 x^n dx = \\frac{1}{n+1}
$$


"""


qq =
    """
| quotation title:Gettysburg Address
Four score and seven years ago

  Now we are engaged in a great civil war

  Now we are engaged in a great civil war. Lorem ipsum dolor sit amet, consectetur adipiscing elit.

  Now we are engaged in a great civil wa. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
"""


t1 =
    """
 || table c c c
 1 & 2 & 3.1234 \\
 4 & 5 & 6.1

"""


tb2 =
    """
 | table c c c
 1 & 2 & 3.1234 \\
 4 & 5 & 6.1
"""


cl =
    """
- Plastic cups
- Red wine
- White wine
- Cheese
- Crackers
"""


nl =
    """
. Plastic cups
. Red wine
. White wine
. Cheese
. Crackers
"""


cl2 =
    """
- Plastic cups
not too big
- Red wine
  really good stuff!
- White wine

$a^ + b^2 = c^2$
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
    case M.Regex.findSectionPrefix line of
        Just prefix ->
            { heading = Ordinary "section", args = [ String.length prefix |> String.fromInt ], properties = Dict.singleton "section-type" "markdown" }
                |> Ok

        Nothing ->
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
                                    coerceToVerbatim line args name args2 properties |> Debug.log "@@M.PrimitiveBlock.getHeadingData"

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
    let
        _ =
            Debug.log "@@M.PrimitiveBlock.coerceToVerbatim" name
    in
    case hasVerbatimWord line of
        Just element ->
            (Ok <| coerceToVerbatim_ line args element) |> Debug.log ("@@M.PrimitiveBlock.coerceToVerbatim (2)" ++ name)

        Nothing ->
            (Ok <| { heading = Ordinary name, args = args2, properties = properties }) |> Debug.log ("@@M.PrimitiveBlock.coerceToVerbatim (3)" ++ name)


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
