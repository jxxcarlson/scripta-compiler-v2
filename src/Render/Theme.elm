module Render.Theme exposing
    ( Theme(..)
    , ActualTheme
    , getColor
    , getElementColor
    , lightTheme
    , darkTheme
    )

{-| Theme support for Scripta rendering.

This module provides light and dark themes for rendering Scripta documents,
with support for both raw Color values and elm-ui Element.Color.


# Types

@docs Theme, ActualTheme


# Theme Selection

@docs getColor, getElementColor


# Predefined Themes

@docs lightTheme, darkTheme

-}

import Color
import Element
import Render.NewColor exposing (..)


{-| Represents the available themes.
-}
type Theme
    = Light
    | Dark


{-| A theme's color palette, containing colors for various UI elements.
-}
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


{-| Get a Color value from the selected theme.

    myTextColor =
        getColor Light .text

-}
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


{-| Get an Element.Color value from the selected theme.
This is useful when working with elm-ui.

    myBackgroundColor =
        getElementColor Dark .background

-}
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


{-| The predefined light theme with professional, readable colors.
-}
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


{-| The predefined dark theme with reduced eye strain for low-light environments.
-}
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
