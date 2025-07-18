module ETeX.Transform exposing
    ( MathExpr(..)
    , MathMacroDict
    , evalStr
    , isUserDefinedMacro
    , macroDefString
    , makeMacroDict
    , parse
    , parseETeX
    , printList
    , resolveSymbolName
    , resolveSymbolNames
    , testMacroDict
    , transformETeX
    )

import Dict exposing (Dict)
import ETeX.Dictionary
import ETeX.KaTeX exposing (isKaTeX)
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


macroDefString =
    """
\\newcommand{\\nat}{\\mathbb{N}}
\\newcommand{\\reals}{\\mathbb{R}}
\\newcommand{\\space}{\\reals^{#1}}
\\newcommand{\\set}{\\{ #1 \\}}
\\newcommand{\\sett}{\\{\\ #1 \\ | \\ #2\\ \\}}
"""


testMacroDict : Dict String MacroBody
testMacroDict =
    makeMacroDict macroDefString


parseETeX : MathMacroDict -> String -> Result (List (DeadEnd Context Problem)) String
parseETeX userMacroDict src =
    src
        |> parse userMacroDict
        |> Debug.log "EXPRS"
        |> Result.map resolveSymbolNames
        |> Debug.log "Symbols resolved"
        |> Result.map printList


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
        |> Debug.log "PARSED"
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

        _ ->
            expr



-- TYPES


type NewCommand
    = NewCommand MathExpr Int (List MathExpr)


type MacroBody
    = MacroBody Int (List MathExpr)


evalStr : MathMacroDict -> String -> String
evalStr userDefinedMacroDict str =
    let
        _ =
            Debug.log "parseManyWithDict" (parseManyWithDict userDefinedMacroDict (String.trim str))
    in
    case parseManyWithDict userDefinedMacroDict (String.trim str) of
        Ok result ->
            List.map (expandMacroWithDict userDefinedMacroDict) result |> printList

        Err _ ->
            -- the intent of evalStr is to expand macros.  So if something
            -- goes wrong with the process, just return the input string.
            -- TODO: This solves the problem of false error reporting, but I don't like the solution.
            str



-- Convert local MathMacroDict to MathMacroDict
--convertToGenericDict : MathMacroDict -> MathMacroDict
--convertToGenericDict dict =
--    -- For now, just return empty dict as we're focusing on threading the parameter
--    -- This should be properly implemented based on the actual conversion logic
--    Dict.empty


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
    | Macro String (List MathExpr)
    | FCall String (List MathExpr)
    | Expr (List MathExpr)


type Deco
    = DecoM MathExpr
    | DecoI Int


expandMacroWithDict : MathMacroDict -> MathExpr -> MathExpr
expandMacroWithDict dict expr =
    case expr of
        Macro macroName args ->
            case Dict.get macroName dict of
                Nothing ->
                    Macro macroName (List.map (expandMacroWithDict dict) args)

                Just (MacroBody k exprs) ->
                    Expr (expandMacro_ (List.map (expandMacroWithDict dict) args) (MacroBody k (List.map (expandMacroWithDict dict) exprs)))

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

        _ ->
            expr


{-|

    > args = [Exprs [AlphaNum "x"],Exprs [AlphaNum "y"]]
    > macroDefBody = (MacroBody 2 [Macro "alpha" [],MathSymbols "(",Param 1,MathSymbols ",",Param 2,MathSymbols ")"])
    > expandMacro_  args macroDefBody
    [Macro "alpha" [],MathSymbols "(",Exprs [AlphaNum "x"],MathSymbols ",",Exprs [AlphaNum "y"],MathSymbols ")"]

-}
expandMacro_ : List MathExpr -> MacroBody -> List MathExpr
expandMacro_ args (MacroBody arity macroDefBody) =
    replaceParams args macroDefBody


type alias MathMacroDict =
    Dict String MacroBody


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

        _ ->
            target


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
        |> List.map (parseNewCommand Dict.empty >> makeEntry)
        |> Maybe.Extra.values
        |> Dict.fromList


makeMacroDictFromLines : List String -> Dict String MacroBody
makeMacroDictFromLines lines =
    lines
        |> List.map (parseNewCommand Dict.empty >> makeEntry)
        |> Maybe.Extra.values
        |> Dict.fromList



