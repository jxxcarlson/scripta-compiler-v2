module Render.Tree2 exposing (renderTree)

{-| This module provides a refactored implementation of tree rendering using the new abstractions.

@docs renderTree

-}

import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Generic.Acc exposing (Accumulator)
import Generic.BlockUtilities
import Generic.Language exposing (ExpressionBlock, Heading(..))
import Render.Attributes
import Render.BlockType exposing (BlockType(..))
import Render.OrdinaryBlock2 as OrdinaryBlock
import Render.Settings exposing (RenderSettings)
import Render.TreeSupport
import RoseTree.Tree exposing (Tree)
import ScriptaV2.Msg exposing (MarkupMsg)


{-| Render a tree of expression blocks
-}
renderTree : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> RoseTree.Tree.Tree ExpressionBlock -> Element MarkupMsg
renderTree count accumulator settings attrs_ tree =
    let
        root =
            RoseTree.Tree.value tree

        blockAttrs : List (Element.Attribute MarkupMsg)
        blockAttrs =
            OrdinaryBlock.getAttributesForBlock root
    in
    case RoseTree.Tree.children tree of
        [] ->
            -- Leaf node: just render the block
            renderLeafNode count accumulator settings attrs_ root

        children ->
            -- Branch node: render based on block type
            renderBranchNode count accumulator settings attrs_ blockAttrs root children tree


{-| Render a leaf node (a block with no children)
-}
renderLeafNode : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
renderLeafNode count accumulator settings attrs_ root =
    Element.column (Render.TreeSupport.renderAttributes settings root ++ getBlockAttributes root)
        (Render.TreeSupport.renderBody count accumulator settings attrs_ root)


{-| Render a branch node (a block with children)
-}
renderBranchNode : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> List (Tree ExpressionBlock) -> Tree ExpressionBlock -> Element MarkupMsg
renderBranchNode count accumulator settings attrs_ blockAttrs root children tree =
    if isBoxBlock root then
        renderBoxBranch count accumulator settings attrs_ blockAttrs root children
    else
        renderStandardBranch count accumulator settings attrs_ blockAttrs root children


{-| Render a branch node that is a box
-}
renderBoxBranch : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> List (Tree ExpressionBlock) -> Element MarkupMsg
renderBoxBranch count accumulator settings attrs_ blockAttrs root children =
    let
        settings_ =
            { settings | width = settings.width - 100, backgroundColor = Element.rgb 0.95 0.93 0.93 }
    in
    Element.column [ Element.paddingEach { left = 12, right = 12, top = 0, bottom = 0 } ]
        [ Element.column (Render.TreeSupport.renderAttributes settings_ root ++ getBlockAttributes root)
            (Render.TreeSupport.renderBody count accumulator settings_ attrs_ root
                ++ List.map (renderTree count accumulator settings_ (attrs_ ++ getInnerAttributes root ++ blockAttrs)) children
            )
        ]


{-| Render a standard branch node
-}
renderStandardBranch : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> List (Tree ExpressionBlock) -> Element MarkupMsg
renderStandardBranch count accumulator settings attrs_ blockAttrs root children =
    Element.column (Element.spacing 12 :: getBlockAttributes root)
        (Render.TreeSupport.renderBody count accumulator settings (getBlockAttributes root) root
            ++ List.map (renderTree count accumulator settings (attrs_ ++ getBlockAttributes root ++ blockAttrs)) children
        )


{-| Check if the block is a box block
-}
isBoxBlock : ExpressionBlock -> Bool
isBoxBlock block =
    block.heading == Generic.Language.Ordinary "box"


{-| Get attributes for a block
-}
getBlockAttributes : ExpressionBlock -> List (Element.Attribute MarkupMsg)
getBlockAttributes block =
    let
        blockName =
            Generic.BlockUtilities.getExpressionBlockName block
                |> Maybe.withDefault "---"
    in
    if List.member blockName italicBlockNames then
        [ Font.italic ]

    else if blockName == "indent" then
        [ Element.spacing 11, Element.paddingEach { left = 12, right = 0, top = 0, bottom = 0 } ]

    else if blockName == "quotation" then
        [ Font.italic, Element.paddingEach { left = 12, right = 0, top = 0, bottom = 0 } ]

    else if blockName == "box" then
        [ Element.spacing 11, Font.italic, Element.paddingXY 12 12, Background.color (Element.rgb 0.95 0.93 0.93) ]

    else
        []


{-| Get inner attributes for a block (applied to children)
-}
getInnerAttributes : ExpressionBlock -> List (Element.Attribute MarkupMsg)
getInnerAttributes block =
    let
        blockName =
            Generic.BlockUtilities.getExpressionBlockName block
                |> Maybe.withDefault "---"
    in
    if List.member blockName italicBlockNames then
        [ Font.italic ]

    else if blockName == "box" then
        [ Element.spacing 11, Background.color (Element.rgb 0.95 0.93 0.93) ]

    else
        []


{-| List of block names that should be rendered in italics
-}
italicBlockNames : List String
italicBlockNames =
    [ "quote"
    , "aside"
    , "note"
    , "warning"
    , "exercise"
    , "problem"
    , "note"
    , "theorem"
    , "proof"
    , "definition"
    , "principle"
    , "construction"
    , "axiom"
    , "lemma"
    , "corollary"
    , "example"
    , "remark"
    ]