module Render.Export.MacroConvert exposing (convertMathMacrosPreservingContext)

import Regex exposing (Regex)



-- PUBLIC


{-| Convert any contiguous block(s) of LaTeX newcommand lines into:

    | mathmacros
    name:   body
    ...

Everything before/after those block(s) is passed through unchanged.

Supported source lines (either form, with or without leading backslash on newcommand):

    \newcommand{\ket}\1{| #1 rangle}
    \newcommand{\bra}[1]{langle #1 |}
    newcommand{\bracket}\2{langle #1 | #2 rangle}
    newcommand{\ketbra}[2]{| #1 rangle langle #2 |}
    \newcommand{\diag}\1{| #1 rangle langle #1 |}
    \newcommand{\od}\2{frac(d #1,   d #2)}

-}
convertMathMacrosPreservingContext : String -> String
convertMathMacrosPreservingContext input =
    let
        lines =
            String.lines input

        ( resultReversed, _, accBlockReversed ) =
            List.foldl
                (step matchNewcommandLine)
                ( [], False, [] )
                lines

        -- flush any trailing open block
        finalResultReversed =
            if List.isEmpty accBlockReversed then
                resultReversed

            else
                emitBlock (List.reverse accBlockReversed) :: resultReversed
    in
    finalResultReversed
        |> List.reverse
        |> String.join "\n"



-- INTERNAL


type alias MacroLine =
    { name : String
    , body : String
    }


{-| One line → Maybe MacroLine (name, body) if it’s a newcommand line
-}
matchNewcommandLine : String -> Maybe MacroLine
matchNewcommandLine line =
    case Regex.find patCanonical line of
        m :: _ ->
            case m.submatches of
                -- groups: 1=name, 2=[n] (ignored), 3=body
                [ Just name, _, Just body ] ->
                    Just { name = name, body = cleanBody body }

                _ ->
                    Nothing

        [] ->
            case Regex.find patShorthand line of
                m2 :: _ ->
                    case m2.submatches of
                        -- groups: 1=name, 2=\N (ignored), 3=body
                        [ Just name, Just _, Just body ] ->
                            Just { name = name, body = cleanBody body }

                        _ ->
                            Nothing

                [] ->
                    Nothing


{-| Fold step that builds result while grouping contiguous macro lines
-}
step :
    (String -> Maybe MacroLine)
    -> String
    -> ( List String, Bool, List MacroLine )
    -> ( List String, Bool, List MacroLine )
step matcher line ( outRev, inBlock, accBlockRev ) =
    case matcher line of
        Just ml ->
            -- still in (or entering) a block: accumulate the macro line
            ( outRev, True, ml :: accBlockRev )

        Nothing ->
            if inBlock then
                -- leaving a block: flush the block, then append this line
                ( emitBlock (List.reverse accBlockRev) :: line :: outRev
                , False
                , []
                )

            else
                -- not in a block: pass through
                ( line :: outRev, False, accBlockRev )


emitBlock : List MacroLine -> String
emitBlock items =
    let
        render ml =
            ml.name ++ ":   " ++ ml.body
    in
    String.join "\n" ("| mathmacros" :: List.map render items)


cleanBody : String -> String
cleanBody body =
    body
        -- collapse runs of space after commas: ",   d" -> ", d"
        |> Regex.replace commaSpaces (\_ -> ", ")
        |> String.trim



-- REGEXES


{-| \\newcommand{\\name}[n]{body}
groups: 1=name, 2=n (optional), 3=body
-}
patCanonical : Regex
patCanonical =
    Regex.fromString
        "\\\\?newcommand\\{\\\\([A-Za-z]+)\\}(?:\\[(\\d+)\\])?\\{([^}]*)\\}"
        |> Maybe.withDefault Regex.never


{-| \\newcommand{\\name}\\N{body} (your shorthand)
groups: 1=name, 2=N, 3=body
-}
patShorthand : Regex
patShorthand =
    Regex.fromString
        "\\\\?newcommand\\{\\\\([A-Za-z]+)\\}\\\\([1-9])\\{([^}]*)\\}"
        |> Maybe.withDefault Regex.never


commaSpaces : Regex
commaSpaces =
    Regex.fromString ",\\s+"
        |> Maybe.withDefault Regex.never
