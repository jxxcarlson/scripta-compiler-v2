module Render.Footnote exposing (endnotes, index)

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
import Html.Attributes
import List.Extra
import Maybe.Extra
import Render.Color as Color
import Render.Expression
import Render.Graphics
import Render.Helper
import Render.IFrame
import Render.List
import Render.Math
import Render.Msg exposing (MarkupMsg(..))
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.Tabular
import Render.Utility exposing (elementAttribute)
import Render.VerbatimBlock as VerbatimBlock
import String.Extra
import Tools.Utility as Utility


index : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
index _ acc _ attrs block =
    let
        groupItemList : List GroupItem
        groupItemList =
            acc.terms
                |> Dict.toList
                |> List.map (\( name, item_ ) -> ( String.trim name, item_ ))
                |> List.sortBy (\( name, _ ) -> name)
                |> List.Extra.groupWhile (\a b -> String.left 1 (Tuple.first a) == String.left 1 (Tuple.first b))
                |> List.map (\thing -> group thing)
                |> List.concat

        groupItemListList : List (List GroupItem)
        groupItemListList =
            groupItemList
                |> List.Extra.greedyGroupsOf 30
                |> List.map normalize
    in
    Element.row ([ Element.spacing 18 ] ++ attrs) (List.map renderGroup groupItemListList)


renderGroup : List GroupItem -> Element MarkupMsg
renderGroup groupItems =
    Element.column [ Element.alignTop, Element.spacing 6, Element.width (Element.px 150) ] (List.map indexItem groupItems)


normalize gp =
    case List.head gp of
        Just GBlankLine ->
            List.drop 1 gp

        Just (GItem _) ->
            gp

        Nothing ->
            gp


group : ( Item, List Item ) -> List GroupItem
group ( item_, list ) =
    GBlankLine :: GItem item_ :: List.map GItem list


indexItem : GroupItem -> Element MarkupMsg
indexItem groupItem =
    case groupItem of
        GBlankLine ->
            Element.el [ Element.height (Element.px 8) ] (Element.text "")

        GItem item_ ->
            indexItem_ item_


indexItem_ : Item -> Element MarkupMsg
indexItem_ ( name, loc ) =
    Element.link [ Font.color (Element.rgb 0 0 0.8), Events.onClick (SelectId loc.id) ]
        { url = Render.Utility.internalLink loc.id, label = Element.el [] (Element.text (String.toLower name)) }



-- ENDNOTES


endnotes : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
endnotes _ acc _ attrs block =
    let
        endnoteList =
            acc.footnotes
                |> Dict.toList
                |> List.map
                    (\( content, meta ) ->
                        { label = Dict.get meta.id acc.footnoteNumbers |> Maybe.withDefault 0
                        , content = content
                        , id = meta.id ++ "_"
                        }
                    )
                |> List.sortBy .label
    in
    Element.column ([ Element.spacing 12 ] ++ attrs)
        (Element.el [ Font.bold ] (Element.text "Endnotes")
            :: List.map renderFootnote endnoteList
        )


renderFootnote : { label : Int, content : String, id : String } -> Element MarkupMsg
renderFootnote { label, content, id } =
    Element.paragraph [ Element.spacing 4 ]
        [ Element.el [ Render.Helper.htmlId id, Element.width (Element.px 24) ] (Element.text (String.fromInt label ++ "."))
        , Element.text content
        ]


type GroupItem
    = GBlankLine
    | GItem Item


type alias Item =
    ( String, { begin : Int, end : Int, id : String } )
