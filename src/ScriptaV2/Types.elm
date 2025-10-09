module ScriptaV2.Types exposing (..)

{-| -}

import Dict exposing (Dict)
import Render.Theme
import ScriptaV2.Language exposing (Language)


type Filter
    = NoFilter
    | SuppressDocumentBlocks


defaultCompilerParameters : CompilerParameters
defaultCompilerParameters =
    { lang = ScriptaV2.Language.EnclosureLang
    , docWidth = 800
    , editCount = 0
    , selectedId = ""
    , selectedSlug = Nothing
    , idsOfOpenNodes = []
    , filter = NoFilter
    , theme = Render.Theme.Light

    --
    , windowWidth = 800
    , longEquationLimit = 800
    , scale = 1
    , numberToLevel = 1
    , data = Dict.empty
    }


type alias CompilerParameters =
    { windowWidth : Int
    , scale : Float
    , lang : Language
    , docWidth : Int
    , editCount : Int
    , selectedId : String
    , selectedSlug : Maybe String
    , idsOfOpenNodes : List String
    , filter : Filter
    , theme : Render.Theme.Theme

    --
    , longEquationLimit : Float
    , numberToLevel : Int
    , data : Dict String String
    }
