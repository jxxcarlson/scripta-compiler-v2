module Render.Block exposing (renderAttributes, renderBody)

import Either exposing (Either(..))
import Element exposing (Element)
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (Expr(..), Expression, ExpressionBlock, Heading(..))
import Render.Expression
import Render.Helper
import Render.Msg exposing (MarkupMsg(..))
import Render.OrdinaryBlock as OrdinaryBlock
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.Utility
import Render.VerbatimBlock as VerbatimBlock


renderAttributes : RenderSettings -> ExpressionBlock -> List (Element.Attribute MarkupMsg)
renderAttributes settings block =
    case block.heading of
        Paragraph ->
            standardAttributes settings block

        Ordinary name ->
            standardAttributes settings block ++ OrdinaryBlock.getAttributes name

        Verbatim _ ->
            standardAttributes settings block


standardAttributes settings block =
    [ Render.Utility.idAttributeFromInt block.meta.lineNumber
    , Render.Sync.rightToLeftSyncHelper block.meta.lineNumber block.meta.numberOfLines
    ]
        ++ Render.Sync.highlightIfIdIsSelected block.meta.lineNumber block.meta.numberOfLines settings


renderBody : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> List (Element MarkupMsg)
renderBody count acc settings attrs block =
    case block.heading of
        Paragraph ->
            [ renderParagraphBody count acc settings attrs block ]

        Ordinary name ->
            [ OrdinaryBlock.render count acc settings attrs block ]

        Verbatim name ->
            [ VerbatimBlock.render count acc settings attrs block |> Render.Helper.showError block.meta.error ]


renderParagraphBody : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
renderParagraphBody count acc settings attrs block =
    case block.body of
        Right exprs ->
            Element.paragraph (Render.Helper.htmlId block.meta.id :: attrs)
                [ List.map (Render.Expression.render count acc settings attrs) exprs
                    |> clickableParagraph block.meta.lineNumber block.meta.numberOfLines (Render.Helper.selectedColor block.meta.id settings)
                    |> indentParagraph block.indent
                ]

        Left _ ->
            Element.none



---- SUBSIDIARY RENDERERS


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


indentParagraph : number -> Element msg -> Element msg
indentParagraph indent x =
    if indent > 0 then
        Element.el [ Element.paddingEach { top = Render.Helper.topPaddingForIndentedElements, bottom = 0, left = 0, right = 0 } ] x

    else
        x
