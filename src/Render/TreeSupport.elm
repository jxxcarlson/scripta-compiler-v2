module Render.TreeSupport exposing (renderAttributes, renderBody)

{-| This module provides simplified versions of Block functions needed by Tree2
to avoid import cycles.

@docs renderAttributes, renderBody

-}

import Either exposing (Either(..))
import Element exposing (Element)
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (ExpressionBlock, Heading(..))
import Render.Expression
import Render.Helper
import Render.Indentation
import Render.OrdinaryBlock
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.Theme
import Render.Utility
import Render.VerbatimBlock as VerbatimBlock
import ScriptaV2.Msg exposing (MarkupMsg(..))
import ScriptaV2.Types


{-| Simplified version of Block.renderAttributes
-}
renderAttributes : RenderSettings -> ExpressionBlock -> List (Element.Attribute MarkupMsg)
renderAttributes settings block =
    case block.heading of
        Paragraph ->
            Element.focused [] :: syncAttributes settings block

        Ordinary name ->
            syncAttributes settings block ++ Element.focused [] :: Render.OrdinaryBlock.getAttributes settings.theme name

        Verbatim _ ->
            Element.focused [] :: syncAttributes settings block


{-| The standard attributes for a block are those needed for LR and RL sync
and for highlighting the block if it is selected.
-}
syncAttributes : RenderSettings -> ExpressionBlock -> List (Element.Attribute MarkupMsg)
syncAttributes settings block =
    [ Render.Utility.idAttributeFromInt block.meta.lineNumber
    , Render.Sync.rightToLeftSyncHelper block.meta.lineNumber block.meta.numberOfLines
    ]
        ++ Render.Sync.highlightIfIdIsSelected block.meta.lineNumber block.meta.numberOfLines settings


{-| Simplified version of Block.renderBody
-}
renderBody : ScriptaV2.Types.CompilerParameters -> RenderSettings -> Accumulator -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> List (Element MarkupMsg)
renderBody params settings acc _ block =
    case block.heading of
        Paragraph ->
            [ Element.column (Render.Sync.attributes settings block) [ renderParagraphBody params.editCount acc settings (Render.Settings.unrollTheme params.theme) block ] ]

        Ordinary _ ->
            [ Element.column (Render.Sync.attributes settings block) [ Render.OrdinaryBlock.render params.editCount acc settings (Render.Settings.unrollTheme params.theme) block ] ]

        Verbatim _ ->
            [ Element.column (Render.Sync.attributes settings block) [ VerbatimBlock.render params.editCount acc settings (Render.Settings.unrollTheme params.theme) block |> Render.Helper.showError block.meta.error ] ]


{-| Render a paragraph body
-}
renderParagraphBody : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
renderParagraphBody count acc settings attrs block =
    case block.body of
        Right exprs ->
            Element.paragraph (Render.Helper.htmlId block.meta.id :: Element.width (Element.px settings.width) :: attrs)
                [ List.map (Render.Expression.render count acc settings attrs) exprs
                    |> clickableParagraph block.meta.lineNumber block.meta.numberOfLines (Render.Helper.selectedColor block.meta.id settings)
                    |> indentParagraph block.indent
                ]

        Left _ ->
            Element.none


{-| Helper for clickable paragraphs
-}
clickableParagraph : Int -> Int -> Element.Attribute MarkupMsg -> List (Element MarkupMsg) -> Element MarkupMsg
clickableParagraph lineNumber numberOfLines color elements =
    let
        id =
            String.fromInt lineNumber
    in
    Element.paragraph
        [ color
        , Render.Sync.rightToLeftSyncHelper lineNumber numberOfLines
        , Render.Helper.htmlId id
        ]
        elements


{-| Helper for indenting paragraphs
-}
indentParagraph : Int -> Element msg -> Element msg
indentParagraph indent x =
    Render.Indentation.indentParagraph indent x
