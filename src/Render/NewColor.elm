module Render.NewColor exposing
    ( Color
    , black, white, transparent
    , blue, blue100, blue200, blue300, blue400, blue500, blue600, blue700, blue800, blue900
    , green, green100, green200, green300, green400, green500, green600, green700, green800, green900
    , amber, amber100, amber200, amber300, amber400, amber500, amber600, amber700, amber800, amber900
    , red, red100, red200, red300, red400, red500, red600, red700, red800, red900
    , indigo, indigo100, indigo200, indigo300, indigo400, indigo500, indigo600, indigo700, indigo800, indigo900
    , teal, teal100, teal200, teal300, teal400, teal500, teal600, teal700, teal800, teal900
    , gray, gray100, gray200, gray300, gray400, gray500, gray600, gray700, gray800, gray900, gray910, gray920, gray930, gray940, gray950, gray960, gray970, gray980, gray990
    , whiteAlpha100, whiteAlpha200, whiteAlpha300, whiteAlpha400, whiteAlpha500, whiteAlpha600, whiteAlpha700, whiteAlpha800, whiteAlpha900
    , blackAlpha100, blackAlpha200, blackAlpha300, blackAlpha400, blackAlpha500, blackAlpha600, blackAlpha700, blackAlpha800, blackAlpha900
    , setOpacity, toCssColor
    , indigo150, indigo175, red1100, red50, transparentIndigo500
    )

{-| A native macOS-inspired color system with professional, subtle tones.


# Types

@docs Color


# Base Colors

@docs black, white, transparent


# Color Scales

Each color comes in 9 harmonized shades (100-900).
Shades are balanced across different hues, meaning blue500 and green500 have similar brightness.

@docs blue, blue100, blue200, blue300, blue400, blue500, blue600, blue700, blue800, blue900
@docs green, green100, green200, green300, green400, green500, green600, green700, green800, green900
@docs amber, amber100, amber200, amber300, amber400, amber500, amber600, amber700, amber800, amber900
@docs red, red100, red200, red300, red400, red500, red600, red700, red800, red900
@docs indigo, indigo100, indigo200, indigo300, indigo400, indigo500, indigo600, indigo700, indigo800, indigo900
@docs teal, teal100, teal200, teal300, teal400, teal500, teal600, teal700, teal800, teal900
@docs gray, gray100, gray200, gray300, gray400, gray500, gray600, gray700, gray800, gray900, gray910, gray920, gray930, gray940, gray950, gray960, gray970, gray980, gray990


# Alpha Variants

Colors with varying transparency levels, useful for overlays and subtle effects.

@docs whiteAlpha100, whiteAlpha200, whiteAlpha300, whiteAlpha400, whiteAlpha500, whiteAlpha600, whiteAlpha700, whiteAlpha800, whiteAlpha900
@docs blackAlpha100, blackAlpha200, blackAlpha300, blackAlpha400, blackAlpha500, blackAlpha600, blackAlpha700, blackAlpha800, blackAlpha900


# Helpers

@docs setOpacity, toCssColor


# Debug

@docs viewColorPalette


# Usage Guidelines

  - 100-200: Light backgrounds, subtle fills
  - 300-400: Secondary backgrounds, separators
  - 500: Primary brand colors, system colors
  - 600-700: Text, active states
  - 800-900: High contrast text, headers

Common semantic uses:

  - blue: Primary actions, links (matches macOS accent color)
  - green: Success states, confirmations
  - amber: Warnings, important notifications
  - red: Error states, destructive actions
  - teal: Information, help content
  - gray: Text, borders, backgrounds, UI chrome

-}

import Color exposing (Color, rgba)
import Css exposing (column, displayFlex, flexDirection, height, int, property, px)
import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (css)


{-| So that the user oif this package doesn't need to import the `Color` package
-}
type alias Color =
    Color.Color


{-| Convert a Color to Css.Color while preserving its original alpha value.
This is useful when working with elm-css and you need to convert colors from elm-color format.

    -- Creating a CSS color from a base color
    buttonBackground =
        css [ backgroundColor (toCssColor blue500) ]

-}
toCssColor : Color -> Css.Color
toCssColor color =
    let
        c =
            Color.toRgba color
    in
    Css.rgba
        (Basics.round (c.red * 255))
        (Basics.round (c.green * 255))
        (Basics.round (c.blue * 255))
        c.alpha


{-| Helper function to set the opacity of any color. Useful for creating hover states
or disabled appearances without defining new colors.

    -- Creating a semi-transparent overlay
    overlay =
        setOpacity 0.5 black

-}
setOpacity : Float -> Color -> Color
setOpacity opacity color =
    let
        c =
            Color.toRgba color
    in
    Color.fromRgba
        { red = c.red
        , green = c.green
        , blue = c.blue
        , alpha = opacity
        }


