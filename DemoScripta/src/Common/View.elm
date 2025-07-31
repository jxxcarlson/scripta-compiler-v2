module Common.View exposing
    ( view
    , Msg(..)
    )

import Browser.Dom
import Common.Model as Common
import Constants exposing (constants)
import Document exposing (Document)
import Editor
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode
import Keyboard
import List.Extra
import Random
import ScriptaV2.API
import ScriptaV2.Compiler
import ScriptaV2.DifferentialCompiler
import ScriptaV2.Language
import ScriptaV2.Msg exposing (MarkupMsg)
import Style
import Theme
import Time
import Widget


type Msg
    = CommonMsg Common.CommonMsg


view : Common.CommonModel -> Html Msg
view model =
    layoutWith { options = [ Element.focusStyle noFocus ] }
        [ Style.background_ model.theme
        , Element.htmlAttribute (Html.Attributes.style "height" "100vh")
        , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
        ]
        (mainColumn model)


noFocus : FocusStyle
noFocus =
    { borderColor = Nothing
    , backgroundColor = Nothing
    , shadow = Nothing
    }


-- GEOMETRY


appWidth : Common.CommonModel -> Int
appWidth model =
    model.windowWidth


sidebarWidth =
    260


panelWidth : Common.CommonModel -> Int
panelWidth model =
    max 200 ((appWidth model - sidebarWidth - 16 - 4 - 16) // 2)


headerHeight =
    90


mainColumn : Common.CommonModel -> Element Msg
mainColumn model =
    column (Style.background_ model.theme :: mainColumnStyle)
        [ column
            [ width fill
            , height fill
            , Element.htmlAttribute (Html.Attributes.style "display" "flex")
            , Element.htmlAttribute (Html.Attributes.style "flex-direction" "column")
            ]
            [ header model
            , Element.el
                [ width fill
                , height (px 1)
                , Background.color (Style.borderColor model.theme)
                ]
                Element.none
            , row
                [ width fill
                , height fill
                , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
                ]
                [ sidebar model
                , editorPanel model
                , outputPanel model
                ]
            ]
        ]


mainColumnStyle : List (Attribute msg)
mainColumnStyle =
    [ width fill
    , height fill
    ]


-- HEADER


header : Common.CommonModel -> Element Msg
header model =
    row
        [ width fill
        , height (px headerHeight)
        , paddingXY 20 10
        , spacing 20
        ]
        [ titleInput model
        , row [ spacing 10, alignRight ]
            [ documentActions model
            , userNameField model
            , themeToggleButton model
            ]
        ]


titleInput : Common.CommonModel -> Element Msg
titleInput model =
    Input.text
        [ width (px 300)
        , Font.size 18
        , Font.bold
        , Border.width 1
        , Border.color (Style.borderColor model.theme)
        , padding 8
        ]
        { onChange = CommonMsg << Common.UpdateFileName
        , text = model.title
        , placeholder = Just (Input.placeholder [] (text "Document Title"))
        , label = Input.labelHidden "Document Title"
        }


documentActions : Common.CommonModel -> Element Msg
documentActions model =
    row [ spacing 10 ]
        [ Widget.sidebarButton model.theme (Just (CommonMsg Common.CreateNewDocument)) "New"
        , Widget.sidebarButton model.theme (Just (CommonMsg Common.SaveDocument)) "Save"
        , Widget.sidebarButton model.theme (Just (CommonMsg Common.ExportToLaTeX)) "Export"
        ]


userNameField : Common.CommonModel -> Element Msg
userNameField model =
    Input.text
        [ width (px 150)
        , Font.size 14
        , Border.width 1
        , Border.color (Style.borderColor model.theme)
        , padding 8
        ]
        { onChange = CommonMsg << Common.InputUserName
        , text = Maybe.withDefault "" model.userName
        , placeholder = Just (Input.placeholder [] (text "Your name"))
        , label = Input.labelHidden "User Name"
        }


themeToggleButton : Common.CommonModel -> Element Msg
themeToggleButton model =
    Widget.sidebarButton model.theme 
        (Just (CommonMsg Common.ToggleTheme)) 
        (if model.theme == Theme.Dark then "☀️" else "🌙")


-- SIDEBAR


sidebar : Common.CommonModel -> Element Msg
sidebar model =
    if model.showDocumentList then
        column
            [ width (px sidebarWidth)
            , height fill
            , Background.color (Style.rightPanelBackgroundColor model.theme)
            , Border.widthEach { bottom = 0, left = 0, right = 1, top = 0 }
            , Border.color (Style.borderColor model.theme)
            , scrollbarY
            ]
            [ sidebarHeader model
            , documentList model
            ]
    else
        Element.none


sidebarHeader : Common.CommonModel -> Element Msg
sidebarHeader model =
    row
        [ width fill
        , paddingXY 15 10
        , Border.widthEach { bottom = 1, left = 0, right = 0, top = 0 }
        , Border.color (Style.borderColor model.theme)
        ]
        [ el [ Font.size 16, Font.bold ] (text "Documents")
        , Element.el [ alignRight ]
            (Widget.sidebarButton model.theme 
                (Just (CommonMsg Common.ToggleDocumentList)) 
                "×")
        ]


documentList : Common.CommonModel -> Element Msg
documentList model =
    column
        [ width fill
        , height fill
        , padding 10
        , spacing 5
        ]
        (List.map (documentItem model) model.documents)


documentItem : Common.CommonModel -> Document -> Element Msg
documentItem model doc =
    let
        isSelected =
            model.currentDocument
                |> Maybe.map (\current -> current.id == doc.id)
                |> Maybe.withDefault False
    in
    row
        [ width fill
        , padding 10
        , Border.rounded 5
        , if isSelected then
            Background.color (Style.electricBlueColor model.theme)
          else
            Background.color (Style.backgroundColor model.theme)
        , mouseOver
            [ Background.color (Style.buttonBackgroundColor model.theme)
            ]
        , pointer
        , onClick (CommonMsg (Common.LoadDocument doc.id))
        ]
        [ column [ width fill, spacing 2 ]
            [ el [ Font.size 14, Font.semiBold ] (text doc.title)
            , el [ Font.size 12, Font.color (Style.textColor model.theme) ] 
                (text (formatTime doc.modifiedAt))
            ]
        , Element.el [ alignRight ]
            (Widget.sidebarButton model.theme 
                (Just (CommonMsg (Common.DeleteDocument doc.id))) 
                "🗑")
        ]


formatTime : Time.Posix -> String
formatTime time =
    -- Simple time formatting - you might want to use a proper date formatting library
    "Modified recently"


-- EDITOR PANEL


editorPanel : Common.CommonModel -> Element Msg
editorPanel model =
    column
        [ width (px (panelWidth model))
        , height fill
        , padding 10
        ]
        [ editorElement model
        ]


editorElement : Common.CommonModel -> Element Msg
editorElement model =
    Element.html <|
        Html.node "codemirror-editor"
            [ Html.Attributes.id "editor"
            , Html.Attributes.attribute "content" model.sourceText
            , Html.Events.on "content-changed" 
                (Json.Decode.map (CommonMsg << Common.InputText) Html.Events.targetValue)
            ]
            []


-- OUTPUT PANEL


outputPanel : Common.CommonModel -> Element Msg
outputPanel model =
    column
        [ width (px (panelWidth model))
        , height fill
        , padding 20
        , scrollbarY
        , Border.widthEach { bottom = 0, left = 1, right = 0, top = 0 }
        , Border.color (Style.borderColor model.theme)
        ]
        [ renderedContent model
        ]


renderedContent : Common.CommonModel -> Element Msg
renderedContent model =
    column
        [ width fill
        , spacing 10
        ]
        (model.compilerOutput.body |> List.map (Element.map (CommonMsg << Common.Render)))


-- HELPER FUNCTIONS


onClick : msg -> Attribute msg
onClick msg =
    Element.htmlAttribute (Html.Events.onClick msg)


pointer : Attribute msg
pointer =
    Element.htmlAttribute (Html.Attributes.style "cursor" "pointer")