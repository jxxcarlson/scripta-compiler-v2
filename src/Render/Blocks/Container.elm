module Render.Blocks.Container exposing
    ( registerRenderers
    , box, comment, collection, bibitem, env, env_
    , itemList, numberedList
    )

{-| This module provides renderers for container blocks.

@docs registerRenderers
@docs box, comment, collection, bibitem, env, env_

-}

import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (ExpressionBlock)
import List.Extra
import Render.BlockRegistry exposing (BlockRegistry)
import Render.Blocks.Stack as Stack
import Render.Color as Color
import Render.Constants
import Render.Expression
import Render.Helper
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.Utility exposing (elementAttribute)
import ScriptaV2.Msg exposing (MarkupMsg(..))
import String.Extra


{-| Register all container block renderers to the registry
-}
registerRenderers : BlockRegistry -> BlockRegistry
registerRenderers registry =
    Render.BlockRegistry.registerBatch
        [ ( "box", box )
        , ( "itemList", itemList )
        , ( "numberedList", numberedList )
        , ( "comment", comment )
        , ( "collection", collection )
        , ( "bibitem", bibitem )
        , ( "env", env_ )
        ]
        registry


itemList : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
itemList count acc settings attr block =
    let
        listOfExprList : List Generic.Language.Expression
        listOfExprList =
            case block.body of
                Left _ ->
                    []

                Right list ->
                    list

        renderItem : RenderSettings -> Generic.Language.Expression -> Element MarkupMsg
        renderItem settings_ expr =
            let
                indentation =
                    case expr of
                        Generic.Language.ExprList n _ _ ->
                            n

                        _ ->
                            0

                level_ =
                    indentation // 2
            in
            Element.row [ Element.paddingEach { left = 0, right = 0, top = 0, bottom = 4 }, Element.width (Element.px (settings.width - Render.Constants.defaultIndentWidth)) ]
                [ Element.el [ Element.alignTop, Element.paddingEach { left = 8 * (indentation + 1), right = 12, top = 0, bottom = 0 } ] (Element.text (itemLabel level_))
                , Element.paragraph (Render.Sync.attributes settings_ block)
                    (Render.Expression.render count acc settings [] expr :: [])
                ]
    in
    Element.column (Element.spacing 2 :: Render.Sync.attributes settings block)
        (List.map (renderItem settings) listOfExprList)


numberedList : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
numberedList count acc settings attr block =
    let
        stack =
            Stack.push 1 []

        indentation_ expr_ =
            case expr_ of
                Generic.Language.ExprList n _ _ ->
                    n

                _ ->
                    0

        level expr_ =
            1 + indentation_ expr_ // 2

        listOfExprList : List Generic.Language.Expression
        listOfExprList =
            case block.body of
                Left _ ->
                    []

                Right list ->
                    list

        preRenderStep : Generic.Language.Expression -> ( Stack.Stack, List Int ) -> ( Stack.Stack, List Int )
        preRenderStep expr ( stack_, intList ) =
            let
                newStack_ =
                    Stack.newStack (level expr) stack_
            in
            ( newStack_, (Stack.top newStack_ |> Maybe.withDefault 1) :: intList )

        makeLabels : List Generic.Language.Expression -> List Int
        makeLabels exprs =
            List.foldl preRenderStep ( [], [] ) exprs
                |> Tuple.second
                |> List.reverse

        renderNumberedItem_ : Int -> Generic.Language.Expression -> Element MarkupMsg
        renderNumberedItem_ k expr =
            Element.row
                [ Element.width (Element.px 400)
                , Element.paddingEach { left = 9 * (1 + indentation_ expr), right = 0, top = 0, bottom = 0 }
                ]
                [ renderNumberedLabel settings (level expr) k
                , Element.paragraph (Render.Sync.attributes settings block)
                    (Render.Expression.render 0 acc settings [] expr :: [])
                ]
    in
    Element.column (Element.spacing 2 :: Render.Sync.attributes settings block)
        (List.map2 renderNumberedItem_ (makeLabels listOfExprList) listOfExprList)


renderNumberedLabel settings level_ index_ =
    Element.el
        [ Font.size 14
        , Element.alignTop
        , Element.width (Element.px 18)

        --, Render.Utility.leftPadding (settings.leftIndentation + 12)
        , Font.color (Render.Settings.getThemedElementColor .text settings.theme)
        ]
        (Element.text <| numbering_ (level_ - 1) index_ ++ ". ")


itemLabel : Int -> String
itemLabel level_ =
    let
        label_ =
            case modBy 3 level_ of
                0 ->
                    String.fromChar '•'

                1 ->
                    String.fromChar '○'

                _ ->
                    "◊"
    in
    label_


