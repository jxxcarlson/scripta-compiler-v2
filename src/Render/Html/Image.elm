module Render.Html.Image exposing (export, exportBlock)

import Dict
import Either exposing (Either(..))
import Generic.ASTTools
import Generic.Language exposing (Expression, ExpressionBlock)
import List.Extra
import Render.Export.Util
import Render.Settings exposing (RenderSettings)
import Render.Utility
import Tools.Utility as Utility


exportBlock : RenderSettings -> ExpressionBlock -> String
exportBlock settings block =
    let
        params =
            imageParametersForBlock settings block

        options =
            [ params.fractionalWidth, ",keepaspectratio" ] |> String.join ""
    in
    exportCenteredFigure params.url params options params.caption


fixWidth : String -> String
fixWidth w =
    if w == "" || w == "fill" then
        "500"

    else
        w


export : RenderSettings -> List Expression -> String
export s exprs =
    let
        args =
            Render.Export.Util.getOneArg exprs |> String.words

        params : ImageParameters
        params =
            imageParameters s exprs

        options =
            [ params.width |> fixWidth, ",keepaspectratio" ] |> String.join ""
    in
    case List.head args of
        Nothing ->
            "ERROR IN IMAGE"

        Just url_ ->
            if params.placement == "C" then
                exportCenteredFigure url_ params options params.caption

            else
                -- exportWrappedFigure params.placement url_ params.fractionalWidth params.caption
                exportCenteredFigure url_ params options params.caption



-- exportCenteredFigure params.url options params.caption


exportCenteredFigure url params options caption =
    if caption == "none" then
        "<img src=" ++ params.url ++ " width=" ++ params.width ++ " >"
        --[ "\\imagecenter{", url, "}{" ++ options ++ "}" ] |> String.join ""

    else
        "<img src=" ++ url ++ " width=" ++ params.width ++ " >"



--  [ "\\imagecentercaptioned{", url, "}{" ++ options ++ "}{" ++ caption ++ "}" ] |> String.join ""


exportWrappedFigure placement url params options caption =
    "<img src=" ++ url ++ " width=" ++ params.width ++ " >"



--[ "\\imagefloat{", url, "}{" ++ options ++ "}{" ++ caption ++ "}{" ++ placement ++ "}" ]
-- string.join ""


type alias ImageParameters =
    { caption : String
    , description : String
    , placement : String
    , width : String
    , fractionalWidth : String
    , url : String
    }


imageParameters : Render.Settings.RenderSettings -> List Expression -> ImageParameters
imageParameters settings body =
    let
        arguments : List String
        arguments =
            Generic.ASTTools.exprListToStringList body |> List.map String.words |> List.concat

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

        caption =
            (captionLeadString :: List.filter (\s -> not (String.contains ":" s)) remainingArguments) |> String.join " "

        dict =
            Utility.keyValueDict keyValueStrings

        description =
            Dict.get "caption" dict |> Maybe.withDefault ""

        displayWidth =
            settings.width

        width : String
        width =
            case Dict.get "width" dict of
                Nothing ->
                    rescale displayWidth displayWidth

                Just "fill" ->
                    rescale displayWidth displayWidth

                Just w_ ->
                    case String.toInt w_ of
                        Nothing ->
                            rescale displayWidth displayWidth

                        Just w ->
                            rescale displayWidth w

        fractionalWidth : String
        fractionalWidth =
            case Dict.get "width" dict of
                Nothing ->
                    fractionaRescale displayWidth

                Just "fill" ->
                    fractionaRescale displayWidth

                Just w_ ->
                    case String.toInt w_ of
                        Nothing ->
                            fractionaRescale displayWidth

                        Just w ->
                            fractionaRescale w

        placement =
            case Dict.get "placement" dict of
                Nothing ->
                    "C"

                Just "left" ->
                    "L"

                Just "right" ->
                    "R"

                Just "center" ->
                    "C"

                _ ->
                    "C"
    in
    { caption = caption, description = description, placement = placement, width = width, fractionalWidth = fractionalWidth, url = url }


imageParametersForBlock : Render.Settings.RenderSettings -> ExpressionBlock -> ImageParameters
imageParametersForBlock settings block =
    let
        url =
            case block.body of
                Left str ->
                    str

                Right _ ->
                    "bad block"

        caption =
            Dict.get "caption" block.properties |> Maybe.withDefault "" |> String.replace ":" ""

        displayWidth =
            settings.width

        width : String
        width =
            case Dict.get "width" block.properties of
                Nothing ->
                    rescale displayWidth displayWidth

                Just "fill" ->
                    rescale displayWidth displayWidth

                Just w_ ->
                    case String.toInt w_ of
                        Nothing ->
                            rescale displayWidth displayWidth

                        Just w ->
                            rescale displayWidth w

        fractionalWidth : String
        fractionalWidth =
            case Dict.get "width" block.properties of
                Nothing ->
                    "0.51\\textwidth"

                Just "fill" ->
                    fractionaRescale displayWidth

                Just w_ ->
                    case String.toInt w_ of
                        Nothing ->
                            fractionaRescale displayWidth

                        Just w ->
                            fractionaRescale w

        placement =
            case Dict.get "placement" block.properties of
                Nothing ->
                    "C"

                Just "left" ->
                    "L"

                Just "right" ->
                    "R"

                Just "center" ->
                    "C"

                _ ->
                    "C"
    in
    { caption = caption, description = caption, placement = placement, width = width, fractionalWidth = fractionalWidth, url = url }


rescale : Int -> Int -> String
rescale displayWidth k =
    toFloat k * (600.0 / toFloat displayWidth) |> String.fromFloat


fractionaRescale : Int -> String
fractionaRescale k =
    let
        f =
            (toFloat k / 600.0) |> String.fromFloat
    in
    [ f, "\\textwidth" ] |> String.join ""
