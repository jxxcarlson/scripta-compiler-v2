module Config exposing (pdfServUrl, pdfServer)

{-| Configuration for PDF server endpoints
-}

import Env


pdfServer : String
pdfServer =
    case Env.mode of
        Env.Production ->
            "https://pdfserv.app"

        Env.Development ->
            "http://localhost:3000"


pdfServUrl : String
pdfServUrl =
    pdfServer ++ "/pdf/"
