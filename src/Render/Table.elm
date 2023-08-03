module Render.Table exposing (render)

import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Font as Font
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (ExpressionBlock)
import List.Extra
import Render.Expression
import Render.Helper
import Render.Msg exposing (MarkupMsg(..))
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.Utility



--
--render : Int -> Accumulator -> RenderSettings -> ExpressionBlock -> Element MarkupMsg
--render count acc settings block =
--    let
--        formatString : List String
--        formatString =
--            String.words (Dict.get "format" block.properties |> Maybe.withDefault "")
--
--        formatList : List (Element.Attribute msg)
--        formatList =
--            List.map (\c -> Dict.get c formatDict |> Maybe.withDefault Element.centerX) formatString
--
--        lines =
--            Render.Utility.getVerbatimContent block |> String.split "\\\\"
--
--        cellsAsStrings_ : List (List String)
--        cellsAsStrings_ =
--            List.map (String.split "&") lines
--                |> List.map (List.map String.trim)
--
--        effectiveFontWidth_ =
--            9.0
--
--        maxRowSize : Maybe Int
--        maxRowSize =
--            List.map List.length cellsAsStrings_ |> List.maximum
--
--        cellsAsStrings =
--            List.filter (\row_ -> Just (List.length row_) == maxRowSize) cellsAsStrings_
--
--        columnWidths : List Int
--        columnWidths =
--            List.map (List.map (Render.Utility.textWidth settings.display)) cellsAsStrings
--                |> List.Extra.transpose
--                |> List.map (\column -> List.maximum column |> Maybe.withDefault 1)
--                |> List.map ((\w -> effectiveFontWidth_ * w) >> round)
--
--        fix colWidths fmtList =
--            let
--                m =
--                    List.length colWidths
--
--                n =
--                    List.length fmtList
--            in
--            case compare m n of
--                LT ->
--                    List.repeat m Element.centerX
--
--                EQ ->
--                    fmtList
--
--                GT ->
--                    List.repeat m Element.centerX
--
--        extendedFormatList : List ( Int, Element.Attribute msg )
--        extendedFormatList =
--            List.map2 (\x y -> ( x, y )) columnWidths (fix columnWidths formatList)
--
--        totalWidth =
--            List.sum columnWidths
--    in
--    Element.column
--        [ Element.paddingEach { left = 24, right = 0, top = 0, bottom = 0 }
--        , Render.Sync.rightToLeftSyncHelper block.meta.lineNumber (block.meta.lineNumber + block.meta.numberOfLines)
--        , Render.Utility.idAttributeFromInt block.meta.lineNumber
--        ]
--        (renderTable extendedFormatList block)
--
--
--renderer count acc settings attr expr =
--    Render.Expression.render count acc settings attr expr


render : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> Generic.Language.ExpressionBlock -> Element MarkupMsg
render count acc settings columnFormats block =
    case block.body of
        Right [ Generic.Language.Fun "table" rows _ ] ->
            let
                formatList_ =
                    Dict.get "format" block.properties
                        |> Maybe.withDefault ""
                        |> String.dropLeft 1
                        |> String.dropRight 1
                        |> String.split " "
                        |> List.map String.trim
                        |> List.map (\c -> Dict.get c formatDict |> Maybe.withDefault Element.centerX)

                columnWidths_ =
                    Dict.get "columnWidths" block.properties
                        |> Maybe.withDefault ""
                        |> String.dropLeft 1
                        |> String.dropRight 1
                        |> String.split ","
                        |> List.map String.trim
                        |> List.map (\c -> String.toInt c |> Maybe.withDefault 100)

                formats =
                    List.map2 (\x y -> ( x, y )) columnWidths_ formatList_
            in
            Element.column [ Element.paddingEach { left = 24, right = 0, top = 24, bottom = 24 } ]
                (List.map (renderRow count acc settings formats) rows)

        _ ->
            Element.none


renderRow : Int -> Accumulator -> RenderSettings -> List ( Int, Element.Attribute MarkupMsg ) -> Generic.Language.Expr Generic.Language.ExprMeta -> Element MarkupMsg
renderRow count acc settings columnFormats row =
    case row of
        Generic.Language.Fun "row" cells _ ->
            let
                list =
                    List.map2 (renderCell count acc settings) columnFormats cells
            in
            Element.row [] list

        _ ->
            Element.none


renderCell : Int -> Accumulator -> RenderSettings -> ( Int, Element.Attribute MarkupMsg ) -> Generic.Language.Expr Generic.Language.ExprMeta -> Element MarkupMsg
renderCell count acc settings ( colWidth, fmt ) cell =
    --Element.el [ Element.width (Element.px (colWidth + 18)) ]
    --    (Element.row [ Element.paddingXY 12 8, fmt ] list)
    case cell of
        Generic.Language.Fun "cell" exprs _ ->
            Element.el [ Element.width (Element.px <| colWidth + 10) ]
                (Element.row [ fmt ] (List.map (Render.Expression.render count acc settings []) exprs))

        _ ->
            Element.none


formatDict : Dict String (Element.Attribute msg)
formatDict =
    Dict.fromList
        [ ( "l", Element.alignLeft )
        , ( "r", Element.alignRight )
        , ( "c", Element.centerX )
        ]
