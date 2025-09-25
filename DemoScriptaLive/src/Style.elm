module Style exposing
    ( backgroundColor
    , background_
    , borderColor
    , buttonBackgroundColor
    , buttonTextColor
    , debugTextColor
    , displayColumn
    , electricBlueColor
    , forceColorStyle
    , mutedTextColor
    , formatRelativeTime
    , htmlId
    , innerColumn
    , innerMultiline
    , multiline
    , rightPanelBackgroundColor
    , rightPanelBackground_
    , textColor
    )

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import Render.Settings exposing (getThemedElementColor)
import Theme
import Time


htmlId str =
    Element.htmlAttribute (Html.Attributes.id str)


background_ theme =
    Background.color <| backgroundColor theme


rightPanelBackground_ theme =
    Background.color <| rightPanelBackgroundColor theme



-- COLOR


forceColorStyle theme =
    case theme of
        Theme.Light ->
            Element.htmlAttribute (Html.Attributes.style "color" "black")

        Theme.Dark ->
            Element.htmlAttribute (Html.Attributes.style "color" "white")


debugTextColor theme_ =
    case theme_ of
        Theme.Light ->
            Element.rgb255 0 0 0

        -- Black for light mode
        Theme.Dark ->
            Element.rgb255 255 255 255


borderColor theme =
    case theme of
        Theme.Light ->
            Element.rgb 0.5 0.5 0.5

        Theme.Dark ->
            Element.rgb 0.5 0.5 0.5


mutedTextColor : Theme.Theme -> Element.Color
mutedTextColor theme =
    case theme of
        Theme.Light ->
            Element.rgb 0.6 0.6 0.6

        Theme.Dark ->
            Element.rgb 0.5 0.5 0.5


textColor : Theme.Theme -> Element.Color
textColor theme =
    case theme of
        Theme.Light ->
            Element.rgb255 33 33 33

        -- Dark gray for light mode
        Theme.Dark ->
            Element.rgb255 240 240 240


backgroundColor : Theme.Theme -> Element.Color
backgroundColor theme =
    case theme of
        Theme.Light ->
            getThemedElementColor .background (Theme.mapTheme theme)

        Theme.Dark ->
            Element.rgb255 48 54 59


buttonTextColor : Theme.Theme -> Element.Color
buttonTextColor theme =
    case theme of
        Theme.Light ->
            Element.rgb255 255 165 0

        -- Darker orange for light mode
        Theme.Dark ->
            Element.rgb255 255 165 0


electricBlueColor : Theme.Theme -> Element.Color
electricBlueColor theme =
    case theme of
        Theme.Light ->
            Element.rgb255 20 123 255

        -- Bright electric blue for light mode
        Theme.Dark ->
            Element.rgb255 0 191 255


buttonBackgroundColor : Theme.Theme -> Element.Color
buttonBackgroundColor theme =
    case theme of
        Theme.Light ->
            Element.rgb255 25 25 35

        -- Light gray for light mode
        Theme.Dark ->
            backgroundColor theme


rightPanelBackgroundColor : Theme.Theme -> Element.Color
rightPanelBackgroundColor theme =
    case theme of
        Theme.Light ->
            Element.rgb255 230 230 230

        -- Light gray for light mode
        Theme.Dark ->
            backgroundColor theme



-- TIME


formatRelativeTime : Time.Posix -> Time.Posix -> String
formatRelativeTime currentTime savedTime =
    let
        currentMillis =
            Time.posixToMillis currentTime

        savedMillis =
            Time.posixToMillis savedTime

        diffMillis =
            currentMillis - savedMillis

        seconds =
            diffMillis // 1000

        minutes =
            seconds // 60

        hours =
            minutes // 60
    in
    if savedMillis == 0 then
        "Never"

    else if seconds < 5 then
        "Just now"

    else if seconds < 60 then
        String.fromInt seconds ++ " seconds ago"

    else if minutes < 60 then
        String.fromInt minutes
            ++ " minute"
            ++ (if minutes == 1 then
                    ""

                else
                    "s"
               )
            ++ " ago"

    else if hours < 24 then
        String.fromInt hours
            ++ " hour"
            ++ (if hours == 1 then
                    ""

                else
                    "s"
               )
            ++ " ago"

    else
        String.fromInt (hours // 24)
            ++ " day"
            ++ (if hours // 24 == 1 then
                    ""

                else
                    "s"
               )
            ++ " ago"



-- WIDGET STYLE


button theme =
    [ Background.color (buttonBackgroundColor theme)
    , Font.color (buttonTextColor theme)
    , paddingXY 12 8
    , Border.rounded 4
    , Border.width 1
    , Border.color (Element.rgba 0.5 0.5 0.5 0.3)
    , mouseOver
        [ Background.color (Element.rgba 0.5 0.5 0.5 0.2)
        , Border.color (Element.rgba 0.5 0.5 0.5 0.5)
        ]
    , mouseDown
        [ Background.color (Element.rgba 0.5 0.5 0.5 0.3)
        , Border.color (Element.rgba 0.5 0.5 0.5 0.7)
        ]
    , Element.htmlAttribute
        (Html.Attributes.style "color"
            (case theme of
                Theme.Light ->
                    "rgb(255, 140, 0)"

                Theme.Dark ->
                    "rgb(255, 165, 0)"
            )
        )
    ]


innerMultiline theme =
    [ width fill
    , height fill
    , Font.size 14
    , Element.alignTop
    , Font.color (textColor theme)
    , Background.color (backgroundColor theme)
    , forceColorStyle theme
    , Element.htmlAttribute (Html.Attributes.id "source-text-input")
    , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
    , Element.htmlAttribute (Html.Attributes.style "padding" "8px 8px 24px 8px")
    ]


displayColumn =
    [ width fill
    , height fill
    , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
    , Element.htmlAttribute (Html.Attributes.style "overflow-x" "hidden")
    , Element.htmlAttribute (Html.Attributes.style "position" "absolute")
    , Element.htmlAttribute (Html.Attributes.style "top" "0")
    , Element.htmlAttribute (Html.Attributes.style "left" "0")
    , Element.htmlAttribute (Html.Attributes.style "right" "0")
    , Element.htmlAttribute (Html.Attributes.style "bottom" "0")
    , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
    ]


innerDisplayColumn theme =
    [ background_ theme
    , spacing 24
    , width fill
    , htmlId "rendered-text"
    , alignTop
    , centerX
    , Font.color (textColor theme)
    , forceColorStyle theme
    , Element.htmlAttribute (Html.Attributes.style "padding" "16px")
    , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
    ]


innerColumn =
    [ width fill
    , height fill
    , Element.paddingXY 16 16
    , Element.spacing 12
    , scrollbarY
    , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
    , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
    , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
    ]


multiline : (Element.Length -> Element.Attribute msg) -> (Element.Length -> Element.Attribute msg) -> List (Element.Attribute msg)
multiline width height =
    [ width Element.fill
    , height Element.fill
    , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
    , Element.htmlAttribute (Html.Attributes.style "overflow-x" "hidden")
    , Element.htmlAttribute (Html.Attributes.style "position" "absolute")
    , Element.htmlAttribute (Html.Attributes.style "top" "0")
    , Element.htmlAttribute (Html.Attributes.style "left" "0")
    , Element.htmlAttribute (Html.Attributes.style "right" "0")
    , Element.htmlAttribute (Html.Attributes.style "bottom" "0")
    , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
    ]
