module Render.Tree exposing (renderTreeQ)

-- import Render.Block

import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Generic.Acc exposing (Accumulator)
import Generic.BlockUtilities
import Generic.Forest exposing (Forest)
import Generic.ForestTransform exposing (Error)
import Generic.Language exposing (ExpressionBlock)
import Generic.Pipeline
import Generic.Settings
import M.Expression
import Render.Block
import Render.Msg exposing (MarkupMsg)
import Render.OrdinaryBlock as OrdinaryBlock exposing (getAttributesForBlock)
import Render.Settings exposing (RenderSettings)
import Tree exposing (Tree)


unravelL : Tree (Element MarkupMsg) -> Element MarkupMsg
unravelL tree =
    let
        children =
            Tree.children tree
    in
    if List.isEmpty children then
        Tree.label tree

    else
        let
            root : Element MarkupMsg
            root =
                Tree.label tree
        in
        Element.column [ Font.italic ]
            [ root
            , Element.column
                [ Element.paddingEach
                    { top = 12
                    , left = 0
                    , right = 0
                    , bottom = 0
                    }
                ]
                (List.map unravelL children)
            ]


unravelM : Tree (Element MarkupMsg) -> Element MarkupMsg
unravelM tree =
    let
        children =
            Tree.children tree
    in
    if List.isEmpty children then
        Tree.label tree

    else
        let
            root : Element MarkupMsg
            root =
                Tree.label tree
        in
        Element.column [ Font.italic ]
            [ root
            , Element.column
                [ Element.paddingEach
                    { top = 12
                    , left = 12
                    , right = 0
                    , bottom = 0
                    }
                ]
                (List.map unravelM children)
            ]


r1 : Int -> Accumulator -> RenderSettings -> ExpressionBlock -> List (Element.Attribute msg)
r1 k a s block =
    -- Debug.todo "r1"
    [ Font.italic ]



--
--renderTreeL : Int -> Accumulator -> RenderSettings -> Tree ExpressionBlock -> Element MarkupMsg
--renderTreeL count accumulator settings tree =
--    let
--        blockName =
--            Generic.BlockUtilities.getExpressionBlockName (Tree.label tree)
--                |> Maybe.withDefault "---"
--    in
--    if List.member blockName Generic.Settings.numberedBlockNames then
--        Element.el [ Font.italic ] ((Tree.map (Render.Block.render count accumulator settings) >> unravelL) tree)
--
--    else
--        (Tree.map (Render.Block.render count accumulator settings) >> unravelL) tree
--


renderTreeQ : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> Tree ExpressionBlock -> Element MarkupMsg
renderTreeQ count accumulator settings attrs_ tree =
    let
        root =
            Tree.label tree

        blockAttrs =
            OrdinaryBlock.getAttributesForBlock root
    in
    case Tree.children tree of
        [] ->
            Element.column (Render.Block.renderAttributes settings root ++ rootAttributes root)
                (Render.Block.renderBody count accumulator settings attrs_ root)

        children ->
            Element.column (rootAttributes root)
                (Render.Block.renderBody count accumulator settings (rootAttributes root) root
                    ++ List.map (renderTreeQ count accumulator settings (attrs_ ++ blockAttrs)) children
                )



--
--renderTreeQ1 : Int -> Accumulator -> RenderSettings -> Tree ExpressionBlock -> Element MarkupMsg
--renderTreeQ1 count accumulator settings tree =
--    let
--        attr =
--            if Generic.BlockUtilities.getExpressionBlockName root == Just "box" then
--                [ Font.italic, Element.paddingXY 32 12, Background.color (Element.rgb 0.9 0.9 1.0) ]
--
--            else
--                []
--
--        root =
--            Tree.label tree
--    in
--    case Tree.children tree of
--        [] ->
--            Element.column (Render.Block2.renderAttributes count accumulator settings root ++ attr)
--                (Render.Block2.renderBody count accumulator settings root)
--
--        children ->
--            Element.column (Render.Block2.renderAttributes count accumulator settings root ++ attr)
--                (Render.Block2.renderBody count accumulator settings root ++ List.map (renderTreeQ1 count accumulator settings) children)


rootAttributes rootBlock =
    case Generic.BlockUtilities.getExpressionBlockName rootBlock of
        Just "box" ->
            [ Element.paddingXY 32 12, Background.color (Element.rgb 0.9 0.9 1.0) ]

        Just "theorem" ->
            [ Font.italic ]

        _ ->
            []



--r2 : Int -> Accumulator -> RenderSettings -> ExpressionBlock -> List (Element msg)
--r2 k a s block =
--    -- Debug.todo "r2"
--
--render2 : Int -> Accumulator -> RenderSettings -> Tree ExpressionBlock -> Element MarkupMsg
--render2 count acc settings tree =
--    let
--        children =
--            Tree.children tree
--    in
--    if List.isEmpty children then
--        Tree.label tree |> Render.Block.render count acc settings
--
--    else
--        let
--            root = Tree.label tree
--            attributes =
--                r1 count acc settings root ++ [ Font.italic ]
--
--            elements =
--                r2 count acc settings root
--        in
--        Element.column (r1 count acc settings root)
--            [ root |> Render.Block.render count acc settings
--            , Element.column
--                ([ Element.paddingEach
--                    { top = Render.Settings.defaultSettings.topMarginForChildren
--                    , left = Render.Settings.defaultSettings.leftIndent
--                    , right = 0
--                    , bottom = 0
--                    }
--                 ]
--                    ++ attributes
--                )
--                (List.map (render2 count acc settings) children)
--            ]
