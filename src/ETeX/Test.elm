module ETeX.Test exposing (transform)

import ETeX.Transform exposing (makeMacroDict, transformETeX)


transform str =
    transformETeX (makeMacroDict data |> Debug.log "MacroDict") str


data =
    """
nat:      mathbb N
reals:    mathbb R
space:    reals^(#1)
set:      \\{ #1 \\}
sett:     \\{\\ #1 \\ | \\ #2 \\ \\}
"""
