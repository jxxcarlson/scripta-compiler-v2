module Render.Theme exposing (..)

import Color
import Element
import Render.NewColor exposing (..)


type Theme
    = Light
    | Dark



--
--mapTheme : Theme -> Render.Theme.Theme
--mapTheme theme =
--    case theme of
--        Light ->
--            Render.Theme.Light
--
--        Dark ->
--            Render.Theme.Dark
-- getColor : Theme -> (ActualTheme -> Color) -> Element.Color


getColor : Theme -> (ActualTheme -> Color) -> Color
getColor theme colorSelector =
    let
        actualTheme =
            case theme of
                Light ->
                    lightTheme

                Dark ->
                    darkTheme
    in
    colorSelector actualTheme


getElementColor : Theme -> (ActualTheme -> Color) -> Element.Color
getElementColor theme colorSelector =
    let
        actualTheme =
            case theme of
                Light ->
                    lightTheme

                Dark ->
                    darkTheme
    in
    colorSelector actualTheme |> elementColorFromColor


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
    , footnote : Color
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
    , footnote = gray600
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
    , footnote = gray400
    , highlight = transparentIndigo500
    }



---
--
--
--type alias ActualTheme =
--    { background : Color
--    , text : Color
--    , codeBackground : Color
--    , codeText : Color
--    , offsetBackground : Color
--    , offsetText : Color
--    , link : Color
--    , footnote : Color
--    , highlight : Color
--    }
--
--
--lightTheme : ActualTheme
--lightTheme =
--    { background = whiteAlpha100
--    , text = gray950
--    , codeBackground = indigo200
--    , codeText = gray900
--    , offsetBackground = whiteAlpha100
--    , offsetText = gray800
--    , link = blue700
--    , footnote = gray600
--    , highlight = transparentIndigo500
--    }
--
--
--darkTheme : ActualTheme
--darkTheme =
--    { background = gray900
--    , text = gray100
--    , codeBackground = gray920
--    , codeText = gray100
--    , offsetBackground = gray700
--    , offsetText = gray200
--    , link = blue100
--    , footnote = gray400
--    , highlight = transparentIndigo500
--    }
