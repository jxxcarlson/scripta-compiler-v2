module Render.Export.LaTeXToScripta2 exposing
    ( convertVerbatimBacktick
    , mathMacros
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
import Regex
import RoseTree.Tree as Tree exposing (Tree)
import ScriptaV2.Config as Config
import ScriptaV2.Language exposing (Language(..))


{-| Translate LaTeX source code to Scripta (Enclosure) source code
-}
translate : String -> String
translate latexSource =
    let
        lines =
            String.lines (convertVerbatimBacktick latexSource)

        -- Separate \newcommand lines from other content
        isNewCommand line =
            String.trim line |> String.startsWith "\\newcommand"

        ( newCommandLines, contentLines ) =
            lines
                |> List.partition isNewCommand

        newMacroNames : List String
        newMacroNames =
            newCommandLines
                |> List.filterMap
                    (\line ->
                        case E.parseNewCommand line of
                            Ok (E.NewCommand (E.MacroName name) _ _) ->
                                Just name

                            _ ->
                                Nothing
                    )

        -- Convert \newcommand lines to mathmacros
        macroBlock : String
        macroBlock =
            if List.isEmpty newCommandLines then
                ""

            else
                mathMacros newMacroNames (String.join "\n" newCommandLines) ++ "\n\n"

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
                renderS newMacroNames forest
    in
    -- Combine macros and content
    macroBlock ++ renderedContent


convertVerbatimBacktick : String -> String
convertVerbatimBacktick input =
    let
        -- Pattern specifically for verb`...` (no backslash required)
        verbPattern =
            Maybe.withDefault Regex.never <|
                Regex.fromString "verb`([^`]*)`"

        replacer : Regex.Match -> String
        replacer match =
            case match.submatches of
                [ Just content ] ->
                    "`" ++ content ++ "`"

                _ ->
                    match.match
    in
    Regex.replace verbPattern replacer input


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
renderS : List String -> Forest ExpressionBlock -> String
renderS newMacroNames forest =
    forest
        |> List.map (renderTree newMacroNames 0)
        |> String.join "\n\n"


{-| Render a tree with proper indentation
-}
renderTree : List String -> Int -> Tree ExpressionBlock -> String
renderTree newMacroNames indent tree =
    let
        -- Create indentation string (2 spaces per level)
        indentStr =
            String.repeat (indent * 2) " "

        -- Render the current node's block with indentation
        currentBlock =
            Tree.value tree

        currentRendered =
            indentStr ++ renderBlock newMacroNames currentBlock

        -- Recursively render all children with increased indentation
        children =
            Tree.children tree

        childrenRendered =
            case children of
                [] ->
                    ""

                _ ->
                    children
                        |> List.map (renderTree newMacroNames (indent + 1))
                        |> String.join "\n"
                        |> (\s -> "\n" ++ s)
    in
    currentRendered ++ childrenRendered


{-| Render an individual ExpressionBlock to Scripta syntax
-}
renderBlock : List String -> ExpressionBlock -> String
renderBlock newMacroNames block =
    case block.heading of
        Paragraph ->
            -- Handle paragraph blocks
            renderParagraph newMacroNames block

        Ordinary name ->
            -- Handle ordinary blocks (sections, environments, etc.)
            renderOrdinary newMacroNames name block

        Verbatim name ->
            -- Handle verbatim blocks (code, math, etc.)
            renderVerbatim newMacroNames name block


{-| Render a paragraph block
-}
renderParagraph : List String -> ExpressionBlock -> String
renderParagraph newMacroNames block =
    case block.body of
        Left str ->
            -- Simple string content (trim to remove extra whitespace)
            String.trim str

        Right exprs ->
            -- Expression list
            exprs
                |> List.map (renderExpression newMacroNames)
                |> String.join " "
                |> String.trim


{-| Render an ordinary block (sections, environments, etc.)
-}
renderOrdinary : List String -> String -> ExpressionBlock -> String
renderOrdinary newMacroNames name block =
    case name of
        "section" ->
            -- Need to check if it's actually a subsection or subsubsection
            renderSectionWithLevel block

        "subsection" ->
            renderSection 2 block

        "subsubsection" ->
            renderSection 3 block

        "itemize" ->
            ""

        "enumerate" ->
            ""

        "item" ->
            renderItem newMacroNames block

        -- Theorem-like environments
        "theorem" ->
            renderTheoremLike newMacroNames "theorem" block

        "lemma" ->
            renderTheoremLike newMacroNames "lemma" block

        "proposition" ->
            renderTheoremLike newMacroNames "proposition" block

        "corollary" ->
            renderTheoremLike newMacroNames "corollary" block

        "definition" ->
            renderTheoremLike newMacroNames "definition" block

        -- Note-like environments
        "example" ->
            renderNoteLike newMacroNames "example" block

        "remark" ->
            renderNoteLike newMacroNames "remark" block

        "note" ->
            renderNoteLike newMacroNames "note" block

        -- Other common environments
        "abstract" ->
            renderEnvironment newMacroNames "abstract" block

        "quote" ->
            renderEnvironment newMacroNames "quote" block

        "center" ->
            renderCenterEnvironment newMacroNames block

        "figure" ->
            renderFigure block

        "table" ->
            renderTable block

        _ ->
            -- Generic block
            "| " ++ name


{-| Render a verbatim block (code, math, etc.)
-}
renderVerbatim : List String -> String -> ExpressionBlock -> String
renderVerbatim newMacroNames name block =
    case name of
        "math" ->
            renderMathBlock newMacroNames block

        "equation" ->
            renderEquationBlock newMacroNames block

        "align" ->
            renderAlignedBlock newMacroNames block

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
renderArgs : List String -> List Expression -> String
renderArgs newMacroNames args =
    args
        |> List.map (renderExpression newMacroNames)
        |> String.join " "


{-| Render a single expression
-}
renderExpression : List String -> Expression -> String
renderExpression newMacroNames expr =
    case expr of
        Text str _ ->
            str

        Fun name args _ ->
            renderFunction newMacroNames name args

        VFun name arg _ ->
            renderVerbatimFunction newMacroNames name arg

        ExprList exprs _ ->
            exprs
                |> List.map (renderExpression newMacroNames)
                |> String.join " "


{-| Render a function call
-}
renderFunction : List String -> String -> List Expression -> String
renderFunction newMacroNames name args =
    case name of
        "text" ->
            -- Convert \text{...} to quoted text "..." in Scripta math
            "\"" ++ renderArgs newMacroNames args ++ "\""

        "bold" ->
            "[b " ++ renderArgs newMacroNames args ++ "]"

        "textbf" ->
            "[b " ++ renderArgs newMacroNames args ++ "]"

        "italic" ->
            "[i " ++ renderArgs newMacroNames args ++ "]"

        "emph" ->
            "[i " ++ renderArgs newMacroNames args ++ "]"

        "underline" ->
            "[u " ++ renderArgs newMacroNames args ++ "]"

        "footnote" ->
            "[footnote " ++ renderArgs newMacroNames args ++ "]"

        "cite" ->
            "[cite " ++ renderArgs newMacroNames args ++ "]"

        "compactItem" ->
            "- " ++ renderArgs newMacroNames args

        "ref" ->
            "[ref " ++ renderArgs newMacroNames args ++ "]"

        "label" ->
            "[label " ++ renderArgs newMacroNames args ++ "]"

        "href" ->
            case args of
                first :: second :: _ ->
                    -- MicroLaTeX gives us \href{url}{text} as args [url, text]
                    -- We need [link text url] in Scripta
                    -- So we swap: second (text) then first (url)
                    "[link " ++ renderExpression newMacroNames second ++ " " ++ renderExpression newMacroNames first ++ "]"

                single :: _ ->
                    "[link " ++ renderExpression newMacroNames single ++ "]"

                _ ->
                    "[link]"

        "includegraphics" ->
            case args of
                path :: _ ->
                    "[image " ++ renderExpression newMacroNames path ++ "]"

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
                    "| image caption:" ++ renderExpression newMacroNames caption ++ "\n" ++ renderExpression newMacroNames url

                caption :: url :: _ ->
                    -- Two args: might be caption and url (width missing)
                    "| image caption:" ++ renderExpression newMacroNames caption ++ "\n" ++ renderExpression newMacroNames url

                url :: _ ->
                    -- One arg: just the URL
                    "| image\n" ++ renderExpression newMacroNames url

                _ ->
                    -- No args
                    "| image"

        _ ->
            "[" ++ name ++ " " ++ renderArgs newMacroNames args ++ "]"


{-| Render a verbatim function
-}
renderVerbatimFunction : List String -> String -> String -> String
renderVerbatimFunction newMacroNames name content =
    case name of
        "math" ->
            -- Convert LaTeX math to Scripta math format
            "$" ++ convertLatexMathToScripta newMacroNames content ++ "$"

        "code" ->
            "`" ++ content ++ "`"

        _ ->
            "[" ++ name ++ " " ++ content ++ "]"


{-| Render a math block
-}
renderMathBlock : List String -> ExpressionBlock -> String
renderMathBlock newMacroNames block =
    case block.body of
        Left str ->
            "| math\n" ++ convertLatexMathToScripta newMacroNames str

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
renderEquationBlock : List String -> ExpressionBlock -> String
renderEquationBlock newMacroNames block =
    case block.body of
        Left str ->
            "| equation\n" ++ convertLatexMathToScripta newMacroNames str

        _ ->
            "Error: Invalid equation block"


{-| Render an item block
-}
renderItem : List String -> ExpressionBlock -> String
renderItem newMacroNames block =
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

        -- Extract content from \item{content} or \item {content} in firstLine
        extractFromFirstLine =
            let
                line = block.firstLine
            in
            if String.contains "\\item" line && String.contains "{" line then
                -- Handle both \item{...} and \item {...}
                line
                    |> String.replace "\\item" ""
                    |> String.trim
                    |> (\s -> if String.startsWith "{" s then String.dropLeft 1 s else s)
                    |> String.split "}"
                    |> List.head
                    |> Maybe.withDefault ""
                    |> String.trim
            else
                ""

        content =
            -- First try to extract from \item{...} syntax in firstLine
            if not (String.isEmpty extractFromFirstLine) then
                extractFromFirstLine
            -- Then check if there are args
            else if not (List.isEmpty block.args) then
                case block.args of
                    arg :: _ ->
                        arg
                    [] ->
                        ""
            -- Otherwise fall back to body
            else
                case block.body of
                    Left str ->
                        String.trim str

                    Right exprs ->
                        -- Filter out error highlighting functions
                        exprs
                            |> List.filter (\expr ->
                                case expr of
                                    Fun "errorHighlight" _ _ -> False
                                    Fun "blue" _ _ -> False  -- This seems to be a parsing artifact
                                    _ -> True
                            )
                            |> List.map (renderExpression newMacroNames)
                            |> String.join " "
                            |> String.trim
    in
    prefix ++ content


{-| Render theorem-like environments
-}
renderTheoremLike : List String -> String -> ExpressionBlock -> String
renderTheoremLike newMacroNames envName block =
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
                    exprs |> List.map (renderExpression newMacroNames) |> String.join " "
    in
    "| " ++ envName ++ title ++ "\n" ++ content


{-| Render note-like environments
-}
renderNoteLike : List String -> String -> ExpressionBlock -> String
renderNoteLike newMacroNames envName block =
    let
        content =
            case block.body of
                Left str ->
                    String.trim str

                Right exprs ->
                    exprs |> List.map (renderExpression newMacroNames) |> String.join " "
    in
    "| " ++ envName ++ "\n" ++ content


{-| Render generic environments
-}
renderEnvironment : List String -> String -> ExpressionBlock -> String
renderEnvironment newMacroNames envName block =
    let
        content =
            case block.body of
                Left str ->
                    String.trim str

                Right exprs ->
                    exprs |> List.map (renderExpression newMacroNames) |> String.join " "
    in
    "| " ++ envName ++ "\n" ++ content


{-| Render center environment with special handling for centered images
-}
renderCenterEnvironment : List String -> ExpressionBlock -> String
renderCenterEnvironment newMacroNames block =
    -- Check if this is a Verbatim block (which means it's properly parsed as center environment)
    case block.heading of
        Verbatim "center" ->
            -- This is a verbatim center block
            case block.body of
                Left str ->
                    if String.contains "\\includegraphics" str then
                        -- Extract URL from \includegraphics[...]{url}
                        let
                            -- Handle the URL extraction, accounting for optional parameters
                            extractUrl s =
                                s
                                    |> String.lines
                                    |> List.filter (String.contains "\\includegraphics")
                                    |> List.head
                                    |> Maybe.withDefault ""
                                    |> (\line ->
                                        -- Split on { and get everything after it
                                        case String.split "{" line of
                                            _ :: rest ->
                                                String.join "{" rest
                                                    |> String.split "}"
                                                    |> List.head
                                                    |> Maybe.withDefault ""
                                                    |> String.trim
                                            _ ->
                                                ""
                                    )

                            url = extractUrl str
                        in
                        if String.isEmpty url then
                            "| image"
                        else
                            "| image\n" ++ url
                    else
                        -- Regular center content
                        "| center\n" ++ String.trim str

                Right _ ->
                    "| center"

        _ ->
            -- This is an Ordinary block named "center"
            case block.body of
                Right exprs ->
                    -- Check if any expression is includegraphics (may have optional parameters attached)
                    let
                        hasIncludeGraphics =
                            exprs
                                |> List.any (\expr ->
                                    case expr of
                                        Fun name _ _ -> String.startsWith "includegraphics" name
                                        _ -> False
                                )
                    in
                    if hasIncludeGraphics then
                        -- Look for includegraphics function and extract URL
                        exprs
                            |> List.filterMap (\expr ->
                                case expr of
                                    Fun name args _ ->
                                        if String.startsWith "includegraphics" name then
                                            -- The URL is in the second element of args (after the optional parameters)
                                            case args of
                                                _ :: Text url _ :: _ ->
                                                    if String.contains "http" url then
                                                        Just url
                                                    else
                                                        Nothing
                                                [ Text url _ ] ->
                                                    -- Sometimes it's the only argument
                                                    if String.contains "http" url then
                                                        Just url
                                                    else
                                                        Nothing
                                                _ ->
                                                    -- Try to find any Text with http in args
                                                    args
                                                        |> List.filterMap (\arg ->
                                                            case arg of
                                                                Text url _ ->
                                                                    if String.contains "http" url then
                                                                        Just url
                                                                    else
                                                                        Nothing
                                                                _ -> Nothing
                                                        )
                                                        |> List.head
                                        else
                                            Nothing
                                    _ -> Nothing
                            )
                            |> List.head
                            |> Maybe.map (\url -> "| image\n" ++ url)
                            |> Maybe.withDefault "| image"
                    else
                        -- Regular center with expressions
                        let
                            content = exprs |> List.map (renderExpression newMacroNames) |> String.join " "
                        in
                        "| center\n" ++ content

                Left str ->
                    "| center\n" ++ String.trim str


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
renderAlignedBlock : List String -> ExpressionBlock -> String
renderAlignedBlock newMacroNames block =
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
        "| aligned\n" ++ convertLatexMathToScripta newMacroNames content


{-| Convert LaTeX newcommand macros to Scripta mathmacros format
-}
mathMacros : List String -> String -> String
mathMacros newMacroNames latexMacros =
    let
        lines =
            String.lines latexMacros
                |> List.map String.trim
                |> List.filter (not << String.isEmpty)

        macroDefinitions =
            lines
                |> List.filterMap (parseNewCommand newMacroNames)
                |> List.map formatMacroDefinition
    in
    if List.isEmpty macroDefinitions then
        ""

    else
        "| mathmacros\n" ++ String.join "\n" macroDefinitions


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
parseNewCommand : List String -> String -> Maybe ( String, String )
parseNewCommand newMacroNames line =
    case E.parseNewCommand line of
        Ok (E.NewCommand (E.MacroName name) _ bodyExprs) ->
            -- Convert the body expressions to Scripta format
            let
                body =
                    bodyExprs
                        |> List.map (mathExprToScripta newMacroNames)
                        |> String.join ""
                        |> String.trim
            in
            Just ( name, body )

        _ ->
            Nothing


{-| Intelligently join math tokens with spaces where needed
Adds spaces between alphanumeric tokens that would otherwise run together
-}
intelligentJoin : List String -> String
intelligentJoin tokens =
    case tokens of
        [] ->
            ""

        [ single ] ->
            single

        first :: second :: rest ->
            let
                needsSpace =
                    -- Add space if first ends with alphanumeric and second starts with alphanumeric
                    (String.right 1 first |> isAlphaNum) && (String.left 1 second |> isAlphaNum)

                separator =
                    if needsSpace then
                        " "

                    else
                        ""
            in
            first ++ separator ++ intelligentJoin (second :: rest)


{-| Check if a string is alphanumeric
-}
isAlphaNum : String -> Bool
isAlphaNum str =
    case String.uncons str of
        Just ( char, _ ) ->
            Char.isAlphaNum char

        Nothing ->
            False


{-| Convert LaTeX math content to Scripta math format
This uses the ETeX parser to parse LaTeX math and convert it to Scripta syntax
-}
convertLatexMathToScripta : List String -> String -> String
convertLatexMathToScripta newMacroNames latexMath =
    -- Parse the LaTeX math expression using ETeX parser
    case E.parse latexMath of
        Ok exprs ->
            -- Convert each expression to Scripta format
            exprs
                |> List.map (mathExprToScripta newMacroNames)
                |> intelligentJoin

        Err _ ->
            -- If parsing fails, return original LaTeX
            latexMath


{-| Convert ETeX MathExpr to Scripta format string
-}
mathExprToScripta : List String -> E.MathExpr -> String
mathExprToScripta newMacroNames expr =
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
            exprs
                |> List.map (mathExprToScripta newMacroNames)
                |> intelligentJoin

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
                if ETeX.KaTeX.isKaTeX name then
                    name

                else
                    "\\" ++ name

            else
                -- Has arguments - special handling for functions
                case name of
                    "text" ->
                        case args of
                            [ E.Arg content ] ->
                                "\"" ++ (List.map (mathExprToScripta newMacroNames) content |> String.join "") ++ "\""

                            _ ->
                                "\\" ++ name ++ (List.map (mathExprToScriptaArg newMacroNames) args |> String.join "")

                    _ ->
                        if ETeX.KaTeX.isKaTeX name || List.member name newMacroNames then
                            name ++ "(" ++ (List.map (mathExprToScripta newMacroNames) args |> String.join ", ") ++ ")"

                        else
                            "\\"
                                ++ name
                                ++ (List.map (mathExprToScripta newMacroNames >> (\x -> "{" ++ x ++ "}")) args |> String.join "")

        E.Expr exprs ->
            List.map (mathExprToScripta newMacroNames) exprs |> String.join ""

        E.Comma ->
            ","

        E.LeftParen ->
            "("

        E.RightParen ->
            ")"

        E.Sub deco ->
            "_" ++ decoToString newMacroNames deco

        E.Super deco ->
            "^" ++ decoToString newMacroNames deco


{-| Helper to convert arguments with proper bracing
-}
mathExprToScriptaArg : List String -> E.MathExpr -> String
mathExprToScriptaArg newMacroNames expr =
    case expr of
        E.Arg exprs ->
            -- For arguments in macro calls, we do want braces
            "{" ++ (List.map (mathExprToScripta newMacroNames) exprs |> String.join "") ++ "}"

        _ ->
            mathExprToScripta newMacroNames expr


{-| Convert Deco to string
-}
decoToString : List String -> E.Deco -> String
decoToString newMacroNames deco =
    case deco of
        E.DecoM expr ->
            let
                content =
                    mathExprToScripta newMacroNames expr
            in
            -- Add braces if needed
            if String.startsWith "\"" content then
                -- Quoted strings don't need braces
                content

            else if String.length content > 1 || String.contains " " content then
                "{" ++ content ++ "}"

            else
                content

        E.DecoI n ->
            let
                nStr =
                    String.fromInt n
            in
            -- Add braces if number has multiple digits
            if String.length nStr > 1 then
                "{" ++ nStr ++ "}"

            else
                nStr
