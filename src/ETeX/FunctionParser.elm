module ETeX.FunctionParser exposing (..)

import ETeX.Dictionary exposing (functionDict)
import Parser exposing (..)
import Parser.Advanced
import Set



-- Parser.Advanced.DeadEnd "Parsing error" input


type Expr
    = Var String
    | FCall String (List Expr)
    | Number Int



-- other variants...


exprParser : Parser Expr
exprParser =
    oneOf
        [ variableParser
        , numberParser
        ]


functionCallParser : Parser Expr
functionCallParser =
    succeed FCall
        |= functionNameParser
        |. symbol "("
        |= argumentListParser
        |. symbol ")"


functionNameParser : Parser String
functionNameParser =
    variable
        { start = Char.isAlpha
        , inner = \c -> Char.isAlpha c
        , reserved = Set.empty
        }


argumentListParser : Parser (List Expr)
argumentListParser =
    oneOf
        [ sepBy (symbol ",") (succeed identity |. spaces |= lazy (\_ -> exprParser) |. spaces)
        , succeed []
        ]


variableParser : Parser Expr
variableParser =
    map Var functionNameParser


numberParser : Parser Expr
numberParser =
    map Number int



-- Helper function for comma-separated lists


sepBy : Parser sep -> Parser a -> Parser (List a)
sepBy separator item =
    succeed (::)
        |= item
        |= loop [] (sepByHelp separator item)


sepByHelp : Parser sep -> Parser a -> List a -> Parser (Step (List a) (List a))
sepByHelp separator item revItems =
    oneOf
        [ succeed (\i -> Loop (i :: revItems))
            |. separator
            |= item
        , succeed ()
            |> map (\_ -> Done (List.reverse revItems))
        ]



-- Usage:
-- run exprParser "f(a,b,c)" == Ok (FCall "f" [Var "a", Var "b", Var "c"])
-- run exprParser "sum(1,add(2,3),x)" == Ok (FCall "sum" [Number 1, FCall "add" [Number 2, Number 3], Var "x"])
