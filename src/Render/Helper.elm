module Render.Helper exposing
    ( blockAttributes
    , blockLabel
    , features
    , fontColor
    , getLabel
    , htmlId
    , labeledArgs
    , leftPadding
    , noSuchOrdinaryBlock
    , noSuchVerbatimBlock
    , nonExportableOrdinaryBlocks
    , nonExportableVerbatimBlocks
    , noteFromPropertyKey
    , renderNothing
    , renderWithDefault
    , renderWithDefaultNarrow
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
import Render.Constants
import Render.Expression
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.Utility
import ScriptaV2.Msg exposing (MarkupMsg(..))


publicationData =
    { title = "No Title"
    , authorList = []
    , kind = "Article"
    }


features settings block =
    let
        author =
            case Dict.get "author" block.properties of
                Just a ->
                    a

                Nothing ->
                    ""

        indentation =
            -- If the argument list is empty, use the default width from settings,
            -- otherwise try to parse the first argument as an integer for the width.
            case List.head block.args of
                Nothing ->
                    Render.Constants.defaultIndentWidth

                Just str ->
                    case String.toInt str of
                        Just w ->
                            w

                        Nothing ->
                            Render.Constants.defaultIndentWidth

        italicStyle : Element.Attribute msg
        italicStyle =
            case Dict.get "style" block.properties of
                Just "italic" ->
                    Font.italic

                _ ->
                    Font.unitalicized

        colorValue =
            case Dict.get "color" block.properties of
                Just "red" ->
                    Element.rgb 0.8 0 0

                Just "blue" ->
                    Element.rgb 0 0 0.8

                Just "gray" ->
                    Element.rgb 0.5 0.5 0.5

                _ ->
                    Element.rgb 0 0 0

        bodyWidth =
            settings.width - indentation

        titleElement =
            case Dict.get "title" block.properties of
                Just title_ ->
                    Element.el
                        [ Element.paddingEach { left = indentation, right = 0, top = 0, bottom = 4 }
                        , Font.color colorValue
                        , Font.semiBold
                        ]
                        (Element.text title_)

                Nothing ->
                    Element.none

        authorElement =
            case Dict.get "author" block.properties of
                Just author_ ->
                    Element.el
                        [ Element.paddingEach { left = 0, right = 0, top = 0, bottom = 4 }
                        , Font.color colorValue
                        ]
                        (Element.text <| "(" ++ author_ ++ ")")

                Nothing ->
                    Element.none
    in
    { titleElement = titleElement
    , bodyWidth = bodyWidth
    , indentation = indentation
    , italicStyle = italicStyle
    , colorValue = colorValue
    , authorElement = authorElement
    }



-- SETTINGS


leftPadding k =
    Element.paddingEach { top = 0, right = 0, bottom = 0, left = k }


topPaddingForIndentedElements =
    10


nonExportableVerbatimBlocks =
    [ "hide", "svg", "chart", "include", "iframe" ]


nonExportableOrdinaryBlocks =
    [ "box", "set-key", "comment", "runninghead", "banner", "type", "setcounter", "q", "a" ]



-- HELPERS
-- oteFromPropertyKey : String -> ExpressionBlock -> Element MarkupMsg


noteFromPropertyKey key attrs block =
    case Dict.get key block.properties of
        Nothing ->
            Element.none

        Just note_ ->
            Element.paragraph attrs [ Element.text note_ ]


{-|

    Used in function env (render generic LaTeX environments)

-}
blockLabel : Dict String String -> String
blockLabel properties =
    Dict.get "label" properties |> Maybe.withDefault ""


blockAttributes settings block attrs =
    [ Render.Utility.idAttributeFromInt block.meta.lineNumber
    ]
        ++ Render.Sync.attributes settings block
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


htmlId : String -> Element.Attribute msg
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
        [ Element.paragraph [ Font.color (Element.rgb255 180 0 0) ] [ Element.text <| "No such block (V): " ++ functionName ]
        , Element.column [ Element.spacing 4 ] (List.map (\t -> Element.el [] (Element.text t)) (String.lines content))
        ]


noSuchOrdinaryBlock : Int -> Accumulator -> RenderSettings -> ExpressionBlock -> Element MarkupMsg
noSuchOrdinaryBlock count acc settings block =
    Element.column [ Element.spacing 4 ]
        [ Element.paragraph [ Font.color (Element.rgb255 180 0 0) ] [ Element.text <| "No such block (O):" ++ (block.args |> String.join " ") ]

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


renderWithDefaultNarrow : String -> Int -> Generic.Acc.Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> List Expression -> List (Element MarkupMsg)
renderWithDefaultNarrow default count acc settings attr exprs =
    if List.isEmpty exprs then
        [ Element.el [ Font.color settings.redColor, Font.size 14 ] (Element.text default) ]

    else
        List.map (Render.Expression.render count acc { settings | paragraphSpacing = 0 } attr) exprs
