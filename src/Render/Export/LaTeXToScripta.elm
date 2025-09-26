module Render.Export.LaTeXToScripta exposing (translate)

{-| Convert LaTeX documents to Scripta format.

@docs translate

-}

import Regex


{-| Main translation function that converts LaTeX to Scripta.
-}
translate : String -> String
translate input =
    input
        |> convertEnvironments
        |> convertSections
        |> convertFractions
        |> convertMathSymbols
        |> convertReferences
        |> convertBibItems
        |> convertTerms
        |> cleanupBackslashes


{-| Convert LaTeX environments to Scripta equivalents.
Handles: equation, remark, aligned
-}
convertEnvironments : String -> String
convertEnvironments input =
    let
        -- Convert \begin{equation}...\end{equation} to |equation
        convertEquation text =
            text
                |> Regex.replace
                    (Regex.fromStringWith { multiline = True, caseInsensitive = False }
                        "\\\\begin\\{equation\\}([\\s\\S]*?)\\\\end\\{equation\\}"
                        |> Maybe.withDefault Regex.never
                    )
                    (\match ->
                        case match.submatches of
                            [ Just content ] ->
                                "| equation" ++ content

                            _ ->
                                match.match
                    )

        -- Convert \begin{remark}...\end{remark} to |remark
        convertRemark text =
            text
                |> Regex.replace
                    (Regex.fromStringWith { multiline = True, caseInsensitive = False }
                        "\\\\begin\\{remark\\}([\\s\\S]*?)\\\\end\\{remark\\}"
                        |> Maybe.withDefault Regex.never
                    )
                    (\match ->
                        case match.submatches of
                            [ Just content ] ->
                                "| remark" ++ content

                            _ ->
                                match.match
                    )

        -- Convert \begin{aligned}...\end{aligned} to |aligned
        convertAligned text =
            text
                |> Regex.replace
                    (Regex.fromStringWith { multiline = True, caseInsensitive = False }
                        "\\\\begin\\{align\\}([\\s\\S]*?)\\\\end\\{align\\}"
                        |> Maybe.withDefault Regex.never
                    )
                    (\match ->
                        case match.submatches of
                            [ Just content ] ->
                                "| aligned" ++ content

                            _ ->
                                match.match
                    )
    in
    input
        |> convertEquation
        |> convertRemark
        |> convertAligned


{-| Convert LaTeX sections to Scripta format.
-}
convertSections : String -> String
convertSections input =
    input
        |> Regex.replace
            (Regex.fromString "\\\\section\\{([^}]*)\\}"
                |> Maybe.withDefault Regex.never
            )
            (\match ->
                case match.submatches of
                    [ Just title ] ->
                        "## " ++ title

                    _ ->
                        match.match
            )


{-| Convert LaTeX fractions from \\frac{a}{b} to frac(a, b).
Preserves \\left( and \\right) and similar delimiters.
-}
convertFractions : String -> String
convertFractions input =
    let
        -- First, temporarily protect \left and \right delimiters
        protectDelimiters text =
            text
                |> String.replace "\\left(" "<<<LEFTPAREN>>>"
                |> String.replace "\\right)" "<<<RIGHTPAREN>>>"
                |> String.replace "\\left[" "<<<LEFTBRACKET>>>"
                |> String.replace "\\right]" "<<<RIGHTBRACKET>>>"
                |> String.replace "\\left\\{" "<<<LEFTBRACE>>>"
                |> String.replace "\\right\\}" "<<<RIGHTBRACE>>>"

        -- Restore protected delimiters
        restoreDelimiters text =
            text
                |> String.replace "<<<LEFTPAREN>>>" "\\left("
                |> String.replace "<<<RIGHTPAREN>>>" "\\right)"
                |> String.replace "<<<LEFTBRACKET>>>" "\\left["
                |> String.replace "<<<RIGHTBRACKET>>>" "\\right]"
                |> String.replace "<<<LEFTBRACE>>>" "\\left\\{"
                |> String.replace "<<<RIGHTBRACE>>>" "\\right\\}"

        -- Convert \frac{a}{b} to frac(a, b)
        convertFrac text =
            text
                |> Regex.replace
                    (Regex.fromString "\\\\frac\\{([^{}]*)\\}\\{([^{}]*)\\}"
                        |> Maybe.withDefault Regex.never
                    )
                    (\match ->
                        case match.submatches of
                            [ Just num, Just denom ] ->
                                "frac(" ++ num ++ ", " ++ denom ++ ")"

                            _ ->
                                match.match
                    )
    in
    input
        |> protectDelimiters
        |> convertFrac
        |> restoreDelimiters


