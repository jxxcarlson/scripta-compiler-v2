module Render.Settings exposing
    ( Display(..), defaultSettings, makeSettings, RenderSettings, default
    , Theme, unrollTheme
    )

{-| The Settings record holds information needed to render a
parsed document. For example, the renderer needs to
know the width of the window in which the document
is to be displayed. This is given by the `.width` field.

@docs Display, defaultSettings, makeSettings, RenderSettings, default

-}

import Dict exposing (Dict)
import Element
import Element.Background as BackgroundColor
import Element.Font as Font


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
    }


type alias Theme =
    { backgroundColor : Element.Color
    , textColor : Element.Color
    , codeColor : Element.Color
    , linkColor : Element.Color
    }


unrollTheme theme =
    [ BackgroundColor.color theme.backgroundColor, Font.color theme.textColor ]


{-| A light theme with a white background and dark text.
-}
lightTheme : Theme
lightTheme =
    { backgroundColor = Element.rgb 1 1 1
    , textColor = Element.rgb 0.1 0.1 0.1
    , codeColor = Element.rgb255 20 120 210
    , linkColor = Element.rgb 0.1 0.1 0.8
    }


darkTheme : Theme
darkTheme =
    { backgroundColor = Element.rgb 0.1 0.1 0.1
    , textColor = Element.rgb 1 1 1
    , codeColor = Element.rgb255 0 100 200
    , linkColor = Element.rgb 0.2 0.2 1.0
    }


{-| -}
type Display
    = DefaultDisplay
    | PhoneDisplay


{-| -}
defaultSettings : RenderSettings
defaultSettings =
    makeSettings lightTheme "" Nothing 1 600 Dict.empty


{-| -}
default : Theme -> String -> Int -> RenderSettings
default theme selectedId width =
    makeSettings theme selectedId Nothing 1 width Dict.empty


{-| -}
makeSettings : Theme -> String -> Maybe String -> Float -> Int -> Dict String String -> RenderSettings
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
    , backgroundColor = Element.rgb 1 1 1
    , textColor = Element.rgb 0.1 0.1 0.1
    , codeColor = Element.rgb255 20 120 210
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
    }
