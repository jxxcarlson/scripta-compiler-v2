module Render.OrdinaryBlock2 exposing
    ( getAttributes
    , getAttributesForBlock
    , render
    , initRegistry
    )

{-| This module provides a new implementation of OrdinaryBlock using the registry pattern

@docs getAttributes, getAttributesForBlock, render, initRegistry

-}

import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Generic.BlockUtilities
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (Expr(..), Expression, ExpressionBlock, Heading(..))
import Render.Attributes
import Render.BlockRegistry exposing (BlockRegistry)
import Render.BlockType exposing (BlockType(..))
import Render.Blocks.Container as ContainerBlocks
import Render.Blocks.Document as DocumentBlocks
import Render.Blocks.Interactive as InteractiveBlocks
import Render.Blocks.Text as TextBlocks
import Render.Helper
import Render.List
import Render.Footnote
import Render.Table
import Render.Settings exposing (RenderSettings)
import ScriptaV2.Msg exposing (MarkupMsg(..))


{-| Get attributes for a specific block type by name
-}
getAttributes : String -> List (Element.Attribute MarkupMsg)
getAttributes name =
    if name == "box" then
        [ Background.color (Element.rgb 0.95 0.93 0.93) ]

    else if List.member name italicNames then
        [ Font.italic ]

    else
        []


{-| Get attributes for a block
-}
getAttributesForBlock : ExpressionBlock -> List (Element.Attribute MarkupMsg)
getAttributesForBlock block =
    case Generic.BlockUtilities.getExpressionBlockName block of
        Nothing ->
            []

        Just name ->
            getAttributes name


{-| List of block names that should be rendered in italics
-}
italicNames : List String
italicNames =
    [ "theorem"
    , "lemma"
    , "corollary"
    , "proposition"
    , "definition"
    , "example"
    , "remark"
    , "exercise"
    , "question"
    , "answer"
    ]


{-| Initialize the registry with all renderers
-}
initRegistry : BlockRegistry
initRegistry =
    Render.BlockRegistry.empty
        |> TextBlocks.registerRenderers
        |> ContainerBlocks.registerRenderers
        |> DocumentBlocks.registerRenderers
        |> InteractiveBlocks.registerRenderers
        |> Render.BlockRegistry.registerBatch
            [ ( "table", Render.Table.render )
            , ( "item", Render.List.item )
            , ( "desc", Render.List.desc )
            , ( "numbered", Render.List.numbered )
            , ( "index", Render.Footnote.index )
            , ( "endnotes", Render.Footnote.endnotes )
            ]


{-| Render an ordinary block using the registry
-}
render : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
render count acc settings attr block =
    let
        registry =
            initRegistry
    in
    case block.body of
        Left _ ->
            Element.none

        Right _ ->
            case block.heading of
                Ordinary functionName ->
                    let
                        renderedBlock =
                            case Render.BlockRegistry.lookup functionName registry of
                                Nothing ->
                                    -- Fall back to the environment renderer
                                    let
                                        -- Find the env renderer as our fallback
                                        envRenderer =
                                            Render.BlockRegistry.lookup "env" registry
                                                |> Maybe.withDefault (\_ _ _ _ _ -> Element.none)
                                    in
                                    envRenderer count acc settings attr block

                                Just renderer ->
                                    let
                                        newSettings =
                                            if List.member block.heading [ Ordinary "item", Ordinary "numbered" ] then
                                                { settings | width = settings.width - 6 * block.indent }
                                            else
                                                settings
                                    in
                                    renderer count acc newSettings attr block
                    in
                    -- Apply indentation to the rendered block
                    indentOrdinaryBlock block.indent (String.fromInt block.meta.lineNumber) settings renderedBlock

                _ ->
                    Element.none


{-| Apply indentation to an ordinary block
-}
indentOrdinaryBlock : Int -> String -> RenderSettings -> Element msg -> Element msg
indentOrdinaryBlock indent id settings x =
    if indent > 0 then
        Element.el [ Render.Helper.selectedColor id settings, Element.paddingEach { top = Render.Helper.topPaddingForIndentedElements, bottom = 0, left = 0, right = 0 } ] x
    else
        x