module Render.Helper exposing
    ( blockAttributes
    , blockLabel
    , fontColor
    , getLabel
    , htmlId
    , labeledArgs
    , noSuchOrdinaryBlock
    , noSuchVerbatimBlock
    , nonExportableOrdinaryBlocks
    , nonExportableVerbatimBlocks
    , renderNothing
    , renderWithDefault
    , selectedColor
    , showError
    , topPaddingForIndentedElements
    )

import Dict exposing (Dict)
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (Expr(..), Expression, ExpressionBlock, Heading(..))
import Html.Attributes
import Render.Expression
import Render.Msg exposing (MarkupMsg(..))
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.Utility



-- SETTINGS


topPaddingForIndentedElements =
    10


nonExportableVerbatimBlocks =
    [ "hide", "svg", "chart", "include", "iframe" ]


nonExportableOrdinaryBlocks =
    [ "box", "set-key", "comment", "runninghead", "banner", "type", "setcounter", "q", "a" ]



-- HELPERS


{-|

    Used in function env (render generic LaTeX environments)

-}
blockLabel : Dict String String -> String
blockLabel properties =
    Dict.get "label" properties |> Maybe.withDefault ""


blockAttributes settings block attrs =
    [ Render.Sync.rightToLeftSyncHelper block.meta.lineNumber block.meta.numberOfLines
    , Render.Utility.idAttributeFromInt block.meta.lineNumber
    ]
        ++ Render.Sync.highlightIfIdIsSelected block.meta.lineNumber block.meta.numberOfLines settings
        ++ attrs


fontColor selectedId selectedSlug docId =
    if selectedId == docId then
        Font.color (Element.rgb 0.8 0 0)

    else if selectedSlug == Just docId then
        Font.color (Element.rgb 0.8 0 0)

    else
        Font.color (Element.rgb 0 0 0.9)


getLabel : Dict String String -> String
getLabel dict =
    Dict.get "label" dict |> Maybe.withDefault ""


labeledArgs : List String -> String
labeledArgs args =
    List.map (\s -> String.replace "label:" "" s) args |> String.join " "


selectedColor id settings =
    if id == settings.selectedId then
        Background.color (Element.rgb 0.9 0.9 1.0)

    else
        Background.color settings.backgroundColor


htmlId str =
    Element.htmlAttribute (Html.Attributes.id str)


showError : Maybe String -> Element msg -> Element msg
showError maybeError x =
    case maybeError of
        Nothing ->
            x

        Just error ->
            Element.column []
                [ x
                , Element.el [ Font.color (Element.rgb 0.7 0 0) ] (Element.text error)
                ]



-- ERRORS.


noSuchVerbatimBlock : String -> String -> Element MarkupMsg
noSuchVerbatimBlock functionName content =
    Element.column [ Element.spacing 4 ]
        [ Element.paragraph [ Font.color (Element.rgb255 180 0 0) ] [ Element.text <| "No such block: " ++ functionName ]
        , Element.column [ Element.spacing 4 ] (List.map (\t -> Element.el [] (Element.text t)) (String.lines content))
        ]


noSuchOrdinaryBlock : Int -> Accumulator -> RenderSettings -> ExpressionBlock -> Element MarkupMsg
noSuchOrdinaryBlock count acc settings block =
    Element.column [ Element.spacing 4 ]
        [ Element.paragraph [ Font.color (Element.rgb255 180 0 0) ] [ Element.text <| "No such block:" ++ (block.args |> String.join " ") ]

        -- TODO fix this
        --, Element.paragraph [] (List.map (Render.Expression.render count acc settings) (Generic.Language.getExpressionContent block))
        ]


renderNothing : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
renderNothing _ _ _ _ _ =
    Element.none


renderWithDefault : String -> Int -> Generic.Acc.Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> List Expression -> List (Element MarkupMsg)
renderWithDefault default count acc settings attr exprs =
    if List.isEmpty exprs then
        [ Element.el [ Font.color settings.redColor, Font.size 14 ] (Element.text default) ]

    else
        List.map (Render.Expression.render count acc settings attr) exprs
