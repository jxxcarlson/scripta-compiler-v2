module Render.Settings exposing
    ( Display(..), defaultSettings, makeSettings
    , RenderSettings, default
    )

{-| The Settings record holds information needed to render a
parsed document. For example, the renderer needs to
know the width of the window in which the document
is to be displayed. This is given by the `.width` field.

@docs Display, Settings, defaultSettings, makeSettings

-}

import Element


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
    , titlePrefix : String
    , isStandaloneDocument : Bool
    , codeColor : Element.Color
    , leftIndent : Int
    , leftIndentation : Int
    , leftRightIndentation : Int
    , wideLeftIndentation : Int
    , windowWidthScale : Float
    , maxHeadingFontSize : Float
    , redColor : Element.Color
    , topMarginForChildren : Int
    }


{-| -}
type Display
    = DefaultDisplay
    | PhoneDisplay


{-| -}
defaultSettings : RenderSettings
defaultSettings =
    makeSettings "" Nothing 1 600


default selectedId width =
    makeSettings selectedId Nothing 1 width


{-| -}
makeSettings : String -> Maybe String -> Float -> Int -> RenderSettings
makeSettings selectedId selectedSlug scale windowWidth =
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
    , titlePrefix = ""
    , isStandaloneDocument = False
    , codeColor = Element.rgb255 0 0 210
    , leftIndent = 18
    , leftIndentation = 18
    , leftRightIndentation = 18
    , wideLeftIndentation = 54
    , windowWidthScale = 0.3
    , maxHeadingFontSize = (titleSize |> toFloat) * 0.67
    , redColor = Element.rgb 0.7 0 0
    , topMarginForChildren = 6
    }
