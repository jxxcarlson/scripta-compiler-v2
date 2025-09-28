module Render.Export.LaTeXToScripta2 exposing
    ( mathMacros
    , parseL
    , parseNewCommand
    , renderBlock
    , renderExpression
    , renderS
    , renderTree
    , translate
    )

import ETeX.KaTeX
import ETeX.MathMacros as E
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
        lines =
            String.lines latexSource

        -- Separate \newcommand lines from other content
        isNewCommand line =
            String.trim line |> String.startsWith "\\newcommand"

        ( newCommandLines, contentLines ) =
            lines
                |> List.partition isNewCommand

        -- Convert \newcommand lines to mathmacros
        macroBlock =
            if List.isEmpty newCommandLines then
                ""

            else
                mathMacros (String.join "\n" newCommandLines) ++ "\n\n"

        -- Parse and render the remaining content
        contentSource =
            String.join "\n" contentLines

        forest =
            parseL contentSource

        renderedContent =
            if List.isEmpty forest && not (String.isEmpty (String.trim contentSource)) then
                -- If parsing produces an empty forest but we have non-empty input,
                -- treat it as plain text
                contentSource

            else
                renderS forest
    in
    -- Combine macros and content
    macroBlock ++ renderedContent


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

        "item" ->
            renderItem block

        -- Theorem-like environments
        "theorem" ->
            renderTheoremLike "theorem" block

        "lemma" ->
            renderTheoremLike "lemma" block

        "proposition" ->
            renderTheoremLike "proposition" block

        "corollary" ->
            renderTheoremLike "corollary" block

        "definition" ->
            renderTheoremLike "definition" block

        -- Note-like environments
        "example" ->
            renderNoteLike "example" block

        "remark" ->
            renderNoteLike "remark" block

        "note" ->
            renderNoteLike "note" block

        -- Other common environments
        "abstract" ->
            renderEnvironment "abstract" block

        "quote" ->
            renderEnvironment "quote" block

        "center" ->
            renderEnvironment "center" block

        "figure" ->
            renderFigure block

        "table" ->
            renderTable block

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

        "verbatim" ->
            renderVerbatimBlock block

        "lstlisting" ->
            renderCodeBlock block

        "minted" ->
            renderCodeBlock block

        "figure" ->
            renderFigureVerbatim block

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
        "text" ->
            -- Convert \text{...} to quoted text "..." in Scripta math
            "\"" ++ renderArgs args ++ "\""

        "bold" ->
            "[b " ++ renderArgs args ++ "]"

        "textbf" ->
            "[b " ++ renderArgs args ++ "]"

        "italic" ->
            "[i " ++ renderArgs args ++ "]"

        "emph" ->
            "[i " ++ renderArgs args ++ "]"

        "underline" ->
            "[underline " ++ renderArgs args ++ "]"

        "footnote" ->
            "[footnote " ++ renderArgs args ++ "]"

        "cite" ->
            "[cite " ++ renderArgs args ++ "]"

        "compactItem" ->
            "- " ++ renderArgs args

        "ref" ->
            "[ref " ++ renderArgs args ++ "]"

        "label" ->
            "[label " ++ renderArgs args ++ "]"

        "href" ->
            case args of
                first :: second :: _ ->
                    -- MicroLaTeX gives us \href{url}{text} as args [url, text]
                    -- We need [link text url] in Scripta
                    -- So we swap: second (text) then first (url)
                    "[link " ++ renderExpression second ++ " " ++ renderExpression first ++ "]"

                single :: _ ->
                    "[link " ++ renderExpression single ++ "]"

                _ ->
                    "[link]"

        "includegraphics" ->
            case args of
                path :: _ ->
                    "[image " ++ renderExpression path ++ "]"

                _ ->
                    "[image]"

        "imagecentercaptioned" ->
            -- MicroLaTeX parser appears to give us args in reverse order: [caption, width, url]
            case args of
                caption :: width :: url :: _ ->
                    -- Three args: caption, width, url (in that order from parser)
                    let
                        _ =
                            width

                        -- Acknowledge width parameter even though we don't use it
                    in
                    "| image caption:" ++ renderExpression caption ++ "\n" ++ renderExpression url

                caption :: url :: _ ->
                    -- Two args: might be caption and url (width missing)
                    "| image caption:" ++ renderExpression caption ++ "\n" ++ renderExpression url

                url :: _ ->
                    -- One arg: just the URL
                    "| image\n" ++ renderExpression url

                _ ->
                    -- No args
                    "| image"

        _ ->
            "[" ++ name ++ " " ++ renderArgs args ++ "]"


