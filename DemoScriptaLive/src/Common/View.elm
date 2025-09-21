module Common.View exposing (view)

import Browser.Dom
import Common.Model as Common
import Config
import Constants exposing (constants)
import Document exposing (Document)
import Editor
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Keyed
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode
import Json.Encode
import Keyboard
import List.Extra
import Random
import ScriptaV2.API
import ScriptaV2.Compiler
import ScriptaV2.DifferentialCompiler
import ScriptaV2.Language
import ScriptaV2.Msg exposing (MarkupMsg)
import Style
import Sync
import Task
import Theme
import Time
import Widget


-- VIEW


view : (Common.CommonMsg -> msg) -> (MarkupMsg -> msg) -> Common.CommonModel -> Html msg
view toMsg renderMsg model =
    layoutWith { options = [ Element.focusStyle noFocus ] }
        [ Style.background_ model.theme
        , Element.htmlAttribute (Html.Attributes.style "height" "100vh")
        , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
        ]
        (mainColumn toMsg renderMsg model)


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


mainColumn : (Common.CommonMsg -> msg) -> (MarkupMsg -> msg) -> Common.CommonModel -> Element msg
mainColumn toMsg renderMsg model =
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
                , Element.htmlAttribute (Html.Attributes.style "flex" "1")
                , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
                ]
                [ editorView toMsg model
                , Element.el
                    [ width (px 1)
                    , height fill
                    , Background.color (Style.borderColor model.theme)
                    ]
                    Element.none
                , displayRenderedText renderMsg model
                , Element.el
                    [ width (px 1)
                    , height fill
                    , Background.color (Style.borderColor model.theme)
                    ]
                    Element.none
                , sidebar toMsg model
                ]
            ]
        ]


sidebar : (Common.CommonMsg -> msg) -> Common.CommonModel -> Element msg
sidebar toMsg model =
    Element.column
        [ Element.width <| px <| sidebarWidth
        , height fill
        , Font.color (Style.textColor model.theme)
        , Font.size 14
        , Style.rightPanelBackground_ model.theme
        , Style.forceColorStyle model.theme
        , Border.widthEach { left = 1, right = 0, top = 0, bottom = 0 }
        , Border.color (Element.rgb 0.5 0.5 0.5)
        ]
        [ -- Documents section that can grow
          Element.column
            Style.innerColumn
            [ -- User name section
              nameElement toMsg model
            , Element.el [ Element.paddingXY 0 8, Element.width Element.fill ] (Element.text "")
            , toggleTheme toMsg model
            , crudButtons toMsg model
            , exportStuff toMsg model
            , Element.el [ Element.paddingXY 0 8, Element.width Element.fill ] (Element.text "")
            , Element.column
                [ spacing 4
                , width fill
                , height (px 300)
                , scrollbarY
                , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
                , Element.htmlAttribute (Html.Attributes.style "overflow-x" "hidden")
                ]
                (List.map (documentItem toMsg model) (List.sortBy (\d -> d.title) model.documents))
            ]
        ]


crudButtons : (Common.CommonMsg -> msg) -> Common.CommonModel -> Element msg
crudButtons toMsg model =
    Element.row [ spacing 8, width fill ]
        [ newButton toMsg model
        , saveButton toMsg model
        ]


newButton : (Common.CommonMsg -> msg) -> Common.CommonModel -> Element msg
newButton toMsg model =
    Widget.sidebarButton model.theme (Just (toMsg Common.CreateNewDocument)) "New"


saveButton : (Common.CommonMsg -> msg) -> Common.CommonModel -> Element msg
saveButton toMsg model =
    Widget.sidebarButton model.theme (Just (toMsg Common.SaveDocument)) "Save"


