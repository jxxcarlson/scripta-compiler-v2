module ETeX.Transform exposing
    ( MathExpr(..)
    , parse
    , parseETeX
    , printList
    , resolveSymbolName
    , resolveSymbolNames
    , transformETeX
    )

import Dict exposing (Dict)
import ETeX.Dictionary
import ETeX.KaTeX exposing (isKaTeX)
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


parseETeX src =
    src
        |> parse
        |> Debug.log "EXPRS"
        |> Result.map resolveSymbolNames
        |> Debug.log "Symbols resolved"
        |> Result.map printList


transformETeX : String -> String
transformETeX src =
    case transformETeX_ src of
        Ok result ->
            List.map print result |> String.join ""

        Err _ ->
            src



--transformETeX_ : String -> Result (List (DeadEnd Context Problem)) String
--transformETeX_ : String -> Result (List (DeadEnd Context Problem)) (List String -> String)


transformETeX_ : String -> Result (List (DeadEnd Context Problem)) (List MathExpr)
transformETeX_ src =
    src
        |> parseMany
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
evalStr dict str =
    case parseMany (String.trim str) of
        Ok result ->
            List.map (expandMacroWithDict dict) result |> printList

        Err _ ->
            -- the intent of evalStr is to expand macros.  So if something
            -- goes wrong with the process, just return the input string.
            -- TODO: This solves the problem of false error reporting, but I don't like the solution.
            str


parseMany : String -> Result (List (DeadEnd Context Problem)) (List MathExpr)
parseMany str =
    str
        |> String.trim
        |> String.lines
        |> List.map String.trim
        |> List.map parse
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



-- RESUlT: [Macro "frac" [Arg [Macro "baar" [Arg [AlphaNum "X"]]],Arg [Macro "baar" [Arg [AlphaNum "Y"]]]]]


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
        |> List.map (parseNewCommand >> makeEntry)
        |> Maybe.Extra.values
        |> Dict.fromList


makeMacroDictFromLines : List String -> Dict String MacroBody
makeMacroDictFromLines lines =
    lines
        |> List.map (parseNewCommand >> makeEntry)
        |> Maybe.Extra.values
        |> Dict.fromList


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


parse : String -> Result (List (DeadEnd Context Problem)) (List MathExpr)
parse str =
    PA.run (many mathExprParser) str


macroParser =
    succeed Macro
        |. symbol (Token "\\" ExpectingBackslash)
        |= alphaNumParser_
        |= many argParser



-- Parser that parses comma-separated function arguments
functionArgsParser : PA.Parser Context Problem (List MathExpr)
functionArgsParser =
    succeed identity
        |. symbol (Token "(" ExpectingLeftParen)
        |= lazy (\_ -> functionArgListParser)
        |. symbol (Token ")" ExpectingRightParen)


