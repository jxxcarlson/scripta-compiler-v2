module ScriptaV2.Language exposing (ExpressionBlock, Language(..), RenderSettings, renderSettingsFromDisplaySettings)

{-|

@docs ExpressionBlock, Language, RenderSettings, renderSettingsFromDisplaySettings

-}

import Generic.Language
import Render.Settings


{-| -}
type Language
    = MicroLaTeXLang
    | L0Lang
    | XMarkdownLang


{-| -}
type alias RenderSettings =
    Render.Settings.RenderSettings


{-| -}
type alias ExpressionBlock =
    Generic.Language.ExpressionBlock


{-|

  - windowWidth: set this to agree with the width
    of the window in pixels in which the rendered
    text is displayed.

  - counter: This is updated on each edit.
    For technical reasons (virtual Dom)
    this is needed for the text to display properly.

  - selectedId and selectedSlug: useful for interactive editing.

  - scale: a fudge factor

-}
type alias DisplaySettings =
    { windowWidth : Int
    , longEquationLimit : Float
    , counter : Int
    , selectedId : String
    , selectedSlug : Maybe String
    , scale : Float
    }


{-| -}
renderSettingsFromDisplaySettings : DisplaySettings -> RenderSettings
renderSettingsFromDisplaySettings ds =
    Render.Settings.makeSettings ds.selectedId ds.selectedSlug ds.scale ds.windowWidth
