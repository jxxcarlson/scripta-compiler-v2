module Scripta.Regex exposing (SectionType(..), findSectionPrefix, findSectionPrefix_, findSectionType, findUnNumberedSectionPrefix)

import Regex


titleOrAsteriskSectionRegex : Regex.Regex
titleOrAsteriskSectionRegex =
    Maybe.withDefault Regex.never <|
        Regex.fromString "^(#+|\\*+)\\s*"


type SectionType
    = Numbered String
    | Unnumbered String
    | Unknown


findSectionType : String -> SectionType
findSectionType string =
    case findSectionPrefix_ string of
        Just prefix ->
            if String.startsWith "#" prefix then
                Numbered prefix

            else if String.startsWith "*" prefix then
                Unnumbered prefix

            else
                Unknown

        Nothing ->
            Unknown


findSectionPrefix_ : String -> Maybe String
findSectionPrefix_ string =
    Regex.find titleOrAsteriskSectionRegex string
        |> List.map .match
        |> List.head
        |> Maybe.map String.trim


titleSectionRegex : Regex.Regex
titleSectionRegex =
    Maybe.withDefault Regex.never <|
        Regex.fromString "^#+\\s*"


findSectionPrefix : String -> Maybe String
findSectionPrefix string =
    case findSectionType string of
        Numbered prefix ->
            Just prefix

        Unnumbered prefix ->
            Just prefix

        Unknown ->
            Nothing


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