-- Convert local MacroBody to Generic.MathMacro.MacroBody


convertToGenericMacroBody : MacroBody -> Generic.MathMacro.MacroBody
convertToGenericMacroBody (MacroBody arity exprs) =
    Generic.MathMacro.MacroBody arity (List.map convertToGenericMathExpr exprs)



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



-- Convert local Deco to Generic.MathMacro.Deco


convertToGenericDeco : Deco -> Generic.MathMacro.Deco
convertToGenericDeco deco =
    case deco of
        DecoM expr ->
            Generic.MathMacro.DecoM (convertToGenericMathExpr expr)

        DecoI n ->
            Generic.MathMacro.DecoI n



-- Convert a dictionary of local MacroBody to MathMacroDict


makeEntry : Result error NewCommand -> Maybe ( String, MacroBody )
makeEntry newCommand_ =
    case newCommand_ of
        Ok (NewCommand (F0 name) arity [ Arg body ]) ->
            Just ( name, MacroBody arity body )

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


type alias MathExprParser a =
    PA.Parser Context Problem a



-- PARSER


parse : MathMacroDict -> String -> Result (List (DeadEnd Context Problem)) (List MathExpr)
parse userMacroDict str =
    parseWithDict userMacroDict str


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
                [ mathMediumSpaceParser
                , mathSmallSpaceParser
                , mathSpaceParser
                , leftBraceParser
                , rightBraceParser
                , macroParser userMacroDict
                , alphaNumWithoutLookaheadParser -- Use plain alphaNum to avoid recursion
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
                    , -- Otherwise, just return as AlphaNum
                      succeed (AlphaNum name)
                    ]
            )


mathExprParser : MathMacroDict -> PA.Parser Context Problem MathExpr
mathExprParser userMacroDict =
    oneOf
        [ mathMediumSpaceParser
        , mathSmallSpaceParser
        , mathSpaceParser
        , leftBraceParser
        , rightBraceParser
        , macroParser userMacroDict
        , alphaNumWithLookaheadParser userMacroDict -- This handles both function calls and plain alphanums
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


mathSymbolsParser =
    (succeed String.slice
        |= getOffset
        |. chompIf (\c -> not (Char.isAlpha c) && not (List.member c [ '_', '^', '#', '\\', '{', '}', '(', ')', ',' ])) ExpectingNotAlpha
        |. chompWhile (\c -> not (Char.isAlpha c) && not (List.member c [ '_', '^', '#', '\\', '{', '}', '(', ')', ',' ]))
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
    succeed (\name arity body -> NewCommand name arity body)
        |. symbol (Token "\\newcommand" ExpectingNewCommand)
        |. symbol (Token "{" ExpectingLeftBrace)
        |= f0Parser
        |. symbol (Token "}" ExpectingRightBrace)
        |= optionalParamParser
        |= many (mathExprParser userMacroDict)


newCommandParser2 : MathMacroDict -> PA.Parser Context Problem NewCommand
newCommandParser2 userMacroDict =
    succeed (\name body -> NewCommand name 0 body)
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
    if arity == 0 then
        "\\newcommand" ++ enclose (print mathExpr) ++ printList body

    else
        "\\newcommand" ++ enclose (print mathExpr) ++ "[" ++ String.fromInt arity ++ "]" ++ printList body


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
            enclose (printList exprs)

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
            let
                _ =
                    Debug.log "BODY" body
            in
            case body of
                [ PArg exprs ] ->
                    -- Single argument in parentheses: convert to braces
                    "\\" ++ name ++ enclose (printList exprs)

                [ ParenthExpr exprs ] ->
                    -- Convert parentheses to braces for macro
                    "\\" ++ name ++ enclose (printList exprs)

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


enclose : String -> String
enclose str =
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
            enclose (printList contents)

        (PArg contents) :: Comma :: rest ->
            enclose (printList contents) ++ printMacroArgs rest

        (PArg contents) :: rest ->
            enclose (printList contents) ++ printMacroArgs rest

        other :: rest ->
            print other ++ printMacroArgs rest