exportStuff : (Common.CommonMsg -> msg) -> Common.CommonModel -> Element msg
exportStuff toMsg model =
    Element.column [ spacing 4, width fill ]
        [ Element.el [ Font.bold ] (Element.text "Export")
        , case model.printingState of
            Common.PrintWaiting ->
                Element.row [ spacing 4, width fill ]
                    [ Widget.sidebarButton model.theme (Just (toMsg Common.PrintToPDF)) "PDF"
                    , Widget.sidebarButton model.theme (Just (toMsg Common.ExportToLaTeX)) "LaTeX"
                    , Widget.sidebarButton model.theme (Just (toMsg Common.ExportToRawLaTeX)) "Raw LaTeX"
                    ]

            Common.PrintProcessing ->
                Element.el [ Font.size 14, padding 8 ] (Element.text "Processing...")

            Common.PrintReady ->
                Element.column [ spacing 4, width fill ]
                    [ Element.newTabLink
                        [ Font.size 14
                        , Font.color (Element.rgb 0 0 0.8)
                        ]
                        { url = Config.pdfServUrl ++ extractFileName model.pdfLink
                        , label = Element.text "Click for PDF"
                        }
                    , Element.row [ spacing 4, width fill ]
                        [ Widget.sidebarButton model.theme (Just (toMsg Common.PrintToPDF)) "PDF"
                        , Widget.sidebarButton model.theme (Just (toMsg Common.ExportToLaTeX)) "LaTeX"
                        , Widget.sidebarButton model.theme (Just (toMsg Common.ExportToRawLaTeX)) "Raw LaTeX"
                        ]
                    ]
        ]


extractFileName : String -> String
extractFileName pdfLink =
    pdfLink
        |> String.split "/"
        |> List.reverse
        |> List.head
        |> Maybe.withDefault ""


documentItem : (Common.CommonMsg -> msg) -> Common.CommonModel -> Document -> Element msg
documentItem toMsg model doc =
    let
        isActive =
            case model.currentDocument of
                Just currentDoc ->
                    currentDoc.id == doc.id

                Nothing ->
                    False

        borderAttrs =
            if isActive then
                [ Border.width 1
                , Border.color
                    (case model.theme of
                        Theme.Light ->
                            Element.rgb255 64 64 64

                        -- Dark gray for light mode
                        Theme.Dark ->
                            Element.rgb255 220 220 220
                     -- Almost white for dark mode
                    )
                ]

            else
                []
    in
    Element.row
        ([ width fill
         , padding 8
         , Border.rounded 4
         , spacing 8
         , mouseOver [ Background.color (Element.rgba 0.5 0.5 0.5 0.2) ]
         ]
            ++ borderAttrs
        )
        [ Input.button
            [ width fill ]
            { onPress = Just (toMsg (Common.LoadDocument doc.id))
            , label =
                Element.column [ spacing 2 ]
                    [ Element.el [ Font.size 13 ] (text doc.title)
                    , Element.el
                        [ Font.size 11
                        , Font.color
                            (case model.theme of
                                Theme.Light ->
                                    Element.rgb 0.4 0.4 0.4

                                -- Darker gray for light mode
                                Theme.Dark ->
                                    Element.rgb 0.7 0.7 0.7
                             -- Original lighter gray for dark mode
                            )
                        ]
                        (text <| Style.formatRelativeTime model.currentTime doc.modifiedAt)
                    ]
            }
        , Input.button
            [ Font.color (Element.rgb 1 0.5 0.5)
            , mouseOver [ Font.color (Element.rgb 1 0.3 0.3) ]
            , mouseDown [ Font.color (Element.rgb 1 0.2 0.2) ]
            ]
            { onPress = Just (toMsg (Common.DeleteDocument doc.id))
            , label = text "×"
            }
        ]


noFocus : Element.FocusStyle
noFocus =
    { borderColor = Nothing
    , backgroundColor = Nothing
    , shadow = Nothing
    }


displayRenderedText : (MarkupMsg -> msg) -> Common.CommonModel -> Element msg
displayRenderedText renderMsg model =
    Element.el
        [ alignTop
        , height (px (max 100 (model.windowHeight - headerHeight - 1))) -- Match editor height
        , width (px <| panelWidth model)
        , Element.clipY
        , Element.scrollbarY
        , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
        , Element.htmlAttribute (Html.Attributes.style "overflow-x" "hidden")
        , Style.htmlId "rendered-text-container"
        ]
        (Element.Keyed.column
            [ Font.size 14
            , padding 16
            , spacing 24
            , width fill
            , Style.htmlId "rendered-text"
            , Style.background_ model.theme
            , alignTop
            , centerX
            , Font.color (Style.textColor model.theme)
            , Style.forceColorStyle model.theme
            ]
            [ ( String.fromInt model.count
              , container model (model.compilerOutput.body |> List.map (Element.map renderMsg))
              )
            ]
        )


