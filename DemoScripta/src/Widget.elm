module Widget exposing
    ( inputTextWidget
    , sidebarButton
    )

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import Style
import Theme


sidebarButton theme msg label =
    Input.button
        [ paddingXY 12 6
        , Background.color
            (if theme == Theme.Light then
                Element.rgb255 255 255 255

             else
                Element.rgb255 80 80 80
            )
        , Font.color
            (if theme == Theme.Light then
                Element.rgb255 50 50 50

             else
                Element.rgb255 150 150 150
            )
        , Element.htmlAttribute
            (Html.Attributes.style "color"
                (case theme of
                    Theme.Light ->
                        "rgb(255, 140, 0)"

                    Theme.Dark ->
                        "rgb(255, 165, 0)"
                )
            )
        , Border.roundEach { topLeft = 0, bottomLeft = 0, topRight = 4, bottomRight = 4 }
        , Font.size 14
        , Font.bold
        ]
        { onPress = msg
        , label = Element.text label
        }


inputTextWidget theme input msg =
    Input.text
        [ width fill
        , paddingXY 8 4
        , Border.width 1
        , Border.rounded 4
        , Border.color (Element.rgba 0.5 0.5 0.5 0.3)
        , Background.color (Style.backgroundColor theme)
        , Font.color (Style.textColor theme)
        , Font.size 14
        , Font.bold
        ]
        { onChange = msg
        , text = input
        , placeholder = Nothing
        , label = Input.labelHidden "Your name"
        }
