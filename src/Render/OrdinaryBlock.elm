module Render.OrdinaryBlock exposing (getAttributes, getAttributesForBlock, render)

import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Background as Background
import Element.Events as Events
import Element.Font as Font
import Element.Input
import Generic.ASTTools as ASTTools
import Generic.Acc exposing (Accumulator)
import Generic.BlockUtilities
import Generic.Language exposing (Expr(..), Expression, ExpressionBlock, Heading(..))
import List.Extra
import Maybe.Extra
import Render.Color as Color
import Render.Expression
import Render.Footnote
import Render.Helper
import Render.List
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.Sync2
import Render.Table
import Render.Utility exposing (elementAttribute)
import ScriptaV2.Msg exposing (MarkupMsg(..))
import String.Extra
import Tools.Utility as Utility


render : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
render count acc settings attr block =
    case block.body of
        Left _ ->
            Element.none

        Right _ ->
            case block.heading of
                Ordinary functionName ->
                    case Dict.get functionName blockDict of
                        Nothing ->
                            env count acc settings attr block
                                |> indentOrdinaryBlock block.indent (String.fromInt block.meta.lineNumber) settings

                        Just f ->
                            let
                                newSettings =
                                    if List.member block.heading [ Ordinary "item", Ordinary "numbered" ] then
                                        { settings | width = settings.width - 6 * block.indent }

                                    else
                                        settings
                            in
                            f count acc newSettings attr block
                                |> indentOrdinaryBlock block.indent (String.fromInt block.meta.lineNumber) settings

                _ ->
                    Element.none


getAttributesForBlock : ExpressionBlock -> List (Element.Attribute MarkupMsg)
getAttributesForBlock block =
    case Generic.BlockUtilities.getExpressionBlockName block of
        Nothing ->
            []

        Just name ->
            getAttributes name


getAttributes : String -> List (Element.Attribute MarkupMsg)
getAttributes name =
    if name == "box" then
        [ Background.color (Element.rgb 0.9 0.9 1.0) ]

    else if name == "quotation" then
        [ Element.paddingEach { top = 0, bottom = 0, left = 0, right = 0 }, Font.italic ]

    else if List.member name italicNames then
        [ Font.italic ]

    else
        []


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


blockDict : Dict String (Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg)
blockDict =
    Dict.fromList
        [ ( "indent", indented )
        , ( "center", centered )
        , ( "box", box )
        , ( "quotation", quotation )
        , ( "set-key", \_ _ _ _ _ -> Element.none )
        , ( "comment", comment )
        , ( "compact", compact )
        , ( "identity", identity )
        , ( "blue", blue )
        , ( "red", red )
        , ( "red2", red2 )
        , ( "q", question ) -- xx
        , ( "a", answer ) -- xx
        , ( "reveal", reveal ) -- xx
        , ( "document", document )
        , ( "collection", collection )
        , ( "bibitem", bibitem )
        , ( "section", section ) -- xx
        , ( "subheading", subheading )
        , ( "runninghead_", \_ _ _ _ _ -> Element.none )
        , ( "banner", \_ _ _ _ _ -> Element.none )
        , ( "visibleBanner", visibleBanner )
        , ( "title", \_ _ _ _ _ -> Element.none )

        -- , ( "title", \c a s b -> title c a s b )
        , ( "subtitle", \_ _ _ _ _ -> Element.none )
        , ( "author", \_ _ _ _ _ -> Element.none )
        , ( "date", \_ _ _ _ _ -> Element.none )
        , ( "contents", \_ _ _ _ _ -> Element.none )
        , ( "table", Render.Table.render )
        , ( "tags", \_ _ _ _ _ -> Element.none )
        , ( "type", \_ _ _ _ _ -> Element.none )
        , ( "env", env_ )
        , ( "item", Render.List.item )
        , ( "desc", Render.List.desc )
        , ( "numbered", Render.List.numbered )
        , ( "index", Render.Footnote.index )
        , ( "endnotes", Render.Footnote.endnotes )
        , ( "setcounter", \_ _ _ _ _ -> Element.none )
        , ( "shiftandsetcounter", \_ _ _ _ _ -> Element.none )

        --, ( "list", \_ _ _ _ -> Element.none )
        ]