container : Common.CommonModel -> List (Element msg) -> Element msg
container model elements_ =
    Element.column (Style.background_ model.theme :: [ Element.centerX, spacing 24 ]) elements_


header : Common.CommonModel -> Element msg
header model =
    Element.row
        [ Element.height <| Element.px <| headerHeight
        , Element.width <| Element.fill
        , Element.spacing 32
        , Element.centerX
        , Background.color (Style.backgroundColor model.theme)
        , paddingEach { left = 18, right = 18, top = 0, bottom = 0 }
        , Style.forceColorStyle model.theme
        , Border.widthEach { left = 0, right = 0, top = 0, bottom = 1 }
        , Border.color (Style.borderColor model.theme)
        ]
        [ Element.el
            [ centerX
            , centerY
            , Font.color (Style.debugTextColor model.theme)
            , Font.size 18
            , Font.semiBold
            , Style.forceColorStyle model.theme
            ]
            (Element.text model.title)
        ]


-- STYLE


mainColumnStyle =
    [ width fill
    , height fill
    ]


-- EDITOR


editorView : (Common.CommonMsg -> msg) -> Common.CommonModel -> Element msg
editorView toMsg model =
    Element.Keyed.el
        [ -- RECEIVE INFORMATION FROM CODEMIRROR
          Element.htmlAttribute (onSelectionChange toMsg) -- receive info from codemirror
        , Element.alignTop
        , Element.htmlAttribute (onTextChange toMsg) -- receive info from codemirror
        , Style.htmlId "editor-here"
        , Element.height (Element.px <| editorHeight model)
        , Element.width (Element.px <| panelWidth model)
        , Background.color (Element.rgb255 0 68 85)
        , Font.color (Element.rgb 0.85 0.85 0.85)
        , Font.size 12
        ]
        ( stringOfBool False
          -- Keep the same key always
        , Element.html
            (Html.node "codemirror-editor"
                [ -- SEND INFORMATION TO CODEMIRROR
                  if model.loadDocumentIntoEditor then
                    Html.Attributes.attribute "load" model.sourceText

                  else
                    Html.Attributes.attribute "noOp" "true"
                , Html.Attributes.attribute "text" model.initialText
                , Html.Attributes.attribute "editordata" (encodeEditorData model.editorData)
                , case model.maybeSelectionOffset of
                    Nothing ->
                        Html.Attributes.attribute "noOp" "true"

                    Just refinedSelection ->
                        Html.Attributes.attribute "refineselection" (encodeRefinedSelection refinedSelection model.editorData)
                , Html.Attributes.attribute "selection" (stringOfBool model.doSync)
                ]
                []
            )
        )


editorHeight : Common.CommonModel -> Int
editorHeight model =
    max 100 (model.windowHeight - headerHeight - 1)


-- Editor event handlers


onSelectionChange : (Common.CommonMsg -> msg) -> Html.Attribute msg
onSelectionChange toMsg =
    Html.Events.on "selected-text"
        (Json.Decode.field "detail" Json.Decode.string
            |> Json.Decode.map (toMsg << Common.SelectedText)
        )


onTextChange : (Common.CommonMsg -> msg) -> Html.Attribute msg
onTextChange toMsg =
    Html.Events.on "text-change"
        (Json.Decode.map2
            (\position source ->
                toMsg (Common.InputText2 { position = position, source = source })
            )
            (Json.Decode.at [ "detail", "position" ] Json.Decode.int)
            (Json.Decode.at [ "detail", "source" ] Json.Decode.string)
        )


-- Editor utility functions


encodeEditorData : { begin : Int, end : Int } -> String
encodeEditorData { begin, end } =
    Json.Encode.object
        [ ( "begin", Json.Encode.int begin )
        , ( "end", Json.Encode.int end )
        ]
        |> Json.Encode.encode 2


