module Render.Blocks.Document exposing
    ( registerRenderers
    , document, section, subheading, visibleBanner
    , unnumberedSection
    )

{-| This module provides renderers for document structure blocks.

@docs registerRenderers
@docs document, section, subheading, title, visibleBanner

-}

import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Font as Font
import Element.Input
import Generic.ASTTools as ASTTools
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (ExpressionBlock)
import List.Extra
import Maybe.Extra
import Render.BlockRegistry exposing (BlockRegistry)
import Render.Expression
import Render.Helper
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.Sync2
import Render.Theme
import Render.Utility exposing (elementAttribute)
import ScriptaV2.Msg exposing (MarkupMsg(..))
import Tools.Utility as Utility


{-| Register all document structure block renderers to the registry
-}
registerRenderers : BlockRegistry -> BlockRegistry
registerRenderers registry =
    Render.BlockRegistry.registerBatch
        [ ( "document", document )
        , ( "book", book )
        , ( "chapter", chapter )
        , ( "section", section )
        , ( "section*", unnumberedSection )
        , ( "subheading", subheading )
        , ( "sh", subheading )
        , ( "settings", \_ _ _ _ _ -> Element.none )

        --, ( "title", title )
        , ( "visibleBanner", visibleBanner )
        , ( "runninghead_", \_ _ _ _ _ -> Element.none )
        , ( "banner", \_ _ _ _ _ -> Element.none )
        , ( "subtitle", \_ _ _ _ _ -> Element.none )
        , ( "author", \_ _ _ _ _ -> Element.none )
        , ( "date", \_ _ _ _ _ -> Element.none )
        , ( "contents", \_ _ _ _ _ -> Element.none )
        , ( "tags", \_ _ _ _ _ -> Element.none )
        , ( "type", \_ _ _ _ _ -> Element.none )
        , ( "setcounter", \_ _ _ _ _ -> Element.none )
        , ( "shiftandsetcounter", \_ _ _ _ _ -> Element.none )
        ]
        registry


{-| Render a document reference block
-}
document : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
document _ _ settings attrs block =
    let
        docId =
            -- In the example above, docId = "jxxcarlson:wave-packets-schroedinger"
            case block.args |> List.head of
                Just idx ->
                    -- could be the block ID
                    idx

                Nothing ->
                    case Dict.get "docId" block.properties of
                        --|> Dict.toList |> List.head |> Maybe.map (\( a, b ) -> a ++ ":" ++ b) of
                        Just ident ->
                            -- this is the block slug referred to
                            ident

                        Nothing ->
                            "(noId)"

        level =
            List.Extra.getAt 1 block.args |> Maybe.withDefault "1" |> String.toInt |> Maybe.withDefault 1

        title_ =
            List.map ASTTools.getText (Generic.Language.getExpressionContent block) |> Maybe.Extra.values |> String.join " " |> Utility.truncateString 35

        sectionNumber =
            case Dict.get "label" block.properties of
                Just "-" ->
                    "- "

                Just "" ->
                    ""

                Just s ->
                    s ++ ". "

                Nothing ->
                    "- "
    in
    Element.row
        [ Element.alignTop
        , Render.Utility.elementAttribute "id" settings.selectedId
        , Render.Utility.vspace 0 settings.topMarginForChildren
        , Element.moveRight (15 * (level - 1) |> toFloat)
        , Render.Helper.fontColor settings.selectedId settings.selectedSlug docId
        ]
        [ Element.el
            [ Font.size 14
            , Element.alignTop
            , Element.width (Element.px 30)
            ]
            (Element.text sectionNumber)
        , ilink title_ settings.selectedId settings.selectedSlug docId
        ]


{-| Helper for internal links
-}
ilink : String -> String -> Maybe String -> String -> Element MarkupMsg
ilink docTitle selectedId selecteSlug docId =
    Element.Input.button []
        { onPress = Just (GetPublicDocument ScriptaV2.Msg.MHStandard docId)
        , label =
            Element.el
                [ Element.centerX
                , Element.centerY
                , Font.size 14
                , Render.Helper.fontColor selectedId selecteSlug docId
                ]
                (Element.text docTitle)
        }


book : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
book count acc settings attr block =
    let
        fontSize =
            2.2 * settings.maxHeadingFontSize |> round

        exprs =
            Generic.Language.getExpressionContent block
    in
    Element.paragraph [ Font.size fontSize ] (renderWithDefaultWithSize fontSize "--" count acc settings attr exprs)


