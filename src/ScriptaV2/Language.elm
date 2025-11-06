module ScriptaV2.Language exposing (Language(..), ExpressionBlock, toString)

{-|

@docs Language, ExpressionBlock, toString

-}

import Generic.Forest
import Generic.Language


{-| -}
type Language
    = MiniLaTeXLang
    | ScriptaLang
    | SMarkdownLang
    | MarkdownLang


{-| -}
type alias ExpressionBlock =
    Generic.Language.ExpressionBlock


{-| -}
toString : Language -> String
toString lang =
    case lang of
        MiniLaTeXLang ->
            "MiniLaTeX"

        ScriptaLang ->
            "Scripta"

        SMarkdownLang ->
            "SMarkdown"

        MarkdownLang ->
            "Markdown"
