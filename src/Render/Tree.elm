module Render.Tree exposing (renderTree)

{-| This module provides a refactored implementation of tree rendering using the new abstractions.

@docs renderTree

-}

import Element exposing (Element)
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (ExpressionBlock, Heading(..))
import Render.Attributes
import Render.BlockType exposing (BlockType(..), ContainerBlockType(..), DocumentBlockType(..), InteractiveBlockType(..), ListBlockType(..), TextBlockType(..))
import Render.Color
import Render.OrdinaryBlock as OrdinaryBlock
import Render.Settings exposing (RenderSettings)
import Render.Theme
import Render.TreeSupport
import RoseTree.Tree exposing (Tree)
import ScriptaV2.Msg exposing (MarkupMsg)


{-| Render a tree of expression blocks
-}
renderTree :
    Render.Theme.Theme
    -> Int
    -> Accumulator
    -> RenderSettings
    -> List (Element.Attribute MarkupMsg)
    -> RoseTree.Tree.Tree ExpressionBlock
    -> Element MarkupMsg
renderTree theme count accumulator settings attrs_ tree =
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
            renderLeafNode theme count accumulator settings [] root

        children ->
            -- Branch node: render based on block type
            renderBranchNode theme count accumulator settings [] [] root children tree


{-| Render a leaf node (a block with no children)
-}
renderLeafNode :
    Render.Theme.Theme
    -> Int
    -> Accumulator
    -> RenderSettings
    -> List (Element.Attribute MarkupMsg)
    -> ExpressionBlock
    -> Element MarkupMsg
renderLeafNode theme count accumulator settings attrs_ root =
    Element.column (Render.TreeSupport.renderAttributes settings root ++ getBlockAttributes root settings ++ Render.Settings.unrollTheme theme)
        (Render.TreeSupport.renderBody theme count accumulator settings attrs_ root)


renderLeafNodeALT :
    Render.Theme.Theme
    -> Int
    -> Accumulator
    -> RenderSettings
    -> List (Element.Attribute MarkupMsg)
    -> ExpressionBlock
    -> Element MarkupMsg
renderLeafNodeALT theme count accumulator settings attrs_ root =
    Element.column []
        --(Render.TreeSupport.renderAttributes settings root)
        (Render.TreeSupport.renderBody theme count accumulator settings [] root)


{-| Render a branch node (a block with children)
-}
renderBranchNode :
    Render.Theme.Theme
    -> Int
    -> Accumulator
    -> RenderSettings
    -> List (Element.Attribute MarkupMsg)
    -> List (Element.Attribute MarkupMsg)
    -> ExpressionBlock
    -> List (Tree ExpressionBlock)
    -> Tree ExpressionBlock
    -> Element MarkupMsg
renderBranchNode theme count accumulator settings attrs_ blockAttrs root children tree =
    case getBlockType root of
        ContainerBlock Box ->
            renderBoxBranch theme count accumulator settings attrs_ blockAttrs root children

        _ ->
            renderStandardBranch theme count accumulator settings [] [] root children


{-| Render a branch node that is a box
-}
renderBoxBranch :
    Render.Theme.Theme
    -> Int
    -> Accumulator
    -> RenderSettings
    -> List (Element.Attribute MarkupMsg)
    -> List (Element.Attribute MarkupMsg)
    -> ExpressionBlock
    -> List (Tree ExpressionBlock)
    -> Element MarkupMsg
renderBoxBranch theme count accumulator settings attrs_ blockAttrs root children =
    let
        settings_ =
            { settings | width = settings.width - 100, backgroundColor = Render.Color.boxBackground }
    in
    Element.column [ Element.paddingEach { left = 18, right = 18, top = 0, bottom = 0 } ]
        [ Element.column (Render.TreeSupport.renderAttributes settings_ root ++ getBlockAttributes root settings)
            (Render.TreeSupport.renderBody theme count accumulator settings_ attrs_ root
                --++ List.map (renderTree count accumulator settings_ (attrs_ ++ getInnerAttributes root settings_ ++ blockAttrs)) children
                ++ List.map (renderTree theme count accumulator settings_ (attrs_ ++ blockAttrs)) children
            )
        ]


{-|

    Render a standard branch node:
     - render the body of the root
     - render the forest     using each child's attributes plus those inherited from the root.

     (( Something like that ))

-}
renderStandardBranch :
    Render.Theme.Theme
    -> Int
    -> Accumulator
    -> RenderSettings
    -> List (Element.Attribute MarkupMsg)
    -> List (Element.Attribute MarkupMsg)
    -> ExpressionBlock
    -> List (Tree ExpressionBlock)
    -> Element MarkupMsg
renderStandardBranch theme count accumulator settings attrs_ blockAttrs root children =
    Element.column (Element.spacing 12 :: getBlockAttributes root settings)
        (Render.TreeSupport.renderBody theme count accumulator settings [] root
            ++ List.map (renderTree theme count accumulator settings (attrs_ ++ getBlockAttributes root settings ++ blockAttrs)) children
        )


{-| Get the BlockType for a block
-}
getBlockType : ExpressionBlock -> BlockType
getBlockType block =
    case block.heading of
        Ordinary name ->
            Render.BlockType.fromString name

        _ ->
            MiscBlock ""


{-| Get attributes for a block using the consolidated Attributes module
-}
getBlockAttributes : ExpressionBlock -> RenderSettings -> List (Element.Attribute MarkupMsg)
getBlockAttributes block settings =
    Render.Attributes.getBlockAttributes block settings


{-| Get inner attributes for a block (applied to children)
-}
getInnerAttributes : ExpressionBlock -> RenderSettings -> List (Element.Attribute MarkupMsg)
getInnerAttributes block settings =
    let
        blockType =
            getBlockType block
    in
    case blockType of
        ContainerBlock Box ->
            Render.Attributes.getBoxAttributes

        _ ->
            if List.member (Render.BlockType.toString blockType) Render.Attributes.italicBlockNames then
                Render.Attributes.getItalicAttributes

            else
                []
