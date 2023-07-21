module ScriptaV2.Helper exposing
    ( encodeForPDF, pdfFileNameToGet
    , fileNameForExport, prepareContentForExport
    , getName, getBlockNames, getImageUrls
    , banner, renderBody, setName, title, viewToc
    )

{-|


## PDF

@docs encodeForPDF, pdfFileNameToGet


## Export

@docs fileNameForExport, prepareContentForExport


## Getters

@docs getName, getBlockNames, getImageUrls


## Render

@docs banner, renderBody, setName, title, viewToc

-}

import Dict
import Either
import Element exposing (Attribute, Element)
import Generic.ASTTools as ASTTools
import Generic.Acc exposing (Accumulator)
import Generic.Forest exposing (Forest)
import Generic.Language exposing (ExpressionBlock)
import Json.Encode
import List.Extra
import Maybe.Extra
import Render.Block
import Render.Export.LaTeX
import Render.Msg exposing (MarkupMsg)
import Render.Settings
import Render.TOC
import Time
import Tools.Utility
import Tree


{-| -}
type alias RenderSettings =
    Render.Settings.RenderSettings


{-| -}
banner : List (Tree.Tree ExpressionBlock) -> Maybe ExpressionBlock
banner =
    ASTTools.banner


{-| -}
getName : ExpressionBlock -> Maybe String
getName =
    Generic.Language.getName


{-| -}
renderBody : Int -> Accumulator -> Render.Settings.RenderSettings -> List (Attribute MarkupMsg) -> ExpressionBlock -> List (Element MarkupMsg)
renderBody =
    Render.Block.renderBody


{-| -}
setName : String -> ExpressionBlock -> ExpressionBlock
setName =
    Generic.Language.setName


{-| -}
title : Forest ExpressionBlock -> String
title =
    ASTTools.title


{-| -}
viewToc : Int -> Accumulator -> List (Attribute MarkupMsg) -> Forest ExpressionBlock -> List (Element MarkupMsg)
viewToc counter acc attr ast =
    Render.TOC.view counter acc attr ast



--- Scripta.API ---


