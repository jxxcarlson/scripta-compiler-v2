module Main exposing (main)

import AppData
import Browser
import Browser.Dom
import Browser.Events
import Dict
import Download
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import File.Download
import Html exposing (Html)
import Html.Attributes
import Keyboard
import Render.Export.LaTeX
import Render.Settings exposing (getThemedElementColor)
import ScriptaV2.API
import ScriptaV2.Compiler
import ScriptaV2.DifferentialCompiler
import ScriptaV2.Language
import ScriptaV2.Msg exposing (MarkupMsg)
import Task
import Theme
import Time


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Browser.Events.onResize GotNewWindowDimensions
        , Sub.map KeyMsg Keyboard.subscriptions
        ]


type alias Model =
    { sourceText : String
    , count : Int
    , windowWidth : Int
    , windowHeight : Int
    , currentLanguage : ScriptaV2.Language.Language
    , selectId : String
    , theme : Theme.Theme
    , pressedKeys : List Keyboard.Key
    , currentTime : Time.Posix
    , editRecord : ScriptaV2.DifferentialCompiler.EditRecord
    }


textColor : Theme.Theme -> Element.Color
textColor theme =
    getThemedElementColor .text (Theme.mapTheme theme)


headeBackgrounColor : Theme.Theme -> Element.Color
headeBackgrounColor theme =
    getThemedElementColor .text (Theme.mapTheme theme)


backgroundColor : Theme.Theme -> Element.Color
backgroundColor theme =
    getThemedElementColor .background (Theme.mapTheme theme)


type Msg
    = NoOp
    | InputText String
    | Render MarkupMsg
    | GotNewWindowDimensions Int Int
    | KeyMsg Keyboard.Msg
    | ToggleTheme


type alias Flags =
    { window : { windowWidth : Int, windowHeight : Int } }