chapter : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
chapter count acc settings attr block =
    -- level 1 is reserved for titles
    let
        fontSize =
            1.6 * settings.maxHeadingFontSize |> round

        exprs =
            Generic.Language.getExpressionContent block
    in
    Element.link
        (sectionBlockAttributes block
            settings
            [ topPadding 20
            , Font.size fontSize
            , Font.color (Render.Theme.getElementColor settings.theme .text)
            ]
            ++ Render.Sync.attributes settings block
        )
        { url = Render.Utility.internalLink (settings.titlePrefix ++ "title")
        , label = Element.paragraph [] (renderWithDefaultWithSize 18 "--" count acc settings attr exprs)
        }


{-| Render a section heading
TODO: re-examine how we compute adn display hierarchical section numbers.
-}
section : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
section count acc settings attr block =
    -- level 1 is reserved for titles
    let
        maxNumberedLevel =
            Dict.get "number-to-level" settings.properties
                |> Maybe.andThen String.toFloat
                |> Maybe.withDefault 0

        headingLevel : Float
        headingLevel =
            case Dict.get "level" block.properties of
                Nothing ->
                    2

                Just n ->
                    String.toFloat n |> Maybe.withDefault 3

        fontSize =
            1.2 * (settings.maxHeadingFontSize / sqrt headingLevel) |> round

        sectionNumber =
            if headingLevel <= maxNumberedLevel then
                Element.el [ Font.size fontSize ] (Element.text (Render.Helper.blockLabel block.properties ++ ". "))

            else
                Element.none

        exprs =
            Generic.Language.getExpressionContent block
    in
    Element.link
        (sectionBlockAttributes block
            settings
            [ topPadding 20
            , Font.size fontSize
            ]
            ++ Render.Sync.attributes settings block
        )
        { url = Render.Utility.internalLink (settings.titlePrefix ++ "title")
        , label = Element.paragraph [] (sectionNumber :: renderWithDefaultWithSize 18 "--" count acc settings attr exprs)
        }


unnumberedSection : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
unnumberedSection count acc settings attr block =
    -- level 1 is reserved for titles
    let
        headingLevel : Float
        headingLevel =
            case Dict.get "level" block.properties of
                Nothing ->
                    2

                Just n ->
                    String.toFloat n |> Maybe.withDefault 3

        fontSize =
            1.2 * (settings.maxHeadingFontSize / sqrt headingLevel) |> round

        exprs =
            Generic.Language.getExpressionContent block
    in
    Element.link
        (sectionBlockAttributes block
            settings
            [ topPadding 20
            , Font.size fontSize
            ]
        )
        { url = Render.Utility.internalLink (settings.titlePrefix ++ "title")
        , label = Element.paragraph (Render.Sync.attributes settings block) (renderWithDefaultWithSize 18 "--" count acc settings attr exprs)
        }


{-| Render a subheading
-}
subheading : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
subheading count acc settings attr block =
    Element.link
        (sectionBlockAttributes block settings ([ topPadding 10, Font.size 18 ] ++ attr) |> Render.Sync2.sync block settings)
        { url = Render.Utility.internalLink (settings.titlePrefix ++ "title")
        , label = Element.paragraph (Render.Sync.attributes settings block) (Render.Helper.renderWithDefault "| subheading" count acc settings attr (Generic.Language.getExpressionContent block))
        }


{-| Render a visible banner
-}
visibleBanner : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
visibleBanner count acc settings attr block =
    let
        fontSize =
            12

        exprs =
            case block.body of
                Left _ ->
                    []

                Right exprs_ ->
                    exprs_
    in
    Element.paragraph ([ Font.size fontSize, elementAttribute "id" "banner" ] ++ Render.Sync.attributes settings block)
        (renderWithDefaultWithSize fontSize "??!!(2)" count acc settings attr exprs)


{-| Helper for section block attributes
-}
sectionBlockAttributes : ExpressionBlock -> RenderSettings -> List (Element.Attr () MarkupMsg) -> List (Element.Attr () MarkupMsg)
sectionBlockAttributes block settings attrs =
    [ Render.Utility.makeId (Generic.Language.getExpressionContent block)
    , Render.Utility.idAttribute block.meta.id
    ]
        ++ Render.Sync.highlightIfIdIsSelected block.meta.lineNumber block.meta.numberOfLines settings
        ++ attrs


{-| Padding helper
-}
topPadding : Int -> Element.Attribute msg
topPadding k =
    Element.paddingEach { top = k, bottom = 0, left = 0, right = 0 }


{-| Helper for rendering with a default and size
-}
renderWithDefaultWithSize : Int -> String -> Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> List Generic.Language.Expression -> List (Element MarkupMsg)
renderWithDefaultWithSize size default count acc settings attr exprs =
    if List.isEmpty exprs then
        [ Element.el ([ Font.color settings.redColor, Font.size size ] ++ attr) (Element.text default) ]

    else
        List.map (Render.Expression.render count acc settings attr) exprs