{-| Render a verbatim function
-}
renderVerbatimFunction : String -> String -> String
renderVerbatimFunction name content =
    case name of
        "math" ->
            -- Convert LaTeX math to Scripta math format
            "$" ++ convertLatexMathToScripta content ++ "$"

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
            "| math\n" ++ convertLatexMathToScripta str

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


{-| Render a verbatim block
-}
renderVerbatimBlock : ExpressionBlock -> String
renderVerbatimBlock block =
    case block.body of
        Left str ->
            "| verbatim\n" ++ str

        _ ->
            "| verbatim"


{-| Render a equation block
-}
renderEquationBlock : ExpressionBlock -> String
renderEquationBlock block =
    case block.body of
        Left str ->
            "| equation\n" ++ convertLatexMathToScripta str

        _ ->
            "Error: Invalid equation block"


{-| Render an item block
-}
renderItem : ExpressionBlock -> String
renderItem block =
    let
        -- Check if we're in an enumerate context by looking at the source
        isEnumerate =
            String.contains "\\begin{enumerate}" block.meta.sourceText
                || String.contains "enumerate" block.firstLine

        prefix =
            if isEnumerate then
                ". "

            else
                "- "

        content =
            case block.body of
                Left str ->
                    String.trim str

                Right exprs ->
                    exprs |> List.map renderExpression |> String.join " "
    in
    prefix ++ content


{-| Render theorem-like environments
-}
renderTheoremLike : String -> ExpressionBlock -> String
renderTheoremLike envName block =
    let
        title =
            case block.args of
                [] ->
                    ""

                arg :: _ ->
                    " " ++ arg

        content =
            case block.body of
                Left str ->
                    String.trim str

                Right exprs ->
                    exprs |> List.map renderExpression |> String.join " "
    in
    "| " ++ envName ++ title ++ "\n" ++ content


{-| Render note-like environments
-}
renderNoteLike : String -> ExpressionBlock -> String
renderNoteLike envName block =
    let
        content =
            case block.body of
                Left str ->
                    String.trim str

                Right exprs ->
                    exprs |> List.map renderExpression |> String.join " "
    in
    "| " ++ envName ++ "\n" ++ content


{-| Render generic environments
-}
renderEnvironment : String -> ExpressionBlock -> String
renderEnvironment envName block =
    let
        content =
            case block.body of
                Left str ->
                    String.trim str

                Right exprs ->
                    exprs |> List.map renderExpression |> String.join " "
    in
    "| " ++ envName ++ "\n" ++ content


{-| Render figure environment
-}
renderFigure : ExpressionBlock -> String
renderFigure block =
    let
        caption =
            case block.args of
                [] ->
                    ""

                arg :: _ ->
                    "\nCaption: " ++ arg
    in
    "| figure" ++ caption


{-| Render table environment
-}
renderTable : ExpressionBlock -> String
renderTable block =
    case block.body of
        Left str ->
            "| table\n" ++ String.trim str

        Right _ ->
            "| table"


