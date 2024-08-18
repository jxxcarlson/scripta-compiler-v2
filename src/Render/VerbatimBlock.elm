module Render.VerbatimBlock exposing (render)

import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (Expr(..), Expression, ExpressionBlock, Heading(..))
import Html.Events as Event
import Render.Chart
import Render.ChartV2
import Render.DataTable
import Render.Graphics
import Render.Helper
import Render.IFrame
import Render.Math
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.Table
import Render.Utility exposing (elementAttribute)
import ScriptaV2.Msg exposing (MarkupMsg(..))


render : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
render count acc settings attrs block =
    case block.body of
        Right _ ->
            Element.none

        Left str ->
            case block.heading of
                Verbatim functionName ->
                    case Dict.get functionName verbatimDict of
                        Nothing ->
                            Render.Helper.noSuchVerbatimBlock functionName str

                        Just f ->
                            Element.el
                                [ Render.Helper.selectedColor block.meta.id settings
                                , Render.Helper.htmlId block.meta.id
                                ]
                                (f count acc settings attrs block)

                _ ->
                    Element.none


verbatimDict : Dict String (Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg)
verbatimDict =
    Dict.fromList
        [ ( "math", Render.Math.displayedMath )
        , ( "equation", Render.Math.equation )
        , ( "aligned", Render.Math.aligned )
        , ( "code", renderCode )
        , ( "verse", renderVerse )
        , ( "verbatim", renderVerbatim )

        --, ( "tabular", Render.Tabular.render )
        , ( "load", renderLoad )
        , ( "load-data", Render.Helper.renderNothing )
        , ( "hide", Render.Helper.renderNothing )
        , ( "texComment", Render.Helper.renderNothing )
        , ( "docinfo", Render.Helper.renderNothing )
        , ( "mathmacros", Render.Helper.renderNothing )
        , ( "textmacros", Render.Helper.renderNothing )
        , ( "datatable", Render.DataTable.render )
        , ( "chart", Render.ChartV2.render )
        , ( "svg", Render.Graphics.svg )
        , ( "quiver", Render.Graphics.quiver )
        , ( "image", Render.Graphics.image2 )
        , ( "tikz", Render.Graphics.tikz )
        , ( "load-files", Render.Helper.renderNothing )
        , ( "include", Render.Helper.renderNothing )
        , ( "setup", Render.Helper.renderNothing )
        , ( "table", Render.Table.render )
        , ( "iframe", Render.IFrame.render )
        ]


renderLoadData : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
renderLoadData _ _ _ _ block =
    Element.none


setup : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
setup _ _ _ _ block =
    Element.none


renderLoad : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
renderLoad _ _ _ _ block =
    case block.body of
        Left url ->
            let
                tag =
                    block.args |> List.head |> Maybe.withDefault "default"
            in
            Element.Input.button []
                { onPress = Just (LoadFile tag url)
                , label =
                    Element.el
                        [ Border.rounded 12
                        , Element.mouseDown [ Background.color (Element.rgb 0.4 0.2 0.9) ]
                        , Background.color (Element.rgb 0 0 0.7)
                        , Font.color (Element.rgb 1 1 1)
                        , Element.padding 12
                        ]
                        (Element.text ("load " ++ url ++ " into " ++ tag))
                }

        Right _ ->
            Element.none


renderCode : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
renderCode count acc settings attr block =
    Element.column
        ([ Font.color settings.codeColor
         , Font.family
            [ Font.typeface "Inconsolata"
            , Font.monospace
            ]

         --, Element.spacing 8
         , Element.paddingEach { left = 24, right = 0, top = 0, bottom = 0 }
         , Render.Sync.rightToLeftSyncHelper block.meta.lineNumber block.meta.numberOfLines
         , Render.Utility.idAttributeFromInt block.meta.lineNumber
         ]
            ++ attr
        )
        (case List.head block.args of
            Just arg ->
                --List.map (renderVerbatimLine arg) (String.lines (String.trim (Render.Utility.getVerbatimContent block)))
                List.map (renderVerbatimLine arg) (String.lines (Render.Utility.getVerbatimContent block))

            Nothing ->
                --List.map (renderVerbatimLine "plain") (String.lines (String.trim (Render.Utility.getVerbatimContent block)))
                List.map (renderVerbatimLine "plain") (String.lines (Render.Utility.getVerbatimContent block))
        )


renderVerbatim : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
renderVerbatim _ _ _ attrs block =
    Element.column
        ([ Font.family
            [ Font.typeface "Inconsolata"
            , Font.monospace
            ]
         , Element.spacing 8
         , Element.paddingEach { left = 24, right = 0, top = 0, bottom = 0 }
         ]
            ++ attrs
        )
        (List.map (renderVerbatimLine "none") (String.lines (String.trim (Render.Utility.getVerbatimContent block))))


renderVerbatimLine : String -> String -> Element msg
renderVerbatimLine lang str_ =
    let
        str =
            String.replace "\\bt" "`" str_
    in
    if String.trim str == "" then
        Element.el [ Element.height (Element.px 11) ] (Element.text "")

    else if lang == "plain" then
        Element.el [ Element.height (Element.px 22) ] (Element.text str)

    else
        Element.paragraph [ Element.height (Element.px 22) ] (renderedColoredLine lang str)


renderVerse : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
renderVerse _ _ _ attrs block =
    Element.column
        (verbatimBlockAttributes block.meta.lineNumber block.meta.numberOfLines [] ++ attrs)
        (List.map (renderVerbatimLine "plain") (String.lines (String.trim (Render.Utility.getVerbatimContent block))))


verbatimBlockAttributes lineNumber numberOfLines attrs =
    [ Render.Sync.rightToLeftSyncHelper lineNumber numberOfLines
    , Render.Utility.idAttributeFromInt lineNumber
    ]
        ++ attrs



-- HELPERS


renderedColoredLine lang str =
    str
        |> String.words
        |> List.map (renderedColoredWord lang)


renderedColoredWord lang word =
    case lang of
        "elm" ->
            case Dict.get word elmDict of
                Just color ->
                    Element.el [ color ] (Element.text (word ++ " "))

                Nothing ->
                    Element.el [] (Element.text (word ++ " "))

        _ ->
            Element.el [] (Element.text (word ++ " "))


orange =
    Font.color (Element.rgb255 227 81 18)


green =
    Font.color (Element.rgb255 11 158 26)


cyan =
    Font.color (Element.rgb255 11 143 158)


elmDict =
    Dict.fromList
        [ ( "type", orange )
        , ( "LB", green )
        , ( "RB", green )
        , ( "S", green )
        , ( "String", green )
        , ( "Meta", cyan )
        ]
