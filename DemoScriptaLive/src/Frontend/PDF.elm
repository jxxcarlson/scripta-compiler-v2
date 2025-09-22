module Frontend.PDF exposing (pdfResponseDecoder, requestPDF)

import Common.Model exposing (CommonMsg(..), PdfResponse)
import Config
import Http
import Json.Decode as D
import Json.Encode as E
import Render.Export.LaTeX
import Render.Settings
import ScriptaV2.Compiler
import ScriptaV2.Helper
import ScriptaV2.Language
import Time


type alias ExportData =
    { title : String
    , content : String
    , sourceText : String
    , language : ScriptaV2.Language.Language
    }


type alias ImageRecord =
    { url : String
    , filename : String
    }


pdfResponseDecoder : D.Decoder PdfResponse
pdfResponseDecoder =
    D.map4 PdfResponse
        (D.maybe (D.field "pdf" D.string))
        (D.maybe (D.field "errorReport" D.string))
        (D.field "hasErrors" D.bool)
        (D.oneOf [ D.field "pdfFailed" D.bool, D.succeed False ])


requestPDF : ExportData -> Cmd CommonMsg
requestPDF exportData =
    let
        syntaxTree =
            ScriptaV2.Compiler.parseFromString exportData.language exportData.sourceText

        imageUrls =
            ScriptaV2.Helper.getImageUrls syntaxTree

        imageRecords =
            urlsToImageRecords imageUrls

        processedContent =
            substituteFilenameForUrls imageRecords exportData.content
    in
    Http.post
        { url = Config.pdfServer ++ "/pdf"
        , body = Http.jsonBody (encodeForPDF exportData.title processedContent imageRecords)
        , expect = Http.expectJson GotPdfResponse pdfResponseDecoder
        }


urlsToImageRecords : List String -> List ImageRecord
urlsToImageRecords urls =
    List.indexedMap
        (\index url ->
            { url = url
            , filename =
                if String.startsWith "https://imagedelivery.net" url then
                    "cf-image-" ++ String.fromInt (index + 1) ++ ".jpg"
                else
                    "image-" ++ String.fromInt (index + 1) ++ ".jpg"
            }
        )
        urls


substituteFilenameForUrls : List ImageRecord -> String -> String
substituteFilenameForUrls imageRecords str =
    let
        folder record acc =
            String.replace (String.replace "https://" "" record.url) record.filename acc
                |> String.replace ("https://" ++ record.filename) record.filename
    in
    List.foldl folder str imageRecords


encodeForPDF : String -> String -> List ImageRecord -> E.Value
encodeForPDF title content imageRecords =
    E.object
        [ ( "id", E.string (normalize title ++ ".tex") )
        , ( "title", E.string title )
        , ( "content", E.string content )
        , ( "packageList", E.list E.string [] )
        , ( "urlList", E.list encodeImageRecord imageRecords )
        ]


encodeImageRecord : ImageRecord -> E.Value
encodeImageRecord record =
    E.object
        [ ( "filename", E.string record.filename )
        , ( "url", E.string record.url )
        ]


normalize : String -> String
normalize str =
    str
        |> String.replace " " "-"
        |> String.replace "." "-"
        |> String.replace "," "-"
        |> String.toLower