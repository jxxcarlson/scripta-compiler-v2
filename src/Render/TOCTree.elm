module Render.TOCTree exposing
    ( TOCNodeValue
    , ViewParameters
    , nodeLevel
    , view
    )

import Array
import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Background
import Element.Events as Events
import Element.Font as Font
import Generic.ASTTools
import Generic.Acc exposing (Accumulator)
import Generic.Forest exposing (Forest)
import Generic.Language exposing (Expr(..), ExpressionBlock, Heading(..))
import Library.Forest
import Library.Tree
import Render.Expression
import Render.Settings
import Render.Theme
import Render.Utility
import RoseTree.Tree exposing (Tree)
import ScriptaV2.Config as Config
import ScriptaV2.Msg exposing (MarkupMsg(..))
import String.Extra


type alias ViewParameters =
    { idsOfOpenNodes : List String
    , selectedId : String
    , counter : Int
    , attr : List (Element.Attribute MarkupMsg)
    , settings : Render.Settings.RenderSettings
    }


view : Render.Theme.Theme -> ViewParameters -> Accumulator -> Forest ExpressionBlock -> List (Element MarkupMsg)
view theme viewParameters acc documentAst =
    let
        tocAST : List ExpressionBlock
        tocAST =
            Generic.ASTTools.tableOfContents 8 documentAst

        nodes : List TOCNodeValue
        nodes =
            List.map (makeNodeValue viewParameters.idsOfOpenNodes) tocAST

        forest : List (Tree TOCNodeValue)
        forest =
            Library.Forest.makeForest Library.Tree.lev nodes

        vee t =
            { length = t |> RoseTree.Tree.children >> List.length, view = viewTOCTree theme viewParameters acc 4 0 Nothing t }

        vee2 t =
            let
                data =
                    vee t

                format =
                    if data.length > 0 then
                        [ Font.italic
                        , Font.color (Render.Settings.getThemedElementColor .text theme)

                        --, Element.Background.color (Render.Settings.getThemedElementColor .background theme)
                        ]

                    else
                        []
            in
            Element.el format data.view
    in
    forest
        |> List.map vee2


style_ theme_ =
    case theme_ of
        Render.Theme.Dark ->
            [ Element.Background.color (Render.Settings.getThemedElementColor .background theme_)
            , Font.color (Render.Settings.getThemedElementColor .text theme_)
            ]

        Render.Theme.Light ->
            [ Element.Background.color (Render.Settings.getThemedElementColor .background theme_)
            , Font.color (Render.Settings.getThemedElementColor .text theme_)
            ]


viewTOCTree : Render.Theme.Theme -> ViewParameters -> Accumulator -> Int -> Int -> Maybe (List String) -> Tree TOCNodeValue -> Element MarkupMsg
viewTOCTree theme viewParameters acc depth indentation maybeFoundIds tocTree =
    let
        style =
            style_ theme

        val : TOCNodeValue
        val =
            RoseTree.Tree.value tocTree

        actualChildren : List (Tree TOCNodeValue)
        actualChildren =
            RoseTree.Tree.children tocTree

        hasChildren : Bool
        hasChildren =
            not (List.isEmpty actualChildren)

        children : List (Tree TOCNodeValue)
        children =
            if List.member val.block.meta.id viewParameters.idsOfOpenNodes then
                actualChildren

            else
                []
    in
    if depth < 0 || val.visible == False then
        Element.none

    else if List.isEmpty children then
        Element.el style (viewNodeWithChildren theme viewParameters acc indentation val hasChildren)

    else
        Element.column [ Element.spacing 8 ]
            (Element.el style (viewNodeWithChildren theme viewParameters acc indentation val hasChildren)
                :: List.map (viewTOCTree theme viewParameters acc (depth - 1) (indentation + 1) maybeFoundIds)
                    children
            )


