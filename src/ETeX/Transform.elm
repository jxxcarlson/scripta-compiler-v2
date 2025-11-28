module ETeX.Transform exposing
    ( evalStr
    , greekSymbolParser
    , makeMacroDict
    , toLaTeXNewCommands
    , transformETeX
    )

import Dict exposing (Dict)
import ETeX.Dictionary
import ETeX.KaTeX exposing (isKaTeX)
import ETeX.MathMacros exposing (MacroBody(..), MathMacroDict, NewCommand(..))
import Generic.MathMacro
import Maybe.Extra
import Parser.Advanced as PA
    exposing
        ( (|.)
        , (|=)
        , DeadEnd
        , Step(..)
        , Token(..)
        , backtrackable
        , chompIf
        , chompWhile
        , getChompedString
        , getOffset
        , getSource
        , lazy
        , loop
        , map
        , oneOf
        , run
        , succeed
        , symbol
        )
import Result.Extra



-- TYPES


type MathExpr
    = AlphaNum String
    | F0 String
    | Arg (List MathExpr)
    | PArg (List MathExpr)
    | ParenthExpr (List MathExpr)
    | Sub Deco
    | Super Deco
    | Param Int
    | WS
    | MathSpace
    | MathSmallSpace
    | MathMediumSpace
    | LeftMathBrace
    | RightMathBrace
    | LeftParen
    | RightParen
    | Comma
    | MathSymbols String
    | GreekSymbol String
    | Macro String (List MathExpr)
    | FCall String (List MathExpr)
    | Expr (List MathExpr)
    | Text String


type Deco
    = DecoM MathExpr
    | DecoI Int



-- OTHER --


transformETeX : MathMacroDict -> String -> String
transformETeX userdefinedMacroDict src =
    case transformETeX_ userdefinedMacroDict src of
        Ok result ->
            List.map print result |> String.join ""

        Err _ ->
            src


isUserDefinedMacro : MathMacroDict -> String -> Bool
isUserDefinedMacro dict name =
    Dict.member name dict


transformETeX_ userdefinedMacroDict src =
    src
        |> parseMany userdefinedMacroDict
        |> Result.map resolveSymbolNames


resolveSymbolNames : List MathExpr -> List MathExpr
resolveSymbolNames exprs =
    List.map resolveSymbolName exprs


{-|

    TODO: Need to take care of all cases where a symbol name is used.

-}
resolveSymbolName : MathExpr -> MathExpr
resolveSymbolName expr =
    case expr of
        AlphaNum str ->
            case Dict.get str ETeX.Dictionary.symbolDict of
                Just _ ->
                    AlphaNum ("\\" ++ str)

                Nothing ->
                    AlphaNum str

        PArg exprs ->
            PArg (List.map resolveSymbolName exprs)

        ParenthExpr exprs ->
            ParenthExpr (List.map resolveSymbolName exprs)

        Macro name args ->
            Macro name (List.map resolveSymbolName args)

        F0 str ->
            F0 str

        Arg exprs ->
            Arg (List.map resolveSymbolName exprs)

        Sub deco ->
            Sub (resolveSymbolNameInDeco deco)

        Super deco ->
            Super (resolveSymbolNameInDeco deco)

        Param n ->
            Param n

        WS ->
            WS

        MathSpace ->
            MathSpace

        MathSmallSpace ->
            MathSmallSpace

        MathMediumSpace ->
            MathMediumSpace

        LeftMathBrace ->
            LeftMathBrace

        RightMathBrace ->
            RightMathBrace

        LeftParen ->
            LeftParen

        RightParen ->
            RightParen

        Comma ->
            Comma

        MathSymbols str ->
            MathSymbols str

        FCall name args ->
            FCall name (List.map resolveSymbolName args)

        Expr exprs ->
            Expr (List.map resolveSymbolName exprs)

        Text str ->
            Text str

        GreekSymbol str ->
            Text ("\\" ++ str)



-- Helper function to resolve symbol names in Deco


resolveSymbolNameInDeco : Deco -> Deco
resolveSymbolNameInDeco deco =
    case deco of
        DecoM expr ->
            DecoM (resolveSymbolName expr)

        DecoI n ->
            DecoI n


evalStr : MathMacroDict -> String -> String
evalStr userDefinedMacroDict str =
    case parseManyWithDict userDefinedMacroDict (String.trim str) of
        Ok result ->
            List.map (expandMacroWithDict userDefinedMacroDict) result |> printList

        Err _ ->
            -- the intent of evalStr is to expand macros.  So if something
            -- goes wrong with the process, just return the input string.
            -- TODO: This solves the problem of false error reporting, but I don't like the solution.
            str


parseMany : MathMacroDict -> String -> Result (List (DeadEnd Context Problem)) (List MathExpr)
parseMany userDefinedMacroDict str =
    parseManyWithDict userDefinedMacroDict str


parseManyWithDict : MathMacroDict -> String -> Result (List (DeadEnd Context Problem)) (List MathExpr)
parseManyWithDict userMacroDict str =
    str
        |> String.trim
        |> String.lines
        |> List.map String.trim
        |> List.map (parseWithDict userMacroDict)
        |> Result.Extra.combine
        |> Result.map List.concat



-- Helper to extract just PArg elements from a comma-separated list


extractMacroArgs : List MathExpr -> List MathExpr
extractMacroArgs args =
    case args of
        [] ->
            []

        (PArg contents) :: rest ->
            Arg contents :: extractMacroArgs rest

        Comma :: rest ->
            extractMacroArgs rest

        other :: rest ->
            other :: extractMacroArgs rest



-- Helper to flatten PArg content for single-argument macros


flattenForSingleArg : List MathExpr -> List MathExpr
flattenForSingleArg args =
    case args of
        [] ->
            []

        (PArg contents) :: rest ->
            contents ++ flattenForSingleArg rest

        other :: rest ->
            other :: flattenForSingleArg rest


