module Render.Settings exposing
    ( Display(..), defaultSettings, makeSettings, RenderSettings, default
    , ThemedStyles, darkTheme, getThemedElementColor, lightTheme, toElementColor, unrollTheme
    )

{-| The Settings record holds information needed to render a
parsed document. For example, the renderer needs to
know the width of the window in which the document
is to be displayed. This is given by the `.width` field.

@docs Display, defaultSettings, makeSettings, RenderSettings, default

-}

import Color
import Dict exposing (Dict)
import Element
import Element.Background as BackgroundColor
import Element.Font as Font
import Render.NewColor exposing (..)
import Render.Theme


{-| A record of information needed to render a document.
For instance, the`width`field defines the width of the
page in which the document is e
-}
type alias RenderSettings =
    { paragraphSpacing : Int
    , selectedId : String -- the element with this id will be highlighted
    , display : Display
    , longEquationLimit : Float
    , selectedSlug : Maybe String -- is this necessary?
    , showErrorMessages : Bool
    , showTOC : Bool -- is this necessary?
    , titleSize : Int
    , width : Int
    , backgroundColor : Element.Color
    , textColor : Element.Color
    , codeColor : Element.Color
    , linkColor : Element.Color
    , highlight : Element.Color
    , codeBackground : Element.Color
    , titlePrefix : String
    , isStandaloneDocument : Bool
    , leftIndent : Int
    , leftIndentation : Int
    , leftRightIndentation : Int
    , wideLeftIndentation : Int
    , windowWidthScale : Float
    , maxHeadingFontSize : Float
    , redColor : Element.Color
    , topMarginForChildren : Int
    , data : Dict String String
    , theme : Render.Theme.Theme
    }


type alias ThemedStyles =
    { background : Color
    , text : Color
    , codeBackground : Color
    , codeText : Color
    , renderedBackground : Color
    , renderedText : Color
    , link : Color
    , highlight : Color
    }


getThemedColor : (ThemedStyles -> Color) -> Render.Theme.Theme -> Color
getThemedColor keyAccess theme =
    keyAccess
        (case theme of
            Render.Theme.Dark ->
                darkTheme

            Render.Theme.Light ->
                lightTheme
        )


getThemedElementColor : (ThemedStyles -> Color) -> Render.Theme.Theme -> Element.Color
getThemedElementColor keyAccess theme =
    toElementColor (getThemedColor keyAccess theme)


{-| Unrolls the theme into a list of Element styles.
-}
unrollTheme : Render.Theme.Theme -> List (Element.Attr decorative msg)
unrollTheme theme =
    [ BackgroundColor.color (getThemedElementColor .background theme)
    , Font.color (getThemedElementColor .text theme)
    ]


toElementColor : Color -> Element.Color
toElementColor color =
    let
        c =
            Color.toRgba color
    in
    Element.rgba c.red c.green c.blue c.alpha


{-| A light theme with a white background and dark text.
-}
lightTheme : ThemedStyles
lightTheme =
    { background = indigo100
    , text = gray950
    , codeBackground = Color.rgba 0.835 0.847 0.882 1
    , codeText = gray900
    , renderedBackground = indigo100
    , renderedText = gray900
    , link = blue600
    , highlight = transparentBlue500
    }


darkTheme : ThemedStyles
darkTheme =
    { background = gray900
    , text = gray100
    , codeBackground = Color.rgba 0.298 0.314 0.329 1
    , codeText = gray100
    , renderedBackground = indigo100
    , renderedText = gray900
    , link = blue300
    , highlight = blue500
    }


{-| -}
type Display
    = DefaultDisplay
    | PhoneDisplay


{-| -}
defaultSettings : RenderSettings
defaultSettings =
    makeSettings Render.Theme.Light "" Nothing 1 600 Dict.empty


{-| -}
default : Render.Theme.Theme -> String -> Int -> RenderSettings
default theme selectedId width =
    makeSettings theme selectedId Nothing 1 width Dict.empty


{-| -}
makeSettings : Render.Theme.Theme -> String -> Maybe String -> Float -> Int -> Dict String String -> RenderSettings
makeSettings theme selectedId selectedSlug scale windowWidth data =
    let
        titleSize =
            32
    in
    { width = round (scale * toFloat windowWidth)
    , titleSize = titleSize
    , paragraphSpacing = 28
    , display = DefaultDisplay
    , longEquationLimit = 1 * (windowWidth |> toFloat)
    , showTOC = True
    , showErrorMessages = False
    , selectedId = selectedId
    , selectedSlug = selectedSlug
    , backgroundColor = getThemedElementColor .background theme
    , textColor = getThemedElementColor .text theme
    , codeColor = getThemedElementColor .codeText theme
    , linkColor = getThemedElementColor .link theme
    , highlight = getThemedElementColor .highlight theme
    , codeBackground = getThemedElementColor .codeBackground theme
    , titlePrefix = ""
    , isStandaloneDocument = False
    , leftIndent = 0
    , leftIndentation = 18
    , leftRightIndentation = 18
    , wideLeftIndentation = 54
    , windowWidthScale = 0.3
    , maxHeadingFontSize = (titleSize |> toFloat) * 0.72
    , redColor = Element.rgb 0.7 0 0
    , topMarginForChildren = 6
    , data = data
    , theme = theme
    }