bibitem : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
bibitem count acc settings attrs block =
    let
        label =
            List.Extra.getAt 0 block.args |> Maybe.withDefault "(12)" |> (\s -> "[" ++ s ++ "]")
    in
    Element.row ([ Element.alignTop, Render.Utility.idAttributeFromInt block.meta.lineNumber, Render.Utility.vspace 0 settings.topMarginForChildren ] ++ Render.Sync.highlightIfIdIsSelected block.meta.lineNumber block.meta.numberOfLines settings)
        [ Element.el
            [ Font.size 14
            , Element.alignTop
            , Font.bold
            , Element.width (Element.px 34)
            ]
            (Element.text label)
        , Element.paragraph []
            (Render.Helper.renderWithDefault "bibitem" count acc settings attrs (Generic.Language.getExpressionContent block))
        ]


box : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
box count acc settings attr block =
    --Element.paragraph [ Element.height Element.fill ]
    Element.column [ Element.spacing 8 ]
        [ Element.el [ Font.bold ] (Element.text (blockHeading block))
        , Element.paragraph
            []
            (Render.Helper.renderWithDefault "" count acc settings attr (Generic.Language.getExpressionContent block))
        ]


centered : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
centered count acc settings attr block =
    Element.el
        ((Element.width (Element.px settings.width) :: attr) |> Render.Sync2.sync block settings)
        (Element.paragraph [ Element.centerX, Element.width (Element.px (settings.width - 100)) ]
            (Render.Helper.renderWithDefault "centered" count acc settings attr (Generic.Language.getExpressionContent block))
        )


compact : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
compact count acc settings attr block =
    Element.el
        ((Element.width (Element.px settings.width) :: attr) |> Render.Sync2.sync block settings)
        (Element.column [ Element.spacing 0, Element.width (Element.px (settings.width - 0)) ]
            (Render.Helper.renderWithDefaultNarrow "compact" count acc settings attr (Generic.Language.getExpressionContent block))
        )


identity : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
identity count acc settings attr block =
    Element.el
        ((Element.width (Element.px settings.width) :: attr) |> Render.Sync2.sync block settings)
        (Element.column [ Element.spacing 0, Element.width (Element.px (settings.width - 0)) ]
            (Render.Helper.renderWithDefault "identity" count acc settings attr (Generic.Language.getExpressionContent block))
        )


red : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
red count acc settings attr block =
    Element.el
        ((Element.width (Element.px settings.width) :: attr) |> Render.Sync2.sync block settings)
        (Element.column
            [ Element.width (Element.px (settings.width - 0))
            , Font.color (Element.rgb 0.8 0 0)
            ]
            (Render.Helper.renderWithDefaultNarrow "red" count acc settings attr (Generic.Language.getExpressionContent block))
        )


red2 : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
red2 count acc settings attr block =
    Element.el
        ([ Element.width (Element.px settings.width) ] |> Render.Sync2.sync block settings)
        (Element.column
            [ Element.paddingEach { left = 12, right = 0, top = 0, bottom = 0 }
            , Font.color (Element.rgb 0.8 0 0)
            ]
            (Render.Helper.renderWithDefault "red2" count acc settings attr (Generic.Language.getExpressionContent block))
        )


indented2 : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
indented2 count acc settings attr block =
    Element.el
        ([ Element.width (Element.px settings.width) ] |> Render.Sync2.sync block settings)
        (Element.paragraph [ Element.paddingEach { left = 12, right = 0, top = 0, bottom = 0 } ]
            (Render.Helper.renderWithDefault "indent" count acc settings attr (Generic.Language.getExpressionContent block))
        )


blue : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
blue count acc settings attr block =
    Element.el
        ((Element.width (Element.px settings.width) :: attr) |> Render.Sync2.sync block settings)
        (Element.column
            [ Element.width (Element.px (settings.width - 0))
            , Font.color (Element.rgb 0 0 0.8)
            ]
            (Render.Helper.renderWithDefaultNarrow "blue" count acc settings attr (Generic.Language.getExpressionContent block))
        )