expandMacroWithDict : MathMacroDict -> MathExpr -> MathExpr
expandMacroWithDict dict expr =
    case expr of
        Macro macroName args ->
            case Dict.get macroName dict of
                Nothing ->
                    Macro macroName (List.map (expandMacroWithDict dict) args)

                Just (MacroBody arity exprs) ->
                    let
                        macroArgs =
                            if arity == 1 then
                                -- For single-argument macros, combine all content into one Arg
                                case args of
                                    [] ->
                                        []

                                    _ ->
                                        [ Arg (flattenForSingleArg args) ]

                            else
                                -- For multi-argument macros, extract PArg elements separately
                                extractMacroArgs args
                    in
                    Expr (expandMacro_ (List.map (expandMacroWithDict dict) macroArgs) (MacroBody arity exprs))

        Arg exprs ->
            Arg (List.map (expandMacroWithDict dict) exprs)

        Sub decoExpr ->
            case decoExpr of
                DecoM decoMExpr ->
                    Sub (DecoM (expandMacroWithDict dict decoMExpr))

                DecoI m ->
                    Sub (DecoI m)

        Super decoExpr ->
            case decoExpr of
                DecoM decoMExpr ->
                    Super (DecoM (expandMacroWithDict dict decoMExpr))

                DecoI m ->
                    Super (DecoI m)

        PArg exprs ->
            PArg (List.map (expandMacroWithDict dict) exprs)

        ParenthExpr exprs ->
            ParenthExpr (List.map (expandMacroWithDict dict) exprs)

        FCall name args ->
            FCall name (List.map (expandMacroWithDict dict) args)

        Expr exprs ->
            Expr (List.map (expandMacroWithDict dict) exprs)

        Text str ->
            Text str

        -- Simple cases that don't contain sub-expressions
        AlphaNum str ->
            AlphaNum str

        F0 str ->
            F0 str

        Param n ->
            Param n

        WS ->
            WS

        MathSpace ->
            MathSpace

        MathSmallSpace ->
            MathSmallSpace

        MathMediumSpace ->
            MathMediumSpace

        LeftMathBrace ->
            LeftMathBrace

        RightMathBrace ->
            RightMathBrace

        LeftParen ->
            LeftParen

        RightParen ->
            RightParen

        Comma ->
            Comma

        MathSymbols str ->
            MathSymbols str

        GreekSymbol str ->
            GreekSymbol str


{-|

    > args = [Exprs [AlphaNum "x"],Exprs [AlphaNum "y"]]
    > macroDefBody = (MacroBody 2 [Macro "alpha" [],MathSymbols "(",Param 1,MathSymbols ",",Param 2,MathSymbols ")"])
    > expandMacro_  args macroDefBody
    [Macro "alpha" [],MathSymbols "(",Exprs [AlphaNum "x"],MathSymbols ",",Exprs [AlphaNum "y"],MathSymbols ")"]

-}
expandMacro_ : List MathExpr -> MacroBody -> List MathExpr
expandMacro_ args (MacroBody arity macroDefBody) =
    -- Convert ETeX.MathMacros.MathExpr to local MathExpr
    let
        localMacroDefBody =
            List.map convertFromETeXMathExpr macroDefBody
    in
    replaceParams args localMacroDefBody


replaceParam_ : Int -> MathExpr -> MathExpr -> MathExpr
replaceParam_ k expr target =
    case target of
        Arg exprs ->
            Arg (List.map (replaceParam_ k expr) exprs)

        Sub decoExpr ->
            case decoExpr of
                DecoM decoMExpr ->
                    Sub (DecoM (replaceParam_ k expr decoMExpr))

                DecoI m ->
                    Sub (DecoI m)

        Super decoExpr ->
            case decoExpr of
                DecoM decoMExpr ->
                    Super (DecoM (replaceParam_ k expr decoMExpr))

                DecoI m ->
                    Super (DecoI m)

        Param m ->
            if m == k then
                expr

            else
                Param m

        Macro name exprs ->
            Macro name (List.map (replaceParam_ k expr) exprs)

        PArg exprs ->
            PArg (List.map (replaceParam_ k expr) exprs)

        ParenthExpr exprs ->
            ParenthExpr (List.map (replaceParam_ k expr) exprs)

        FCall name args ->
            FCall name (List.map (replaceParam_ k expr) args)

        Expr exprs ->
            Expr (List.map (replaceParam_ k expr) exprs)

        Text str ->
            Text str

        -- Simple cases that don't contain sub-expressions
        AlphaNum str ->
            AlphaNum str

        F0 str ->
            F0 str

        WS ->
            WS

        MathSpace ->
            MathSpace

        MathSmallSpace ->
            MathSmallSpace

        MathMediumSpace ->
            MathMediumSpace

        LeftMathBrace ->
            LeftMathBrace

        RightMathBrace ->
            RightMathBrace

        LeftParen ->
            LeftParen

        RightParen ->
            RightParen

        Comma ->
            Comma

        MathSymbols str ->
            MathSymbols str

        GreekSymbol str ->
            GreekSymbol str


replaceParam : Int -> MathExpr -> List MathExpr -> List MathExpr
replaceParam k expr exprs =
    List.map (replaceParam_ k expr) exprs


replaceParams : List MathExpr -> List MathExpr -> List MathExpr
replaceParams replacementList target =
    List.foldl (\( k, replacement ) acc -> replaceParam (k + 1) replacement acc) target (List.indexedMap (\k item -> ( k, item )) replacementList)


makeMacroDict : String -> Dict String MacroBody
makeMacroDict str =
    str
        |> String.trim
        |> String.lines
        |> List.map String.trim
        |> List.filter (not << String.isEmpty)
        |> makeMacroDictFromMixedLines



-- Process lines that can be either format


makeMacroDictFromMixedLines : List String -> Dict String MacroBody
makeMacroDictFromMixedLines lines =
    List.foldl addMixedFormatMacro Dict.empty lines



-- Add a macro in either format


addMixedFormatMacro : String -> Dict String MacroBody -> Dict String MacroBody
addMixedFormatMacro line dict =
    let
        knownMacros =
            Dict.keys dict
    in
    if String.startsWith "\\newcommand" line then
        -- Traditional format
        case parseNewCommand Dict.empty line |> makeEntry of
            Just ( name, body ) ->
                Dict.insert name body dict

            Nothing ->
                dict

    else if String.contains ":" line then
        -- Simple format
        case parseSimpleMacroWithContext knownMacros line of
            Just ( name, body ) ->
                Dict.insert name body dict

            Nothing ->
                dict

    else
        -- Skip unrecognized lines
        dict



-- Parse with context of known macro names


