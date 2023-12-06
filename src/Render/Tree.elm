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
            let
                settings_ =
                    { settings | width = settings.width - 100, backgroundColor = Element.rgb 0.9 0.9 1.0 }
            in
            if root.heading == Generic.Language.Ordinary "box" then
                Element.column [ Element.paddingEach { left = 12, right = 12, top = 0, bottom = 0 } ]
                    [ Element.column (Render.Block.renderAttributes settings_ root ++ rootAttributes root)
                        (Render.Block.renderBody count accumulator settings_ attrs_ root
                            ++ List.map (renderTreeQ count accumulator settings_ (attrs_ ++ rootAttributes root ++ blockAttrs)) children
                        )
                    ]

            else
                Element.column (Element.spacing 12 :: rootAttributes root)
                    (Render.Block.renderBody count accumulator settings (rootAttributes root) root
                        ++ List.map (renderTreeQ count accumulator settings (attrs_ ++ rootAttributes root ++ blockAttrs)) children
                    )


rootAttributes rootBlock =
    let
        blockName =
            Generic.BlockUtilities.getExpressionBlockName rootBlock
                |> Maybe.withDefault "---"
    in
    if List.member blockName italicBlockNames then
        [ Font.italic ]

    else if blockName == "box" then
        [ Element.spacing 11, Font.italic, Element.paddingXY 12 12, Background.color (Element.rgb 0.9 0.9 1.0) ]

    else
        []


italicBlockNames =
    [ "quote", "aside", "note", "warning", "exercise", "theorem", "proof", "definition", "lemma", "corollary", "example", "remark" ]