numbering_ : Int -> Int -> String
numbering_ level_ index_ =
    let
        alphabet =
            [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" ]

        romanNumerals =
            [ "i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x", "xi", "xii", "xiii", "xiv", "xv", "xvi", "xvii", "xviii", "xix", "xx", "xi", "xxii", "xxiii", "xxiv", "xxv", "vi" ]

        alpha k =
            List.Extra.getAt (modBy 26 (k - 1)) alphabet |> Maybe.withDefault "a"

        roman k =
            List.Extra.getAt (modBy 26 (k - 1)) romanNumerals |> Maybe.withDefault "i"

        label_ =
            case modBy 3 level_ of
                1 ->
                    alpha index_

                2 ->
                    roman index_

                _ ->
                    String.fromInt index_
    in
    label_


{-| Render a box block
-}
box : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
box count acc settings attr block =
    let
        numbering : Element msg
        numbering =
            if List.member "numbered" block.args then
                Element.el [] (Element.text (blockHeading block))

            else
                Element.none

        caption : Element msg
        caption =
            case Dict.get "caption" block.properties of
                Just c ->
                    Element.el [] (Element.text c)

                Nothing ->
                    Element.text "Box"

        style =
            case Dict.get "style" block.properties of
                Just "italic" ->
                    Font.italic

                _ ->
                    Font.unitalicized

        bgColorAttr =
            Background.color (Render.Settings.getThemedElementColor .offsetBackground settings.theme)

        heading : Element MarkupMsg
        heading =
            Element.row
                [ Font.size 16
                , Element.paddingEach { left = 0, right = 0, top = 18, bottom = 4 }
                , Font.underline
                , Font.color (Render.Settings.getThemedElementColor .text settings.theme)
                , bgColorAttr
                ]
                [ numbering, caption ]
    in
    Element.column (Element.width (Element.px (settings.width - 0)) :: Element.spacing 8 :: bgColorAttr :: Render.Sync.attributes settings block)
        [ heading
        , Element.paragraph
            [ Element.paddingXY 0 0, Element.centerX, bgColorAttr ]
            (Render.Helper.renderWithDefault "" count acc { settings | width = settings.width - 180 } (style :: bgColorAttr :: attr) (Generic.Language.getExpressionContent block))
        ]


{-| Render a comment block
-}
comment1 : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
comment1 count acc settings attrs block =
    let
        author_ =
            String.join " " block.args

        author =
            if author_ == "" then
                ""

            else
                author_ ++ ":"
    in
    Element.column (Element.spacing 6 :: Render.Sync.attributes settings block)
        [ Element.el [ Font.bold, Font.color Color.blue ] (Element.text author)
        , Element.paragraph
            ([ Render.Utility.idAttributeFromInt block.meta.lineNumber
             ]
                ++ Render.Sync.attributes settings block
            )
            (Render.Helper.renderWithDefault "| comment" count acc settings attrs (Generic.Language.getExpressionContent block))
        ]


comment : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
comment count acc settings attr block =
    let
        feature =
            Render.Helper.features settings block
    in
    Element.column
        [ Element.width (Element.px feature.bodyWidth), Element.paddingEach { left = feature.indentation, right = 0, top = 0, bottom = 0 } ]
        [ Element.row [ Element.spacing 8 ]
            [ feature.titleElement, feature.authorElement ]
        , Element.paragraph
            (feature.italicStyle
                :: Font.color feature.colorValue
                :: [ Element.paddingEach { left = feature.indentation, right = 0, top = 0, bottom = 0 } ]
                ++ Render.Sync.attributes settings block
            )
            -- compensate: the width of the body must be reduced by the indent width
            (Render.Helper.renderWithDefault "indent" count acc { settings | width = feature.bodyWidth } attr (Generic.Language.getExpressionContent block))
        ]


{-| Render a collection block (currently returns Element.none)
-}
collection : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
collection _ _ _ _ _ =
    Element.none


{-| Render a bibitem block
-}
bibitem : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
bibitem count acc settings attrs block =
    let
        label =
            List.Extra.getAt 0 block.args |> Maybe.withDefault "(12)" |> (\s -> "[" ++ s ++ "]")
    in
    Element.row
        [ Element.alignTop
        , Render.Utility.idAttributeFromInt block.meta.lineNumber
        , Render.Utility.vspace 0 settings.topMarginForChildren
        ]
        [ Element.el
            [ Font.size 14
            , Element.alignTop
            , Font.bold
            , Element.width (Element.px 34)
            ]
            (Element.text label)
        , Element.paragraph (Render.Sync.attributes settings block)
            (Render.Helper.renderWithDefault "bibitem" count acc settings attrs (Generic.Language.getExpressionContent block))
        ]


{-| Entry point for environment blocks
-}
env_ : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
env_ count acc settings attr block =
    case List.head block.args of
        Nothing ->
            env count acc settings attr block

        Just _ ->
            env count acc settings attr block


{-| Render an environment block
-}
env : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
env count acc settings attr block =
    case block.body of
        Left _ ->
            Element.none

        Right exprs ->
            Element.column (Element.spacing 8 :: Render.Utility.idAttributeFromInt block.meta.lineNumber :: Render.Sync.attributes settings block)
                [ Element.row
                    []
                    [ Element.el [ Font.bold ] (Element.text (blockHeading block))
                    , Element.el [] (Element.text (String.join " " block.args))
                    ]
                , Element.paragraph
                    []
                    (renderWithDefault2 ("??" ++ (Generic.Language.getNameFromHeading block.heading |> Maybe.withDefault "(name)")) count acc settings attr exprs)
                ]


{-| Helper for rendering default content
-}
renderWithDefault2 _ count acc settings attr exprs =
    List.map (Render.Expression.render count acc settings attr) exprs


{-| Extract block heading for display
-}
blockHeading : ExpressionBlock -> String
blockHeading block =
    case Generic.Language.getNameFromHeading block.heading of
        Nothing ->
            ""

        Just name ->
            if List.member name [ "banner_", "banner" ] then
                ""

            else
                (name |> String.Extra.toTitleCase)
                    ++ " "
                    ++ (Dict.get "label" block.properties |> Maybe.withDefault "")
                    ++ ". "
