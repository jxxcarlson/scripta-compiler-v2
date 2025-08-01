module Render.Graphics exposing (image, image2, inlineimage, quiver, svg, tikz)

import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element, alignLeft, alignRight, centerX, column, el, px, rgb255, spacing)
import Element.Font as Font
import Generic.ASTTools as ASTTools
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (Expression, ExpressionBlock)
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.Utility
import ScriptaV2.Msg exposing (MarkupMsg(..))
import SvgParser
import Tools.Utility as Utility


red : Element.Color
red =
    rgb255 255 0 0


type alias ImageParameters msg =
    { caption : Element msg
    , description : String
    , placement : Element.Attribute msg
    , width : Element.Length
    , url : String
    , yPadding : Maybe Int
    }


image : Render.Settings.RenderSettings -> List (Element.Attribute MarkupMsg) -> List Expression -> Element MarkupMsg
image settings attrs body =
    let
        params =
            body |> argumentsFromAST |> imageParameters settings

        ypadding =
            case params.yPadding of
                Nothing ->
                    0

                Just k ->
                    k

        inner =
            column
                [ spacing 8, Element.width (px settings.width), params.placement, Element.paddingXY 0 ypadding ]
                [ Element.image [ Element.width params.width, params.placement ]
                    { src = params.url, description = params.description }
                , el [ params.placement ] params.caption
                ]
    in
    Element.newTabLink attrs
        { url = params.url
        , label = inner
        }


inlineimage : Render.Settings.RenderSettings -> List (Element.Attribute MarkupMsg) -> List Expression -> Element MarkupMsg
inlineimage settings attrs body =
    let
        params =
            body |> argumentsFromAST |> imageParameters settings

        inner =
            Element.image [ Element.width params.width, params.placement ]
                { src = params.url, description = params.description }
    in
    inner


{-| For \\image and [image ...]
-}
image2 : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
image2 _ _ settings attrs block =
    let
        width =
            case Dict.get "width" block.properties of
                Nothing ->
                    Element.px settings.width

                Just "fill" ->
                    Element.fill

                Just "to-edges" ->
                    Element.px (round (1.2 * toFloat settings.width))

                Just w_ ->
                    case String.toInt w_ of
                        Nothing ->
                            Element.px settings.width

                        Just w ->
                            Element.px w

        ypadding =
            case Dict.get "ypadding" block.properties of
                Nothing ->
                    18

                Just dy ->
                    dy |> String.toInt |> Maybe.withDefault 18

        url =
            case block.body of
                Left str ->
                    str

                Right _ ->
                    "bad block"

        params =
            parameters settings block.properties

        inner =
            column
                [ spacing 8
                , Element.paddingEach { left = 0, right = 0, top = ypadding + 6, bottom = ypadding }
                , Element.centerX
                ]
                [ Element.image [ Element.width params.width ]
                    { src = url, description = getDescription block.properties }
                , figureLabel
                ]

        figureLabel =
            case ( Dict.get "figure" block.properties, Dict.get "caption" block.properties ) of
                ( Nothing, Nothing ) ->
                    Element.none

                ( Nothing, Just cap ) ->
                    Element.el [ Element.centerX ] (Element.text cap)

                ( Just fig, Nothing ) ->
                    Element.el [ Element.centerX ] (Element.text ("Figure " ++ fig))

                ( Just fig, Just cap ) ->
                    Element.el [ Element.centerX ] (Element.text ("Figure " ++ fig ++ ". " ++ cap))

        outer =
            Element.newTabLink []
                { url = url
                , label = inner
                }
    in
    Element.column [ Element.width (Element.px settings.width) ]
        [ Element.column ([ Element.width width, Element.centerX ] ++ attrs ++ Render.Sync.attributes settings block)
            [ Element.el [ Element.width params.width, Element.spacing 0 ] outer ]
        ]



-- Property Helpers


getFigureLabel : Dict String String -> String
getFigureLabel dict =
    Dict.get "figure" dict |> Maybe.withDefault ""


getWidth : Dict String String -> Element.Length
getWidth properties =
    Dict.get "width" properties |> Maybe.andThen String.toInt |> Maybe.withDefault 400 |> Element.px


getCaption : Dict String String -> String
getCaption properties =
    Dict.get "caption" properties |> Maybe.withDefault ""


getDescription : Dict String String -> String
getDescription properties =
    Dict.get "description" properties |> Maybe.withDefault ""


getPlacement : Dict String String -> String
getPlacement properties =
    Dict.get "placement" properties |> Maybe.withDefault ""


getVerbatimContent : ExpressionBlock -> String
getVerbatimContent { body } =
    case body of
        Left str ->
            str

        Right _ ->
            ""


svg : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
svg count acc settings attrs block =
    case SvgParser.parse (getVerbatimContent block) of
        Ok html_ ->
            Element.column
                ([ Element.paddingEach { left = 0, right = 0, top = 24, bottom = 0 }
                 , Element.width (Element.px settings.width)
                 ]
                    ++ attrs
                    ++ Render.Sync.attributes settings block
                )
                [ Element.column [ Element.centerX ] [ html_ |> Element.html ]
                ]

        Err _ ->
            Element.el [] (Element.text "SVG parse error")