white : Color
white =
    rgba 1 1 1 1


black : Color
black =
    rgba 0 0 0 1


transparent : Color
transparent =
    rgba 0 0 0 0



-- Base colors (500 variants)


blue : Color
blue =
    blue500


red : Color
red =
    red500


green : Color
green =
    green500


indigo : Color
indigo =
    indigo500


teal : Color
teal =
    teal500


amber : Color
amber =
    amber500


gray : Color
gray =
    gray500



-- White alpha variants


whiteAlpha100 : Color
whiteAlpha100 =
    rgba 1.0 1.0 1.0 0.04


whiteAlpha200 : Color
whiteAlpha200 =
    rgba 1.0 1.0 1.0 0.08


whiteAlpha300 : Color
whiteAlpha300 =
    rgba 1.0 1.0 1.0 0.16


whiteAlpha400 : Color
whiteAlpha400 =
    rgba 1.0 1.0 1.0 0.24


whiteAlpha500 : Color
whiteAlpha500 =
    rgba 1.0 1.0 1.0 0.36


whiteAlpha600 : Color
whiteAlpha600 =
    rgba 1.0 1.0 1.0 0.48


whiteAlpha700 : Color
whiteAlpha700 =
    rgba 1.0 1.0 1.0 0.64


whiteAlpha800 : Color
whiteAlpha800 =
    rgba 1.0 1.0 1.0 0.8


whiteAlpha900 : Color
whiteAlpha900 =
    rgba 1.0 1.0 1.0 0.92



-- Black alpha variants


blackAlpha100 : Color
blackAlpha100 =
    rgba 0.0 0.0 0.0 0.04


blackAlpha200 : Color
blackAlpha200 =
    rgba 0.0 0.0 0.0 0.08


blackAlpha300 : Color
blackAlpha300 =
    rgba 0.0 0.0 0.0 0.16


blackAlpha400 : Color
blackAlpha400 =
    rgba 0.0 0.0 0.0 0.24


blackAlpha500 : Color
blackAlpha500 =
    rgba 0.0 0.0 0.0 0.36


blackAlpha600 : Color
blackAlpha600 =
    rgba 0.0 0.0 0.0 0.48


blackAlpha700 : Color
blackAlpha700 =
    rgba 0.0 0.0 0.0 0.64


blackAlpha800 : Color
blackAlpha800 =
    rgba 0.0 0.0 0.0 0.8


blackAlpha900 : Color
blackAlpha900 =
    rgba 0.0 0.0 0.0 0.92



-- Blue variants (macOS system blue inspired)


blue100 : Color
blue100 =
    rgba 0.9 0.94 1.0 1


blue200 : Color
blue200 =
    rgba 0.74 0.84 0.98 1


blue300 : Color
blue300 =
    rgba 0.54 0.71 0.94 1


blue400 : Color
blue400 =
    rgba 0.32 0.56 0.88 1


blue500 : Color
blue500 =
    rgba 0.0 0.48 1.0 1



-- macOS accent blue


blue600 : Color
blue600 =
    rgba 0.0 0.42 0.89 1


blue700 : Color
blue700 =
    rgba 0.0 0.36 0.75 1


blue800 : Color
blue800 =
    rgba 0.0 0.29 0.59 1


blue900 : Color
blue900 =
    rgba 0.0 0.21 0.41 1



-- Green variants (macOS system green inspired)


green100 : Color
green100 =
    rgba 0.87 0.97 0.87 1


green200 : Color
green200 =
    rgba 0.74 0.93 0.74 1


green300 : Color
green300 =
    rgba 0.58 0.88 0.58 1


green400 : Color
green400 =
    rgba 0.39 0.82 0.39 1


green500 : Color
green500 =
    rgba 0.16 0.75 0.16 1



-- macOS system green


green600 : Color
green600 =
    rgba 0.13 0.67 0.13 1


green700 : Color
green700 =
    rgba 0.1 0.58 0.1 1


green800 : Color
green800 =
    rgba 0.07 0.47 0.07 1


green900 : Color
green900 =
    rgba 0.04 0.35 0.04 1



-- Amber variants (macOS warning color inspired)


amber100 : Color
amber100 =
    rgba 1.0 0.98 0.92 1


amber200 : Color
amber200 =
    rgba 1.0 0.94 0.76 1


amber300 : Color
amber300 =
    rgba 1.0 0.89 0.57 1


amber400 : Color
amber400 =
    rgba 1.0 0.82 0.36 1



-- This is #FFC900


amber500 : Color
amber500 =
    rgba 1.0 0.73 0.0 1


