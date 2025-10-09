module Render.Settings exposing
    ( Display(..), makeSettings, RenderSettings, default
    , DisplaySettings, RenderData, ThemedStyles, darkTheme, defaultDisplaySettings, defaultRenderData, defaultRenderSettings, getThemedColor, getThemedElementColor, lightTheme, toElementColor, unrollTheme
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
import Generic.Acc
import Render.NewColor exposing (..)
import Render.Theme
import ScriptaV2.Types exposing (CompilerParameters)


type alias RenderData =
    { count : Int
    , idPrefix : String
    , settings : RenderSettings
    , initialAccumulatorData : Generic.Acc.InitialAccumulatorData
    }



-- default selectedId width


defaultRenderData : CompilerParameters -> Int -> Int -> String -> RenderData
defaultRenderData params width outerCount selectedId =
    { count = outerCount
    , idPrefix = "!!"
    , settings = default params selectedId width
    , initialAccumulatorData = Generic.Acc.initialData
    }


defaultDisplaySettings : DisplaySettings
defaultDisplaySettings =
    { windowWidth = 800
    , longEquationLimit = 800
    , counter = 0
    , selectedId = ""
    , selectedSlug = Nothing
    , scale = 1
    , data = Dict.empty
    , idsOfOpenNodes = []
    , numberToLevel = 1
    }


type alias DisplaySettings =
    { windowWidth : Int
    , longEquationLimit : Float
    , counter : Int
    , selectedId : String
    , selectedSlug : Maybe String
    , scale : Float
    , data : Dict String String
    , idsOfOpenNodes : List String
    , numberToLevel : Int
    }


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
    , paddingTop : Int
    , paddingBottom : Int
    , properties : Dict String String
    }


type alias ThemedStyles =
    { background : Color
    , text : Color
    , codeBackground : Color
    , codeText : Color
    , offsetBackground : Color
    , offsetText : Color
    , link : Color
    , highlight : Color
    , border : Color
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
    { background = Color.rgba 1 1 1 1
    , text = gray950
    , codeBackground = Color.rgba 0.835 0.847 0.882 1 --- 0.8 0 0 0.2 -- 0.835 0.847 0.882 1
    , codeText = gray900
    , offsetBackground = Color.rgb 1 1 1 --indigo300 |> Render.NewColor.setOpacity 0.25
    , offsetText = gray950
    , link = blue500
    , highlight = indigo200
    , border = gray300
    }


darkTheme : ThemedStyles
darkTheme =
    { background = gray900
    , text = Color.rgba 0.835 0.847 0.882 1 -- gray100
    , codeBackground = Color.rgba 0.298 0.314 0.329 1 --
    , codeText = gray100
    , offsetBackground = gray900
    , offsetText = Color.rgba 0.835 0.847 0.882 1 -- gray200 |> Render.NewColor.setOpacity 0.25

    --, offsetText = teal600 |> Render.NewColor.setOpacity 0.25
    , link = blue300
    , highlight = indigo500
    , border = gray700
    }


{-| -}
type Display
    = DefaultDisplay
    | PhoneDisplay


{-| -}
defaultRenderSettings : CompilerParameters -> RenderSettings
defaultRenderSettings params =
    makeSettings params


{-| -}
default : CompilerParameters -> String -> Int -> RenderSettings
default params selectedId width =
    makeSettings params


{-| -}
makeSettings : CompilerParameters -> RenderSettings
makeSettings params =
    let
        titleSize =
            32
    in
    { width = round (params.scale * toFloat params.windowWidth)
    , titleSize = titleSize
    , paragraphSpacing = 28
    , display = DefaultDisplay
    , longEquationLimit = 1 * (params.windowWidth |> toFloat)
    , showTOC = True
    , showErrorMessages = False
    , selectedId = params.selectedId
    , selectedSlug = params.selectedSlug
    , backgroundColor = getThemedElementColor .background params.theme
    , textColor = getThemedElementColor .text params.theme
    , codeColor = getThemedElementColor .codeText params.theme
    , linkColor = getThemedElementColor .link params.theme
    , highlight = getThemedElementColor .highlight params.theme
    , codeBackground = getThemedElementColor .codeBackground params.theme
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
    , data = params.data
    , theme = params.theme
    , paddingTop = 0
    , paddingBottom = 0
    , properties = Dict.empty
    }
