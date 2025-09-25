module Widget exposing
    ( inputTextWidget
    , nameElement
    , sidebarButton
    , toggleTheme
    )

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import Model exposing (Msg(..))
import Style
import Theme


toggleTheme model =
    Element.row
        [ Border.width 1
        , Border.color (Element.rgb 0.7 0.7 0.7)
        , Border.rounded 4
        , height (px 30)

        --, paddingXY 12 6
        ]
        [ if model.theme == Theme.Dark then
            sidebarButton2 model.theme Theme.Dark (Just ToggleTheme) "Dark"

          else
            sidebarButton model.theme (Just ToggleTheme) "Dark"
        , if model.theme == Theme.Light then
            sidebarButton2 model.theme Theme.Light (Just ToggleTheme) "Light"

          else
            sidebarButton model.theme (Just ToggleTheme) "Light"
        ]


nameElement model =
    case model.userName of
        Just name ->
            if String.trim name /= "" then
                -- Show just the username when it's filled
                inputTextWidget model.theme name InputUserName

            else
                -- Show label and input when empty
                Element.column [ spacing 8 ]
                    [ Element.el []
                        (Element.text "Your Name")
                    , inputTextWidget model.theme name InputUserName
                    ]

        Nothing ->
            -- Show label and input when Nothing
            Element.column [ spacing 8 ]
                [ Element.el [ Font.bold, paddingEach { top = 0, bottom = 8, left = 0, right = 0 } ]
                    (Element.text "Your Name")
                , inputTextWidget model.theme "" InputUserName
                ]



-- Tools section at the bottom


tools model =
    Element.column
        [ width fill
        , alignBottom
        , Element.paddingXY 16 16
        , Element.spacing 12
        , Border.widthEach { left = 0, right = 0, top = 1, bottom = 0 }
        , Border.color (Element.rgb 0.5 0.5 0.5)
        ]
        [ nameElement model
        , Element.el [ Font.bold, paddingEach { top = 0, bottom = 8, left = 0, right = 0 } ]
            (Element.text "Tools:")
        , foo model
        ]


foo model =
    Input.button
        [ Background.color (Style.buttonBackgroundColor model.theme)
        , Font.color (Style.electricBlueColor model.theme)
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
                (case model.theme of
                    Theme.Light ->
                        "rgb(0, 123, 255)"

                    Theme.Dark ->
                        "rgb(0, 191, 255)"
                )
            )
        , width fill
        ]
        { onPress = Just DownloadScript
        , label = text "Download script"
        }


sidebarButton2 buttonTheme modelTheme msg label =
    Input.button
        [ paddingXY 8 4
        , Background.color
            (if modelTheme == Theme.Light then
                Element.rgb255 255 255 255

             else
                Element.rgb255 48 54 59
            )
        , Font.color
            (if modelTheme == Theme.Light then
                Element.rgb255 50 50 50

             else
                Element.rgb255 150 150 150
            )
        , Element.htmlAttribute
            (Html.Attributes.style "color"
                (case modelTheme of
                    Theme.Light ->
                        "rgb(0, 40, 40)"

                    Theme.Dark ->
                        "rgb(100, 150, 255)"  -- Light blue instead of orange
                )
            )
        , Border.roundEach { topLeft = 0, bottomLeft = 0, topRight = 4, bottomRight = 4 }
        , Border.width
            (if modelTheme == Theme.Light then
                1

             else
                1
            )
        , Border.color
            (if modelTheme == Theme.Light then
                Element.rgba 0.2 0.2 0.2 1.0

             else
                Element.rgba 0.39 0.59 1.0 0.5  -- Light blue border
            )
        , Font.size 12
        , if buttonTheme == modelTheme then
            Font.bold

          else
            Font.extraLight
        , mouseOver
            [ Background.color
                (if modelTheme == Theme.Light then
                    Element.rgb255 240 240 240
                 else
                    Element.rgb255 65 72 78
                )
            , Border.color
                (if modelTheme == Theme.Light then
                    Element.rgba 0.3 0.3 0.3 1.0
                 else
                    Element.rgba 0.39 0.59 1.0 0.7  -- Light blue border on hover
                )
            ]
        , mouseDown
            [ Background.color
                (if modelTheme == Theme.Light then
                    Element.rgb255 220 220 220
                 else
                    Element.rgb255 75 82 88
                )
            , Border.color
                (if modelTheme == Theme.Light then
                    Element.rgba 0.4 0.4 0.4 1.0
                 else
                    Element.rgba 0.39 0.59 1.0 0.9  -- Light blue border on click
                )
            ]
        ]
        { onPress = msg
        , label = Element.text label
        }


sidebarButton theme msg label =
    Input.button
        [ paddingXY 8 4
        , Background.color
            (if theme == Theme.Light then
                Element.rgb255 255 255 255

             else
                Element.rgb255 48 54 59
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
                        "rgb(0, 40, 40)"

                    Theme.Dark ->
                        "rgb(100, 150, 255)"  -- Light blue instead of orange
                )
            )
        , Border.roundEach { topLeft = 0, bottomLeft = 0, topRight = 4, bottomRight = 4 }
        , Border.width
            (if theme == Theme.Light then
                1

             else
                1
            )
        , Border.color
            (if theme == Theme.Light then
                Element.rgba 0.2 0.2 0.2 1.0

             else
                Element.rgba 0.39 0.59 1.0 0.5  -- Light blue border
            )
        , Font.size 12
        , mouseOver
            [ Background.color
                (if theme == Theme.Light then
                    Element.rgb255 240 240 240
                 else
                    Element.rgb255 65 72 78
                )
            , Border.color
                (if theme == Theme.Light then
                    Element.rgba 0.3 0.3 0.3 1.0
                 else
                    Element.rgba 0.39 0.59 1.0 0.7  -- Light blue border on hover
                )
            ]
        , mouseDown
            [ Background.color
                (if theme == Theme.Light then
                    Element.rgb255 220 220 220
                 else
                    Element.rgb255 75 82 88
                )
            , Border.color
                (if theme == Theme.Light then
                    Element.rgba 0.4 0.4 0.4 1.0
                 else
                    Element.rgba 0.39 0.59 1.0 0.9  -- Light blue border on click
                )
            ]
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
