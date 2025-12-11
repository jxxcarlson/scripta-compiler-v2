module ETeX.MathMacros exposing
    ( Context(..)
    , Deco(..)
    , MacroBody(..)
    , MathExpr(..)
    , MathMacroDict
    , NewCommand(..)
    , Problem(..)
    , parse
    , parseNewCommand
    )

import Dict exposing (Dict)
import ETeX.Dictionary
import List.Extra
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


{-|

    ASSUMPTION: The list of expressions begins with a macro application, e.g.: the input "\\sett{x}{y} (x > 0)" yields

    (*) parser output = k [Macro "sett" [LeftMathBrace,MathSpace,Param 1,MathSymbols (" "),MathSpace,MathSymbols ("| "),MathSpace,Param 2,MathSpace,RightMathBrace]
    ,LeftParen,AlphaNum "x",MathSymbols (" "),Macro "in" [],MathSymbols (" "),AlphaNum "R",RightParen,LeftParen,AlphaNum "x",MathSymbols (" > 0"),RightParen]

    where `parser output` is splits as (head::rest):

    (1) head = (Just (Macro "sett" [LeftMathBrace,MathSpace,Param 1,MathSymbols (" "),MathSpace,MathSymbols ("| "),MathSpace,Param 2,MathSpace,RightMathBrace]))
    (2) rest = [LeftParen,AlphaNum "x",MathSymbols (" "),Macro "in" [],MathSymbols (" "),AlphaNum "R",RightParen,LeftParen,AlphaNum "x",MathSymbols (" > 0"),RightParen]

-}
parseA : String -> Result (List (DeadEnd Context Problem)) (List MathExpr)
parseA str =
    str
        |> parse
        |> Result.map resolveMacroDefinitions



-- TYPES


type MathExpr
    = AlphaNum String
    | MacroName String
    | FunctionName String
    | Arg (List MathExpr)
    | Sub Deco
    | Super Deco
    | Param Int
    | WS
    | MathSpace
    | MathSmallSpace
    | MathMediumSpace
    | LeftMathBrace
    | RightMathBrace
    | MathSymbols String
    | Macro String (List MathExpr)
    | Expr (List MathExpr)
    | Comma
    | LeftParen
    | RightParen


type Deco
    = DecoM MathExpr
    | DecoI Int


type NewCommand
    = NewCommand MathExpr Int (List MathExpr)


type MacroBody
    = MacroBody Int (List MathExpr)


lines =
    [ "\\newcommand{\\nat}{\\mathbb{N}}"
    , "\\newcommand{\\reals}{\\mathbb{R}}"
    , "\\newcommand{\\space}{\\reals^{#1}}"
    , "\\newcommand{\\set}{\\{ #1 \\}}"
    , "\\newcommand{\\sett}{\\{\\ #1 \\ | \\ #2\\ \\}}"
    ]


macroDict : MathMacroDict
macroDict =
    makeMacroDictFromLines lines


defs =
    """
| mathmacros
pdd:    frac(partial^2 #1, partial #2^2)
nat:    mathbb N
reals:  mathbb R
pd:     frac(partial #1, partial #2)
set:    \\{ #1 \\}
sett:   \\{ #1 \\ | \\ #2 \\}
"""


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



-- evalMacro1 :


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


makeMacroDict : String -> MathMacroDict
makeMacroDict str =
    str
        |> String.trim
        |> String.lines
        |> List.map (parseNewCommand >> makeEntry)
        |> Maybe.Extra.values
        |> Dict.fromList


makeMacroDictFromLines : List String -> MathMacroDict
makeMacroDictFromLines lines_ =
    lines_
        |> List.map (parseNewCommand >> makeEntry)
        |> Maybe.Extra.values
        |> Dict.fromList


makeEntry : Result error NewCommand -> Maybe ( String, MacroBody )
makeEntry newCommand_ =
    case newCommand_ of
        Ok (NewCommand (MacroName name) arity [ Arg body ]) ->
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
    | ExpectingUnderscore
    | ExpectingCaret
    | ExpectingSpace
    | ExpectingRightBrace
    | ExpectingHash
    | ExpectingBackslash
    | ExpectingNewCommand
    | ExpectingLeftParen
    | ExpectingRightParen
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


