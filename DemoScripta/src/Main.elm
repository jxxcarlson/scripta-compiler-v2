module Main exposing (main)

import AppData
import Browser
import Browser.Dom
import Browser.Events
import Dict
import Download
import Element exposing (..)
import Element.Background as Background
import Element.Border
import Element.Font as Font
import Element.Input as Input
import File.Download
import Generic.Compiler
import Html exposing (Html)
import Html.Attributes
import Keyboard
import List.Extra
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
    { displaySettings : Generic.Compiler.DisplaySettings
    , sourceText : String
    , count : Int
    , windowWidth : Int
    , windowHeight : Int
    , currentLanguage : ScriptaV2.Language.Language
    , selectId : String
    , title : String
    , theme : Theme.Theme
    , pressedKeys : List Keyboard.Key
    , currentTime : Time.Posix
    , compilerOutput : ScriptaV2.Compiler.CompilerOutput
    , editRecord : ScriptaV2.DifferentialCompiler.EditRecord
    }


textColor : Theme.Theme -> Element.Color
textColor theme =
    case theme of
        Theme.Light ->
            Element.rgb255 213 216 225

        -- getThemedElementColor .text (Theme.mapTheme theme)
        Theme.Dark ->
            Element.rgb255 240 240 240


backgroundColor : Theme.Theme -> Element.Color
backgroundColor theme =
    case theme of
        Theme.Light ->
            getThemedElementColor .background (Theme.mapTheme theme)

        Theme.Dark ->
            Element.rgb255 48 54 59


type Msg
    = NoOp
    | InputText String
    | Render MarkupMsg
    | GotNewWindowDimensions Int Int
    | KeyMsg Keyboard.Msg
    | ToggleTheme


type alias Flags =
    { window : { windowWidth : Int, windowHeight : Int } }