parseSimpleMacroWithContext : List String -> String -> Maybe ( String, MacroBody )
parseSimpleMacroWithContext knownMacros line =
    case String.split ":" line of
        [ name, body ] ->
            let
                trimmedName =
                    String.trim name

                trimmedBody =
                    String.trim body

                -- Process body with knowledge of what macros exist
                processedBody =
                    processSimpleMacroBodyWithContext knownMacros trimmedBody

                -- Convert the simplified syntax to standard newcommand format
                newCommandStr =
                    "\\newcommand{\\" ++ trimmedName ++ "}{" ++ processedBody ++ "}"
            in
            parseNewCommand Dict.empty newCommandStr
                |> makeEntry

        _ ->
            Nothing



-- Process the body of a simple macro to handle various shortcuts


processSimpleMacroBody : String -> String
processSimpleMacroBody body =
    processSimpleMacroBodyWithContext [] body



-- Process with knowledge of existing macros


processSimpleMacroBodyWithContext : List String -> String -> String
processSimpleMacroBodyWithContext knownMacros body =
    -- Parse the body to identify and process tokens
    body
        |> tokenizeSimpleMacroBody
        |> processTokensWithLookahead knownMacros
        |> List.map tokenToString
        |> String.concat



-- Token types for simple macro parsing


type SimpleToken
    = SimpleWord String
    | SimpleBackslash
    | SimpleSpace String
    | SimpleSymbol String
    | SimpleBrace String String -- open/close brace with content
    | SimpleParam Int



-- Tokenize the macro body into recognizable parts


tokenizeSimpleMacroBody : String -> List SimpleToken
tokenizeSimpleMacroBody body =
    tokenizeHelper (String.toList body) []
        |> List.reverse


tokenizeHelper : List Char -> List SimpleToken -> List SimpleToken
tokenizeHelper chars acc =
    case chars of
        [] ->
            acc

        '\\' :: rest ->
            tokenizeHelper rest (SimpleBackslash :: acc)

        '#' :: rest ->
            -- Parse parameter number
            case takeDigits rest of
                ( digits, remaining ) ->
                    case String.toInt (String.fromList digits) of
                        Just n ->
                            tokenizeHelper remaining (SimpleParam n :: acc)

                        Nothing ->
                            tokenizeHelper rest (SimpleSymbol "#" :: acc)

        '{' :: rest ->
            -- Collect content until matching '}'
            case collectUntilCloseBrace rest 1 [] of
                ( content, remaining ) ->
                    tokenizeHelper remaining (SimpleBrace "{" (String.fromList content) :: acc)

        c :: rest ->
            if Char.isAlpha c then
                -- Collect alphabetic word
                case takeAlphas (c :: rest) of
                    ( word, remaining ) ->
                        tokenizeHelper remaining (SimpleWord (String.fromList word) :: acc)

            else if c == ' ' || c == '\t' || c == '\n' then
                -- Collect whitespace
                case takeSpaces (c :: rest) of
                    ( spaces, remaining ) ->
                        tokenizeHelper remaining (SimpleSpace (String.fromList spaces) :: acc)

            else
                -- Single symbol
                tokenizeHelper rest (SimpleSymbol (String.fromChar c) :: acc)



-- Helper to take digits


takeDigits : List Char -> ( List Char, List Char )
takeDigits chars =
    case chars of
        [] ->
            ( [], [] )

        c :: rest ->
            if Char.isDigit c then
                let
                    ( digits, remaining ) =
                        takeDigits rest
                in
                ( c :: digits, remaining )

            else
                ( [], chars )



-- Helper to take alphabetic characters


takeAlphas : List Char -> ( List Char, List Char )
takeAlphas chars =
    case chars of
        [] ->
            ( [], [] )

        c :: rest ->
            if Char.isAlpha c then
                let
                    ( alphas, remaining ) =
                        takeAlphas rest
                in
                ( c :: alphas, remaining )

            else
                ( [], chars )



-- Helper to take spaces


takeSpaces : List Char -> ( List Char, List Char )
takeSpaces chars =
    case chars of
        [] ->
            ( [], [] )

        c :: rest ->
            if c == ' ' || c == '\t' || c == '\n' then
                let
                    ( spaces, remaining ) =
                        takeSpaces rest
                in
                ( c :: spaces, remaining )

            else
                ( [], chars )



-- Helper to collect content until closing brace


collectUntilCloseBrace : List Char -> Int -> List Char -> ( List Char, List Char )
collectUntilCloseBrace chars depth acc =
    case chars of
        [] ->
            ( List.reverse acc, [] )

        '{' :: rest ->
            collectUntilCloseBrace rest (depth + 1) ('{' :: acc)

        '}' :: rest ->
            if depth == 1 then
                ( List.reverse acc, rest )

            else
                collectUntilCloseBrace rest (depth - 1) ('}' :: acc)

        c :: rest ->
            collectUntilCloseBrace rest depth (c :: acc)



-- Process tokens with lookahead to make better decisions


