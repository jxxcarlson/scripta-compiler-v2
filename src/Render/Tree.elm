module Render.Tree exposing (renderTree)

{-| This module provides a refactored implementation of tree rendering using the new abstractions.

@docs renderTree

-}

import Dict
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font
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
import ScriptaV2.Types


{-| Render a tree of expression blocks
-}
renderTree :
    ScriptaV2.Types.CompilerParameters
    -> Render.Settings.RenderSettings
    -> Accumulator
    -> List (Element.Attribute MarkupMsg)
    -> RoseTree.Tree.Tree ExpressionBlock
    -> Element MarkupMsg
renderTree params settings accumulator attrs_ tree =
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
            Render.Settings.getThemedElementColor .offsetBackground params.theme

        style =
            case Dict.get "style" root.properties of
                Just "italic" ->
                    Element.Font.italic

                _ ->
                    Element.Font.unitalicized

        bgColorAttr : Element.Color
        bgColorAttr =
            Render.Settings.getThemedElementColor .offsetBackground params.theme

        -- Determine if the root bloc`k is a box-like block
        --blockAttrs : List (Element.Attribute MarkupMsg)
        borderColor =
            case params.theme of
                Render.Theme.Light ->
                    Element.rgba 0.7 0.8 0.9 1

                Render.Theme.Dark ->
                    Element.rgba 0.6 0.6 0.6 0.5

        width2 =
            Element.width <| Element.px (settings.width - 60)

        blockAttrs =
            style :: (Element.width <| Element.px settings.width) :: Element.Background.color bgColorAttr :: []
    in
    if isBoxLike root then
        Element.column blockAttrs
            [ Element.column
                [ Element.paddingEach { left = 0, right = 0, top = 0, bottom = 18 }
                , Element.Border.color borderColor
                , Element.Border.width 4
                , Element.centerX
                , width2
                ]
                [ renderTree_ params
                    { settings
                        | width = settings.width - 24
                        , backgroundColor = backgroundColor
                    }
                    accumulator
                    []
                    tree
                ]
            ]

    else
        Element.column [ style ] [ renderTree_ params settings accumulator [ style ] tree ]


renderTree_ :
    ScriptaV2.Types.CompilerParameters
    -> Render.Settings.RenderSettings
    -> Accumulator
    -> List (Element.Attribute MarkupMsg)
    -> RoseTree.Tree.Tree ExpressionBlock
    -> Element MarkupMsg
renderTree_ params settings accumulator attrs_ tree =
    let
        root =
            RoseTree.Tree.value tree
    in
    case RoseTree.Tree.children tree of
        [] ->
            -- Leaf node: just render the block
            renderLeafNode params settings accumulator attrs_ root

        children ->
            -- Branch node: render based on block type
            renderBranchNode params settings accumulator [] [] root children tree


{-| Render a leaf node (a block with no children)
-}
renderLeafNode :
    ScriptaV2.Types.CompilerParameters
    -> RenderSettings
    -> Accumulator
    -> List (Element.Attribute MarkupMsg)
    -> ExpressionBlock
    -> Element MarkupMsg
renderLeafNode params settings accumulator attrs_ root =
    Element.column (Render.TreeSupport.renderAttributes settings root ++ getBlockAttributes root settings ++ Render.Settings.unrollTheme params.theme)
        (Render.TreeSupport.renderBody params settings accumulator attrs_ root)


{-| Render a branch node (a block with children)
-}
renderBranchNode :
    ScriptaV2.Types.CompilerParameters
    -> RenderSettings
    -> Accumulator
    -> List (Element.Attribute MarkupMsg)
    -> List (Element.Attribute MarkupMsg)
    -> ExpressionBlock
    -> List (Tree ExpressionBlock)
    -> Tree ExpressionBlock
    -> Element MarkupMsg
renderBranchNode params settings accumulator attrs_ blockAttrs root children tree =
    case getBlockType root of
        ContainerBlock Box ->
            renderBoxBranch params settings accumulator attrs_ blockAttrs root children

        _ ->
            renderStandardBranch params settings accumulator [] [] root children


{-| Render a branch node that is a box
-}
renderBoxBranch :
    ScriptaV2.Types.CompilerParameters
    -> RenderSettings
    -> Accumulator
    -> List (Element.Attribute MarkupMsg)
    -> List (Element.Attribute MarkupMsg)
    -> ExpressionBlock
    -> List (Tree ExpressionBlock)
    -> Element MarkupMsg
renderBoxBranch params settings accumulator attrs_ blockAttrs root children =
    let
        settings_ =
            { settings | width = settings.width - 100, backgroundColor = Render.Settings.getThemedElementColor .offsetBackground params.theme }
    in
    Element.column [ Element.paddingEach { left = 18, right = 18, top = 0, bottom = 0 } ]
        [ Element.column (Render.TreeSupport.renderAttributes settings_ root ++ getBlockAttributes root settings)
            (Render.TreeSupport.renderBody params settings_ accumulator attrs_ root
                ++ List.map (renderTree_ params settings_ accumulator (attrs_ ++ blockAttrs)) children
            )
        ]


{-|

    Render a standard branch node:
     - render the body of the root
     - render the forest     using each child's attributes plus those inherited from the root.

     (( Something like that ))

-}
renderStandardBranch :
    ScriptaV2.Types.CompilerParameters
    -> RenderSettings
    -> Accumulator
    -> List (Element.Attribute MarkupMsg)
    -> List (Element.Attribute MarkupMsg)
    -> ExpressionBlock
    -> List (Tree ExpressionBlock)
    -> Element MarkupMsg
renderStandardBranch params settings accumulator attrs_ blockAttrs root children =
    Element.column (Element.spacing 12 :: getBlockAttributes root settings)
        (Render.TreeSupport.renderBody params settings accumulator [] root
            ++ List.map (renderTree_ params settings accumulator (attrs_ ++ getBlockAttributes root settings ++ blockAttrs)) children
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