indented : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
indented count acc settings attr block =
    Element.el
        ([ Element.width (Element.px settings.width) ] |> Render.Sync2.sync block settings)
        (Element.paragraph [ Element.paddingEach { left = 12, right = 0, top = 0, bottom = 0 } ]
            (Render.Helper.renderWithDefault "indent" count acc settings attr (Generic.Language.getExpressionContent block))
        )


quotation : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
quotation count acc settings attrs block =
    Element.column ([ Element.spacing 12 ] |> Render.Sync2.sync block settings)
        [ Element.paragraph
            (Render.Helper.blockAttributes settings block [])
            (Render.Helper.renderWithDefault "quotation" count acc settings attrs (Generic.Language.getExpressionContent block))
        ]


{-| -}
comment count acc settings attrs block =
    let
        author_ =
            String.join " " block.args

        author =
            if author_ == "" then
                ""

            else
                author_ ++ ":"
    in
    Element.column ([ Element.spacing 6 ] |> Render.Sync2.sync block settings)
        [ Element.el [ Font.bold, Font.color Color.blue ] (Element.text author)
        , Element.paragraph ([ Font.italic, Font.color Color.blue, Render.Sync.rightToLeftSyncHelper block.meta.lineNumber block.meta.numberOfLines, Render.Utility.idAttributeFromInt block.meta.lineNumber ] ++ Render.Sync.highlightIfIdIsSelected block.meta.lineNumber block.meta.numberOfLines settings)
            (Render.Helper.renderWithDefault "| comment" count acc settings attrs (Generic.Language.getExpressionContent block))
        ]


{-|

    A block of the form "| collection" informs Scripta that the body
    of the document is a collection of links to other documents and
    that it should be interpreted as a kind of table of contents

    A collection document might look like this:

    | title
    Quantum Mechanics Notes

    [tags jxxcarlson:quantum-mechanics-notes, collection, system:startup, folder:krakow]

    | collection

    | document jxxcarlson:qmnotes-trajectories-uncertainty
    Trajectories and Uncertainty

    | document jxxcarlson:wave-packets-dispersion
    Wave Packets and the Dispersion Relation

    | document jxxcarlson:wave-packets-schroedinger
    Wave Packets and Schrödinger's Equation

-}
collection : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
collection _ _ _ _ _ =
    Element.none


