module ScriptaV2.API exposing
    ( compile, compileString
    , compileStringWithTitle
    )

{-|

@docs compile, compileString

-}

import Element exposing (Element)
import Element.Font
import Render.Settings
import Render.Theme
import ScriptaV2.Compiler
import ScriptaV2.Language
import ScriptaV2.Msg
import ScriptaV2.Types


settings : { filter : ScriptaV2.Types.Filter, lang : ScriptaV2.Language.Language, width : Int }
settings =
    { filter = ScriptaV2.Types.NoFilter
    , lang = ScriptaV2.Language.MicroLaTeXLang
    , width = 800
    }


{-| -}
compile : ScriptaV2.Types.CompilerParameters -> List String -> List (Element ScriptaV2.Msg.MarkupMsg)
compile params lines =
    ScriptaV2.Compiler.compile params lines |> ScriptaV2.Compiler.view params.docWidth


{-| -}
compileString : ScriptaV2.Types.CompilerParameters -> String -> List (Element ScriptaV2.Msg.MarkupMsg)
compileString params str =
    -- ScriptaV2.Compiler.compile filter lang width 0 "---" (String.lines str) |> ScriptaV2.Compiler.view width
    ScriptaV2.Compiler.compile params (String.lines str) |> ScriptaV2.Compiler.view params.docWidth


compileStringWithTitle : String -> ScriptaV2.Types.CompilerParameters -> String -> List (Element ScriptaV2.Msg.MarkupMsg)
compileStringWithTitle title params str =
    ScriptaV2.Compiler.compile params (String.lines str)
        |> ScriptaV2.Compiler.viewBodyOnly params.docWidth
        |> (\x -> Element.el [ Element.height (Element.px 130), Element.Font.size 24, Element.paddingEach { left = 0, right = 0, top = 8, bottom = 24 } ] (Element.text title) :: x)
