module ScriptaV2.Settings exposing (RenderSettings, DisplaySettings, defaultSettings, makeSettings, renderSettingsFromDisplaySettings)

{-|

@docs RenderSettings, DisplaySettings, defaultSettings, makeSettings, renderSettingsFromDisplaySettings

-}

import Dict exposing (Dict)
import Render.Settings
import Render.Theme


{-| -}
type alias RenderSettings =
    Render.Settings.RenderSettings


{-| -}
makeSettings : DisplaySettings -> Render.Theme.Theme -> String -> Maybe String -> Float -> Int -> Dict String String -> Render.Settings.RenderSettings
makeSettings displaySettings =
    Render.Settings.makeSettings displaySettings


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
renderSettingsFromDisplaySettings : DisplaySettings -> Render.Theme.Theme -> DisplaySettings -> RenderSettings
renderSettingsFromDisplaySettings displaySettings theme ds =
    Render.Settings.makeSettings displaySettings theme ds.selectedId ds.selectedSlug ds.scale ds.windowWidth ds.data


{-| -}
defaultSettings : DisplaySettings -> RenderSettings
defaultSettings displaySettings =
    Render.Settings.defaultSettings displaySettings
