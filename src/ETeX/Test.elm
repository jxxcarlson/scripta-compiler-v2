module ETeX.Test exposing (evalStr, transform)

import ETeX.Transform exposing (makeMacroDict)


transform str =


evalStr str =


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
