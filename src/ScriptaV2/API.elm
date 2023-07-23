module ScriptaV2.API exposing (compile, compileString)

{-|

@docs compile, compileString

-}

import ScriptaV2.Compiler


{-| -}
compile lang width outerCount selectedId lines =
    ScriptaV2.Compiler.compile lang width outerCount selectedId lines |> ScriptaV2.Compiler.view


{-| -}
compileString lang width str =
    ScriptaV2.Compiler.compile lang width 0 "---" (String.lines str) |> ScriptaV2.Compiler.view
