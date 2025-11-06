module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Events
import Data.M
import Data.MicroLaTeX
import Data.XMarkdown
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes
import List.Extra
import ScriptaV2.Compiler
import ScriptaV2.Language
import ScriptaV2.Msg exposing (MarkupMsg)
import ScriptaV2.Types exposing (Filter(..), defaultCompilerParameters)
import Task


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Browser.Events.onResize GotNewWindowDimensions


type alias Model =
    { sourceText : String
    , count : Int
    , windowWidth : Int
    , windowHeight : Int
    , currentLanguage : ScriptaV2.Language.Language
    , selectId : String
    , idsOfOpenNodes : List String
    }


type Msg
    = NoOp
    | InputText String
    | Render MarkupMsg
    | GotNewWindowDimensions Int Int
    | SetLanguage ScriptaV2.Language.Language


type alias Flags =
    { window : { windowWidth : Int, windowHeight : Int } }


setSourceText currentLanguage =
    case currentLanguage of
        ScriptaV2.Language.ScriptaLang ->
            Data.M.text

        ScriptaV2.Language.MiniLaTeXLang ->
            Data.MicroLaTeX.text

        ScriptaV2.Language.SMarkdownLang ->
            Data.XMarkdown.text

        ScriptaV2.Language.MarkdownLang ->
            Data.XMarkdown.text


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { sourceText = Data.MicroLaTeX.text
      , count = 0
      , windowWidth = flags.window.windowWidth
      , windowHeight = flags.window.windowHeight
      , currentLanguage = ScriptaV2.Language.MiniLaTeXLang
      , selectId = "@InitID"
      , idsOfOpenNodes = []
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotNewWindowDimensions width height ->
            ( { model | windowWidth = width, windowHeight = height }, Cmd.none )

        InputText str ->
            ( { model
                | sourceText = str
                , count = model.count + 1
              }
            , Cmd.none
            )

        SetLanguage lang ->
            ( { model | currentLanguage = lang, sourceText = setSourceText lang }, Cmd.none )

        Render msg_ ->
            case msg_ of
                ScriptaV2.Msg.ToggleTOCNodeID id ->
                    let
                        idsOfOpenNodes =
                            if String.left 2 id == "@-" then
                                if List.member id model.idsOfOpenNodes then
                                    List.Extra.remove id model.idsOfOpenNodes

                                else
                                    id :: model.idsOfOpenNodes

                            else
                                model.idsOfOpenNodes
                    in
                    ( { model | idsOfOpenNodes = idsOfOpenNodes |> Debug.log ("@@::idsOfOpenNodes, " ++ id) }, Cmd.none )

                ScriptaV2.Msg.SelectId id ->
                    if id == "title" then
                        ( { model | selectId = id }, jumpToTopOf "rendered-text" )

                    else
                        ( { model | selectId = id }, Cmd.none )

                ScriptaV2.Msg.SendLineNumber line ->
                    ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )



--
-- VIEW
--


view : Model -> Html Msg
view model =
    layoutWith { options = [ Element.focusStyle noFocus ] }
        [ bgGray 0.2 ]
        (mainColumn model)


mainColumn : Model -> Element Msg
mainColumn model =
    let
        params =
            { defaultCompilerParameters
                | lang = model.currentLanguage
                , docWidth = rhPanelWidth model - 3 * xPadding
                , editCount = model.count
                , selectedId = "selectedId"
                , idsOfOpenNodes = model.idsOfOpenNodes
                , filter = NoFilter
            }

        compilerOutput =
            ScriptaV2.Compiler.compile params (String.lines model.sourceText)
    in
    column mainColumnStyle
        [ column [ width (px <| appWidth model), height (px <| appHeight model), clipY ]
            [ title "Compiler Demo"
            , header model
            , row [ spacing margin.between, centerX, width (px <| model.windowWidth - 50 - margin.left - margin.right) ]
                [ inputText model
                , displayRenderedText model compilerOutput |> Element.map Render
                , displayToc model compilerOutput |> Element.map Render
                ]
            ]
        ]


languageToString : ScriptaV2.Language.Language -> String
languageToString lang =
    case lang of
        ScriptaV2.Language.ScriptaLang ->
            "M"

        ScriptaV2.Language.SMarkdownLang ->
            "SMarkdown"

        ScriptaV2.Language.MiniLaTeXLang ->
            "MicroLaTeX"

        ScriptaV2.Language.MarkdownLang ->
            "Markdown"