mathExprParser =
    oneOf
        [ mathMediumSpaceParser
        , mathSmallSpaceParser
        , mathSpaceParser
        , leftBraceParser
        , rightBraceParser
        , leftParenParser
        , rightParenParser
        , commaParser
        , macroParser
        , mathSymbolsParser
        , lazy (\_ -> argParser)
        , lazy (\_ -> parenthesizedGroupParser)
        , paramParser
        , whitespaceParser
        , alphaNumParser
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


parenthesizedGroupParser : PA.Parser Context Problem MathExpr
parenthesizedGroupParser =
    (succeed identity
        |. symbol (Token "(" ExpectingLeftParen)
        |= lazy (\_ -> many mathExprParser)
    )
        |. symbol (Token ")" ExpectingRightParen)
        |> PA.map Arg


whitespaceParser =
    symbol (Token " " ExpectingSpace) |> PA.map (\_ -> WS)


alphaNumParser : PA.Parser c Problem MathExpr
alphaNumParser =
    alphaNumParser_ |> PA.map AlphaNum


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
        |> PA.map MacroName


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

        MathSmallSpace ->
            "\\,"

        MathMediumSpace ->
            "\\;"

        MathSpace ->
            "\\ "

        MacroName str ->
            "\\" ++ str

        FunctionName str ->
            str

        Param k ->
            "#" ++ String.fromInt k

        Arg exprs ->
            enclose (printList exprs)

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
            "\\" ++ name ++ printList body

        Expr exprs ->
            List.map print exprs |> String.join ""

        Comma ->
            ","

        LeftParen ->
            "("

        RightParen ->
            ")"


printDeco : Deco -> String
printDeco deco =
    case deco of
        DecoM expr ->
            print expr

        DecoI k ->
            String.fromInt k



-- HELPERS II
--getArgList: List MathExpr -> List (List MathExpr)


getArgList : List MathExpr -> List (List MathExpr)
getArgList exprs =
    let
        test : MathExpr -> MathExpr -> Bool
        test a b =
            case ( a, b ) of
                ( RightParen, LeftParen ) ->
                    False

                _ ->
                    True
    in
    List.Extra.groupWhile test exprs
        |> List.map Tuple.second
        |> List.map (\list -> List.take (List.length list - 1) list)



-- HELPERS


second : MathExprParser a -> MathExprParser b -> MathExprParser b
second p q =
    p
        |> PA.andThen (\_ -> q)


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



-- SYMBOL NAMES


resolveMacroDefinitions : List MathExpr -> List MathExpr
resolveMacroDefinitions exprs =
    List.map resolveMacroDefinition exprs


resolveMacroDefinition : MathExpr -> MathExpr
resolveMacroDefinition expr =
    case expr of
        AlphaNum name ->
            case Dict.get name macroDict of
                Just (MacroBody x body) ->
                    Macro name body

                Nothing ->
                    expr

        Arg exprs ->
            Arg (List.map resolveMacroDefinition exprs)

        Sub decoExpr ->
            case decoExpr of
                DecoM decoMExpr ->
                    Sub (DecoM (resolveMacroDefinition decoMExpr))

                DecoI m ->
                    Sub (DecoI m)

        Super decoExpr ->
            case decoExpr of
                DecoM decoMExpr ->
                    Super (DecoM (resolveMacroDefinition decoMExpr))

                DecoI m ->
                    Super (DecoI m)

        _ ->
            expr


resolveSymbolNames : List MathExpr -> List MathExpr
resolveSymbolNames exprs =
    List.map resolveSymbolName exprs


resolveSymbolName : MathExpr -> MathExpr
resolveSymbolName expr =
    case expr of
        AlphaNum str ->
            case Dict.get str ETeX.Dictionary.symbolDict of
                Just _ ->
                    AlphaNum ("\\" ++ str)

                Nothing ->
                    AlphaNum str

        _ ->
            expr



-- MAKE FUNCTION NAMES --


makeFunctionNames : List MathExpr -> List MathExpr
makeFunctionNames words =
    let
        b =
            List.drop 1 words

        a =
            List.take (List.length words - 1) words

        pairs =
            List.map2 (\x y -> ( x, y )) a b

        transformPair : ( MathExpr, MathExpr ) -> MathExpr
        transformPair ( w1, w2 ) =
            case ( w1, w2 ) of
                ( AlphaNum str, LeftParen ) ->
                    case Dict.get str ETeX.Dictionary.functionDict of
                        Just _ ->
                            MacroName str

                        Nothing ->
                            FunctionName str

                _ ->
                    w1
    in
    case List.Extra.last words of
        Nothing ->
            []

        Just lastToken ->
            List.map transformPair pairs ++ [ lastToken ]
