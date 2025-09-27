module Render.Export.LaTeXToScripta2 exposing (parseL, renderBlock, renderS, renderTree, translate)

import Either exposing (Either(..))
import Generic.Compiler
import Generic.Forest exposing (Forest)
import Generic.Language exposing (Expr(..), Expression, ExpressionBlock, Heading(..))
import MicroLaTeX.Expression
import MicroLaTeX.PrimitiveBlock
import RoseTree.Tree as Tree exposing (Tree)
import ScriptaV2.Config as Config
import ScriptaV2.Language exposing (Language(..))


{-| Translate LaTeX source code to Scripta (Enclosure) source code
-}
translate : String -> String
translate latexSource =
    let
        forest =
            parseL latexSource
    in
    if List.isEmpty forest && not (String.isEmpty (String.trim latexSource)) then
        -- If parsing produces an empty forest but we have non-empty input,
        -- treat it as plain text
        latexSource

    else
        renderS forest


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
-}
renderS : Forest ExpressionBlock -> String
renderS forest =
    forest
        |> List.map (renderTree 0)
        |> String.join "\n\n"


{-| Render a tree with proper indentation
-}
renderTree : Int -> Tree ExpressionBlock -> String
renderTree indent tree =
    let
        -- Create indentation string (2 spaces per level)
        indentStr =
            String.repeat (indent * 2) " "

        -- Render the current node's block with indentation
        currentBlock =
            Tree.value tree

        currentRendered =
            indentStr ++ renderBlock currentBlock

        -- Recursively render all children with increased indentation
        children =
            Tree.children tree

        childrenRendered =
            case children of
                [] ->
                    ""

                _ ->
                    children
                        |> List.map (renderTree (indent + 1))
                        |> String.join "\n"
                        |> (\s -> "\n" ++ s)
    in
    currentRendered ++ childrenRendered


{-| Render an individual ExpressionBlock to Scripta syntax
-}
renderBlock : ExpressionBlock -> String
renderBlock block =
    case block.heading of
        Paragraph ->
            -- Handle paragraph blocks
            renderParagraph block

        Ordinary name ->
            -- Handle ordinary blocks (sections, environments, etc.)
            renderOrdinary name block

        Verbatim name ->
            -- Handle verbatim blocks (code, math, etc.)
            renderVerbatim name block


{-| Render a paragraph block
-}
renderParagraph : ExpressionBlock -> String
renderParagraph block =
    case block.body of
        Left str ->
            -- Simple string content (trim to remove extra whitespace)
            String.trim str

        Right exprs ->
            -- Expression list
            exprs
                |> List.map renderExpression
                |> String.join " "
                |> String.trim


{-| Render an ordinary block (sections, environments, etc.)
-}
renderOrdinary : String -> ExpressionBlock -> String
renderOrdinary name block =
    case name of
        "section" ->
            -- Need to check if it's actually a subsection or subsubsection
            renderSectionWithLevel block ++ "\n"

        "subsection" ->
            renderSection 2 block ++ "\n"

        "subsubsection" ->
            renderSection 3 block ++ "\n"

        "itemize" ->
            ""

        "enumerate" ->
            ""

        _ ->
            -- Generic block
            "| " ++ name


{-| Render a verbatim block (code, math, etc.)
-}
renderVerbatim : String -> ExpressionBlock -> String
renderVerbatim name block =
    case name of
        "math" ->
            renderMathBlock block

        "equation" ->
            renderEquationBlock block

        "align" ->
            renderAlignedBlock block

        "code" ->
            renderCodeBlock block

        _ ->
            -- Generic verbatim block
            "| " ++ name


{-| Determine section level and render appropriately
-}
renderSectionWithLevel : ExpressionBlock -> String
renderSectionWithLevel block =
    let
        level =
            -- Check properties or firstLine to determine actual section level
            if String.contains "\\subsection" block.firstLine then
                2

            else if String.contains "\\subsubsection" block.firstLine then
                3

            else
                1
    in
    renderSection level block


{-| Render a section heading
-}
renderSection : Int -> ExpressionBlock -> String
renderSection level block =
    let
        marker =
            String.repeat level "#"

        title =
            case block.body of
                Right exprs ->
                    -- Extract title from Text expression in body
                    case exprs of
                        (Text titleText _) :: _ ->
                            titleText

                        _ ->
                            -- Fallback to args if no Text expression
                            case block.args of
                                arg :: _ ->
                                    arg

                                [] ->
                                    "Section"

                Left str ->
                    -- If body is a string, use it
                    str
    in
    marker ++ " " ++ title


{-| Render function arguments (typically section titles)
-}
renderArgs : List Expression -> String
renderArgs args =
    args
        |> List.map renderExpression
        |> String.join " "


{-| Render a single expression
-}
renderExpression : Expression -> String
renderExpression expr =
    case expr of
        Text str _ ->
            str

        Fun name args _ ->
            renderFunction name args

        VFun name arg _ ->
            renderVerbatimFunction name arg

        ExprList exprs _ ->
            exprs
                |> List.map renderExpression
                |> String.join " "


{-| Render a function call
-}
renderFunction : String -> List Expression -> String
renderFunction name args =
    case name of
        "bold" ->
            "[b " ++ renderArgs args ++ "]"

        "textbf" ->
            "[b " ++ renderArgs args ++ "]"

        "italic" ->
            "[i " ++ renderArgs args ++ "]"

        "emph" ->
            "[i " ++ renderArgs args ++ "]"

        _ ->
            "[" ++ name ++ " " ++ renderArgs args ++ "]"


{-| Render a verbatim function
-}
renderVerbatimFunction : String -> String -> String
renderVerbatimFunction name content =
    case name of
        "math" ->
            "$" ++ content ++ "$"

        "code" ->
            "`" ++ content ++ "`"

        _ ->
            "[" ++ name ++ " " ++ content ++ "]"


{-| Render a math block
-}
renderMathBlock : ExpressionBlock -> String
renderMathBlock block =
    case block.body of
        Left str ->
            "| math\n" ++ str

        _ ->
            "| math"


{-| Render a code block
-}
renderCodeBlock : ExpressionBlock -> String
renderCodeBlock block =
    case block.body of
        Left str ->
            "| code\n" ++ str

        _ ->
            "Error: Invalid code block"


{-| Render a equation block
-}
renderEquationBlock : ExpressionBlock -> String
renderEquationBlock block =
    case block.body of
        Left str ->
            "| equation\n" ++ str

        _ ->
            "Error: Invalid equation block"


{-| Render an aligned block
-}
renderAlignedBlock : ExpressionBlock -> String
renderAlignedBlock block =
    -- Check multiple sources for content
    let
        content =
            case block.body of
                Left str ->
                    String.trim str
                Right _ ->
                    -- Try to get content from args or properties
                    case block.args of
                        [] ->
                            -- Check if there's content in the sourceText of meta
                            let
                                sourceLines = String.lines block.meta.sourceText
                                -- Extract content between \begin{align} and \end{align}
                                extractContent lines =
                                    lines
                                        |> List.filter (\line ->
                                            not (String.contains "\\begin{align}" line) &&
                                            not (String.contains "\\end{align}" line))
                                        |> String.join "\n"
                                        |> String.trim
                            in
                            extractContent sourceLines
                        args ->
                            String.join "\n" args
    in
    if String.isEmpty content then
        "| aligned"
    else
        "| aligned\n" ++ content
