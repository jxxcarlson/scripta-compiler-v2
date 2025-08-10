module ETeX.Test exposing (..)

import ETeX.Transform exposing (..)
import Generic.MathMacro


data =
    """
nat:      mathbb N
reals:    mathbb R
space:    reals^(#1)
set:      \\{ #1 \\}
sett:     \\{\\ #1 \\ | \\ #2 \\ \\}
"""


macroDict =
    Generic.MathMacro.makeMacroDict data
