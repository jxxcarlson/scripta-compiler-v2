module ETeX.WordTokenizer exposing
    ( Context(..)
    , Problem(..)
    , parse
    , parse2
    , parseMany
    , printList
    , printWord
    , transformETeX
    )

import Dict exposing (Dict)
import ETeX.Dictionary
import ETeX.Parser as P
import Generic.MathMacro
import List.Extra
import Parser.Advanced as PA
    exposing
        ( (|.)
        , (|=)
        , DeadEnd
        , Step(..)
        , Token(..)
        , chompIf
        , chompWhile
        , getOffset
        , getSource
        , loop
        , map
        , oneOf
        , run
        , spaces
        , succeed
        , symbol
        )
import Result.Extra



-- TYPES


parseMany : String -> Result (List (DeadEnd Context Problem)) (List Word)
parseMany str =
    str
        |> String.trim
        |> String.lines
        |> List.map String.trim
        |> List.map parse
        |> Result.Extra.combine
        |> Result.map List.concat


type Word
    = AlphaNum String
    | Symbol String
    | Comma
    | LeftParen
    | RightParen
    | WS
    | FunctionName String
    | MacroName String


type Context
    = CArg String


type Problem
    = ExpectingNotAlpha
    | ExpectingComma
    | InvalidNumber
    | ExpectingLeftParen
    | ExpectingRightParen
    | ExpectingAlpha
    | ExpectingSpace


type alias MathExprParser a =
    PA.Parser Context Problem a



-- PARSER


parse : String -> Result (List (DeadEnd Context Problem)) (List Word)
parse str =
    PA.run (many wordParser) str
        |> Result.map (List.filter (\w -> w /= WS))
        |> Result.map makeFunctionNames


parse2 str =
    let
        result_ =
            str
                |> PA.run (many wordParser)
                --|> List.map (Generic.MathMacro.evalStr ETeX.Dictionary.macroDict)
                |> Result.map (List.filter (\w -> w /= WS))
                |> Result.map makeFunctionNames
                |> Result.map printList
    in
    case result_ of
        Ok result ->
            P.parse result
                |> Result.map P.printList

        Err _ ->
            Ok "Error parsing expression"


transformETeX : String -> String
transformETeX str =
    case parse2 str of
        Ok result ->
            result

        Err err ->
            str


makeFunctionNames : List Word -> List Word
makeFunctionNames words =
    let
        b =
            List.drop 1 words

        a =
            List.take (List.length words - 1) words

        pairs =
            List.map2 (\x y -> ( x, y )) a b

        transformPair : ( Word, Word ) -> Word
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


wordParser =
    oneOf
        [ whitespaceParser
        , alphaNumParser
        , commaParser
        , leftParenParser
        , rightParenParser
        , symbolParser
        ]


leftParenParser : PA.Parser c Problem Word
leftParenParser =
    succeed LeftParen
        |. symbol (Token "(" ExpectingLeftParen)


rightParenParser : PA.Parser c Problem Word
rightParenParser =
    succeed RightParen
        |. symbol (Token ")" ExpectingRightParen)


whitespaceParser =
    symbol (Token " " ExpectingSpace) |> PA.map (\_ -> WS)


alphaNumParser : PA.Parser c Problem Word
alphaNumParser =
    alphaNumParser_ |> map String.trim |> PA.map AlphaNum


commaParser : PA.Parser c Problem Word
commaParser =
    succeed Comma
        |. symbol (Token "," ExpectingComma)


alphaNumParser_ : PA.Parser c Problem String
alphaNumParser_ =
    succeed String.slice
        |= getOffset
        |. chompIf Char.isAlpha ExpectingAlpha
        |. chompWhile Char.isAlphaNum
        |. spaces
        |= getOffset
        |= getSource


symbolParser =
    (succeed String.slice
        |= getOffset
        |. chompIf (\c -> not (Char.isAlpha c)) ExpectingNotAlpha
        |. chompWhile (\c -> c /= ' ')
        |. spaces
        |= getOffset
        |= getSource
    )
        |> PA.map Symbol



-- PRINT


printList : List Word -> String
printList exprs =
    List.map printWord exprs |> String.join " " |> String.trim


printWord : Word -> String
printWord expr =
    case expr of
        AlphaNum str ->
            str

        Symbol str ->
            str

        WS ->
            " "

        Comma ->
            ","

        LeftParen ->
            "("

        RightParen ->
            ")"

        FunctionName str ->
            str

        MacroName str ->
            "\\" ++ str



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