{-| Render a figure verbatim block
-}
renderFigureVerbatim : ExpressionBlock -> String
renderFigureVerbatim block =
    case block.body of
        Left str ->
            -- Parse the figure content to extract image and caption
            let
                lines =
                    String.lines str

                -- Look for \includegraphics command
                extractImageUrl line =
                    if String.contains "\\includegraphics" line then
                        -- Extract URL from \includegraphics[...]{url}
                        line
                            |> String.split "{"
                            |> List.drop 1
                            |> List.head
                            |> Maybe.withDefault ""
                            |> String.split "}"
                            |> List.head
                            |> Maybe.withDefault ""

                    else
                        ""

                -- Look for \caption command
                extractCaption lines_ =
                    lines_
                        |> List.filter (String.contains "\\caption")
                        |> List.head
                        |> Maybe.map
                            (\line ->
                                line
                                    |> String.split "\\caption{"
                                    |> List.drop 1
                                    |> String.join ""
                                    |> String.split "}"
                                    |> List.head
                                    |> Maybe.withDefault ""
                            )
                        |> Maybe.withDefault ""

                imageUrl =
                    lines
                        |> List.map extractImageUrl
                        |> List.filter ((/=) "")
                        |> List.head
                        |> Maybe.withDefault ""

                caption =
                    extractCaption lines
            in
            if String.isEmpty imageUrl then
                "| figure"

            else if String.isEmpty caption then
                "| image\n" ++ imageUrl

            else
                "| image caption:" ++ caption ++ "\n" ++ imageUrl

        _ ->
            "| figure"


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
                                sourceLines =
                                    String.lines block.meta.sourceText

                                -- Extract content between \begin{align} and \end{align}
                                extractContent lines =
                                    lines
                                        |> List.filter
                                            (\line ->
                                                not (String.contains "\\begin{align}" line)
                                                    && not (String.contains "\\end{align}" line)
                                            )
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
        "| aligned\n" ++ convertLatexMathToScripta content


{-| Convert LaTeX newcommand macros to Scripta mathmacros format
-}
mathMacros : String -> String
mathMacros latexMacros =
    let
        lines =
            String.lines latexMacros
                |> List.map String.trim
                |> List.filter (not << String.isEmpty)

        macroDefinitions =
            lines
                |> List.filterMap parseNewCommand
                |> List.map formatMacroDefinition
    in
    if List.isEmpty macroDefinitions then
        ""

    else
        "| mathmacros\n" ++ String.join "\n" macroDefinitions



--{-| Parse a single \\newcommand line
--Returns Just (name, body) or Nothing
---}
--parseNewCommand : String -> Maybe ( String, String )
--parseNewCommand line =
--    if String.startsWith "\\newcommand{\\" line then
--        let
--            -- Extract command name (without the backslash)
--            nameStart =
--                String.dropLeft 13 line
--
--            -- Drop "\\newcommand{\\" (13 chars)
--            nameEnd =
--                String.indexes "}" nameStart
--                    |> List.head
--                    |> Maybe.withDefault -1
--
--            name =
--                String.left nameEnd nameStart
--
--            -- Extract the body (everything between the final {...})
--            remainingAfterName =
--                String.dropLeft (nameEnd + 1) nameStart
--
--            -- Find the body between the last pair of braces
--            bodyStart =
--                String.indexes "{" remainingAfterName
--                    |> List.reverse
--                    |> List.head
--                    |> Maybe.map ((+) 1)
--                    |> Maybe.withDefault 0
--
--            bodyEnd =
--                String.indexes "}" remainingAfterName
--                    |> List.reverse
--                    |> List.head
--                    |> Maybe.withDefault (String.length remainingAfterName)
--
--            body =
--                String.slice bodyStart bodyEnd remainingAfterName
--                    |> transformMacroBody
--        in
--        if String.isEmpty name then
--            Nothing
--
--        else
--            Just ( name, body )
--
--    else
--        Nothing


{-| Transform the macro body from LaTeX to Scripta format
-}
transformMacroBody : String -> String
transformMacroBody body =
    body
        -- Replace LaTeX backslash commands with their names
        |> String.replace "\\langle" "langle"
        |> String.replace "\\rangle" "rangle"
        |> String.replace "\\frac{" "frac("
        -- Handle frac specifically - convert \frac{a}{b} to frac(a, b)
        |> transformFrac
        -- Clean up spaces
        |> String.trim


