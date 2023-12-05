module ScriptaV2.API exposing (compile, compileString)

{-|

@docs compile, compileString

-}

import Element exposing (Element)
import Render.Msg exposing (MarkupMsg)
import ScriptaV2.Compiler
import ScriptaV2.Language exposing (Language)


{-| -}
compile : Language -> Int -> Int -> String -> List String -> List (Element MarkupMsg)
compile lang width outerCount selectedId lines =
    ScriptaV2.Compiler.compile lang width outerCount selectedId lines |> ScriptaV2.Compiler.view width


{-| -}
compileString : Language -> Int -> String -> List (Element MarkupMsg)
compileString lang width str =
    ScriptaV2.Compiler.compile lang width 0 "---" (String.lines str) |> ScriptaV2.Compiler.view width
