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
import ScriptaV2.Language exposing (Language)
import ScriptaV2.Msg exposing (MarkupMsg)


settings : { filter : ScriptaV2.Compiler.Filter, lang : Language, width : Int }
settings =
    { filter = ScriptaV2.Compiler.NoFilter
    , lang = ScriptaV2.Language.MicroLaTeXLang
    , width = 800
    }


{-| -}
compile : Render.Settings.DisplaySettings -> Render.Theme.Theme -> ScriptaV2.Compiler.CompilerParameters -> List String -> List (Element MarkupMsg)
compile displaySettings theme params lines =
    ScriptaV2.Compiler.compile displaySettings theme params lines |> ScriptaV2.Compiler.view params.docWidth


{-| -}
compileString : Render.Settings.DisplaySettings -> Render.Theme.Theme -> ScriptaV2.Compiler.CompilerParameters -> String -> List (Element MarkupMsg)
compileString displaySettings theme params str =
    -- ScriptaV2.Compiler.compile filter lang width 0 "---" (String.lines str) |> ScriptaV2.Compiler.view width
    ScriptaV2.Compiler.compile displaySettings theme params (String.lines str) |> ScriptaV2.Compiler.view params.docWidth


compileStringWithTitle : Render.Settings.DisplaySettings -> Render.Theme.Theme -> String -> ScriptaV2.Compiler.CompilerParameters -> String -> List (Element MarkupMsg)
compileStringWithTitle displaySettings theme title params str =
    ScriptaV2.Compiler.compile displaySettings theme params (String.lines str)
        |> ScriptaV2.Compiler.viewBodyOnly params.docWidth
        |> (\x -> Element.el [ Element.height (Element.px 130), Element.Font.size 24, Element.paddingEach { left = 0, right = 0, top = 8, bottom = 24 } ] (Element.text title) :: x)