initialDisplaySettings flags =
    { windowWidth = flags.window.windowWidth // 3
    , counter = 0
    , selectedId = "nada"
    , selectedSlug = Nothing
    , scale = 1.0
    , longEquationLimit = flags.window.windowWidth |> toFloat
    , data = Dict.empty
    , idsOfOpenNodes = []
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        theme =
            Theme.Dark

        displaySettings =
            initialDisplaySettings flags

        normalizedTex =
            normalize AppData.defaultDocumentText

        title_ =
            getTitle normalizedTex

        editRecord =
            ScriptaV2.DifferentialCompiler.init Dict.empty ScriptaV2.Language.EnclosureLang normalizedTex
    in
    ( { displaySettings = displaySettings
      , sourceText = normalizedTex
      , count = 1
      , windowWidth = flags.window.windowWidth
      , windowHeight = flags.window.windowHeight
      , currentLanguage = ScriptaV2.Language.EnclosureLang
      , selectId = "@InitID"
      , title = title_
      , theme = theme
      , pressedKeys = []
      , currentTime = Time.millisToPosix 0
      , compilerOutput =
            ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput (Theme.mapTheme theme) ScriptaV2.Compiler.SuppressDocumentBlocks displaySettings editRecord
      , editRecord = editRecord
      }
    , Cmd.none
    )



--type alias CompilerOutput =
--    { body : List (Element MarkupMsg)
--    , banner : Maybe (Element MarkupMsg)
--    , toc : List (Element MarkupMsg)
--    , title : Element MarkupMsg
--    }
--titleData : Maybe ExpressionBlock
--titleData =
--        Generic.ASTTools.getBlockByName "title" editRecord.tree
--
--properties =
--    Maybe.map .properties titleData |> Maybe.withDefault Dict.empty


getTitle : String -> String
getTitle str =
    str
        |> String.lines
        |> List.map String.trim
        |> List.Extra.dropWhile (\line -> line == "" || String.startsWith "|" line)
        |> List.head
        |> Maybe.withDefault "No title yet"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotNewWindowDimensions width height ->
            ( { model | windowWidth = width, windowHeight = height }, Cmd.none )

        InputText str ->
            let
                editRecord =
                    ScriptaV2.DifferentialCompiler.update model.editRecord str

                oldDisplaySettings =
                    model.displaySettings

                newDisplaySettings =
                    { oldDisplaySettings
                        | --windowWidth = model.windowWidth
                          counter = model.count + 1
                        , selectedId = model.selectId
                    }
            in
            ( { model
                | sourceText = str
                , count = model.count + 1
                , displaySettings = newDisplaySettings
                , title = getTitle str
                , editRecord =
                    editRecord
                , compilerOutput =
                    ScriptaV2.DifferentialCompiler.editRecordToCompilerOutput (Theme.mapTheme model.theme)
                        ScriptaV2.Compiler.SuppressDocumentBlocks
                        newDisplaySettings
                        editRecord
              }
            , Cmd.none
            )

        KeyMsg keyMsg ->
            let
                pressedKeys =
                    Keyboard.update keyMsg model.pressedKeys

                cmd =
                    --if List.member Keyboard.Control pressedKeys && List.member (Keyboard.Character "T") pressedKeys then
                    --    Task.perform (always ToggleTheme) (Task.succeed ())
                    --
                    --else
                    if List.member Keyboard.Control pressedKeys && List.member (Keyboard.Character "E") pressedKeys then
                        let
                            settings =
                                Render.Settings.makeSettings (Theme.mapTheme model.theme) "-" Nothing 1.0 model.windowWidth Dict.empty

                            exportText =
                                Render.Export.LaTeX.export model.currentTime settings model.editRecord.tree
                        in
                        File.Download.string (model.title ++ ".tex") "application/x-latex" exportText

                    else if List.member Keyboard.Control pressedKeys && List.member (Keyboard.Character "R") pressedKeys then
                        let
                            settings =
                                Render.Settings.makeSettings (Theme.mapTheme model.theme) "-" Nothing 1.0 model.windowWidth Dict.empty

                            exportText =
                                Render.Export.LaTeX.rawExport settings model.editRecord.tree
                        in
                        File.Download.string (model.title ++ ".tex") "application/x-latex" exportText

                    else
                        Cmd.none
            in
            ( { model
                | pressedKeys =
                    if List.length pressedKeys > 1 then
                        []

                    else
                        pressedKeys
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
    Background.color <| backgroundColor model.theme


view : Model -> Html Msg
view model =
    layoutWith { options = [ Element.focusStyle noFocus ] }
        [ background_ model
        , Element.htmlAttribute (Html.Attributes.style "height" "100vh")
        , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
        ]
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
    (appWidth model - sidebarWidth - 16 - 4 - 16) // 2



-- 16 for padding, 4 for spacing, 16 for padding


panelHeight : Model -> Attribute msg
panelHeight model =
    height (px <| model.windowHeight - 100)


margin =
    { left = 0, right = 0, top = 2, bottom = 0, between = 4 }


headerHeight =
    90


mainColumn : Model -> Element Msg
mainColumn model =
    column (background_ model :: mainColumnStyle)
        [ column
            [ width (px <| appWidth model)
            , height (px <| appHeight model)
            , clipY
            , Element.htmlAttribute (Html.Attributes.style "display" "flex")
            , Element.htmlAttribute (Html.Attributes.style "flex-direction" "column")
            ]
            [ header model
            , Element.el [ paddingEach { top = 8, bottom = 0, left = 0, right = 0 } ]
                (row
                    [ width (px <| appWidth model)
                    , height (px <| appHeight model - 45 - 8) -- Account for header height and top padding
                    , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
                    , paddingXY 8 0 -- Add horizontal padding to prevent overhang
                    ]
                    [ inputText model
                    , displayRenderedText model |> Element.map Render
                    , sidebar model
                    ]
                )
            ]
        ]


sidebar : Model -> Element.Element msg
sidebar model =
    let
        forceColorStyle =
            case model.theme of
                Theme.Light ->
                    Element.htmlAttribute (Html.Attributes.style "color" "black")

                Theme.Dark ->
                    Element.htmlAttribute (Html.Attributes.style "color" "white")
    in
    Element.column [ Element.paddingEach { top = 16, bottom = 0, left = 0, right = 0 }, height fill ]
        [ Element.column
            [ Element.width <| px <| sidebarWidth
            , height fill
            , alignTop
            , Font.color (textColor model.theme)
            , Element.paddingXY 16 16
            , Element.spacing 6
            , Font.size 14
            , background_ model --            , Background.color <| Render.Settings.getThemedElementColor .background (Theme.mapTheme model.theme)
            , forceColorStyle
            , scrollbarY
            , Element.htmlAttribute (Html.Attributes.style "overflow-y" "auto")
            , Element.htmlAttribute (Html.Attributes.style "min-height" "0")
            , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
            ]
            [ Element.el
                [ Element.paddingEach { left = 0, right = 0, top = 0, bottom = 12 }
                , Element.Border.widthEach { left = 1, right = 0, top = 0, bottom = 0 }
                , Element.Border.color (Element.rgb255 1 0 0)
                ]
                (Download.downloadButton "Download script" "process_images.sh" "application/x-sh" AppData.processImagesText)
            , Element.text "Bare bones:"

            -- , Element.text "ctrl-T: toggle theme"
            , Element.text "ctrl-E: export to LaTeX"
            , Element.text "ctrl-R: export to Raw LaTeX"
            , Element.text "No way to save docs (yet)"
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
    let
        forceColorStyle =
            case model.theme of
                Theme.Light ->
                    Element.htmlAttribute (Html.Attributes.style "color" "black")

                Theme.Dark ->
                    Element.htmlAttribute (Html.Attributes.style "color" "white")
    in
    Element.el
        [ alignTop
        , height (px <| appHeight model - 45)
        , width (px <| panelWidth model)
        , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
        , Element.htmlAttribute (Html.Attributes.style "position" "relative")
        , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
        ]
        (Element.el
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
            (column [ Font.size 14, height fill, width fill ]
                [ column
                    [ background_ model
                    , spacing 24
                    , width fill
                    , htmlId "rendered-text"
                    , alignTop
                    , centerX
                    , Font.color (textColor model.theme)
                    , forceColorStyle
                    , Element.htmlAttribute (Html.Attributes.style "padding" "16px")
                    , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
                    ]
                    [ container model model.compilerOutput.body ]
                ]
            )
        )



--container : (a -> List (Element msg)) -> a -> Element msg


container : Model -> List (Element msg) -> Element msg
container model elements_ =
    Element.column (background_ model :: [ Element.centerX, spacing 24 ]) elements_


compile : Model -> List (Element MarkupMsg)
compile model =
    ScriptaV2.API.compileStringWithTitle
        (Theme.mapTheme model.theme)
        ""
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


header : Model -> Element msg
header model =
    let
        debugTextColor =
            case model.theme of
                Theme.Light ->
                    Element.rgb255 0 0 0

                -- Black for light mode
                Theme.Dark ->
                    Element.rgb255 255 255 255

        -- Pure white for dark mode
        themeLabel =
            case model.theme of
                Theme.Light ->
                    "Light Mode"

                Theme.Dark ->
                    "Dark Mode"

        -- Force color with HTML style attribute
        forceColorStyle =
            case model.theme of
                Theme.Light ->
                    Element.htmlAttribute (Html.Attributes.style "color" "black")

                Theme.Dark ->
                    Element.htmlAttribute (Html.Attributes.style "color" "white")
    in
    Element.row
        [ Element.height <| Element.px <| headerHeight
        , Element.width <| Element.px <| appWidth model
        , Element.spacing 32
        , Element.centerX
        , Background.color (backgroundColor model.theme)
        , paddingEach { left = 18, right = 18, top = 0, bottom = 0 }
        , forceColorStyle
        ]
        [ Element.el
            [ centerX
            , Font.color debugTextColor
            , forceColorStyle
            , Element.Border.widthEach { left = 0, right = 0, top = 0, bottom = 1 }
            , Element.Border.color (Element.rgb255 1 1 1)
            ]
            (Element.text <| "Scripta Live: " ++ model.title)
        ]


innerMarginWidth =
    16


inputText : Model -> Element Msg
inputText model =
    let
        forceColorStyle =
            case model.theme of
                Theme.Light ->
                    Element.htmlAttribute (Html.Attributes.style "color" "black")

                Theme.Dark ->
                    Element.htmlAttribute (Html.Attributes.style "color" "white")
    in
    Element.el
        [ alignTop
        , height (px <| appHeight model - 45)
        , width (px <| panelWidth model)
        , Element.htmlAttribute (Html.Attributes.style "overflow" "hidden")
        , Element.htmlAttribute (Html.Attributes.style "position" "relative")
        , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
        ]
        (Element.el
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
            (Input.multiline
                [ width fill
                , height fill
                , Font.size 14
                , Element.alignTop
                , Font.color (textColor model.theme)
                , Background.color (backgroundColor model.theme)
                , forceColorStyle
                , Element.htmlAttribute (Html.Attributes.id "source-text-input")
                , Element.htmlAttribute (Html.Attributes.style "box-sizing" "border-box")
                , Element.htmlAttribute (Html.Attributes.style "padding" "8px")
                ]
                { onChange = InputText
                , text = model.sourceText
                , placeholder = Nothing
                , label = Input.labelAbove [] <| el [] (text "")
                , spellcheck = False
                }
            )
        )


fontGray g =
    Font.color (Element.rgb g g g)


bgGray g =
    Background.color (Element.rgb g g g)


mainColumnStyle =
    [ centerX
    , centerY
    , bgGray 0.4
    , paddingXY 20 20
    , height fill
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
