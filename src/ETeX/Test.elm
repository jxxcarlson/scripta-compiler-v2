module ETeX.Test exposing (data1, data2, evalStr, makeDict, transform, transformETeX)

import Dict
import ETeX.Transform exposing (evalStr, makeMacroDict, transformETeX)


transform =
    ETeX.Transform.transformETeX


transformETeX =
    ETeX.Transform.transformETeX


evalStr str =
    ETeX.Transform.evalStr


makeDict str =
    ETeX.Transform.makeMacroDict str


data =
    ""


data1 =
    """
nat:      mathbb N
reals:    mathbb R
space:    reals^(#1)
set:      \\{ #1 \\}
sett:     \\{\\ #1 \\ | \\ #2 \\ \\}
bracket:  \\{ [ #1 ] \\}
"""


data2 =
    "[m a^2 + b^2 = bracket(x^2 + y^2)]"
