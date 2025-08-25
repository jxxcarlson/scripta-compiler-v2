module ETeX.Test exposing (evalStr, p, q, t, transform)

import ETeX.Transform exposing (makeMacroDict)
import Generic.Language
import Generic.Pipeline
import M.Expression
import M.PrimitiveBlock


p : String -> List Generic.Language.PrimitiveBlock
p str =
    M.PrimitiveBlock.parse "0" 0 (String.lines str)


q : String -> List Generic.Language.ExpressionBlock
q =
    p >> List.map expressionBlockFromPrimitiveBlock


t =
    "[i foo [link NYT https://nytimes.com]]\n\n"


expressionBlockFromPrimitiveBlock : Generic.Language.PrimitiveBlock -> Generic.Language.ExpressionBlock
expressionBlockFromPrimitiveBlock =
    Generic.Pipeline.toExpressionBlock M.Expression.parse


transform str =
    ETeX.Transform.transformETeX (makeMacroDict data |> Debug.log "MacroDict") str


evalStr str =
    ETeX.Transform.evalStr (makeMacroDict data |> Debug.log "MacroDict") str


data =
    ""


data1 =
    """
nat:      mathbb N
reals:    mathbb R
space:    reals^(#1)
set:      \\{ #1 \\}
sett:     \\{\\ #1 \\ | \\ #2 \\ \\}
"""