{-| Transform \\frac{a}{b} patterns to frac(a, b)
-}
transformFrac : String -> String
transformFrac str =
    if String.contains "frac(" str then
        -- Find and replace }{  with ,  for frac arguments
        let
            -- Simple approach: replace }{ with , when it appears after frac(
            parts =
                String.split "frac(" str

            processPart part =
                if String.contains "}" part && String.contains "{" part then
                    -- Find the first }{ pattern and replace with ,
                    String.replace "}{" ", " part
                        |> String.replace "}" ")"

                else
                    part

            processedParts =
                case parts of
                    first :: rest ->
                        first :: List.map processPart rest

                    [] ->
                        []
        in
        String.join "frac(" processedParts

    else
        str


{-| Format a macro definition for Scripta output
-}
formatMacroDefinition : ( String, String ) -> String
formatMacroDefinition ( name, body ) =
    name ++ ": " ++ body


{-| Parse a \\newcommand using the ETeX parser for better handling of complex expressions
-}
parseNewCommand : String -> Maybe ( String, String )
parseNewCommand line =
    case E.parseNewCommand line of
        Ok (E.NewCommand (E.MacroName name) _ bodyExprs) ->
            -- Convert the body expressions to Scripta format
            let
                body =
                    bodyExprs
                        |> List.map mathExprToScripta
                        |> String.join ""
                        |> String.trim
            in
            Just ( name, body )

        _ ->
            Nothing


{-| Convert LaTeX math content to Scripta math format
This uses the ETeX parser to parse LaTeX math and convert it to Scripta syntax
-}
convertLatexMathToScripta : String -> String
convertLatexMathToScripta latexMath =
    -- Parse the LaTeX math expression using ETeX parser
    case E.parse latexMath of
        Ok exprs ->
            -- Convert each expression to Scripta format
            exprs
                |> List.map mathExprToScripta
                |> String.join ""

        Err _ ->
            -- If parsing fails, return original LaTeX
            latexMath


{-| Convert ETeX MathExpr to Scripta format string
-}
mathExprToScripta : E.MathExpr -> String
mathExprToScripta expr =
    case expr of
        E.AlphaNum str ->
            str

        E.MacroName str ->
            -- Don't add backslash for macro names in Scripta format
            if ETeX.KaTeX.isKaTeX str then
                str

            else
                "\\" ++ str

        E.FunctionName str ->
            str

        E.Arg exprs ->
            -- For top-level Arg in parseNewCommand, we don't want braces
            -- The body comes wrapped in an Arg, so we just extract the content
            List.map mathExprToScripta exprs |> String.join ""

        E.Param n ->
            "#" ++ String.fromInt n

        E.WS ->
            " "

        E.MathSpace ->
            " "

        E.MathSmallSpace ->
            " "

        E.MathMediumSpace ->
            " "

        E.LeftMathBrace ->
            "\\{"

        E.RightMathBrace ->
            "\\}"

        E.MathSymbols str ->
            str

        E.Macro name args ->
            if List.isEmpty args then
                -- No arguments - check if it's a Greek letter or other special case
                case name of
                    -- Greek letters without backslash
                    "alpha" -> "alpha"
                    "beta" -> "beta"
                    "gamma" -> "gamma"
                    "delta" -> "delta"
                    "epsilon" -> "epsilon"
                    "zeta" -> "zeta"
                    "eta" -> "eta"
                    "theta" -> "theta"
                    "iota" -> "iota"
                    "kappa" -> "kappa"
                    "lambda" -> "lambda"
                    "mu" -> "mu"
                    "nu" -> "nu"
                    "xi" -> "xi"
                    "pi" -> "pi"
                    "rho" -> "rho"
                    "sigma" -> "sigma"
                    "tau" -> "tau"
                    "upsilon" -> "upsilon"
                    "phi" -> "phi"
                    "chi" -> "chi"
                    "psi" -> "psi"
                    "omega" -> "omega"
                    -- Capital Greek letters
                    "Gamma" -> "Gamma"
                    "Delta" -> "Delta"
                    "Theta" -> "Theta"
                    "Lambda" -> "Lambda"
                    "Xi" -> "Xi"
                    "Pi" -> "Pi"
                    "Sigma" -> "Sigma"
                    "Upsilon" -> "Upsilon"
                    "Phi" -> "Phi"
                    "Psi" -> "Psi"
                    "Omega" -> "Omega"
                    -- Special symbols without backslash
                    "otimes" -> "otimes"
                    "oplus" -> "oplus"
                    "times" -> "times"
                    "cdot" -> "cdot"
                    "infty" -> "infty"
                    "partial" -> "partial"
                    "nabla" -> "nabla"
                    -- Default: keep backslash
                    _ ->
                        if ETeX.KaTeX.isKaTeX name then
                            name
                        else
                            "\\" ++ name

            else
                -- Has arguments - special handling for functions
                case name of
                    -- \frac{num}{denom} to frac(num, denom)
                    "frac" ->
                        case args of
                            [ E.Arg num, E.Arg denom ] ->
                                "frac(" ++ (List.map mathExprToScripta num |> String.join "") ++ ", " ++ (List.map mathExprToScripta denom |> String.join "") ++ ")"

                            _ ->
                                "\\" ++ name ++ (List.map mathExprToScriptaArg args |> String.join "")

                    -- \tfrac is like frac
                    "tfrac" ->
                        case args of
                            [ E.Arg num, E.Arg denom ] ->
                                "frac(" ++ (List.map mathExprToScripta num |> String.join "") ++ ", " ++ (List.map mathExprToScripta denom |> String.join "") ++ ")"

                            _ ->
                                "\\" ++ name ++ (List.map mathExprToScriptaArg args |> String.join "")

                    -- \sqrt{x} to sqrt(x)
                    "sqrt" ->
                        case args of
                            [ E.Arg content ] ->
                                "sqrt(" ++ (List.map mathExprToScripta content |> String.join "") ++ ")"

                            _ ->
                                "\\" ++ name ++ (List.map mathExprToScriptaArg args |> String.join "")

                    -- \text{...} to "..."
                    "text" ->
                        case args of
                            [ E.Arg content ] ->
                                "\"" ++ (List.map mathExprToScripta content |> String.join "") ++ "\""

                            _ ->
                                "\\" ++ name ++ (List.map mathExprToScriptaArg args |> String.join "")

                    -- User-defined macros (like \ket) keep backslash (TODO: for now)
                    _ ->
                        if ETeX.KaTeX.isKaTeX name then
                            name ++ "(" ++ (List.map mathExprToScripta args |> String.join ", ") ++ ")"

                        else
                            "\\"
                                ++ name
                                ++ (List.map (mathExprToScripta >> (\x -> "{" ++ x ++ "}")) args |> String.join "")

        E.Expr exprs ->
            List.map mathExprToScripta exprs |> String.join ""

        E.Comma ->
            ","

        E.LeftParen ->
            "("

        E.RightParen ->
            ")"

        E.Sub deco ->
            "_" ++ decoToString deco

        E.Super deco ->
            "^" ++ decoToString deco


{-| Helper to convert arguments with proper bracing
-}
mathExprToScriptaArg : E.MathExpr -> String
mathExprToScriptaArg expr =
    case expr of
        E.Arg exprs ->
            -- For arguments in macro calls, we do want braces
            "{" ++ (List.map mathExprToScripta exprs |> String.join "") ++ "}"

        _ ->
            mathExprToScripta expr


{-| Convert Deco to string
-}
decoToString : E.Deco -> String
decoToString deco =
    case deco of
        E.DecoM expr ->
            mathExprToScripta expr

        E.DecoI n ->
            String.fromInt n