{-|

    Use a document block to include another document in a collection, e.g,

        | document jxxcarlson:wave-packets-schroedinger
        Wave Packets and Schrödinger's Equation

    The primitive block parser converts the argument 'jxxcarlson:wave-packets-schroedinger'
    into a dictionary entry with key 'jxxcarlson' and value 'wave-packets-schroedinger'.

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


ilink : String -> String -> Maybe String -> String -> Element MarkupMsg
ilink docTitle selectedId selecteSlug docId =
    Element.Input.button []
        { onPress = Just (GetPublicDocument ScriptaV2.Msg.MHStandard docId)

        -- { onPress = Just (GetDocumentById docId)
        , label =
            Element.el
                [ Element.centerX
                , Element.centerY
                , Font.size 14
                , Render.Helper.fontColor selectedId selecteSlug docId
                ]
                (Element.text docTitle)
        }



-- QUESTIONS AND ANSWERS (FOR TEACHING)


question : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
question count acc settings attrs block =
    let
        title_ =
            String.join " " block.args

        label =
            " " ++ Render.Helper.getLabel block.properties

        qId =
            Dict.get block.meta.id acc.qAndADict |> Maybe.withDefault block.meta.id
    in
    Element.column ([ Element.spacing 12 ] |> Render.Sync2.sync block settings)
        -- TODO: clean up?
        [ Element.el [ Font.bold, Font.color Color.blue, Events.onClick (HighlightId qId) ] (Element.text (title_ ++ " " ++ label))
        , Element.paragraph ([ Font.italic, Events.onClick (HighlightId qId), Render.Utility.idAttributeFromInt block.meta.lineNumber ] ++ Render.Sync.highlightIfIdIsSelected block.meta.lineNumber block.meta.numberOfLines settings)
            (Render.Helper.renderWithDefault "..." count acc settings attrs (Generic.Language.getExpressionContent block))
        ]


answer : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
answer count acc settings attrs block =
    let
        title_ =
            String.join " " (List.drop 1 block.args)

        clicker =
            if settings.selectedId == block.meta.id then
                Events.onClick (ProposeSolution ScriptaV2.Msg.Unsolved)

            else
                Events.onClick (ProposeSolution (ScriptaV2.Msg.Solved block.meta.id))
    in
    Element.column ([ Element.spacing 12, Element.paddingEach { top = 0, bottom = 24, left = 0, right = 0 } ] |> Render.Sync2.sync block settings)
        [ Element.el [ Font.bold, Font.color Color.blue, clicker ] (Element.text title_)
        , if settings.selectedId == block.meta.id then
            -- TODO: clean up?
            Element.el [ Events.onClick (ProposeSolution ScriptaV2.Msg.Unsolved) ]
                (Element.paragraph ([ Font.italic, Render.Utility.idAttributeFromInt block.meta.lineNumber, Element.paddingXY 8 8 ] ++ Render.Sync.highlightIfIdIsSelected block.meta.lineNumber block.meta.numberOfLines settings)
                    (Render.Helper.renderWithDefault "..." count acc settings attrs (Generic.Language.getExpressionContent block))
                )

          else
            Element.none
        ]


reveal : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
reveal count acc settings attrs block =
    let
        title_ =
            String.join " " block.args

        label =
            " " ++ Render.Helper.getLabel block.properties

        clicker =
            if settings.selectedId == block.meta.id then
                Events.onClick (ProposeSolution ScriptaV2.Msg.Unsolved)

            else
                Events.onClick (ProposeSolution (ScriptaV2.Msg.Solved block.meta.id))
    in
    Element.column [ Element.spacing 6 ]
        [ Element.el
            [ Font.bold
            , Font.color Color.blue
            , clicker
            ]
            (Element.text (title_ ++ " " ++ label))
        , if settings.selectedId == block.meta.id then
            Element.el []
                (Element.paragraph
                    ([ Font.italic
                     , Element.paddingXY 8 8
                     ]
                        |> Render.Sync2.sync block settings
                    )
                    (Render.Helper.renderWithDefault "..." count acc settings attrs (Generic.Language.getExpressionContent block))
                )

          else
            Element.none
        ]


subheading : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
subheading count acc settings attr block =
    Element.link
        (sectionBlockAttributes block settings ([ topPadding 10, Font.size 18 ] ++ attr) |> Render.Sync2.sync block settings)
        { url = Render.Utility.internalLink (settings.titlePrefix ++ "title")
        , label = Element.paragraph [] (Render.Helper.renderWithDefault "| subheading" count acc settings attr (Generic.Language.getExpressionContent block))
        }


section count acc settings attr block =
    -- level 1 is reserved for titles
    let
        maxNumberedLevel =
            1

        headingLevel : Float
        headingLevel =
            case Dict.get "level" block.properties of
                Nothing ->
                    2

                Just n ->
                    String.toFloat n |> Maybe.withDefault 3

        fontSize =
            1.4 * (settings.maxHeadingFontSize / sqrt headingLevel) |> round

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

            --, if headingLevel > 1 then
            --    Font.semiBold
            --
            --  else
            --    Font.regular
            ]
        )
        { url = Render.Utility.internalLink (settings.titlePrefix ++ "title")
        , label = Element.paragraph ([] |> Render.Sync2.sync block settings) (sectionNumber :: renderWithDefaultWithSize 18 "??!!(1)" count acc settings attr exprs)
        }


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
    Element.paragraph [ Font.size fontSize, elementAttribute "id" "banner" ]
        -- renderWithDefaultWithSize size default count acc settings attr exprs
        (renderWithDefaultWithSize fontSize "??!!(2)" count acc settings attr exprs)


title count acc settings attr block =
    let
        fontSize =
            settings.titleSize

        exprs =
            Generic.Language.getExpressionContent block
    in
    Element.paragraph [ Font.size fontSize, elementAttribute "id" "title" ] (renderWithDefaultWithSize fontSize "??!!" count acc settings attr exprs)