processTokensWithLookahead : List String -> List SimpleToken -> List SimpleToken
processTokensWithLookahead knownMacros tokens =
    case tokens of
        [] ->
            []

        (SimpleWord word1) :: (SimpleSpace space) :: (SimpleWord word2) :: rest ->
            -- Check for "mathbb X" pattern
            if word1 == "mathbb" && String.length word2 == 1 then
                SimpleWord "\\mathbb" :: SimpleBrace "{" word2 :: processTokensWithLookahead knownMacros rest

            else
                SimpleWord word1 :: SimpleSpace space :: processTokensWithLookahead knownMacros (SimpleWord word2 :: rest)

        (SimpleWord word) :: (SimpleSymbol "^") :: rest ->
            -- Word followed by ^ - likely a macro reference
            if isKaTeX word || List.member word knownMacros then
                SimpleWord ("\\" ++ word) :: SimpleSymbol "^" :: processTokensWithLookahead knownMacros rest

            else
                SimpleWord word :: SimpleSymbol "^" :: processTokensWithLookahead knownMacros rest

        (SimpleWord word) :: (SimpleSymbol "(") :: rest ->
            -- Word followed by ( - check if it's a function-like macro
            if isKaTeX word && needsBraceConversion word then
                -- For macros like frac, binom that need brace arguments
                let
                    ( args, remaining ) =
                        extractParenArgs rest []

                    processedArgs =
                        args |> List.map (processTokensWithLookahead knownMacros)
                in
                SimpleWord ("\\" ++ word) :: convertArgsToBraces processedArgs ++ processTokensWithLookahead knownMacros remaining

            else if isKaTeX word then
                SimpleWord ("\\" ++ word) :: SimpleSymbol "(" :: processTokensWithLookahead knownMacros rest

            else if List.member word knownMacros then
                SimpleWord ("\\" ++ word) :: SimpleSymbol "(" :: processTokensWithLookahead knownMacros rest

            else
                SimpleWord word :: SimpleSymbol "(" :: processTokensWithLookahead knownMacros rest

        (SimpleWord word) :: rest ->
            -- Check if it's a known function or macro
            if isKaTeX word || List.member word knownMacros then
                SimpleWord ("\\" ++ word) :: processTokensWithLookahead knownMacros rest

            else
                SimpleWord word :: processTokensWithLookahead knownMacros rest

        token :: rest ->
            token :: processTokensWithLookahead knownMacros rest



-- Check if a KaTeX command needs brace conversion


needsBraceConversion : String -> Bool
needsBraceConversion cmd =
    -- Commands that take multiple arguments in braces
    List.member cmd [ "frac", "binom", "overset", "underset", "stackrel", "tfrac", "dfrac", "cfrac", "dbinom", "tbinom" ]



-- Extract arguments from parentheses and remaining tokens


extractParenArgs : List SimpleToken -> List SimpleToken -> ( List (List SimpleToken), List SimpleToken )
extractParenArgs tokens currentArg =
    case tokens of
        [] ->
            if List.isEmpty currentArg then
                ( [], [] )

            else
                ( [ List.reverse currentArg ], [] )

        (SimpleSymbol ")") :: rest ->
            if List.isEmpty currentArg then
                ( [], rest )

            else
                ( [ List.reverse currentArg ], rest )

        (SimpleSymbol ",") :: rest ->
            let
                ( args, remaining ) =
                    extractParenArgs rest []
            in
            ( List.reverse currentArg :: args, remaining )

        token :: rest ->
            extractParenArgs rest (token :: currentArg)



-- Convert comma-separated args to brace notation


convertArgsToBraces : List (List SimpleToken) -> List SimpleToken
convertArgsToBraces args =
    args
        |> List.map (\arg -> SimpleBrace "{" (arg |> List.map tokenToString |> String.concat))



-- Convert token back to string


tokenToString : SimpleToken -> String
tokenToString token =
    case token of
        SimpleWord word ->
            word

        SimpleBackslash ->
            "\\"

        SimpleSpace s ->
            s

        SimpleSymbol s ->
            s

        SimpleBrace open content ->
            open ++ content ++ "}"

        SimpleParam n ->
            "#" ++ String.fromInt n



-- Convert simple macro syntax to LaTeX newcommands


toLaTeXNewCommands : String -> String
toLaTeXNewCommands input =
    input
        |> String.trim
        |> String.lines
        |> List.map String.trim
        |> List.filter (not << String.isEmpty)
        |> List.map simpleMacroToLaTeX
        |> List.filter ((/=) "")
        |> String.join "\n"



-- Convert a single simple macro line to LaTeX newcommand


simpleMacroToLaTeX : String -> String
simpleMacroToLaTeX line =
    if String.contains ":" line then
        case parseSimpleMacroWithContext [] line of
            Just ( name, MacroBody arity _ ) ->
                let
                    processedBody =
                        processSimpleMacroBody (String.split ":" line |> List.drop 1 |> String.join ":" |> String.trim)

                    arityStr =
                        if arity > 0 then
                            "[" ++ String.fromInt arity ++ "]"

                        else
                            ""
                in
                "\\newcommand{\\" ++ name ++ "}" ++ arityStr ++ "{" ++ processedBody ++ "}"

            Nothing ->
                ""

    else
        ""



-- CONVERSIONS
-- Convert local MacroBody to Generic.MathMacro.MacroBody


convertToGenericMacroBody : MacroBody -> Generic.MathMacro.MacroBody
convertToGenericMacroBody (MacroBody arity exprs) =
    let
        localExprs =
            List.map convertFromETeXMathExpr exprs
    in
    Generic.MathMacro.MacroBody arity (List.map convertToGenericMathExpr localExprs)



-- Convert local MathExpr to Generic.MathMacro.MathExpr


convertToGenericMathExpr : MathExpr -> Generic.MathMacro.MathExpr
convertToGenericMathExpr expr =
    case expr of
        AlphaNum str ->
            Generic.MathMacro.AlphaNum str

        F0 str ->
            Generic.MathMacro.F0 str

        Arg exprs ->
            Generic.MathMacro.Arg (List.map convertToGenericMathExpr exprs)

        PArg exprs ->
            -- Convert PArg to Arg in generic representation
            Generic.MathMacro.Arg (List.map convertToGenericMathExpr exprs)

        ParenthExpr exprs ->
            -- Convert ParenthExpr to Expr in generic representation
            Generic.MathMacro.Expr (List.map convertToGenericMathExpr exprs)

        Sub deco ->
            Generic.MathMacro.Sub (convertToGenericDeco deco)

        Super deco ->
            Generic.MathMacro.Super (convertToGenericDeco deco)

        Param n ->
            Generic.MathMacro.Param n

        WS ->
            Generic.MathMacro.WS

        MathSpace ->
            Generic.MathMacro.MathSpace

        MathSmallSpace ->
            Generic.MathMacro.MathSmallSpace

        MathMediumSpace ->
            Generic.MathMacro.MathMediumSpace

        LeftMathBrace ->
            Generic.MathMacro.LeftMathBrace

        RightMathBrace ->
            Generic.MathMacro.RightMathBrace

        LeftParen ->
            -- Convert to MathSymbols in generic representation
            Generic.MathMacro.MathSymbols "("

        RightParen ->
            -- Convert to MathSymbols in generic representation
            Generic.MathMacro.MathSymbols ")"

        Comma ->
            -- Convert to MathSymbols in generic representation
            Generic.MathMacro.MathSymbols ","

        MathSymbols str ->
            Generic.MathMacro.MathSymbols str

        Macro name args ->
            Generic.MathMacro.Macro name (List.map convertToGenericMathExpr args)

        FCall name args ->
            -- Convert FCall to Macro in generic representation
            Generic.MathMacro.Macro name (List.map convertToGenericMathExpr args)

        Expr exprs ->
            Generic.MathMacro.Expr (List.map convertToGenericMathExpr exprs)

        Text str ->
            -- Generic.MathMacro doesn't have Text, so convert to MathSymbols
            Generic.MathMacro.MathSymbols str

        GreekSymbol str ->
            -- Convert GreekSymbol to AlphaNum with backslash
            Generic.MathMacro.AlphaNum ("\\" ++ str)



-- Convert local Deco to Generic.MathMacro.Deco


convertToGenericDeco : Deco -> Generic.MathMacro.Deco
convertToGenericDeco deco =
    case deco of
        DecoM expr ->
            Generic.MathMacro.DecoM (convertToGenericMathExpr expr)

        DecoI n ->
            Generic.MathMacro.DecoI n



-- Convert local MathExpr to ETeX.MathMacros.MathExpr


convertToETeXMathExpr : MathExpr -> ETeX.MathMacros.MathExpr
convertToETeXMathExpr expr =
    case expr of
        AlphaNum str ->
            ETeX.MathMacros.AlphaNum str

        F0 str ->
            ETeX.MathMacros.MacroName str

        Param n ->
            ETeX.MathMacros.Param n

        WS ->
            ETeX.MathMacros.WS

        MathSpace ->
            ETeX.MathMacros.MathSpace

        MathSmallSpace ->
            ETeX.MathMacros.MathSmallSpace

        MathMediumSpace ->
            ETeX.MathMacros.MathMediumSpace

        LeftMathBrace ->
            ETeX.MathMacros.LeftMathBrace

        RightMathBrace ->
            ETeX.MathMacros.RightMathBrace

        MathSymbols str ->
            ETeX.MathMacros.MathSymbols str

        Arg exprs ->
            ETeX.MathMacros.Arg (List.map convertToETeXMathExpr exprs)

        PArg exprs ->
            -- Convert to Arg since ETeX.MathMacros doesn't have PArg
            ETeX.MathMacros.Arg (List.map convertToETeXMathExpr exprs)

        ParenthExpr exprs ->
            -- Convert to Expr since ETeX.MathMacros doesn't have ParenthExpr
            ETeX.MathMacros.Expr (List.map convertToETeXMathExpr exprs)

        Sub decoExpr ->
            ETeX.MathMacros.Sub (convertToETeXDeco decoExpr)

        Super decoExpr ->
            ETeX.MathMacros.Super (convertToETeXDeco decoExpr)

        Macro name args ->
            ETeX.MathMacros.Macro name (List.map convertToETeXMathExpr args)

        FCall name args ->
            ETeX.MathMacros.Macro name (List.map convertToETeXMathExpr args)

        Expr exprs ->
            ETeX.MathMacros.Expr (List.map convertToETeXMathExpr exprs)

        LeftParen ->
            ETeX.MathMacros.LeftParen

        RightParen ->
            ETeX.MathMacros.RightParen

        Comma ->
            ETeX.MathMacros.Comma

        Text str ->
            ETeX.MathMacros.MathSymbols str

        GreekSymbol str ->
            ETeX.MathMacros.AlphaNum ("\\" ++ str)



-- Convert local Deco to ETeX.MathMacros.Deco


convertToETeXDeco : Deco -> ETeX.MathMacros.Deco
convertToETeXDeco deco =
    case deco of
        DecoM mathExpr ->
            ETeX.MathMacros.DecoM (convertToETeXMathExpr mathExpr)

        DecoI n ->
            ETeX.MathMacros.DecoI n



-- Convert ETeX.MathMacros.MathExpr to local MathExpr


convertFromETeXMathExpr : ETeX.MathMacros.MathExpr -> MathExpr
convertFromETeXMathExpr expr =
    case expr of
        ETeX.MathMacros.AlphaNum str ->
            AlphaNum str

        ETeX.MathMacros.MacroName str ->
            F0 str

        ETeX.MathMacros.FunctionName str ->
            F0 str

        ETeX.MathMacros.Param n ->
            Param n

        ETeX.MathMacros.WS ->
            WS

        ETeX.MathMacros.MathSpace ->
            MathSpace

        ETeX.MathMacros.MathSmallSpace ->
            MathSmallSpace

        ETeX.MathMacros.MathMediumSpace ->
            MathMediumSpace

        ETeX.MathMacros.LeftMathBrace ->
            LeftMathBrace

        ETeX.MathMacros.RightMathBrace ->
            RightMathBrace

        ETeX.MathMacros.MathSymbols str ->
            MathSymbols str

        ETeX.MathMacros.Arg exprs ->
            Arg (List.map convertFromETeXMathExpr exprs)

        ETeX.MathMacros.Sub decoExpr ->
            Sub (convertFromETeXDeco decoExpr)

        ETeX.MathMacros.Super decoExpr ->
            Super (convertFromETeXDeco decoExpr)

        ETeX.MathMacros.Macro name args ->
            Macro name (List.map convertFromETeXMathExpr args)

        ETeX.MathMacros.Expr exprs ->
            Expr (List.map convertFromETeXMathExpr exprs)

        ETeX.MathMacros.LeftParen ->
            LeftParen

        ETeX.MathMacros.RightParen ->
            RightParen

        ETeX.MathMacros.Comma ->
            Comma



-- Convert ETeX.MathMacros.Deco to local Deco


convertFromETeXDeco : ETeX.MathMacros.Deco -> Deco
convertFromETeXDeco deco =
    case deco of
        ETeX.MathMacros.DecoM mathExpr ->
            DecoM (convertFromETeXMathExpr mathExpr)

        ETeX.MathMacros.DecoI n ->
            DecoI n



-- Convert a dictionary of local MacroBody to MathMacroDict
-- Helper to find the maximum parameter number in a macro body
-- Helper to find max param in ETeX.MathMacros.MathExpr type


findMaxParamInMathMacros : List ETeX.MathMacros.MathExpr -> Int
findMaxParamInMathMacros exprs =
    case exprs of
        [] ->
            0

        (ETeX.MathMacros.Param n) :: rest ->
            max n (findMaxParamInMathMacros rest)

        (ETeX.MathMacros.Arg innerExprs) :: rest ->
            max (findMaxParamInMathMacros innerExprs) (findMaxParamInMathMacros rest)

        (ETeX.MathMacros.Macro _ args) :: rest ->
            max (findMaxParamInMathMacros args) (findMaxParamInMathMacros rest)

        (ETeX.MathMacros.Expr innerExprs) :: rest ->
            max (findMaxParamInMathMacros innerExprs) (findMaxParamInMathMacros rest)

        (ETeX.MathMacros.Sub (ETeX.MathMacros.DecoM expr)) :: rest ->
            max (findMaxParamInMathMacros [ expr ]) (findMaxParamInMathMacros rest)

        (ETeX.MathMacros.Super (ETeX.MathMacros.DecoM expr)) :: rest ->
            max (findMaxParamInMathMacros [ expr ]) (findMaxParamInMathMacros rest)

        _ :: rest ->
            findMaxParamInMathMacros rest


findMaxParam : List MathExpr -> Int
findMaxParam exprs =
    case exprs of
        [] ->
            0

        (Param n) :: rest ->
            max n (findMaxParam rest)

        (Arg innerExprs) :: rest ->
            max (findMaxParam innerExprs) (findMaxParam rest)

        (PArg innerExprs) :: rest ->
            max (findMaxParam innerExprs) (findMaxParam rest)

        (ParenthExpr innerExprs) :: rest ->
            max (findMaxParam innerExprs) (findMaxParam rest)

        (Macro _ args) :: rest ->
            max (findMaxParam args) (findMaxParam rest)

        (FCall _ args) :: rest ->
            max (findMaxParam args) (findMaxParam rest)

        (Expr innerExprs) :: rest ->
            max (findMaxParam innerExprs) (findMaxParam rest)

        (Sub (DecoM expr)) :: rest ->
            max (findMaxParam [ expr ]) (findMaxParam rest)

        (Super (DecoM expr)) :: rest ->
            max (findMaxParam [ expr ]) (findMaxParam rest)

        _ :: rest ->
            findMaxParam rest


makeEntry : Result error ETeX.MathMacros.NewCommand -> Maybe ( String, MacroBody )
makeEntry newCommand_ =
    case newCommand_ of
        Ok (ETeX.MathMacros.NewCommand (ETeX.MathMacros.MacroName name) arity [ ETeX.MathMacros.Arg body ]) ->
            -- Use the arity from the NewCommand or deduce from parameters
            let
                deducedArity =
                    if arity > 0 then
                        arity

                    else
                        findMaxParamInMathMacros body
            in
            Just ( name, ETeX.MathMacros.MacroBody deducedArity body )

        _ ->
            Nothing


type Context
    = CArg String


type Problem
    = ExpectingLeftBrace
    | ExpectingAlpha
    | ExpectingNotAlpha
    | ExpectingInt
    | InvalidNumber
    | ExpectingMathSmallSpace
    | ExpectingMathMediumSpace
    | ExpectingLeftBracket
    | ExpectingMathSpace
    | ExpectingRightBracket
    | ExpectingLeftMathBrace
    | ExpectingRightMathBrace
    | ExpectingLeftParen
    | ExpectingRightParen
    | ExpectingUnderscore
    | ExpectingCaret
    | ExpectingSpace
    | ExpectingRightBrace
    | ExpectingHash
    | ExpectingBackslash
    | ExpectingNewCommand
    | ExpectingComma
    | ExpectingQuote
    | ExpectingGreekLetter


type alias MathExprParser a =
    PA.Parser Context Problem a



-- PARSER


parseWithDict : MathMacroDict -> String -> Result (List (DeadEnd Context Problem)) (List MathExpr)
parseWithDict userMacroDict str =
    PA.run (many (mathExprParser userMacroDict)) str


macroParser : MathMacroDict -> PA.Parser Context Problem MathExpr
macroParser userMacroDict =
    succeed Macro
        |. symbol (Token "\\" ExpectingBackslash)
        |= alphaNumParser_
        |= many (argParser userMacroDict)



-- Parser that parses comma-separated function arguments


functionArgsParser : MathMacroDict -> PA.Parser Context Problem (List MathExpr)
functionArgsParser userMacroDict =
    succeed identity
        |. symbol (Token "(" ExpectingLeftParen)
        |= lazy (\_ -> functionArgListParser userMacroDict)
        |. symbol (Token ")" ExpectingRightParen)



-- Helper to parse comma-separated arguments


functionArgListParser : MathMacroDict -> PA.Parser Context Problem (List MathExpr)
functionArgListParser userMacroDict =
    let
        -- Parse content that can appear in an argument (excluding commas)
        argContentParser =
            oneOf
                [ textParser -- Parse quoted text
                , mathMediumSpaceParser
                , mathSmallSpaceParser
                , mathSpaceParser
                , leftBraceParser
                , rightBraceParser
                , macroParser userMacroDict
                , alphaNumOrMacroParser userMacroDict -- Check if alphaNum is a macro
                , mathSymbolsParser
                , lazy (\_ -> argParser userMacroDict)
                , lazy (\_ -> standaloneParenthExprParser userMacroDict)
                , paramParser
                , whitespaceParser
                , f0Parser
                , subscriptParser userMacroDict
                , superscriptParser userMacroDict
                ]
    in
    sepByComma (PA.map PArg (many1 argContentParser))



-- Parse alpha numeric without lookahead (to avoid recursion)


alphaNumWithoutLookaheadParser : PA.Parser c Problem MathExpr
alphaNumWithoutLookaheadParser =
    alphaNumParser_ |> PA.map AlphaNum



-- Parse alpha numeric and check if it's a macro (no lookahead for parentheses)


alphaNumOrMacroParser : MathMacroDict -> PA.Parser Context Problem MathExpr
alphaNumOrMacroParser userMacroDict =
    alphaNumParser_
        |> PA.map
            (\name ->
                if isKaTeX name || isUserDefinedMacro userMacroDict name then
                    Macro name []

                else
                    AlphaNum name
            )



-- Helper for parsing one or more items


many1 : PA.Parser Context Problem a -> PA.Parser Context Problem (List a)
many1 p =
    succeed (::)
        |= p
        |= many p



-- Parse items separated by commas, returning the items and commas


sepByComma : PA.Parser Context Problem MathExpr -> PA.Parser Context Problem (List MathExpr)
sepByComma itemParser =
    oneOf
        [ -- Parse at least one item
          itemParser
            |> PA.andThen
                (\firstItem ->
                    loop [ firstItem ] (sepByCommaHelp itemParser)
                )
        , -- Empty case
          succeed []
        ]



-- Helper for parsing more comma-separated items


sepByCommaHelp : PA.Parser Context Problem MathExpr -> List MathExpr -> PA.Parser Context Problem (Step (List MathExpr) (List MathExpr))
sepByCommaHelp itemParser revItems =
    oneOf
        [ -- Try to parse comma and another item
          succeed (\item -> Loop (item :: Comma :: revItems))
            |. symbol (Token "," ExpectingComma)
            |= itemParser
        , -- No more items
          succeed (Done (List.reverse revItems))
        ]



-- Parser for quoted text


textParser : PA.Parser Context Problem MathExpr
textParser =
    succeed Text
        |. symbol (Token "\"" ExpectingQuote)
        |= getChompedString (chompWhile (\c -> c /= '"'))
        |. symbol (Token "\"" ExpectingQuote)



--greekLetterParser : PA.Parser Context Problem MathExpr
--greekLetterParser =
--    succeed AlphaNum
--        |. symbol (Token "\\" ExpectingBackslash)
--        |= greekLetterNameParser
--
-- Parser that looks for function calls with lookahead


alphaNumWithLookaheadParser : MathMacroDict -> PA.Parser Context Problem MathExpr
alphaNumWithLookaheadParser userMacroDict =
    succeed identity
        |= alphaNumParser_
        |> PA.andThen
            (\name ->
                oneOf
                    [ -- Check if followed by '(' and parse comma-separated arguments
                      functionArgsParser userMacroDict
                        |> PA.map
                            (\args ->
                                if isKaTeX name || isUserDefinedMacro userMacroDict name then
                                    Macro name args

                                else
                                    FCall name args
                            )
                    , -- Otherwise, check if it's a macro or just alphanumeric
                      succeed
                        (if isKaTeX name || isUserDefinedMacro userMacroDict name then
                            Macro name []

                         else
                            AlphaNum name
                        )
                    ]
            )


mathExprParser : MathMacroDict -> PA.Parser Context Problem MathExpr
mathExprParser userMacroDict =
    oneOf
        [ textParser -- Parse quoted text first
        , backtrackable greekSymbolParser -- For Greek letters without lookahead
        , mathMediumSpaceParser
        , mathSmallSpaceParser
        , mathSpaceParser
        , leftBraceParser
        , rightBraceParser
        , alphaNumWithLookaheadParser userMacroDict -- This handles both function calls and plain alphanums
        , macroParser userMacroDict
        , lazy (\_ -> standaloneParenthExprParser userMacroDict) -- For standalone parentheses
        , commaParser
        , mathSymbolsParser
        , lazy (\_ -> argParser userMacroDict)
        , paramParser
        , whitespaceParser
        , f0Parser
        , subscriptParser userMacroDict
        , superscriptParser userMacroDict
        ]


greekSymbolParser : PA.Parser Context Problem MathExpr
greekSymbolParser =
    succeed identity
        |= alphaNumParser_
        |> PA.andThen
            (\str ->
                if List.member str ETeX.KaTeX.greekLetters then
                    succeed (AlphaNum ("\\" ++ str))

                else
                    PA.problem ExpectingGreekLetter
            )


mathSymbolsParser =
    (succeed String.slice
        |= getOffset
        |. chompIf (\c -> not (Char.isAlpha c) && not (List.member c [ '_', '^', '#', '\\', '{', '}', '(', ')', ',', '"' ])) ExpectingNotAlpha
        |. chompWhile (\c -> not (Char.isAlpha c) && not (List.member c [ '_', '^', '#', '\\', '{', '}', '(', ')', ',', '"' ]))
        |= getOffset
        |= getSource
    )
        |> PA.map MathSymbols


optionalParamParser =
    succeed identity
        |. symbol (Token "[" ExpectingLeftBracket)
        |= PA.int ExpectingInt InvalidNumber
        |. symbol (Token "]" ExpectingRightBracket)


parseNewCommand : MathMacroDict -> String -> Result (List (DeadEnd Context Problem)) NewCommand
parseNewCommand userMacroDict str =
    run (newCommandParser userMacroDict) str


newCommandParser : MathMacroDict -> PA.Parser Context Problem NewCommand
newCommandParser userMacroDict =
    oneOf [ backtrackable (newCommandParser1 userMacroDict), newCommandParser2 userMacroDict ]


mathSpaceParser : PA.Parser c Problem MathExpr
mathSpaceParser =
    succeed MathSpace
        |. symbol (Token "\\ " ExpectingMathSpace)


mathSmallSpaceParser : PA.Parser c Problem MathExpr
mathSmallSpaceParser =
    succeed MathSmallSpace
        |. symbol (Token "\\," ExpectingMathSmallSpace)


mathMediumSpaceParser : PA.Parser c Problem MathExpr
mathMediumSpaceParser =
    succeed MathMediumSpace
        |. symbol (Token "\\;" ExpectingMathMediumSpace)


leftBraceParser : PA.Parser c Problem MathExpr
leftBraceParser =
    succeed LeftMathBrace
        |. symbol (Token "\\{" ExpectingLeftMathBrace)


rightBraceParser : PA.Parser c Problem MathExpr
rightBraceParser =
    succeed RightMathBrace
        |. symbol (Token "\\}" ExpectingRightMathBrace)



-- Removed unused parsers: leftParenParser and rightParenParser


commaParser : PA.Parser c Problem MathExpr
commaParser =
    succeed Comma
        |. symbol (Token "," ExpectingComma)


newCommandParser1 : MathMacroDict -> PA.Parser Context Problem NewCommand
newCommandParser1 userMacroDict =
    succeed (\name arity body -> NewCommand (convertToETeXMathExpr name) arity (List.map convertToETeXMathExpr body))
        |. symbol (Token "\\newcommand" ExpectingNewCommand)
        |. symbol (Token "{" ExpectingLeftBrace)
        |= f0Parser
        |. symbol (Token "}" ExpectingRightBrace)
        |= optionalParamParser
        |= many (mathExprParser userMacroDict)


newCommandParser2 : MathMacroDict -> PA.Parser Context Problem NewCommand
newCommandParser2 userMacroDict =
    succeed (\name body -> NewCommand (convertToETeXMathExpr name) 0 (List.map convertToETeXMathExpr body))
        |. symbol (Token "\\newcommand" ExpectingNewCommand)
        |. symbol (Token "{" ExpectingLeftBrace)
        |= f0Parser
        |. symbol (Token "}" ExpectingRightBrace)
        |= many (mathExprParser userMacroDict)


argParser : MathMacroDict -> PA.Parser Context Problem MathExpr
argParser userMacroDict =
    (succeed identity
        |. symbol (Token "{" ExpectingLeftBrace)
        |= lazy (\_ -> many (mathExprParser userMacroDict))
    )
        |. symbol (Token "}" ExpectingRightBrace)
        |> PA.map Arg



-- Removed unused parsers: parentheticalExprParser and parentheticalExprParserM


standaloneParenthExprParser : MathMacroDict -> PA.Parser Context Problem MathExpr
standaloneParenthExprParser userMacroDict =
    (succeed identity
        |. symbol (Token "(" ExpectingLeftParen)
        |= lazy (\_ -> many (mathExprParser userMacroDict))
    )
        |. symbol (Token ")" ExpectingRightParen)
        |> PA.map ParenthExpr


whitespaceParser =
    symbol (Token " " ExpectingSpace) |> PA.map (\_ -> WS)



-- Removed unused parser: alphaNumParser


alphaNumParser_ : PA.Parser c Problem String
alphaNumParser_ =
    succeed String.slice
        |= getOffset
        |. chompIf Char.isAlpha ExpectingAlpha
        |. chompWhile Char.isAlphaNum
        |= getOffset
        |= getSource


f0Parser : PA.Parser Context Problem MathExpr
f0Parser =
    second (symbol (Token "\\" ExpectingBackslash)) alphaNumParser_
        |> PA.map F0


paramParser =
    (succeed identity
        |. symbol (Token "#" ExpectingHash)
        |= PA.int ExpectingInt InvalidNumber
    )
        |> PA.map Param


subscriptParser : MathMacroDict -> PA.Parser Context Problem MathExpr
subscriptParser userMacroDict =
    (succeed identity
        |. symbol (Token "_" ExpectingUnderscore)
        |= decoParser userMacroDict
    )
        |> PA.map Sub


superscriptParser : MathMacroDict -> PA.Parser Context Problem MathExpr
superscriptParser userMacroDict =
    (succeed identity
        |. symbol (Token "^" ExpectingCaret)
        |= decoParser userMacroDict
    )
        |> PA.map Super


decoParser : MathMacroDict -> PA.Parser Context Problem Deco
decoParser userMacroDict =
    oneOf [ numericDecoParser, lazy (\_ -> mathExprParser userMacroDict) |> PA.map DecoM ]


numericDecoParser =
    PA.int ExpectingInt InvalidNumber |> PA.map DecoI



-- PRINT


printNewCommand (NewCommand mathExpr arity body) =
    let
        localMathExpr =
            convertFromETeXMathExpr mathExpr

        localBody =
            List.map convertFromETeXMathExpr body
    in
    if arity == 0 then
        "\\newcommand" ++ encloseB (print localMathExpr) ++ printList localBody

    else
        "\\newcommand" ++ encloseB (print localMathExpr) ++ "[" ++ String.fromInt arity ++ "]" ++ printList localBody


printList : List MathExpr -> String
printList exprs =
    List.map print exprs |> String.join ""


print : MathExpr -> String
print expr =
    case expr of
        AlphaNum str ->
            str

        LeftMathBrace ->
            "\\{"

        RightMathBrace ->
            "\\}"

        LeftParen ->
            "("

        RightParen ->
            ")"

        MathSmallSpace ->
            "\\,"

        MathMediumSpace ->
            "\\;"

        MathSpace ->
            "\\ "

        F0 str ->
            "\\" ++ str

        Param k ->
            "#" ++ String.fromInt k

        Arg exprs ->
            encloseB (printList exprs)

        PArg exprs ->
            encloseP (printList exprs)

        Sub deco ->
            -- "_" ++ enclose (printDeco deco)
            "_" ++ printDeco deco

        Super deco ->
            -- "^" ++ enclose (printDeco deco)
            "^" ++ printDeco deco

        MathSymbols str ->
            str

        WS ->
            " "

        Macro name body ->
            case body of
                [ PArg exprs ] ->
                    -- Single argument in parentheses: convert to braces
                    "\\" ++ name ++ encloseB (printList exprs)

                [ ParenthExpr exprs ] ->
                    -- Convert parentheses to braces for macro
                    "\\" ++ name ++ encloseB (printList exprs)

                _ ->
                    -- Multiple arguments or complex case
                    case body of
                        (PArg _) :: _ ->
                            -- Comma-separated arguments: each gets its own braces
                            "\\" ++ name ++ printMacroArgs body

                        _ ->
                            "\\" ++ name ++ printList body

        FCall name args ->
            -- Function calls always use parentheses
            name ++ "(" ++ printArgList args ++ ")"

        Expr exprs ->
            List.map print exprs |> String.join ""

        Comma ->
            ","

        ParenthExpr exprs ->
            encloseP (printList exprs)

        Text str ->
            "\\text{" ++ str ++ "}"

        GreekSymbol str ->
            "\\" ++ str


printDeco : Deco -> String
printDeco deco =
    case deco of
        DecoM expr ->
            print expr

        DecoI k ->
            String.fromInt k



-- HELPERS


second : MathExprParser a -> MathExprParser b -> MathExprParser b
second p q =
    p |> PA.andThen (\_ -> q)


{-| Apply a parser zero or more times and return a list of the results.
-}
many : MathExprParser a -> MathExprParser (List a)
many p =
    loop [] (manyHelp p)


manyHelp : MathExprParser a -> List a -> MathExprParser (Step (List a) (List a))
manyHelp p vs =
    oneOf
        [ succeed (\v -> Loop (v :: vs))
            |= p

        -- |. PA.spaces
        , succeed ()
            |> map (\_ -> Done (List.reverse vs))
        ]


encloseB : String -> String
encloseB str =
    "{" ++ str ++ "}"


encloseP : String -> String
encloseP str =
    "(" ++ str ++ ")"



-- Print a list of arguments (handling comma separation)


printArgList : List MathExpr -> String
printArgList exprs =
    case exprs of
        [] ->
            ""

        [ PArg contents ] ->
            printList contents

        (PArg contents) :: Comma :: rest ->
            printList contents ++ "," ++ printArgList rest

        (PArg contents) :: rest ->
            printList contents ++ printArgList rest

        other :: rest ->
            print other ++ printArgList rest



-- Print macro arguments where each comma-separated arg gets its own braces


printMacroArgs : List MathExpr -> String
printMacroArgs exprs =
    case exprs of
        [] ->
            ""

        [ PArg contents ] ->
            encloseB (printList contents)

        (PArg contents) :: Comma :: rest ->
            encloseB (printList contents) ++ printMacroArgs rest

        (PArg contents) :: rest ->
            encloseB (printList contents) ++ printMacroArgs rest

        other :: rest ->
            print other ++ printMacroArgs rest
