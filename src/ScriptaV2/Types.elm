module ScriptaV2.Types exposing (CompilerParameters, defaultCompilerParameters, Filter(..))

{-| This module defines the core types used for configuring the Scripta compiler.
The main type is `CompilerParameters`, which controls how source text is compiled
and rendered across all supported markup languages (MicroLaTeX, SMarkdown, L0/Enclosure).


# Configuration

@docs CompilerParameters, defaultCompilerParameters, Filter


## Key Parameters

  - **lang**: The markup language to compile (MicroLaTeX, SMarkdown, or Enclosure)
  - **docWidth**: Width of the rendered document in pixels
  - **editCount**: Increment this after each edit for live editing contexts (use 0 for static documents)
  - **selectedId**: ID of the currently selected block for highlighting
  - **theme**: Visual theme (Light or Dark)
  - **idsOfOpenNodes**: List of IDs for expanded/collapsed sections


## Usage

For simple use cases, start with `defaultCompilerParameters` and override the fields you need:

    { defaultCompilerParameters
        | lang = ScriptaV2.Language.MicroLaTeXLang
        , docWidth = 600
        , editCount = model.editCount
    }

-}

import Dict exposing (Dict)
import Render.Theme
import ScriptaV2.Language exposing (Language)


{-| -}
type Filter
    = NoFilter
    | SuppressDocumentBlocks


{-| -}
defaultCompilerParameters : CompilerParameters
defaultCompilerParameters =
    { lang = ScriptaV2.Language.ScriptaLang
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


{-| -}
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
