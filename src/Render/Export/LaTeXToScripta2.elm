module Render.Export.LaTeXToScripta2 exposing (translate)

import Generic.Compiler
import Generic.Forest exposing (Forest)
import Generic.Language exposing (ExpressionBlock)
import MicroLaTeX.Expression
import MicroLaTeX.PrimitiveBlock
import RoseTree.Tree as Tree exposing (Tree)
import ScriptaV2.Config as Config
import ScriptaV2.Language exposing (Language(..))


{-| Translate LaTeX source code to Scripta (Enclosure) source code
-}
translate : String -> String
translate latexSource =
    latexSource
        |> parseL
        |> renderS


{-| Parse LaTeX source code to AST (List of Tree ExpressionBlock)
-}
parseL : String -> Forest ExpressionBlock
parseL latexSource =
    let
        lines =
            String.lines latexSource

        idPrefix =
            Config.idPrefix

        outerCount =
            0
    in
    Generic.Compiler.parse_
        MicroLaTeXLang
        MicroLaTeX.PrimitiveBlock.parse
        MicroLaTeX.Expression.parse
        idPrefix
        outerCount
        lines


{-| Render the AST to Scripta (Enclosure) syntax
TODO: This is a stub that needs to be implemented
-}
renderS : Forest ExpressionBlock -> String
renderS forest =
    -- For now, just return a placeholder
    -- This will be implemented in the next phase
    "% LaTeX to Scripta conversion not yet implemented\n"
        ++ "% AST contains "
        ++ String.fromInt (List.length forest)
        ++ " top-level trees"