{-| Scripta.API provides the functions you will need for an application
that compiles source text in L0, microLaTeX, or XMarkdown to HTML.


# Simple compilation


## Example

`compile (displaySettings 0) "Pythagorean formula: $a^2 + b^2 = c^2$"` where
we define

    displaySettings : Int -> Scripta.API.DisplaySettings
    displaySettings counter =
        { windowWidth = 500
        , counter = counter
        , selectedId = "--"
        , selectedSlug = Nothing
        , scale = 0.8
        }

The counter field must be updated on each edit.
This is needed for the rendered text to be
properly updated. See the demo app in
folder `Example1`.


# Differential Compilation

Compilation can be sped up by keeping track of which blocks
of source text have changed and ony reparsing those blocks.
An `EditRecord` is used to keep track of what has changed
and what has not. In this setup, the `EditRecord` is
initialized with the source text using the `init` function.
On each document change it brought up to date by the
`update` function. The `render` function transforms
the current `EditRecord` into HTML.

@docs EditRecord, init, update, render, makeSettings


# Export

The `export` and `fileNameForExport` are functions used to transform source
text in a given markup language to standard LaTeX. The transformed text
can be used to produce a PDF file or a tar files that contains both the
standare LaTeX source and a folder of images used in the documents.
See the code in modules `PDF` and `Main` of `Example2` for more details.
The Elm app sends data to `https://pdfServ.app`, a small server
(165 lines of Haskell code) where it is turned into a PDF file or
tar archive where it is then accessible by a GET request.
See [pdfServer2@Github](https://github.com/jxxcarlson/pdfServer2).

@docs fileNameForExport, packageNames, prepareContentForExport, getImageUrls, banner, getBlockNames, rawExport, encodeForPDF


# Compatibility

The PDF module in Example2 requires these.

@docs Msg, SyntaxTree


# Utility

@docs matchingIdsInAST

-}



--
--import Compiler.ASTTools as ASTTools
--import Compiler.AbstractDifferentialParser
--import Compiler.DifferentialParser
--import Dict exposing (Dict)
--import Either exposing (Either(..))
--import Element exposing (..)
--import Json.Encode as E
--import List.Extra
--import Maybe.Extra
--import Parser.Block exposing (ExpressionBlock(..))
--import Parser.Forest exposing (Forest)
--import Regex
--import Render.Block
--import Render.Export.LaTeX
--import Render.Markup
--import Render.Msg exposing (MarkupMsg)
--import Render.Settings
--import Scripta.Language exposing (Language)
--import Scripta.TOC
--import Time
--import Tree
--
-- type alias MarkupMsg = Render.Msg.MarkupMsg
--{-| Compile source text in the given language using the given display settings.
---}
--compile : DisplaySettings -> Language -> String -> List (Element Render.Msg.MarkupMsg)
--compile displaySettings language sourceText =
--    sourceText
--        |> init Dict.empty language
--        |> render displaySettings
-- EDITOR


matchingIdsInAST =
    ASTTools.matchingIdsInAST



-- VIEW
-- EXPORT


{-| -}
fileNameForExport : Forest ExpressionBlock -> String
fileNameForExport ast =
    ast
        |> ASTTools.title
        |> compressWhitespace
        |> String.replace " " "-"
        |> removeNonAlphaNum
        |> (\s -> s ++ ".tex")


{-| -}
pdfFileNameToGet : Forest ExpressionBlock -> String
pdfFileNameToGet ast =
    ast
        |> ASTTools.title
        |> compressWhitespace
        |> String.replace " " "-"
        |> String.toLower
        |> removeNonAlphaNum
        |> (\s -> s ++ ".pdf")


packageDict =
    Dict.fromList [ ( "quiver", "quiver.sty" ) ]


{-| -}
packageNames : Forest ExpressionBlock -> List String
packageNames syntaxTree =
    getBlockNames syntaxTree
        |> List.map (\name -> Dict.get name packageDict)
        |> Maybe.Extra.values


{-| -}
prepareContentForExport : Time.Posix -> RenderSettings -> Forest ExpressionBlock -> String
prepareContentForExport currentTime settings syntaxTree =
    let
        contentForExport : String
        contentForExport =
            Render.Export.LaTeX.export currentTime settings syntaxTree
    in
    contentForExport


{-| -}
encodeForPDF : Time.Posix -> RenderSettings -> Forest ExpressionBlock -> Json.Encode.Value
encodeForPDF currentTime settings forest =
    let
        imageUrls : List String
        imageUrls =
            getImageUrls forest

        fileName : String
        fileName =
            fileNameForExport forest

        contentForExport : String
        contentForExport =
            prepareContentForExport currentTime settings forest

        packages : List String
        packages =
            packageNames forest
    in
    Json.Encode.object
        [ ( "id", Json.Encode.string fileName )
        , ( "content", Json.Encode.string contentForExport )
        , ( "urlList", Json.Encode.list Json.Encode.string imageUrls )
        , ( "packageList", Json.Encode.list Json.Encode.string packages )
        ]


{-| -}
getImageUrls : Forest ExpressionBlock -> List String
getImageUrls syntaxTree =
    getImageUrlsFromExpressions syntaxTree
        ++ getImageUrlsFromBlocks syntaxTree
        |> List.sort
        |> List.Extra.unique


getImageUrlsFromExpressions : Forest ExpressionBlock -> List String
getImageUrlsFromExpressions syntaxTree =
    syntaxTree
        |> List.map Tree.flatten
        |> List.concat
        |> List.map (\block -> Either.toList block.body)
        |> List.concat
        |> List.concat
        |> ASTTools.filterExpressionsOnName "image"
        |> List.map (ASTTools.getText >> Maybe.map String.trim)
        |> List.map (Maybe.andThen extractUrl)
        |> Maybe.Extra.values


getImageUrlsFromBlocks : Forest ExpressionBlock -> List String
getImageUrlsFromBlocks syntaxTree =
    syntaxTree
        |> List.map Tree.flatten
        |> List.concat
        |> ASTTools.filterBlocksOnName "image"
        |> List.map Generic.Language.getVerbatimContent
        |> Maybe.Extra.values


{-| -}
getBlockNames : Forest ExpressionBlock -> List String
getBlockNames syntaxTree =
    syntaxTree
        |> List.map Tree.flatten
        |> List.concat
        |> List.map Generic.Language.getName
        |> Maybe.Extra.values


extractUrl : String -> Maybe String
extractUrl str =
    str |> String.split " " |> List.head


compressWhitespace : String -> String
compressWhitespace string =
    Tools.Utility.userReplace "\\s\\s+" (\_ -> " ") string


removeNonAlphaNum : String -> String
removeNonAlphaNum string =
    Tools.Utility.userReplace "[^A-Za-z0-9\\-]" (\_ -> "") string



-- PARSER INTERFACE


body : { a | tree : Forest ExpressionBlock } -> Forest ExpressionBlock
body editRecord =
    editRecord.tree
