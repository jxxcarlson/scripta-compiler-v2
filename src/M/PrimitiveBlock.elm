module M.PrimitiveBlock exposing (..)

import Dict exposing (Dict)
import Generic.Language exposing (Heading(..), PrimitiveBlock)
import Generic.Line exposing (HeadingData, HeadingError(..), Line)
import Generic.PrimitiveBlock exposing (ParserFunctions)
import M.Regex
import Parser exposing ((|.), (|=), Parser)
import Tools.KV as KV


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
                                    Ok <| { heading = Ordinary name, args = args2, properties = properties }

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