setSourceText currentLanguage =
    AppData.defaultDocumentText


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        normalizedTex =
            normalize AppData.defaultDocumentText
    in
    ( { sourceText = normalizedTex
      , count = 1
      , windowWidth = flags.window.windowWidth
      , windowHeight = flags.window.windowHeight
      , currentLanguage = ScriptaV2.Language.EnclosureLang
      , selectId = "@InitID"
      , theme = Theme.Light
      , pressedKeys = []
      , currentTime = Time.millisToPosix 0
      , editRecord = ScriptaV2.DifferentialCompiler.init Dict.empty ScriptaV2.Language.EnclosureLang normalizedTex
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
            let
                normalizedText =
                    normalize str
            in
            ( { model
                | sourceText = normalizedText
                , count = model.count + 1
                , editRecord =
                    ScriptaV2.DifferentialCompiler.update model.editRecord normalizedText
              }
            , Cmd.none
            )

        KeyMsg keyMsg ->
            let
                pressedKeys =
                    Keyboard.update keyMsg model.pressedKeys

                cmd =
                    if List.member Keyboard.Control pressedKeys && List.member (Keyboard.Character "T") pressedKeys then
                        Task.perform (always ToggleTheme) (Task.succeed ())

                    else if List.member Keyboard.Control pressedKeys && List.member (Keyboard.Character "E") pressedKeys then
                        let
                            settings =
                                Render.Settings.makeSettings (Theme.mapTheme model.theme) "-" Nothing 1.0 model.windowWidth Dict.empty

                            exportText =
                                Render.Export.LaTeX.export model.currentTime settings model.editRecord.tree
                        in
                        File.Download.string "out.tex" "application/x-latex" exportText

                    else if List.member Keyboard.Control pressedKeys && List.member (Keyboard.Character "R") pressedKeys then
                        let
                            settings =
                                Render.Settings.makeSettings (Theme.mapTheme model.theme) "-" Nothing 1.0 model.windowWidth Dict.empty

                            exportText =
                                Render.Export.LaTeX.rawExport settings model.editRecord.tree
                        in
                        File.Download.string "out.tex" "application/x-latex" exportText

                    else
                        Cmd.none
            in
            ( { model
                | pressedKeys =
                    if List.length pressedKeys > 1 then
                        []

                    else
                        pressedKeys
                , count = model.count + 1
              }
            , cmd
            )

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

        ToggleTheme ->
            let
                newTheme =
                    case model.theme of
                        Theme.Light ->
                            Theme.Dark

                        Theme.Dark ->
                            Theme.Light
            in
            ( { model | theme = newTheme }, Cmd.none )



--
-- VIEW
--


background_ model =
    Background.color <| getThemedElementColor .background (Theme.mapTheme model.theme)


offsetBackground_ model =
    Background.color <| getThemedElementColor .offsetBackground (Theme.mapTheme model.theme)


view : Model -> Html Msg
view model =
    layoutWith { options = [ Element.focusStyle noFocus ] }
        (background_ model :: [])
        (mainColumn model)



-- GEOMETRY


appWidth : Model -> Int
appWidth model =
    model.windowWidth


appHeight : Model -> Int
appHeight model =
    model.windowHeight - headerHeight


sidebarWidth =
    200


marginWidth =
    16


panelWidth : Model -> Int
panelWidth model =
    (appWidth model - sidebarWidth - 2 * marginWidth) // 2


panelHeight : Model -> Attribute msg
panelHeight model =
    height (px <| model.windowHeight - 100)


margin =
    { left = 0, right = 0, top = 2, bottom = 0, between = 2 }


headerHeight =
    18


mainColumn : Model -> Element Msg
mainColumn model =
    column (background_ model :: mainColumnStyle)
        [ column [ width (px <| appWidth model - 20), height (px <| appHeight model), clipY ]
            [ header model
            , row [ spacing margin.between, centerX ]
                [ inputText model
                , displayRenderedText model |> Element.map Render
                , sidebar model
                ]
            ]
        ]


sidebar : Model -> Element.Element msg
sidebar model =
    Element.column [ Element.paddingEach { top = 16, bottom = 0, left = 0, right = 0 } ]
        [ Element.column
            [ Element.width <| px <| sidebarWidth
            , panelHeight model
            , Font.color (textColor model.theme)
            , Element.paddingXY 16 16
            , Element.spacing 6
            , Font.size 14
            , background_ model --            , Background.color <| Render.Settings.getThemedElementColor .background (Theme.mapTheme model.theme)
            ]
            [ Element.el [ Element.paddingEach { left = 0, right = 0, top = 0, bottom = 12 } ]
                (Download.downloadButton "Download script" "process_images.sh" "application/x-sh" AppData.processImagesText)
            , Element.text "Bare bones:"
            , Element.text "ctrl-T: toggle theme"
            , Element.text "ctrl-E: export to LaTeX"
            , Element.text "ctrl-R: export to Raw LaTeX"
            , Element.text "Alas: no way to save docs"
            ]
        ]


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
        [ column
            [ spacing 4
            , background_ model
            , width <| px <| panelWidth model -- width (px <| (panelWidth model - 0 * innerMarginWidth))
            , panelHeight model
            , htmlId "rendered-text"
            , scrollbarY
            , centerX
            , Font.color (textColor model.theme)

            --            , Background.color (Element.rgba 0.8 0.8 0.95 1.0)
            ]
            [ container compile model ]
        ]


container : (a -> List (Element msg)) -> a -> Element msg
container f model_ =
    Element.column [ Element.centerX ] (f model_)


compile : Model -> List (Element MarkupMsg)
compile model =
    ScriptaV2.API.compileStringWithTitle
        (Theme.mapTheme model.theme)
        "Example"
        { filter = ScriptaV2.Compiler.SuppressDocumentBlocks
        , lang = ScriptaV2.Language.EnclosureLang
        , docWidth = panelWidth model - 200 --5 * xPadding
        , editCount = model.count
        , selectedId = model.selectId
        , idsOfOpenNodes = []
        }
        model.sourceText


htmlId str =
    Element.htmlAttribute (Html.Attributes.id str)


header model =
    Element.row
        [ Element.height <| Element.px <| 90
        , Element.width <| Element.px <| (appWidth model - 2 * marginWidth)
        , Element.spacing 32
        , Element.centerX
        , paddingEach { left = 0, right = 0, top = 0, bottom = 12 }
        , Font.color (getThemedElementColor .text (Theme.mapTheme model.theme))
        , Background.color (getThemedElementColor .background (Theme.mapTheme model.theme))
        ]
        [ Element.el []
            (Element.text "Scripta Live: Sample Doc")
        ]


innerMarginWidth =
    16


inputText : Model -> Element Msg
inputText model =
    Input.multiline
        [ width (px <| (panelWidth model - 2 * innerMarginWidth))
        , height (px <| headerHeight)
        , panelHeight model
        , Font.size 14
        , Element.alignTop
        , Font.color (textColor model.theme)
        , Background.color (backgroundColor model.theme)
        ]
        { onChange = InputText
        , text = model.sourceText
        , placeholder = Nothing
        , label = Input.labelAbove [] <| el [] (text "")
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



-- HELPER FUNCTIONS


normalize : String -> String
normalize input =
    input
        |> String.lines
        |> List.map String.trim
        |> String.join "\n"


scrollToTop : Cmd Msg
scrollToTop =
    Browser.Dom.setViewport 0 0 |> Task.perform (\() -> NoOp)


jumpToTopOf : String -> Cmd Msg
jumpToTopOf id =
    Browser.Dom.getViewportOf id
        |> Task.andThen (\info -> Browser.Dom.setViewportOf id 0 0)
        |> Task.attempt (\_ -> NoOp)
