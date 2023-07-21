module Render.TOC exposing (view)

-- import Render.Block

import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Events as Events
import Element.Font as Font
import Generic.ASTTools
import Generic.Acc exposing (Accumulator)
import Generic.Forest exposing (Forest)
import Generic.Language exposing (Expression, ExpressionBlock)
import List.Extra
import Render.Expression
import Render.Msg exposing (MarkupMsg(..))
import Render.Settings
import Render.Utility
import ScriptaV2.Config as Config
import Tree


view : Int -> Accumulator -> List (Element.Attribute MarkupMsg) -> Forest ExpressionBlock -> List (Element Render.Msg.MarkupMsg)
view counter acc attr ast =
    let
        maximumLevel =
            case Dict.get "contentsdepth" acc.keyValueDict of
                Just level ->
                    String.toInt level |> Maybe.withDefault 3

                Nothing ->
                    3
    in
    prepareTOC maximumLevel counter acc Render.Settings.defaultSettings attr ast


viewTocItem : Int -> Accumulator -> Render.Settings.RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
viewTocItem count acc settings attr ({ args, body, properties } as block) =
    case body of
        Left _ ->
            Element.none

        Right exprs ->
            let
                id =
                    Config.expressionIdPrefix ++ String.fromInt block.meta.lineNumber ++ ".0"

                sectionNumber =
                    case List.Extra.getAt 1 args of
                        Just "-" ->
                            Element.none

                        _ ->
                            Element.el [] (Element.text (blockLabel properties ++ ". "))

                label : Element MarkupMsg
                label =
                    Element.paragraph [ tocIndent args ] (sectionNumber :: List.map (Render.Expression.render count acc settings attr) exprs)
            in
            Element.el [ Events.onClick (SelectId id) ]
                (Element.link [ Font.color (Element.rgb 0 0 0.8) ] { url = Render.Utility.internalLink id, label = label })


blockLabel : Dict String String -> String
blockLabel properties =
    Dict.get "label" properties |> Maybe.withDefault "??"


tocLevel : Int -> ExpressionBlock -> Bool
tocLevel k { args } =
    case List.Extra.getAt 0 args of
        Nothing ->
            True

        Just level ->
            (String.toInt level |> Maybe.withDefault 4) <= k


prepareTOC : Int -> Int -> Accumulator -> Render.Settings.RenderSettings -> List (Element.Attribute MarkupMsg) -> Forest ExpressionBlock -> List (Element MarkupMsg)
prepareTOC maximumLevel count acc settings attr ast =
    let
        rawToc : List ExpressionBlock
        rawToc =
            Generic.ASTTools.tableOfContents maximumLevel ast
                |> List.filter (tocLevel maximumLevel)

        headings =
            getHeadings ast

        title : List (Element MarkupMsg)
        title =
            headings.title
                |> List.map (Render.Expression.render count acc settings attr)

        topItem =
            let
                id =
                    "title"
            in
            Element.el [ Events.onClick (SelectId id), Font.size 18 ]
                (Element.link [ Font.color (Element.rgb 0 0 0.8) ]
                    { url = Render.Utility.internalLink id, label = Element.paragraph [] title }
                )

        toc =
            topItem
                :: (rawToc |> List.map (viewTocItem count acc settings attr))
    in
    toc


tocIndent args =
    Element.paddingEach { left = tocIndentAux args, right = 0, top = 0, bottom = 0 }


tocIndentAux args =
    case List.head args of
        Nothing ->
            0

        Just str ->
            String.toInt str |> Maybe.withDefault 0 |> (\x -> 12 * (x - 1))


getHeadings : Forest ExpressionBlock -> { title : List Expression, subtitle : List Expression }
getHeadings ast =
    let
        flattened =
            List.map Tree.flatten ast |> List.concat

        title : List Expression
        title =
            flattened
                |> Generic.ASTTools.filterBlocksOnName "title"
                |> List.map getContent
                |> List.concat

        --data
        --    |> List.filter (\item -> item.blockType == OrdinaryBlock [ "title" ])
        --    |> List.head
        --    |> Maybe.map .content
        subtitle : List Expression
        subtitle =
            flattened
                |> Generic.ASTTools.filterBlocksOnName "subtitle"
                |> List.map getContent
                |> List.concat
    in
    { title = title, subtitle = subtitle }


getContent : ExpressionBlock -> List Expression
getContent { body } =
    case body of
        Either.Left _ ->
            []

        Either.Right exprs ->
            exprs
