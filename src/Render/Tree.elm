module Render.Tree exposing (renderTree)

{-| This module provides a refactored implementation of tree rendering using the new abstractions.

@docs renderTree

-}

import Element exposing (Element)
import Element.Background
import Element.Border
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
        root : ExpressionBlock
        root =
            RoseTree.Tree.value tree

        isBoxLike : ExpressionBlock -> Bool
        isBoxLike block =
            case Generic.Language.getName block of
                Nothing ->
                    False

                Just name ->
                    name == "box"

        backgroundColor =
            Render.Settings.getThemedElementColor .offsetBackground settings.theme

        bgColorAttr : Element.Color
        bgColorAttr =
            Render.Settings.getThemedElementColor .offsetBackground settings.theme

        -- Determine if the root block is a box-like block
        --blockAttrs : List (Element.Attribute MarkupMsg)
        borderColor =
            case theme of
                Render.Theme.Light ->
                    Element.rgba 0.7 0.8 0.9 1

                Render.Theme.Dark ->
                    Element.rgba 0.6 0.6 0.6 0.5

        blockAttrs =
            case RoseTree.Tree.children tree of
                [] ->
                    [ Element.Background.color bgColorAttr ]

                _ ->
                    Element.Border.color borderColor :: Element.Border.width 2 :: Element.Background.color bgColorAttr :: []
    in
    if isBoxLike root then
        Element.column [ Element.paddingXY 12 12 ]
            [ Element.column blockAttrs
                [ renderTree_ theme
                    count
                    accumulator
                    { settings
                        | width = settings.width - 24
                        , backgroundColor = backgroundColor
                    }
                    []
                    tree
                ]
            ]

    else
        Element.column [] [ renderTree_ theme count accumulator settings [] tree ]


renderTree_ :
    Render.Theme.Theme
    -> Int
    -> Accumulator
    -> RenderSettings
    -> List (Element.Attribute MarkupMsg)
    -> RoseTree.Tree.Tree ExpressionBlock
    -> Element MarkupMsg
renderTree_ theme count accumulator settings attrs_ tree =
    let
        root =
            RoseTree.Tree.value tree
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
            { settings | width = settings.width - 100, backgroundColor = Render.Settings.getThemedElementColor .offsetBackground theme }
    in
    Element.column [ Element.paddingEach { left = 18, right = 18, top = 0, bottom = 0 } ]
        [ Element.column (Render.TreeSupport.renderAttributes settings_ root ++ getBlockAttributes root settings)
            (Render.TreeSupport.renderBody theme count accumulator settings_ attrs_ root
                ++ List.map (renderTree_ theme count accumulator settings_ (attrs_ ++ blockAttrs)) children
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
            ++ List.map (renderTree_ theme count accumulator settings (attrs_ ++ getBlockAttributes root settings ++ blockAttrs)) children
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
            []

        _ ->
            if List.member (Render.BlockType.toString blockType) Render.Attributes.italicBlockNames then
                Render.Attributes.getItalicAttributes

            else
                []
