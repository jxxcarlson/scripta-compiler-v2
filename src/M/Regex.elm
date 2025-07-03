module M.Regex exposing (findSectionPrefix, findUnNumberedSectionPrefix)

import Regex


titleSectionRegex : Regex.Regex
titleSectionRegex =
    Maybe.withDefault Regex.never <|
        Regex.fromString "^#+\\s*"


findSectionPrefix : String -> Maybe String
findSectionPrefix string =
    Regex.find titleSectionRegex string
        |> List.map .match
        |> List.head
        |> Maybe.map String.trim


altTitleSectionRegex : Regex.Regex
altTitleSectionRegex =
    Maybe.withDefault Regex.never <|
        Regex.fromString "^\\*+\\s*"


findUnNumberedSectionPrefix : String -> Maybe String
findUnNumberedSectionPrefix string =
    Regex.find altTitleSectionRegex string
        |> List.map .match
        |> List.head
        |> Maybe.map String.trim
