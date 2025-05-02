module Render.Tree exposing (renderTree)

-- import Render.Block

import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Generic.Acc exposing (Accumulator)
import Generic.BlockUtilities
import Generic.Language exposing (ExpressionBlock)
import Render.Block
import Render.OrdinaryBlock as OrdinaryBlock exposing (getAttributesForBlock)
import Render.Settings exposing (RenderSettings)
import RoseTree.Tree exposing (Tree)
import ScriptaV2.Msg as Tree exposing (MarkupMsg)


unravelL : Tree (Element MarkupMsg) -> Element MarkupMsg
unravelL tree =
    let
        children =
            RoseTree.Tree.children tree
    in
    if List.isEmpty children then
        RoseTree.Tree.value tree

    else
        let
            root : Element MarkupMsg
            root =
                RoseTree.Tree.value tree
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
            RoseTree.Tree.children tree
    in
    if List.isEmpty children then
        RoseTree.Tree.value tree

    else
        let
            root : Element MarkupMsg
            root =
                RoseTree.Tree.value tree
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
            Element.column (Render.Block.renderAttributes settings root ++ rootAttributes root)
                (Render.Block.renderBody count accumulator settings attrs_ root)

        children ->
            let
                settings_ =
                    { settings | width = settings.width - 100, backgroundColor = Element.rgb 0.95 0.93 0.93 }
            in
            if root.heading == Generic.Language.Ordinary "box" then
                Element.column [ Element.paddingEach { left = 12, right = 12, top = 0, bottom = 0 } ]
                    [ Element.column (Render.Block.renderAttributes settings_ root ++ rootAttributes root)
                        (Render.Block.renderBody count accumulator settings_ attrs_ root
                            ++ List.map (renderTree count accumulator settings_ (attrs_ ++ innerAttributes root ++ blockAttrs)) children
                        )
                    ]

            else
                Element.column (Element.spacing 12 :: rootAttributes root)
                    (Render.Block.renderBody count accumulator settings (rootAttributes root) root
                        ++ List.map (renderTree count accumulator settings (attrs_ ++ rootAttributes root ++ blockAttrs)) children
                    )


rootAttributes rootBlock =
    let
        blockName =
            Generic.BlockUtilities.getExpressionBlockName rootBlock
                |> Maybe.withDefault "---"
    in
    if List.member blockName italicBlockNames then
        [ Font.italic ]
        --else if List.member blockName ["quotation"] then
        --    [Element.paddingEach { left = 24, right = 0, top = 0, bottom = 0}]

    else if blockName == "indent" then
        -- re left indent see also Render.OrdingaryBlock.indented.  The value there must
        -- be the same.
        [ Element.spacing 11, Element.paddingEach { left = 12, right = 0, top = 0, bottom = 0 } ]

    else if blockName == "quotation" then
        -- re left indent see also Render.OrdingaryBlock.indented.  The value there must
        -- be the same.
        [ Font.italic, Element.paddingEach { left = 12, right = 0, top = 0, bottom = 0 } ]

    else if blockName == "box" then
        [ Element.spacing 11, Font.italic, Element.paddingXY 12 12, Background.color (Element.rgb 0.95 0.93 0.93) ]

    else
        []


innerAttributes rootBlock =
    let
        blockName =
            Generic.BlockUtilities.getExpressionBlockName rootBlock
                |> Maybe.withDefault "---"
    in
    if List.member blockName italicBlockNames then
        [ Font.italic ]

    else if blockName == "box" then
        [ Element.spacing 11, Background.color (Element.rgb 0.95 0.93 0.93) ]

    else
        []


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
