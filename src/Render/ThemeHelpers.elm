module Render.ThemeHelpers exposing (..)

import Render.Settings exposing (RenderSettings)
import Render.Theme exposing (Theme(..))


themeAsStringFromSettings : Render.Settings.RenderSettings -> String
themeAsStringFromSettings settings =
    case settings.theme of
        Light ->
            "light"

        Dark ->
            "dark"
