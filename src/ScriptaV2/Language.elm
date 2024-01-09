module ScriptaV2.Language exposing (Language(..), ExpressionBlock)

{-|

@docs Language, ExpressionBlock

-}

import Generic.Forest
import Generic.Language


{-| -}
type Language
    = MicroLaTeXLang
    | EnclosureLang
    | SMarkdownLang


{-| -}
type alias ExpressionBlock =
    Generic.Language.ExpressionBlock