encodeRefinedSelection : { focusOffset : Int, anchorOffset : Int, text : String } -> { begin : Int, end : Int } -> String
encodeRefinedSelection { focusOffset, anchorOffset, text } { begin, end } =
    Json.Encode.object
        [ ( "focusOffset", Json.Encode.int focusOffset )
        , ( "anchorOffset", Json.Encode.int anchorOffset )
        , ( "text", Json.Encode.string text )
        , ( "begin", Json.Encode.int begin )
        , ( "end", Json.Encode.int end )
        ]
        |> Json.Encode.encode 2


stringOfBool : Bool -> String
stringOfBool b =
    if b then
        "true"

    else
        "false"


-- WIDGET WRAPPERS


nameElement : (Common.CommonMsg -> msg) -> Common.CommonModel -> Element msg
nameElement toMsg model =
    case model.userName of
        Just name ->
            if String.trim name /= "" then
                -- Show just the username when it's filled
                inputTextWidget model.theme name (toMsg << Common.InputUserName)

            else
                -- Show label and input when empty
                Element.column [ spacing 8 ]
                    [ Element.el 
                        [ Font.size 14
                        , Font.color (Style.textColor model.theme)
                        ] 
                        (text "Your name:")
                    , inputTextWidget model.theme "" (toMsg << Common.InputUserName)
                    ]

        Nothing ->
            -- Show label and input when no username
            Element.column [ spacing 8 ]
                [ Element.el 
                    [ Font.size 14
                    , Font.color (Style.textColor model.theme)
                    ] 
                    (text "Your name:")
                , inputTextWidget model.theme "" (toMsg << Common.InputUserName)
                ]


inputTextWidget : Theme.Theme -> String -> (String -> msg) -> Element msg
inputTextWidget theme value onChange =
    Input.text
        [ width fill
        , height (px 30)
        , Font.size 14
        , Border.width 1
        , Border.color
            (case theme of
                Theme.Light ->
                    Element.rgb 0.7 0.7 0.7

                Theme.Dark ->
                    Element.rgb 0.3 0.3 0.3
            )
        , Border.rounded 4
        , Background.color
            (case theme of
                Theme.Light ->
                    Element.rgb 1 1 1

                Theme.Dark ->
                    Element.rgb 0.1 0.1 0.1
            )
        , Font.color
            (case theme of
                Theme.Light ->
                    Element.rgb 0 0 0

                Theme.Dark ->
                    Element.rgb 0.9 0.9 0.9
            )
        , padding 6
        ]
        { onChange = onChange
        , text = value
        , placeholder = Nothing
        , label = Input.labelHidden "User name"
        }


toggleTheme : (Common.CommonMsg -> msg) -> Common.CommonModel -> Element msg
toggleTheme toMsg model =
    Element.row
        [ Border.width 1
        , Border.color (Element.rgb 0.7 0.7 0.7)
        , Border.rounded 4
        , height (px 30)
        ]
        [ if model.theme == Theme.Dark then
            sidebarButton2 model.theme Theme.Dark (Just (toMsg Common.ToggleTheme)) "Dark"

          else
            Widget.sidebarButton model.theme (Just (toMsg Common.ToggleTheme)) "Dark"
        , if model.theme == Theme.Light then
            sidebarButton2 model.theme Theme.Light (Just (toMsg Common.ToggleTheme)) "Light"

          else
            Widget.sidebarButton model.theme (Just (toMsg Common.ToggleTheme)) "Light"
        ]


sidebarButton2 : Theme.Theme -> Theme.Theme -> Maybe msg -> String -> Element msg
sidebarButton2 modelTheme buttonTheme msg label =
    Input.button
        [ paddingXY 12 6
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
                        "rgb(255, 165, 0)"
                )
            )
        , Border.roundEach { topLeft = 0, bottomLeft = 0, topRight = 4, bottomRight = 4 }
        , Border.width 1
        , Border.color
            (if modelTheme == Theme.Light then
                Element.rgba 0.2 0.2 0.2 1.0

             else
                Element.rgba 1.0 0.647 0.0 0.5
            )
        , Font.size 16
        , if buttonTheme == modelTheme then
            Font.bold

          else
            Font.extraLight
        ]
        { onPress = msg
        , label = Element.text label
        }