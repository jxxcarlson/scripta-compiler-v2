module QuickTest exposing (main)

import Platform
import Render.Export.LaTeXToScripta as L2S


main : Program () () ()
main =
    Platform.worker
        { init = \_ -> ( (), Cmd.none )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


{-| Quick test of equation block
-}
testEquation : String
testEquation =
    let
        latex =
            """\\begin{equation}
E = mc^2
\\end{equation}"""
    in
    L2S.translate latex


{-| Quick test of align block
-}
testAlign : String
testAlign =
    let
        latex =
            """\\begin{align}
x + y &= 5 \\\\
2x - y &= 1
\\end{align}"""
    in
    L2S.translate latex


-- For debugging in elm repl
debug : String
debug =
    "EQUATION:\n" ++ testEquation ++ "\n\nALIGN:\n" ++ testAlign