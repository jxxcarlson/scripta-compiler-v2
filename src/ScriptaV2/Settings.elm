module ScriptaV2.Settings exposing
    ( RenderSettings, DisplaySettings, defaultSettings, makeSettings
    , renderSettingsFromCompilerParameters
    )

{-|

@docs RenderSettings, DisplaySettings, defaultSettings, makeSettings, renderSettingsFromDisplaySettings

-}

import Dict exposing (Dict)
import Render.Settings
import Render.Theme
import ScriptaV2.Types


{-| -}
type alias RenderSettings =
    Render.Settings.RenderSettings


{-| -}
makeSettings : ScriptaV2.Types.CompilerParameters -> Render.Settings.RenderSettings
makeSettings params =
    Render.Settings.makeSettings params


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
    Render.Settings.DisplaySettings


{-| -}
renderSettingsFromCompilerParameters : ScriptaV2.Types.CompilerParameters -> RenderSettings
renderSettingsFromCompilerParameters params =
    Render.Settings.makeSettings params


{-| -}
defaultSettings : ScriptaV2.Types.CompilerParameters -> RenderSettings
defaultSettings displaySettings =
    Render.Settings.defaultRenderSettings displaySettings
