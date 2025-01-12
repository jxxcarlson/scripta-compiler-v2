module Render.TOCTree exposing (..)

import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Events as Events
import Element.Font as Font
import Generic.ASTTools
import Generic.Acc exposing (Accumulator)
import Generic.Forest exposing (Forest)
import Generic.Language exposing (ExpressionBlock)
import Library.Forest
import List.Extra
import Render.Expression
import Render.Settings
import Render.Utility
import RoseTree.Tree as Tree exposing (Tree)
import ScriptaV2.Config as Config
import ScriptaV2.Msg exposing (MarkupMsg(..))


view_ : Render.Settings.RenderSettings -> Int -> Accumulator -> List (Element.Attribute MarkupMsg) -> Forest ExpressionBlock -> List (Tree (Element MarkupMsg))
view_ settings count acc attr ast =
    let
        viewTocItem : ExpressionBlock -> Element MarkupMsg
        viewTocItem =
            viewTocItem_ settings.selectedId count acc settings attr
    in
    List.map (Tree.mapValues viewTocItem) (tocForest ast)


tocForest : Forest ExpressionBlock -> List (Tree ExpressionBlock)
tocForest ast =
    Generic.ASTTools.tableOfContents 8 ast
        -- The "xy" line below is needed because we also have the possibility of
        -- the TOC in the sidebar. We do not want click on a TOC item in the sidebar
        -- targeting the TOC item in the main text.
        |> List.map (Generic.Language.updateMetaInBlock (\m -> { m | id = "xy" ++ m.id }))
        |> Library.Forest.makeForest tocLevel


viewTocItem_ : String -> Int -> Accumulator -> Render.Settings.RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
viewTocItem_ selectedId count acc settings attr ({ args, body, properties } as block) =
    let
        maximumNumberedTocLevel =
            1
    in
    case body of
        Left _ ->
            Element.none

        Right exprs ->
            let
                id =
                    Config.expressionIdPrefix ++ String.fromInt block.meta.lineNumber ++ ".0"

                sectionNumber =
                    case List.Extra.getAt 1 args of
                        Just level ->
                            if (String.toInt level |> Maybe.withDefault 0) <= maximumNumberedTocLevel then
                                Element.el [] (Element.text (blockLabel properties ++ ". "))

                            else
                                Element.none

                        _ ->
                            Element.none

                label : Element MarkupMsg
                label =
                    Element.paragraph [ tocIndent args ] (sectionNumber :: List.map (Render.Expression.render count acc settings attr) exprs)

                color =
                    if id == selectedId then
                        Element.rgb 0.8 0 0.0

                    else
                        Element.rgb 0 0 0.8
            in
            Element.el [ Events.onClick (SelectId id) ]
                (Element.link [ Font.color color ] { url = Render.Utility.internalLink id, label = label })


blockLabel : Dict String String -> String
blockLabel properties =
    Dict.get "label" properties |> Maybe.withDefault "??"


tocIndent args =
    Element.paddingEach { left = tocIndentAux args, right = 0, top = 0, bottom = 0 }


tocIndentAux args =
    case List.head args of
        Nothing ->
            0

        Just str ->
            String.toInt str |> Maybe.withDefault 0 |> (\x -> 12 * (x - 1))


tocLevel : ExpressionBlock -> Int
tocLevel { args } =
    List.Extra.getAt 0 args |> Maybe.andThen String.toInt |> Maybe.withDefault 1