-- Helper to parse comma-separated arguments  
functionArgListParser : PA.Parser Context Problem (List MathExpr)
functionArgListParser =
    let
        -- Parse content that can appear in an argument (excluding commas)
        argContentParser =
            oneOf
                [ mathMediumSpaceParser
                , mathSmallSpaceParser
                , mathSpaceParser
                , leftBraceParser
                , rightBraceParser
                , macroParser
                , alphaNumWithoutLookaheadParser -- Use plain alphaNum to avoid recursion
                , mathSymbolsParser
                , lazy (\_ -> argParser)
                , lazy (\_ -> standaloneParenthExprParser)
                , paramParser
                , whitespaceParser
                , f0Parser
                , subscriptParser
                , superscriptParser
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
alphaNumWithLookaheadParser : PA.Parser Context Problem MathExpr
alphaNumWithLookaheadParser =
    succeed identity
        |= alphaNumParser_
        |> PA.andThen
            (\name ->
                oneOf
                    [ -- Check if followed by '(' and parse comma-separated arguments
                      functionArgsParser
                        |> PA.map
                            (\args ->
                                if isKaTeX name then
                                    Macro name args

                                else
                                    FCall name args
                            )
                    , -- Otherwise, just return as AlphaNum
                      succeed (AlphaNum name)
                    ]
            )


mathExprParser =
    oneOf
        [ mathMediumSpaceParser
        , mathSmallSpaceParser
        , mathSpaceParser
        , leftBraceParser
        , rightBraceParser
        , macroParser
        , alphaNumWithLookaheadParser -- This handles both function calls and plain alphanums
        , lazy (\_ -> standaloneParenthExprParser) -- For standalone parentheses
        , commaParser
        , mathSymbolsParser
        , lazy (\_ -> argParser)
        , paramParser
        , whitespaceParser
        , f0Parser
        , subscriptParser
        , superscriptParser
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


parseNewCommand : String -> Result (List (DeadEnd Context Problem)) NewCommand
parseNewCommand str =
    run newCommandParser str


newCommandParser =
    oneOf [ backtrackable newCommandParser1, newCommandParser2 ]


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


leftParenParser : PA.Parser c Problem MathExpr
leftParenParser =
    succeed LeftParen
        |. symbol (Token "(" ExpectingLeftParen)


rightParenParser : PA.Parser c Problem MathExpr
rightParenParser =
    succeed RightParen
        |. symbol (Token ")" ExpectingRightParen)


commaParser : PA.Parser c Problem MathExpr
commaParser =
    succeed Comma
        |. symbol (Token "," ExpectingComma)


newCommandParser1 : PA.Parser Context Problem NewCommand
newCommandParser1 =
    succeed (\name arity body -> NewCommand name arity body)
        |. symbol (Token "\\newcommand" ExpectingNewCommand)
        |. symbol (Token "{" ExpectingLeftBrace)
        |= f0Parser
        |. symbol (Token "}" ExpectingRightBrace)
        |= optionalParamParser
        |= many mathExprParser


newCommandParser2 =
    succeed (\name body -> NewCommand name 0 body)
        |. symbol (Token "\\newcommand" ExpectingNewCommand)
        |. symbol (Token "{" ExpectingLeftBrace)
        |= f0Parser
        |. symbol (Token "}" ExpectingRightBrace)
        |= many mathExprParser


argParser : PA.Parser Context Problem MathExpr
argParser =
    (succeed identity
        |. symbol (Token "{" ExpectingLeftBrace)
        |= lazy (\_ -> many mathExprParser)
    )
        |. symbol (Token "}" ExpectingRightBrace)
        |> PA.map Arg


parentheticalExprParser : PA.Parser Context Problem MathExpr
parentheticalExprParser =
    (succeed identity
        |. symbol (Token "(" ExpectingLeftParen)
        |= lazy (\_ -> many mathExprParser)
    )
        |. symbol (Token ")" ExpectingRightParen)
        |> PA.map PArg


parentheticalExprParserM : PA.Parser Context Problem MathExpr
parentheticalExprParserM =
    (succeed identity
        |. symbol (Token "(" ExpectingLeftParen)
        |= lazy (\_ -> many mathExprParser)
    )
        |. symbol (Token ")" ExpectingRightParen)
        |> PA.map Arg


standaloneParenthExprParser : PA.Parser Context Problem MathExpr
standaloneParenthExprParser =
    (succeed identity
        |. symbol (Token "(" ExpectingLeftParen)
        |= lazy (\_ -> many mathExprParser)
    )
        |. symbol (Token ")" ExpectingRightParen)
        |> PA.map ParenthExpr


whitespaceParser =
    symbol (Token " " ExpectingSpace) |> PA.map (\_ -> WS)


alphaNumParser : PA.Parser c Problem MathExpr
alphaNumParser =
    alphaNumWithoutLookaheadParser


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


subscriptParser =
    (succeed identity
        |. symbol (Token "_" ExpectingUnderscore)
        |= decoParser
    )
        |> PA.map Sub


superscriptParser =
    (succeed identity
        |. symbol (Token "^" ExpectingCaret)
        |= decoParser
    )
        |> PA.map Super


decoParser =
    oneOf [ numericDecoParser, lazy (\_ -> mathExprParser) |> PA.map DecoM ]


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
                        (PArg _ :: _) ->
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
        
        PArg contents :: Comma :: rest ->
            printList contents ++ "," ++ printArgList rest
        
        PArg contents :: rest ->
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
        
        PArg contents :: Comma :: rest ->
            enclose (printList contents) ++ printMacroArgs rest
        
        PArg contents :: rest ->
            enclose (printList contents) ++ printMacroArgs rest
        
        other :: rest ->
            print other ++ printMacroArgs rest
