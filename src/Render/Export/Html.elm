module Render.Export.Html exposing (export)

import Dict exposing (Dict)
import Either exposing (Either(..))
import File.Download
import Generic.ASTTools as ASTTools
import Generic.BlockUtilities
import Generic.Forest exposing (Forest)
import Generic.Language exposing (Expr(..), Expression, ExpressionBlock, Heading(..))
import Generic.TextMacro
import Html.Attributes exposing (style)
import Html.String as HS exposing (Html, div, text)
import List.Extra
import Maybe.Extra
import MicroLaTeX.Util
import Render.Data
import Render.Export.Image
import Render.Export.Preamble
import Render.Export.Util
import Render.Settings exposing (RenderSettings)
import Render.Utility as Utility
import Time
import Tools.Loop exposing (Step(..), loop)
import Tree exposing (Tree)


counterValue : Forest ExpressionBlock -> Maybe Int
counterValue ast =
    ast
        |> ASTTools.getBlockArgsByName "setcounter"
        |> List.head
        |> Maybe.andThen String.toInt


{-| -}
export : Time.Posix -> RenderSettings -> Forest ExpressionBlock -> Cmd msg
export currentTime settings_ ast =
    let
        rawBlockNames =
            ASTTools.rawBlockNames ast

        expressionNames =
            ASTTools.expressionNames ast ++ macrosInTextMacroDefinitions

        textMacroDefinitions =
            ASTTools.getVerbatimBlockValue "textmacros" ast

        macrosInTextMacroDefinitions =
            Generic.TextMacro.getTextMacroFunctionNames textMacroDefinitions
    in
    frontMatter currentTime ast |> download


download : String -> Cmd msg
download content =
    File.Download.string "out.html" "html/txt" content


frontMatter : Time.Posix -> Forest ExpressionBlock -> String
frontMatter currentTime ast =
    let
        dict =
            ASTTools.frontMatterDict ast

        author1 =
            Dict.get "author1" dict

        author2 =
            Dict.get "author2" dict

        author3 =
            Dict.get "author3" dict

        author4 =
            Dict.get "author4" dict

        authors : String
        authors =
            [ author1, author2, author3, author4 ]
                |> Maybe.Extra.values
                |> String.join "\n\\and\n"
                |> (\s -> "\\author{\n" ++ s ++ "\n}")

        title : String
        title =
            ASTTools.title ast |> (\title_ -> "\\title{" ++ title_ ++ "}")

        date : String
        date =
            Dict.get "date" dict |> Maybe.map (\date_ -> "\\date{" ++ date_ ++ "}") |> Maybe.withDefault ""
    in
    topmatter title date authors |> HS.toString 4


topmatter : String -> String -> String -> Html msg
topmatter title date authors =
    div
        []
        [ text title ]