{-| Convert LaTeX math symbols to Scripta format.
Removes backslashes from common math commands while preserving \\label{...}.
-}
convertMathSymbols : String -> String
convertMathSymbols input =
    let
        -- List of math commands to strip backslashes from
        mathCommands =
            [ "psi"
            , "epsilon"
            , "omega"
            , "lambda"
            , "alpha"
            , "beta"
            , "gamma"
            , "delta"
            , "theta"
            , "phi"
            , "sigma"
            , "tau"
            , "rho"
            , "mu"
            , "nu"
            , "xi"
            , "pi"
            , "Delta"
            , "Gamma"
            , "Lambda"
            , "Omega"
            , "Sigma"
            , "Pi"
            , "infty"
            , "cdot"
            , "cdots"
            , "sum"
            , "int"
            , "hat"
            , "langle"
            , "rangle"
            , "ne"
            , "le"
            , "ge"
            , "equiv"
            , "approx"
            , "times"
            , "div"
            ]

        -- Remove backslash from each math command
        removeMathBackslash cmd text =
            String.replace ("\\" ++ cmd) cmd text

        -- Apply all replacements
        processAllCommands text =
            List.foldl removeMathBackslash text mathCommands
    in
    processAllCommands input


{-| Convert LaTeX references.
\\eqref{...} becomes [ref ...]
\\ref{...} becomes [ref ...]
-}
convertReferences : String -> String
convertReferences input =
    input
        |> Regex.replace
            (Regex.fromString "\\\\eqref\\{([^}]*)\\}"
                |> Maybe.withDefault Regex.never
            )
            (\match ->
                case match.submatches of
                    [ Just ref ] ->
                        "[ref " ++ ref ++ "]"

                    _ ->
                        match.match
            )
        |> Regex.replace
            (Regex.fromString "\\\\ref\\{([^}]*)\\}"
                |> Maybe.withDefault Regex.never
            )
            (\match ->
                case match.submatches of
                    [ Just ref ] ->
                        "[ref " ++ ref ++ "]"

                    _ ->
                        match.match
            )


{-| Convert bibliography items and links.
\\bibitem{...} becomes | bibitem ...
\\href{url}{text} becomes [link "text" url]
-}
convertBibItems : String -> String
convertBibItems input =
    input
        |> Regex.replace
            (Regex.fromString "\\\\bibitem\\{([^}]*)\\}"
                |> Maybe.withDefault Regex.never
            )
            (\match ->
                case match.submatches of
                    [ Just label ] ->
                        "| bibitem " ++ label

                    _ ->
                        match.match
            )
        |> Regex.replace
            (Regex.fromString "\\\\href\\{([^}]*)\\}\\{([^}]*)\\}"
                |> Maybe.withDefault Regex.never
            )
            (\match ->
                case match.submatches of
                    [ Just url, Just text ] ->
                        "[link \"" ++ text ++ "\" " ++ url ++ "]"

                    _ ->
                        match.match
            )


{-| Convert \\term{...} to [term ...].
-}
convertTerms : String -> String
convertTerms input =
    input
        |> Regex.replace
            (Regex.fromString "\\\\term\\{([^}]*)\\}"
                |> Maybe.withDefault Regex.never
            )
            (\match ->
                case match.submatches of
                    [ Just term ] ->
                        "[term " ++ term ++ "]"

                    _ ->
                        match.match
            )


{-| Clean up remaining backslashes that should be removed.
Preserves \\label{...}, \\left/\\right delimiters.
-}
cleanupBackslashes : String -> String
cleanupBackslashes input =
    let
        -- Remove backslashes from common text commands
        textCommands =
            [ "ell"
            , "ldots"
            , "dots"
            , "quad"
            , "qquad"
            , "text"
            , "mathrm"
            ]

        removeTextBackslash cmd text =
            String.replace ("\\" ++ cmd) cmd text
    in
    List.foldl removeTextBackslash input textCommands