-- Buttons


buttonBackground currentLanguage targetLanguage =
    if currentLanguage == targetLanguage then
        Background.color <| Element.rgb255 161 8 8

    else
        Background.color <| Element.rgb255 20 20 20


languageButton currentLanguage targetLanguage =
    Input.button [ buttonBackground currentLanguage targetLanguage ]
        { onPress = Just <| SetLanguage targetLanguage
        , label =
            Element.el
                [ buttonBackground currentLanguage targetLanguage
                , Font.color (Element.rgb 1 1 1)
                , Font.size 14
                , Element.paddingXY 8 8
                , Element.height (Element.px 32)
                ]
                (Element.text <| languageToString targetLanguage)
        }


noFocus : Element.FocusStyle
noFocus =
    { borderColor = Nothing
    , backgroundColor = Nothing
    , shadow = Nothing
    }


title : String -> Element msg
title str =
    row [ centerX, Font.bold, fontGray 0.9 ] [ text str ]



-- VIEWS


displayRenderedText model compilerOutput =
    column [ spacing 8, Font.size 14 ]
        [ el [ fontGray 0.9 ] (text "Rendered Text")
        , column
            [ spacing 12
            , Background.color (Element.rgb 1.0 1.0 1.0)
            , width (px <| panelWidth model)
            , panelHeight model
            , paddingXY 16 32
            , htmlId "rendered-text"
            , scrollbarY
            ]
            compilerOutput.body

        -- (ScriptaV2.Compiler.view (panelWidth model) compilerOutput)
        ]


displayToc model compilerOutput =
    column [ spacing 8, Font.size 14 ]
        [ el [ fontGray 0.9 ] (text "Table of Contents")
        , column
            [ spacing 4
            , Background.color (Element.rgb 1.0 1.0 1.0)
            , width (px <| tocWidth)
            , panelHeight model
            , paddingXY 16 32
            , htmlId "toc"
            , scrollbarY
            ]
            compilerOutput.toc
        ]


htmlId str =
    Element.htmlAttribute (Html.Attributes.id str)


header model =
    Element.row [ Element.spacing 32, Element.centerX, paddingEach { left = 0, right = 0, top = 0, bottom = 12 } ]
        [ languageButton model.currentLanguage ScriptaV2.Language.ScriptaLang
        , languageButton model.currentLanguage ScriptaV2.Language.MiniLaTeXLang
        , languageButton model.currentLanguage ScriptaV2.Language.SMarkdownLang
        ]


inputText : Model -> Element Msg
inputText model =
    Input.multiline [ width (px <| lhPanelWidth model), panelHeight model, Font.size 14 ]
        { onChange = InputText
        , text = model.sourceText
        , placeholder = Nothing
        , label = Input.labelAbove [ fontGray 0.9 ] <| el [] (text "Source text")
        , spellcheck = False
        }



-- GEOMETRY


appWidth : Model -> Int
appWidth model =
    model.windowWidth


appHeight : Model -> Int
appHeight model =
    model.windowHeight - headerHeight


panelWidth : Model -> Int
panelWidth model =
    (appWidth model - (margin.left + margin.right + margin.between)) // 2


lhPanelWidth : Model -> Int
lhPanelWidth model =
    panelWidth model - tocWidth


rhPanelWidth : Model -> Int
rhPanelWidth model =
    panelWidth model - 80


tocWidth =
    200


panelHeight : Model -> Attribute msg
panelHeight model =
    height (px <| appHeight model - margin.bottom - margin.top)


margin =
    { left = 20, right = 20, top = 20, bottom = 60, between = 20 }


paddingZero =
    { left = 0, right = 0, top = 0, bottom = 0 }


xPadding =
    16


headerHeight =
    40



-- Helpers and Constants


fontGray g =
    Font.color (Element.rgb g g g)


bgGray g =
    Background.color (Element.rgb g g g)


mainColumnStyle =
    [ centerX
    , centerY
    , bgGray 0.4
    , paddingXY 20 20
    ]


scrollToTop : Cmd Msg
scrollToTop =
    Browser.Dom.setViewport 0 0 |> Task.perform (\() -> NoOp)


jumpToTopOf : String -> Cmd Msg
jumpToTopOf id =
    Browser.Dom.getViewportOf id
        |> Task.andThen (\info -> Browser.Dom.setViewportOf id 0 0)
        |> Task.attempt (\_ -> NoOp)