amber600 : Color
amber600 =
    rgba 0.9 0.65 0.0 1


amber700 : Color
amber700 =
    rgba 0.78 0.56 0.0 1


amber800 : Color
amber800 =
    rgba 0.63 0.45 0.0 1


amber900 : Color
amber900 =
    rgba 0.46 0.33 0.0 1



-- Red variants (unchanged)


red50 : Color
red50 =
    rgba 1.0 0.9 0.9 1


red100 : Color
red100 =
    rgba 1.0 0.6 0.7 1


red200 : Color
red200 =
    rgba 1.0 0.45 0.6 1


red300 : Color
red300 =
    rgba 1.0 0.3 0.5 1


red400 : Color
red400 =
    rgba 1.0 0.15 0.4 1


red500 : Color
red500 =
    rgba 1.0 0 0.3 1


red600 : Color
red600 =
    rgba 0.9 0 0.27 1


red700 : Color
red700 =
    rgba 0.8 0 0.24 1


red800 : Color
red800 =
    rgba 0.7 0 0.21 1


red900 : Color
red900 =
    rgba 0.6 0 0.18 1


red1100 : Color
red1100 =
    rgba 0.35 0 0.18 1



-- Indigo variants (professional accent color)


indigo100 : Color
indigo100 =
    rgba 0.93 0.94 0.98 1


indigo150 : Color
indigo150 =
    rgba 0.93 0.94 0.98 1


indigo175 : Color
indigo175 =
    rgba 0.88 0.89 0.95 0.5


indigo200 : Color
indigo200 =
    rgba 0.82 0.84 0.93 1


indigo300 : Color
indigo300 =
    rgba 0.68 0.71 0.87 1


indigo400 : Color
indigo400 =
    rgba 0.51 0.55 0.78 1


indigo500 : Color
indigo500 =
    rgba 0.35 0.38 0.67 1


transparentIndigo500 : Color
transparentIndigo500 =
    rgba 0.35 0.38 0.67 0.3



-- Professional indigo


indigo600 : Color
indigo600 =
    rgba 0.29 0.31 0.58 1


indigo700 : Color
indigo700 =
    rgba 0.23 0.25 0.48 1


indigo800 : Color
indigo800 =
    rgba 0.17 0.18 0.37 1


indigo900 : Color
indigo900 =
    rgba 0.11 0.11 0.25 1



-- Teal variants (information/help color)


teal100 : Color
teal100 =
    rgba 0.92 0.97 0.97 1


teal200 : Color
teal200 =
    rgba 0.76 0.91 0.91 1


teal300 : Color
teal300 =
    rgba 0.56 0.83 0.83 1


teal400 : Color
teal400 =
    rgba 0.32 0.73 0.73 1


teal500 : Color
teal500 =
    rgba 0.05 0.61 0.61 1



-- Professional teal


teal600 : Color
teal600 =
    rgba 0.04 0.54 0.54 1


teal700 : Color
teal700 =
    rgba 0.03 0.46 0.46 1


teal800 : Color
teal800 =
    rgba 0.02 0.37 0.37 1


teal900 : Color
teal900 =
    rgba 0.01 0.27 0.27 1



-- Gray variants


gray100 : Color
gray100 =
    rgba 0.96 0.96 0.96 1


gray200 : Color
gray200 =
    rgba 0.89 0.89 0.89 1


gray300 : Color
gray300 =
    rgba 0.82 0.82 0.82 1


gray400 : Color
gray400 =
    rgba 0.65 0.65 0.65 1


gray500 : Color
gray500 =
    rgba 0.47 0.5 0.52 1


gray600 : Color
gray600 =
    rgba 0.4 0.42 0.44 1


gray700 : Color
gray700 =
    rgba 0.33 0.35 0.37 1


gray800 : Color
gray800 =
    rgba 0.26 0.28 0.3 1


gray900 : Color
gray900 =
    rgba 0.19 0.21 0.23 1


gray910 : Color
gray910 =
    rgba 0.17 0.19 0.21 1


gray920 : Color
gray920 =
    rgba 0.15 0.17 0.19 1


gray930 : Color
gray930 =
    rgba 0.13 0.15 0.17 1


gray940 : Color
gray940 =
    rgba 0.11 0.13 0.15 1


gray950 : Color
gray950 =
    rgba 0.09 0.11 0.13 1


gray960 : Color
gray960 =
    rgba 0.07 0.09 0.11 1


gray970 : Color
gray970 =
    rgba 0.05 0.07 0.09 1


gray980 : Color
gray980 =
    rgba 0.03 0.05 0.07 1


gray990 : Color
gray990 =
    rgba 0.01 0.03 0.05 1
