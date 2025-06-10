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
import ScriptaV2.API
import ScriptaV2.Compiler
import ScriptaV2.Language
import ScriptaV2.Msg exposing (MarkupMsg)
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
        ScriptaV2.Language.EnclosureLang ->
            Data.M.text

        ScriptaV2.Language.MicroLaTeXLang ->
            Data.MicroLaTeX.text

        ScriptaV2.Language.SMarkdownLang ->
            Data.XMarkdown.text


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { sourceText = Data.MicroLaTeX.text
      , count = 1
      , windowWidth = flags.window.windowWidth
      , windowHeight = flags.window.windowHeight
      , currentLanguage = ScriptaV2.Language.MicroLaTeXLang
      , selectId = "@InitID"
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



-- GEOMETRY


appWidth : Model -> Int
appWidth model =
    model.windowWidth


appHeight : Model -> Int
appHeight model =
    model.windowHeight - headerHeight


tocWidth =
    250


panelWidth : Model -> Int
panelWidth model =
    (appWidth model - tocWidth - (margin.left + margin.right + 2 * margin.between)) // 2


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


mainColumn : Model -> Element Msg
mainColumn model =
    column mainColumnStyle
        [ column [ width (px <| appWidth model), height (px <| appHeight model), clipY ]
            [ header model
            , row [ spacing margin.between, centerX ]
                [ inputText model
                , displayRenderedText model |> Element.map Render
                ]
            ]
        ]


type Language
    = MLang
    | XMarkdownLang
    | MicroLaTeXLang


languageToString : ScriptaV2.Language.Language -> String
languageToString lang =
    case lang of
        ScriptaV2.Language.EnclosureLang ->
            "Enclosure"

        ScriptaV2.Language.SMarkdownLang ->
            "SMarkdown"

        ScriptaV2.Language.MicroLaTeXLang ->
            "MicroLaTeX"


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


displayRenderedText : Model -> Element MarkupMsg
displayRenderedText model =
    column [ spacing 8, Font.size 14 ]
        [ el [ fontGray 0.9 ] (text "Rendered Text")
        , column
            [ spacing 4
            , Background.color (Element.rgb 1.0 1.0 1.0)
            , width (px <| panelWidth model)
            , panelHeight model
            , paddingXY 16 32
            , htmlId "rendered-text"
            , scrollbarY
            ]
            (ScriptaV2.API.compile
                { filter = ScriptaV2.Compiler.NoFilter
                , lang = model.currentLanguage
                , docWidth = panelWidth model - 3 * xPadding
                , editCount = model.count
                , selectedId = model.selectId
                , idsOfOpenNodes = []
                }
                (String.lines model.sourceText)
            )
        ]



--type alias CompilerParameters =
--    { lang : Language
--    , docWidth : Int
--    , editCount : Int
--    , selectedId : String
--    , idsOfOpenNodes : List String
--    , filter : Filter
--    }


htmlId str =
    Element.htmlAttribute (Html.Attributes.id str)


header model =
    Element.row [ Element.spacing 32, Element.centerX, paddingEach { left = 0, right = 0, top = 0, bottom = 12 } ]
        [ Element.el [ Font.color (Element.rgb 1 1 1) ] (Element.text "Compiler Demo 1")
        , languageButton model.currentLanguage ScriptaV2.Language.EnclosureLang
        , languageButton model.currentLanguage ScriptaV2.Language.MicroLaTeXLang
        , languageButton model.currentLanguage ScriptaV2.Language.SMarkdownLang
        ]


inputText : Model -> Element Msg
inputText model =
    Input.multiline [ width (px <| panelWidth model), panelHeight model, Font.size 14 ]
        { onChange = InputText
        , text = model.sourceText
        , placeholder = Nothing
        , label = Input.labelAbove [ fontGray 0.9 ] <| el [] (text "Source text")
        , spellcheck = False
        }


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
