module ScriptaV2.API exposing (compile, compileString)

{-|

@docs compile, compileString

-}

import Element exposing (Element)
import Render.Msg exposing (MarkupMsg)
import ScriptaV2.Compiler
import ScriptaV2.Language exposing (Language)


{-| -}
compile : ScriptaV2.Compiler.Filter -> Language -> Int -> Int -> String -> List String -> List (Element MarkupMsg)
compile filter lang width outerCount selectedId lines =
    ScriptaV2.Compiler.compile filter lang width outerCount selectedId lines |> ScriptaV2.Compiler.view width


{-| -}
compileString : ScriptaV2.Compiler.Filter -> Language -> Int -> String -> List (Element MarkupMsg)
compileString filter lang width str =
    ScriptaV2.Compiler.compile filter lang width 0 "---" (String.lines str) |> ScriptaV2.Compiler.view width