viewNode : Render.Theme.Theme -> ViewParameters -> Accumulator -> Int -> TOCNodeValue -> Element MarkupMsg
viewNode theme viewParameters acc indentation node =
    viewTocItem_ theme viewParameters acc False node.block


viewNodeWithChildren : Render.Theme.Theme -> ViewParameters -> Accumulator -> Int -> TOCNodeValue -> Bool -> Element MarkupMsg
viewNodeWithChildren theme viewParameters acc indentation node hasChildren =
    viewTocItem_ theme viewParameters acc hasChildren node.block


tocForest : List String -> Forest ExpressionBlock -> List (Tree TOCNodeValue)
tocForest idsOfOpenNodes ast =
    Generic.ASTTools.tableOfContents 8 ast
        |> List.map (makeNodeValue idsOfOpenNodes)
        |> Library.Forest.makeForest nodeLevel


type alias TOCNodeValue =
    { block : ExpressionBlock, visible : Bool }


makeNodeValue : List String -> ExpressionBlock -> TOCNodeValue
makeNodeValue idsOfOpenNodes block =
    let
        level : Int
        level =
            tocLevel block

        visible =
            (level <= 1)
                || List.member block.meta.id idsOfOpenNodes

        newBlock =
            -- The "xy" line below is needed because we also have the possibility of
            -- the TOC in the sidebar. We do not want click on a TOC item in the sidebar
            -- targeting the TOC item in the main text.
            Generic.Language.updateMetaInBlock (\m -> { m | id = "xy" ++ m.id }) block
    in
    { block = newBlock, visible = True }


viewTocItem_ : Render.Theme.Theme -> ViewParameters -> Accumulator -> Bool -> ExpressionBlock -> Element MarkupMsg
viewTocItem_ theme viewParameters acc hasChildren ({ args, body, properties } as block) =
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

                nodeId =
                    block.meta.id

                sectionNumber =
                    let
                        nosectionNumeber =
                            Element.el [ Element.paddingEach { left = 8, right = 0, top = 0, bottom = 0 } ] (Element.text "-")
                    in
                    case Dict.get "level" properties |> Maybe.andThen String.toInt of
                        Nothing ->
                            nosectionNumeber

                        Just level ->
                            if level <= maximumNumberedTocLevel then
                                case Dict.get "label" properties of
                                    Nothing ->
                                        nosectionNumeber

                                    Just label ->
                                        Element.el [] (Element.text (label ++ "."))

                            else
                                nosectionNumeber

                --exprs2 : Element MarkupMsg
                exprs2 =
                    case exprs |> List.head |> Maybe.andThen Generic.Language.extractText of
                        Nothing ->
                            exprs

                        Just ( text, meta ) ->
                            [ Generic.Language.composeTextElement (String.Extra.softWrapWith 22 "..." (String.trim text)) meta ]

                content =
                    Element.row ([ tocIndent args, Element.width (Element.px 180), Element.spacing 8 ] ++ style_ theme) (sectionNumber :: List.map (Render.Expression.render viewParameters.counter acc viewParameters.settings viewParameters.attr) exprs2)

                color =
                    if id == viewParameters.selectedId then
                        Render.Settings.getThemedElementColor .text theme

                    else
                        Element.rgb 0 0 0.8

                -- Click handlers based on whether the item has children
                clickHandlers =
                    if hasChildren then
                        [ Events.onClick (ToggleTOCNodeID nodeId), Font.size 14 ]

                    else
                        [ Events.onClick (SelectId <| id), Font.size 14 ]
            in
            Element.el clickHandlers
                (Element.link [ Font.color color ] { url = Render.Utility.internalLink id, label = content })


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
tocLevel block =
    case Dict.get "level" block.properties of
        Just level ->
            String.toInt level |> Maybe.withDefault 0

        Nothing ->
            0


nodeLevel : TOCNodeValue -> Int
nodeLevel =
    \node -> Dict.get "level" node.block.properties |> Maybe.andThen String.toInt |> Maybe.withDefault 1 |> (\x -> x - 1)