sectionBlockAttributes : ExpressionBlock -> RenderSettings -> List (Element.Attr () MarkupMsg) -> List (Element.Attr () MarkupMsg)
sectionBlockAttributes block settings attrs =
    [ Render.Utility.makeId (Generic.Language.getExpressionContent block)
    , Render.Utility.idAttribute block.meta.id
    ]
        ++ Render.Sync.highlightIfIdIsSelected block.meta.lineNumber block.meta.numberOfLines settings
        ++ attrs


topPadding : Int -> Element.Attribute msg
topPadding k =
    Element.paddingEach { top = k, bottom = 0, left = 0, right = 0 }



-- renderWithDefaultWithSize : Int -> String -> Int -> Accumulator -> RenderSettings -> List Expression -> List (Element MarkupMsg)


renderWithDefaultWithSize size default count acc settings attr exprs =
    if List.isEmpty exprs then
        [ Element.el ([ Font.color settings.redColor, Font.size size ] ++ attr) (Element.text default) ]

    else
        List.map (Render.Expression.render count acc settings attr) exprs


indentOrdinaryBlock : Int -> String -> RenderSettings -> Element msg -> Element msg
indentOrdinaryBlock indent id settings x =
    if indent > 0 then
        Element.el [ Render.Helper.selectedColor id settings, Element.paddingEach { top = Render.Helper.topPaddingForIndentedElements, bottom = 0, left = 0, right = 0 } ] x

    else
        x


{-|

    Used to render generic LaTeX environments

-}



-- env_ : Int -> Accumulator -> RenderSettings -> ExpressionBlock -> Element MarkupMsg


env_ count acc settings attr block =
    case List.head block.args of
        Nothing ->
            Element.paragraph
                [ Render.Utility.idAttributeFromInt block.meta.lineNumber
                , Font.color settings.redColor
                , Render.Sync.rightToLeftSyncHelper block.meta.lineNumber block.meta.numberOfLines
                ]
                [ Element.text "| env (missing name!)" ]

        Just _ ->
            env count acc settings attr block


{-|

    Used to render generic LaTeX environments

-}



-- env : Int -> Accumulator -> RenderSettings -> ExpressionBlock -> Element MarkupMsg


env : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
env count acc settings attr block =
    case block.body of
        Left _ ->
            Element.none

        Right exprs ->
            Element.column ([ Element.spacing 8, Render.Utility.idAttributeFromInt block.meta.lineNumber ] ++ Render.Sync.highlightIfIdIsSelected block.meta.lineNumber block.meta.numberOfLines settings)
                [ Element.el
                    ([ Font.bold
                     , Render.Sync.rightToLeftSyncHelper block.meta.lineNumber block.meta.numberOfLines
                     ]
                        |> Render.Sync.highlightIfIdSelected block.meta.id settings
                    )
                    (Element.text (blockHeading block))
                , Element.paragraph
                    ([ Font.italic

                     --, Render.Utility.elementAttribute "id" block.meta.id
                     , Render.Helper.htmlId block.meta.id
                     , Render.Sync.rightToLeftSyncHelper block.meta.lineNumber block.meta.numberOfLines
                     ]
                        |> Render.Sync.highlightIfIdSelected block.meta.id
                            settings
                    )
                    (renderWithDefault2 ("??" ++ (Generic.Language.getNameFromHeading block.heading |> Maybe.withDefault "(name)")) count acc settings attr exprs)
                ]


highlightBlock : RenderSettings -> ExpressionBlock -> List (Element.Attr () msg)
highlightBlock settings block =
    Render.Sync.highlightIfIdSelected block.meta.id
        settings
        (Render.Sync.highlighter block.args
            []
        )


renderWithDefault2 _ count acc settings attr exprs =
    List.map (Render.Expression.render count acc settings attr) exprs


{-|

    Used in function env (ender generic LaTeX environments).
    This function numbers blocks for which there is a "label" property

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
                    ++ String.join " " block.args
