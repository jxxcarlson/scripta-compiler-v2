module Theme exposing (..)

import Color
import Element
import Render.NewColor exposing (..)
import Render.Theme


type Theme
    = Light
    | Dark


mapTheme : Theme -> Render.Theme.Theme
mapTheme theme =
    case theme of
        Light ->
            Render.Theme.Light

        Dark ->
            Render.Theme.Dark


elementColorFromColor : Color -> Element.Color
elementColorFromColor color =
    let
        v =
            Color.toRgba color
    in
    Element.rgb v.red v.green v.blue


type alias ActualTheme =
    { background : Color
    , text : Color
    , codeBackground : Color
    , codeText : Color
    , offsetBackground : Color
    , offsetText : Color
    , link : Color
    , highlight : Color
    }


lightTheme : ActualTheme
lightTheme =
    { background = whiteAlpha100
    , text = gray950
    , codeBackground = indigo200
    , codeText = gray900
    , offsetBackground = whiteAlpha100
    , offsetText = gray800
    , link = indigo600
    , highlight = transparentIndigo500
    }


darkTheme : ActualTheme
darkTheme =
    { background = gray900
    , text = gray100
    , codeBackground = gray920
    , codeText = gray100
    , offsetBackground = gray700
    , offsetText = gray200
    , link = indigo600
    , highlight = transparentIndigo500
    }
