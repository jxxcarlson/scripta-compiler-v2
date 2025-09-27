module Render.Export.Image exposing (export, exportBlock)

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

        -- For LaTeX figure environment, we want the width without comma prefix
        widthOption =
            if params.fractionalWidth == "" then
                "0.75\\textwidth"
            else
                params.fractionalWidth
    in
    exportCenteredFigure params.url widthOption params.caption


fixWidth : String -> String
fixWidth w =
    if w == "" || w == "fill" then
        "500"

    else
        w


export : RenderSettings -> List Expression -> String
export s exprs =
    let
        params =
            imageParameters s exprs

        -- For standard LaTeX, use fractional width
        widthOption =
            if params.fractionalWidth == "" then
                "0.75\\textwidth"
            else
                params.fractionalWidth
    in
    if params.url == "no-image" then
        "ERROR IN IMAGE"
    else
        if params.placement == "C" then
            exportCenteredFigure params.url widthOption params.caption
        else
            exportWrappedFigure params.placement params.url params.fractionalWidth params.caption


exportCenteredFigure url options caption =
    if caption == "none" || caption == "" then
        -- No caption, just center the image without figure environment
        [ "\\begin{center}\n"
        , "\\includegraphics[width=" ++ options ++ "]{" ++ url ++ "}\n"
        , "\\end{center}"
        ] |> String.join ""

    else
        -- With caption, use figure environment
        let
            -- Generate a label from the caption (simplified version)
            label =
                caption
                    |> String.words
                    |> List.take 2
                    |> String.join ""
                    |> String.toLower
                    |> String.filter Char.isAlphaNum
        in
        [ "\\begin{figure}[h]\n"
        , "  \\centering\n"
        , "  \\includegraphics[width=" ++ options ++ "]{" ++ url ++ "}\n"
        , "  \\caption{" ++ caption ++ "}\n"
        , "  \\label{fig:" ++ label ++ "}\n"
        , "\\end{figure}"
        ] |> String.join ""


exportWrappedFigure placement url options caption =
    -- For non-centered images, use wrapfigure package
    let
        placementChar =
            case placement of
                "L" -> "l"
                "R" -> "r"
                _ -> "r"
    in
    if caption == "none" || caption == "" then
        -- No caption, just wrap the image
        [ "\\begin{wrapfigure}{" ++ placementChar ++ "}{" ++ options ++ "}\n"
        , "\\centering\n"
        , "\\includegraphics[width=" ++ options ++ "]{" ++ url ++ "}\n"
        , "\\end{wrapfigure}"
        ] |> String.join ""
    else
        -- With caption
        let
            label =
                caption
                    |> String.words
                    |> List.take 2
                    |> String.join ""
                    |> String.toLower
                    |> String.filter Char.isAlphaNum
        in
        [ "\\begin{wrapfigure}{" ++ placementChar ++ "}{" ++ options ++ "}\n"
        , "\\centering\n"
        , "\\includegraphics[width=" ++ options ++ "]{" ++ url ++ "}\n"
        , "\\caption{" ++ caption ++ "}\n"
        , "\\label{fig:" ++ label ++ "}\n"
        , "\\end{wrapfigure}"
        ] |> String.join ""


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
    (toFloat k * (6.0 / toFloat displayWidth) |> String.fromFloat) ++ "truein"


fractionaRescale : Int -> String
fractionaRescale k =
    let
        f =
            (toFloat k / 600.0) |> String.fromFloat
    in
    [ f, "\\textwidth" ] |> String.join ""