{-| Create elements from HTML markup. On parsing error, output no elements.
-}
tikz : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
tikz count acc settings attrs block =
    let
        maybePair_ =
            case String.split "---" (getVerbatimContent block) of
                a :: b :: [] ->
                    Just ( a, b )

                _ ->
                    Nothing
    in
    case maybePair_ of
        Nothing ->
            Element.el [ Font.size 16, Font.color red ] (Element.text "Something is wrong")

        Just ( imageData, _ ) ->
            let
                params =
                    String.words imageData |> imageParameters settings
            in
            Element.column
                ([ Element.spacing 8, Element.width (Element.px settings.width), params.placement, Element.paddingXY 0 18 ]
                    ++ attrs
                    ++ Render.Sync.attributes settings block
                )
                [ Element.image [ Element.width params.width, params.placement ]
                    { src = params.url, description = params.description }
                , Element.el [ params.placement ] params.caption
                ]


quiver : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
quiver _ _ settings attrs block =
    let
        -- arguments: ["width:250","caption:Fig","1"]
        qArgs : { caption : Maybe String, description : Maybe String, placement : Element.Attribute a, width : Element.Length }
        qArgs =
            parameters settings block.properties

        maybePair =
            case String.split "---" (getVerbatimContent block) of
                a :: b :: [] ->
                    Just ( a, b )

                _ ->
                    Nothing
    in
    case maybePair of
        Nothing ->
            Element.el [ Font.size 16, Font.color red ] (Element.text "Something is wrong")

        Just ( imageData, _ ) ->
            let
                params =
                    String.words imageData |> imageParameters settings

                desc =
                    case qArgs.caption of
                        Just caption ->
                            caption

                        _ ->
                            ""
            in
            Element.column
                ([ Element.spacing 8
                 , Element.width (Element.px settings.width)
                 ]
                    ++ attrs
                    ++ Render.Sync.attributes settings block
                )
                [ Element.image [ Element.width qArgs.width, params.placement ]
                    { src = params.url, description = desc }
                , Element.el
                    (Render.Sync.highlighter block.args
                        [ params.placement, params.placement, Element.paddingXY 12 4, Render.Utility.elementAttribute "id" block.meta.id ]
                    )
                    (Element.text desc)
                ]


argumentsFromAST : List Expression -> List String
argumentsFromAST body =
    ASTTools.exprListToStringList body |> List.map String.words |> List.concat


imageParameters : Render.Settings.RenderSettings -> List String -> ImageParameters msg
imageParameters settings arguments =
    let
        url =
            List.head arguments |> Maybe.withDefault "no-image"

        remainingArguments =
            List.drop 1 arguments

        keyValueStrings_ =
            List.filter (\s -> String.contains ":" s) remainingArguments

        keyValueStrings : List String
        keyValueStrings =
            List.filter (\s -> not (String.contains "caption" s)) keyValueStrings_

        captionLeadString =
            List.filter (\s -> String.contains "caption" s) keyValueStrings_
                |> String.join ""
                |> String.replace "caption:" ""

        captionPhrase =
            (captionLeadString :: List.filter (\s -> not (String.contains ":" s)) remainingArguments) |> String.join " "

        dict =
            Utility.keyValueDict keyValueStrings

        description : String
        description =
            Dict.get "caption" dict |> Maybe.withDefault ""

        caption : Element msg
        caption =
            if captionPhrase == "" then
                Element.none

            else
                Element.row [ placement, Element.width Element.fill ] [ el [ Element.width Element.fill ] (Element.text captionPhrase) ]

        displayWidth =
            settings.width

        yPadding =
            Dict.get "ypadding" dict |> Maybe.andThen String.toInt

        width : Element.Length
        width =
            case Dict.get "width" dict of
                Nothing ->
                    px displayWidth

                Just "fill" ->
                    Element.fill

                Just "to-edges" ->
                    px (round (1.5 * toFloat displayWidth))

                Just w_ ->
                    case String.toInt w_ of
                        Nothing ->
                            px displayWidth

                        Just w ->
                            px w

        placement =
            case Dict.get "placement" dict of
                Nothing ->
                    centerX

                Just "left" ->
                    alignLeft

                Just "right" ->
                    alignRight

                Just "center" ->
                    centerX

                _ ->
                    centerX
    in
    { caption = caption, description = description, placement = placement, width = width, url = url, yPadding = yPadding }


parameters :
    RenderSettings
    -> Dict String String
    ->
        { caption : Maybe String
        , description : Maybe String
        , placement : Element.Attribute msg
        , width : Element.Length
        }
parameters settings properties =
    let
        captionPhrase =
            Dict.get "caption" properties

        description =
            Dict.get "description" properties

        displayWidth =
            settings.width

        width : Element.Length
        width =
            case Dict.get "width" properties of
                Nothing ->
                    px displayWidth

                Just "fill" ->
                    Element.fill

                Just "to-edges" ->
                    px (displayWidth + 198)

                Just w_ ->
                    case String.toInt w_ of
                        Nothing ->
                            px displayWidth

                        Just w ->
                            px w

        placement =
            case Dict.get "placement" properties of
                Nothing ->
                    centerX

                Just "left" ->
                    alignLeft

                Just "right" ->
                    alignRight

                Just "center" ->
                    centerX

                _ ->
                    centerX
    in
    { caption = captionPhrase, description = description, placement = placement, width = width }
