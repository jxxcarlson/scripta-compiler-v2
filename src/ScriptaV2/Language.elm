module ScriptaV2.Language exposing (Language(..), ExpressionBlock)

{-|

@docs Language, ExpressionBlock

-}

import Generic.Forest
import Generic.Language


{-| -}
type Language
    = MicroLaTeXLang
    | L0Lang
    | XMarkdownLang


{-| -}
type alias ExpressionBlock =
    Generic.Language.ExpressionBlock
