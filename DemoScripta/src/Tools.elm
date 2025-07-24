module Tools exposing (..)

import Element
import Element.Background as Background
import Render.Settings
import Theme


view : { a | theme : Theme.Theme } -> Element.Element msg
view model =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Background.color <| Render.Settings.getThemedElementColor .background (Theme.mapTheme model.theme)
        ]
        [ Element.text "This is a themed view"
        , Element.text "More content can go here"
        ]
