module Scripta.PrimitiveBlock exposing (parse)

import Dict exposing (Dict)
import Generic.Language exposing (Heading(..), PrimitiveBlock)
import Generic.Line exposing (HeadingData, HeadingError(..), Line)
import Generic.PrimitiveBlock exposing (ParserFunctions)
import Scripta.Regex
import Tools.KV as KV


{-| Parse a list of strings into a list of primitive blocks given
a function for determining when a string is the first line
of a verbatim block.

Definitions:

    type alias PrimitiveBlock =
        Block (List String) BlockMeta

    type alias BlockMeta =
        { position : Int
        , lineNumber : Int
        , numberOfLines : Int
        , id : String
        , messages : List String
        , sourceText : String
        , error : Maybe String
        }

-}
parse : String -> Int -> List String -> List PrimitiveBlock
parse initialId outerCount lines =
    Generic.PrimitiveBlock.parse functionData initialId outerCount lines


functionData =
    { isVerbatimBlock = isVerbatimLine
    , getHeadingData = getHeadingData
    , findSectionPrefix = Scripta.Regex.findSectionPrefix
    }


isVerbatimLine : String -> Bool
isVerbatimLine str =
    (String.left 2 str == "||")
        -- the "||" prefix is in use but is deprecated and not public
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
    case Scripta.Regex.findSectionType line of
        Scripta.Regex.Numbered prefixSection ->
            { heading = Ordinary "section", args = [ String.length (String.trim prefixSection) |> String.fromInt ], properties = Dict.singleton "section-type" "markdown" }
                |> Ok

        Scripta.Regex.Unnumbered unnumberedPrefix ->
            { heading = Ordinary "section*", args = [ String.length (String.trim unnumberedPrefix) |> String.fromInt ], properties = Dict.singleton "section-type" "markdown" }
                |> Ok

        Scripta.Regex.Unknown ->
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
