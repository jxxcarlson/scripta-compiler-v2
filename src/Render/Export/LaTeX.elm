module Render.Export.LaTeX exposing (export, exportExpr, rawExport)

{-|

@docs export, exportExpr, rawExport

-}

import Array
import Dict exposing (Dict)
import ETeX.MathMacros
import ETeX.Transform
import Either exposing (Either(..))
import Generic.ASTTools as ASTTools
import Generic.BlockUtilities
import Generic.Forest exposing (Forest)
import Generic.Language exposing (Expr(..), Expression, ExpressionBlock, Heading(..))
import Generic.TextMacro
import List.Extra
import MicroLaTeX.Util
import Render.Data
import Render.Export.Image
import Render.Export.Preamble
import Render.Export.Util
import Render.Settings exposing (RenderSettings)
import Render.Utility as Utility
import RoseTree.Tree as Tree exposing (Tree(..))
import Time
import Tools.Loop exposing (Step(..), loop)


counterValue : Forest ExpressionBlock -> Maybe Int
counterValue ast =
    ast
        |> ASTTools.getBlockArgsByName "setcounter"
        |> List.head
        |> Maybe.andThen String.toInt


type alias PublicationData =
    { title : String
    , authorList : List String
    , kind : String
    }


{-| -}
export : Time.Posix -> PublicationData -> RenderSettings -> List (Tree ExpressionBlock) -> String
export currentTime publicationData settings_ ast =
    let
        titleData : Maybe ExpressionBlock
        titleData =
            ASTTools.getBlockByName "title" ast

        properties =
            Maybe.map .properties titleData
                |> Maybe.withDefault Dict.empty

        settings =
            { settings_ | properties = properties }

        counterValue_ =
            Dict.get "first-section" properties
                |> Maybe.andThen String.toInt
                |> Maybe.map (\x -> x - 1)

        setTheFirstSection =
            case counterValue_ of
                Nothing ->
                    ""

                Just k ->
                    "\n\\setcounter{section}{" ++ String.fromInt k ++ "}\n"

        rawBlockNames =
            ASTTools.rawBlockNames ast

        expressionNames =
            ASTTools.expressionNames ast ++ macrosInTextMacroDefinitions

        textMacroDefinitions =
            ASTTools.getVerbatimBlockValue "textmacros" ast

        macrosInTextMacroDefinitions =
            Generic.TextMacro.getTextMacroFunctionNames textMacroDefinitions
    in
    Render.Export.Preamble.make publicationData
        rawBlockNames
        expressionNames
        ++ frontMatter currentTime publicationData ast
        ++ setTheFirstSection
        ++ tableofcontents properties rawBlockNames
        ++ "\n\n"
        ++ rawExport settings ast
        ++ "\n\n\\end{document}\n"


frontMatter : Time.Posix -> PublicationData -> Forest ExpressionBlock -> String
frontMatter currentTime publicationData ast =
    let
        dict =
            ASTTools.frontMatterDict ast

        authors =
            let
                authorList : List String
                authorList =
                    publicationData.authorList
            in
            case authorList of
                [] ->
                    "\\author{}"

                _ ->
                    authorList
                        |> String.join "\n\\and\n"
                        |> (\s -> "\\author{\n" ++ s ++ "\n}")

        title =
            "\\title{" ++ publicationData.title ++ "}"

        date =
            Dict.get "date" dict |> Maybe.map (\date_ -> "\\date{" ++ date_ ++ "}") |> Maybe.withDefault ""
    in
    "\\begin{document}"
        :: title
        :: date
        :: authors
        :: "\\maketitle"
        :: []
        |> String.join "\n\n"


today : Time.Posix -> String
today currenTime =
    "currentTime: not implemented"


tableofcontents : Dict String String -> List String -> String
tableofcontents properties rawBlockNames_ =
    let
        -- Count actual section blocks (not title blocks)
        -- Note: In LaTeX export, level 1 sections become \title,
        -- level 2+ become \section, \subsection, etc.
        -- The TOC only includes \section and below, not \title
        sectionCount =
            List.length (List.filter (\name -> name == "section" || name == "section*") rawBlockNames_)

        numberToLevel =
            Dict.get "number-to-level" properties
                |> Maybe.andThen String.toFloat
                |> Maybe.withDefault 3

        -- Don't show TOC if:
        -- 1. There's only one or zero sections
        -- 2. Numbering is completely disabled (number-to-level:0)
        -- Note: if all sections are level 1 (rendered as \title), TOC will be empty
        shouldShowTOC =
            sectionCount > 1 && numberToLevel > 0
    in
    if shouldShowTOC then
        "\n\n\\tableofcontents"

    else
        ""


zeroOrSome : Maybe Int -> Int
zeroOrSome mInt =
    case mInt of
        Nothing ->
            0

        Just k ->
            k


oneOrTwo : Maybe Int -> Int
oneOrTwo mInt =
    case mInt of
        Nothing ->
            1

        Just _ ->
            2


{-| In a standalone MicroLaTeX document, sections correspond to sections in the
exported document.

If a document is part of a collection or "notebook", where we have
set the section number using \\setcounter{N}, sections correspond
to subsections IF the document is exported as a standalone document.

Function shiftSection makes the adjustments needed for export.

-}
shiftSection : Int -> ExpressionBlock -> ExpressionBlock
shiftSection delta block =
    if Generic.BlockUtilities.getExpressionBlockName block == Just "section" then
        case block.args of
            level :: rest ->
                case String.toInt level of
                    Nothing ->
                        block

                    Just kk ->
                        let
                            newLevel =
                                String.fromInt (kk + delta)
                        in
                        { block | args = newLevel :: rest }

            _ ->
                block

    else
        block


{-| Prepend a line number comment to exported LaTeX if the block has a valid source line number.
Synthetic blocks (created by the compiler) won't have valid line numbers and are skipped.
-}
annotateWithLineNumber : ExpressionBlock -> String -> String
annotateWithLineNumber block output =
    let
        lineNumber =
            block.meta.lineNumber
    in
    if lineNumber > 0 then
        "%%% Line " ++ String.fromInt lineNumber ++ "\n" ++ output

    else
        output


exportTree : ETeX.MathMacros.MathMacroDict -> RenderSettings -> Tree ExpressionBlock -> String
exportTree mathMacroDict settings tree =
    let
        block =
            Tree.value tree

        result =
            case Generic.Language.getHeadingFromBlock block of
                Ordinary "itemList" ->
                    let
                        exprList : List Expression
                        exprList =
                            case block.body of
                                Left _ ->
                                    []

                                Right exprs ->
                                    exprs

                        compactItem x =
                            "\\compactItem{" ++ x ++ "}"

                        renderExprList : List Expression -> String
                        renderExprList exprs =
                            List.map (exportExpr mathMacroDict settings >> compactItem) exprs |> String.join "\n"
                    in
                    renderExprList exprList

                Ordinary "numberedList" ->
                    let
                        label : Int -> String
                        label n =
                            String.fromInt (n + 1) ++ ". "

                        hang str =
                            "\\leftskip=1em\\hangindent=1em\n\\hangafter=1\n" ++ str

                        exprList : List Expression
                        exprList =
                            case block.body of
                                Left _ ->
                                    []

                                Right exprs ->
                                    exprs

                        renderExprList : List Expression -> String
                        renderExprList exprs =
                            List.indexedMap (\k -> exportExpr mathMacroDict settings >> (\x -> label k ++ hang x)) exprs |> String.join "\n\n"
                    in
                    renderExprList exprList

                _ ->
                    case Tree.children tree of
                        [] ->
                            exportBlock mathMacroDict settings block

                        children ->
                            -- Special handling for item blocks with nested list children
                            case Generic.BlockUtilities.getExpressionBlockName block of
                                Just "item" ->
                                    handleItemWithChildren mathMacroDict settings tree children

                                Just "numbered" ->
                                    handleItemWithChildren mathMacroDict settings tree children

                                _ ->
                                    -- Default behavior for other blocks with children
                                    let
                                        renderedChildren : List String
                                        renderedChildren =
                                            List.map (exportTree mathMacroDict settings) children
                                                |> List.map String.lines
                                                |> List.concat

                                        root : List String
                                        root =
                                            exportBlock mathMacroDict settings block |> String.lines
                                    in
                                    case List.Extra.unconsLast root of
                                        Nothing ->
                                            ""

                                        Just ( lastLine, firstLines ) ->
                                            let
                                                _ =
                                                    firstLines

                                                _ =
                                                    renderedChildren

                                                _ =
                                                    lastLine
                                            in
                                            firstLines ++ renderedChildren ++ [ lastLine ] |> String.join "\n"
    in
    annotateWithLineNumber block result


handleItemWithChildren : ETeX.MathMacros.MathMacroDict -> RenderSettings -> Tree ExpressionBlock -> List (Tree ExpressionBlock) -> String
handleItemWithChildren mathMacroDict settings tree children =
    let
        -- Export the item content
        itemContent =
            exportBlock mathMacroDict settings (Tree.value tree)

        -- Check if first child is a beginBlock (nested list)
        firstChildIsBeginBlock =
            List.head children
                |> Maybe.map Tree.value
                |> Maybe.andThen Generic.BlockUtilities.getExpressionBlockName
                |> Maybe.map (\name -> name == "beginBlock" || name == "beginNumberedBlock")
                |> Maybe.withDefault False
    in
    if firstChildIsBeginBlock then
        -- Nested list case: export item, then children with indentation
        let
            childrenOutput =
                List.map (exportTree mathMacroDict settings) children
                    |> String.join "\n"
                    |> indentNestedList
        in
        itemContent ++ "\n" ++ childrenOutput

    else
        -- No nested list: just concatenate
        itemContent ++ "\n" ++ (List.map (exportTree mathMacroDict settings) children |> String.join "\n")


indentNestedList : String -> String
indentNestedList str =
    str
        |> String.lines
        |> List.map (\line -> "  " ++ line)
        |> String.join "\n"


{-| -}
rawExport : RenderSettings -> List (Tree ExpressionBlock) -> String
rawExport settings ast_ =
    let
        -- mathMacroDict : Dict String ETeX.Transform.MacroBody
        mathMacroDict =
            ast_
                |> ASTTools.getVerbatimBlockValue "mathmacros"
                |> ETeX.Transform.makeMacroDict

        mathMacroBlock_ : Maybe ExpressionBlock
        mathMacroBlock_ =
            ASTTools.getBlockByName "mathmacros" ast_

        hideMathMacros : Tree ExpressionBlock -> Tree ExpressionBlock
        hideMathMacros (Tree val children) =
            let
                outputTree =
                    case val.heading of
                        Paragraph ->
                            Tree val children

                        Ordinary _ ->
                            Tree val children

                        Verbatim "mathmacros" ->
                            Tree { val | heading = Verbatim "hide" } children

                        Verbatim _ ->
                            Tree val children
            in
            outputTree

        ast =
            case mathMacroBlock_ of
                Nothing ->
                    ast_

                Just mathMacroBlock ->
                    Tree.leaf mathMacroBlock :: List.map (Tree.map hideMathMacros) ast_
    in
    let
        processedTrees =
            ast
                |> ASTTools.filterForestOnLabelNames (\name -> not (name == Just "runninghead"))
                |> Generic.Forest.map Generic.BlockUtilities.condenseUrls
                |> encloseLists

        exportedStrings =
            processedTrees
                |> List.map (exportTree mathMacroDict settings)
    in
    smartJoin exportedStrings


{-| Join exported strings intelligently:

  - All elements use double newlines (one empty line) for proper LaTeX formatting
  - This ensures proper spacing after \\begin{itemize}, \\item, \\end{itemize}, etc.

-}
smartJoin : List String -> String
smartJoin strings =
    String.join "\n\n" strings


type Status
    = InsideItemizedList
    | InsideNumberedList
    | InsideDescriptionList
    | OutsideList


encloseLists : Forest ExpressionBlock -> Forest ExpressionBlock
encloseLists blocks =
    -- First, recursively process children of each tree
    let
        processedBlocks =
            List.map processTreeChildren blocks
    in
    -- Then wrap consecutive items at this level
    loop { status = OutsideList, input = processedBlocks, output = [], itemNumber = 0 } nextStep |> List.reverse


{-| Recursively process children of a tree to enclose nested lists
-}
processTreeChildren : Tree ExpressionBlock -> Tree ExpressionBlock
processTreeChildren (Tree block children) =
    let
        childList =
            Array.toList children

        processedChildren =
            case childList of
                [] ->
                    Array.empty

                _ ->
                    -- Recursively process children and wrap them in begin/end blocks if needed
                    encloseLists childList |> Array.fromList
    in
    Tree block processedChildren


type alias State =
    { status : Status, input : Forest ExpressionBlock, output : Forest ExpressionBlock, itemNumber : Int }


nextStep : State -> Step State (Forest ExpressionBlock)
nextStep state =
    case List.head state.input of
        Nothing ->
            -- When input is exhausted, close any open lists
            case state.status of
                InsideItemizedList ->
                    Done (Tree.leaf endItemizedBlock :: state.output)

                InsideNumberedList ->
                    Done (Tree.leaf endNumberedBlock :: state.output)

                InsideDescriptionList ->
                    Done (Tree.leaf endDescriptionBlock :: state.output)

                OutsideList ->
                    Done state.output

        Just tree ->
            Loop (nextState tree state)


emptyExpressionBlock =
    Generic.Language.expressionBlockEmpty


beginItemizedBlock : ExpressionBlock
beginItemizedBlock =
    { emptyExpressionBlock
        | indent = 1
        , heading = Ordinary "beginBlock"
        , body = Right [ Text "itemize" { begin = 0, end = 7, index = 0, id = "" } ]
    }
        |> Generic.BlockUtilities.updateMeta
            (\m ->
                { m
                    | sourceText = "| beginBlock\nitemize"
                    , numberOfLines = 2
                }
            )


endItemizedBlock : ExpressionBlock
endItemizedBlock =
    { emptyExpressionBlock
        | indent = 1
        , heading = Ordinary "endBlock"
        , body = Right [ Text "itemize" { begin = 0, end = 7, index = 0, id = "end" } ]
    }
        |> Generic.BlockUtilities.updateMeta
            (\m ->
                { m
                    | sourceText = "| endBlock\nitemize"
                    , numberOfLines = 2
                }
            )


beginNumberedBlock : ExpressionBlock
beginNumberedBlock =
    { emptyExpressionBlock
        | indent = 1
        , heading = Ordinary "beginNumberedBlock"
        , body = Right [ Text "enumerate" { begin = 0, end = 7, index = 0, id = "begin" } ]
    }
        |> Generic.BlockUtilities.updateMeta
            (\m ->
                { m
                    | sourceText = "| beginBlock\nitemize"
                    , numberOfLines = 2
                }
            )


endNumberedBlock : ExpressionBlock
endNumberedBlock =
    { emptyExpressionBlock
        | indent = 1
        , heading = Ordinary "endNumberedBlock"
        , body = Right [ Text "enumerate" { begin = 0, end = 7, index = 0, id = "begin" } ]
    }
        |> Generic.BlockUtilities.updateMeta
            (\m ->
                { m
                    | sourceText = "| endBlock\nitemize"
                    , numberOfLines = 2
                }
            )


beginDescriptionBlock : ExpressionBlock
beginDescriptionBlock =
    { emptyExpressionBlock
        | indent = 1
        , heading = Ordinary "beginDescriptionBlock"
        , body = Right [ Text "description" { begin = 0, end = 7, index = 0, id = "begin" } ]
    }
        |> Generic.BlockUtilities.updateMeta
            (\m ->
                { m
                    | sourceText = "| beginBlock\ndescription"
                    , numberOfLines = 2
                }
            )


endDescriptionBlock : ExpressionBlock
endDescriptionBlock =
    { emptyExpressionBlock
        | indent = 1
        , heading = Ordinary "endDescriptionBlock"
        , body = Right [ Text "description" { begin = 0, end = 7, index = 0, id = "end" } ]
    }
        |> Generic.BlockUtilities.updateMeta
            (\m ->
                { m
                    | sourceText = "| endBlock\ndescription"
                    , numberOfLines = 2
                }
            )


nextState : Tree ExpressionBlock -> State -> State
nextState tree state =
    let
        name_ =
            Tree.value tree |> Generic.BlockUtilities.getExpressionBlockName
    in
    case ( state.status, name_ ) of
        -- ITEMIZED LIST
        ( OutsideList, Just "item" ) ->
            { state | status = InsideItemizedList, itemNumber = 1, output = tree :: Tree.leaf beginItemizedBlock :: state.output, input = List.drop 1 state.input }

        ( InsideItemizedList, Just "item" ) ->
            { state | output = tree :: state.output, itemNumber = state.itemNumber + 1, input = List.drop 1 state.input }

        ( InsideItemizedList, _ ) ->
            { state | status = OutsideList, itemNumber = 0, output = tree :: Tree.leaf endItemizedBlock :: state.output, input = List.drop 1 state.input }

        -- NUMBERED LIST
        ( OutsideList, Just "numbered" ) ->
            { state | status = InsideNumberedList, itemNumber = 1, output = tree :: Tree.leaf beginNumberedBlock :: state.output, input = List.drop 1 state.input }

        ( InsideNumberedList, Just "numbered" ) ->
            { state | output = tree :: state.output, itemNumber = state.itemNumber + 1, input = List.drop 1 state.input }

        ( InsideNumberedList, _ ) ->
            { state | status = OutsideList, itemNumber = 0, output = tree :: Tree.leaf endNumberedBlock :: state.output, input = List.drop 1 state.input }

        -- DESCRIPTION LIST
        ( OutsideList, Just "desc" ) ->
            { state | status = InsideDescriptionList, itemNumber = 1, output = tree :: Tree.leaf beginDescriptionBlock :: state.output, input = List.drop 1 state.input }

        ( InsideDescriptionList, Just "desc" ) ->
            { state | output = tree :: state.output, itemNumber = state.itemNumber + 1, input = List.drop 1 state.input }

        ( InsideDescriptionList, _ ) ->
            { state | status = OutsideList, itemNumber = 0, output = tree :: Tree.leaf endDescriptionBlock :: state.output, input = List.drop 1 state.input }

        --- OUTSIDE
        ( OutsideList, _ ) ->
            { state | output = tree :: state.output, input = List.drop 1 state.input }


exportBlock : ETeX.MathMacros.MathMacroDict -> RenderSettings -> ExpressionBlock -> String
exportBlock mathMacroDict settings block =
    case block.heading of
        Paragraph ->
            case block.body of
                Left str ->
                    mapChars2 str

                Right exprs_ ->
                    exportExprList mathMacroDict settings exprs_

        Ordinary "table" ->
            case block.body of
                Left str ->
                    str

                Right exprs_ ->
                    case List.head exprs_ of
                        Just (Fun "table" body _) ->
                            let
                                renderRow : Expression -> List Expression
                                renderRow rowExpr =
                                    case rowExpr of
                                        Fun "row" cells _ ->
                                            cells

                                        _ ->
                                            []

                                cellTable : List (List Expression)
                                cellTable =
                                    List.map renderRow body

                                stringTable : List (List String)
                                stringTable =
                                    cellTable |> List.map (List.map exportCell)

                                exportCell : Expression -> String
                                exportCell expr =
                                    case expr of
                                        Fun "cell" exprs2 _ ->
                                            exportExprList mathMacroDict settings exprs2

                                        _ ->
                                            "error constructing table cell"

                                makeRow : List String -> String
                                makeRow row =
                                    row |> String.join "& "

                                output =
                                    List.map makeRow stringTable |> String.join " \\\\\n"

                                columns =
                                    List.length (List.Extra.transpose stringTable)

                                defaultFormat =
                                    List.repeat columns "l"
                                        |> String.join " "
                                        |> (\x -> "{" ++ x ++ "}")

                                format =
                                    Dict.get "format" block.properties |> Maybe.withDefault defaultFormat
                            in
                            "\\begin{tabular}" ++ format ++ "\n" ++ output ++ "\n\\end{tabular}"

                        _ ->
                            "error in constructing table"

        Ordinary name ->
            case block.body of
                Left _ ->
                    ""

                Right exprs_ ->
                    case Dict.get name (blockDict mathMacroDict) of
                        Just f ->
                            f settings block.args (exportExprList mathMacroDict settings exprs_)

                        Nothing ->
                            environment name (exportExprList mathMacroDict settings exprs_)

        Verbatim name ->
            case block.body of
                Left str ->
                    case name of
                        "math" ->
                            let
                                fix_ : String -> String
                                fix_ str_ =
                                    str_
                                        |> String.lines
                                        |> List.filter (\line -> String.left 2 line /= "$$")
                                        |> String.join "\n"
                                        |> ETeX.Transform.transformETeX mathMacroDict
                                        |> MicroLaTeX.Util.transformLabel
                            in
                            -- TODO: This should be fixed upstream
                            [ "$$", fix_ str, "$$" ] |> String.join "\n"

                        "csvtable" ->
                            let
                                data =
                                    Render.Data.prepareTable 1 block

                                renderRow : Int -> List Int -> List String -> String
                                renderRow rowNumber widths_ rowOfCells =
                                    if rowNumber == 0 then
                                        List.map2 (\cell width -> String.padRight width ' ' cell) rowOfCells widths_
                                            |> String.join " "
                                            |> String.replace "_" " "

                                    else
                                        List.map2 (\cell width -> String.padRight width ' ' cell) rowOfCells widths_ |> String.join " "

                                renderedRows =
                                    List.indexedMap (\rowNumber -> renderRow rowNumber data.columnWidths) data.selectedCells |> String.join "\n"
                            in
                            case data.title of
                                Nothing ->
                                    [ "\\begin{verbatim}", renderedRows, "\\end{verbatim}" ] |> String.join "\n"

                                Just title ->
                                    let
                                        separator =
                                            String.repeat data.totalWidth "-"
                                    in
                                    [ "\\begin{verbatim}", title, separator, renderedRows, "\\end{verbatim}" ] |> String.join "\n"

                        "equation" ->
                            let
                                maybeLabel : Maybe String
                                maybeLabel =
                                    Dict.get "label" block.properties |> Maybe.map (\l -> "\\label{" ++ String.trim l ++ "}")
                            in
                            case maybeLabel of
                                Nothing ->
                                    [ "\\begin{equation}", str |> ETeX.Transform.transformETeX mathMacroDict |> MicroLaTeX.Util.transformLabel, "\\end{equation}" ] |> String.join "\n"

                                Just label ->
                                    [ "\\begin{equation}", label, str |> ETeX.Transform.transformETeX mathMacroDict |> MicroLaTeX.Util.transformLabel, "\\end{equation}" ] |> String.join "\n"

                        "aligned" ->
                            -- TODO: equation numbers and label
                            let
                                maybeLabel : Maybe String
                                maybeLabel =
                                    Dict.get "label" block.properties |> Maybe.map (\l -> "\\label{" ++ String.trim l ++ "}")

                                -- Strip trailing \\ from a line if present
                                stripTrailingBackslashes : String -> String
                                stripTrailingBackslashes line =
                                    if String.endsWith "\\\\" line then
                                        String.dropRight 2 line |> String.trimRight

                                    else
                                        line

                                -- Process each line separately and add \\ line breaks
                                lines =
                                    str
                                        |> String.lines
                                        |> List.map String.trim
                                        |> List.filter (\line -> not (String.isEmpty line))
                                        |> List.map stripTrailingBackslashes
                                        |> List.map (ETeX.Transform.transformETeX mathMacroDict)
                                        |> List.map MicroLaTeX.Util.transformLabel

                                -- Add \\ to the end of all lines except the last
                                processedLines =
                                    case List.reverse lines of
                                        [] ->
                                            ""

                                        lastLine :: restReversed ->
                                            (List.reverse restReversed |> List.map (\line -> line ++ "\\\\"))
                                                ++ [ lastLine ]
                                                |> String.join "\n"
                            in
                            case maybeLabel of
                                Nothing ->
                                    [ "\\begin{align}", processedLines, "\\end{align}" ] |> String.join "\n"

                                Just label ->
                                    [ "\\begin{align}", label, processedLines, "\\end{align}" ] |> String.join "\n"

                        "code" ->
                            str |> fixChars |> (\s -> "\\begin{verbatim}\n" ++ s ++ "\n\\end{verbatim}")

                        "tabular" ->
                            str |> fixChars |> (\s -> "\\begin{tabular}{" ++ String.join " " block.args ++ "}\n" ++ s ++ "\n\\end{tabular}")

                        "verbatim" ->
                            str |> fixChars |> (\s -> "\\begin{verbatim}\n" ++ s ++ "\n\\end{verbatim}")

                        "verse" ->
                            str |> fixChars |> (\s -> "\\begin{verbatim}\n" ++ s ++ "\n\\end{verbatim}")

                        "load-files" ->
                            ""

                        "mathmacros" ->
                            str |> ETeX.Transform.toLaTeXNewCommands

                        "texComment" ->
                            str |> String.lines |> texComment

                        "textmacros" ->
                            Generic.TextMacro.exportTexMacros str

                        "image" ->
                            Render.Export.Image.exportBlock settings block

                        "quiver" ->
                            let
                                lines =
                                    String.split "---" str
                                        |> List.drop 1
                                        |> String.join "\n"
                                        |> String.lines
                                        |> List.filter (\line -> line /= "")

                                line1 =
                                    List.head lines |> Maybe.withDefault "%%" |> String.trim

                                line1b =
                                    if String.contains "\\hide{" line1 then
                                        -- preserve comment with quiver url
                                        line1 |> String.replace "\\hide{" "" |> String.dropRight 1 |> (\x -> "%% " ++ x)

                                    else
                                        line1

                                data =
                                    lines
                                        |> List.drop 1
                                        -- now normalize the data
                                        |> List.filter (\line -> not <| String.contains "\\[\\begin{tikzcd}" line)
                                        |> List.filter (\line -> not <| String.contains "\\end{tikzcd}\\]" line)
                                        |> (\x -> line1b :: "\\[\\begin{tikzcd}" :: x ++ [ "\\end{tikzcd}\\]" ])
                                        |> String.join "\n"
                            in
                            data

                        "tikz" ->
                            let
                                renderedAsLaTeX =
                                    String.contains "\\hide{" str

                                data =
                                    String.split "---" str
                                        |> List.drop 1
                                        |> String.join ""
                                        |> String.lines
                                        |> List.map (hideToPercentComment >> commentBlankLine)
                                        |> String.join "\n"
                                        |> addTikzPictureClosing renderedAsLaTeX
                            in
                            [ "\\[\n", data, "\n\\]" ]
                                |> String.join ""

                        "docinfo" ->
                            ""

                        "hide" ->
                            ""

                        _ ->
                            "%%% export of this block is unimplemented"

                Right _ ->
                    "???(13)"


addTikzPictureClosing flagUp str =
    if flagUp then
        str ++ "\n\\end{tikzpicture}"

    else
        str


commentBlankLine : String -> String
commentBlankLine line =
    if line == "" then
        "%"

    else
        line


hideToPercentComment : String -> String
hideToPercentComment str =
    if String.left 6 str == "\\hide{" then
        str |> String.dropLeft 6 |> String.dropRight 1 |> (\s -> "%% " ++ s)

    else
        str


fixChars str =
    str |> String.replace "{" "\\{" |> String.replace "}" "\\}"


renderDefs : ETeX.MathMacros.MathMacroDict -> RenderSettings -> List Expression -> String
renderDefs mathMacroDict settings exprs =
    "%% Macro definitions from Markup text:\n"
        ++ exportExprList mathMacroDict settings exprs


mapChars1 : String -> String
mapChars1 str =
    str
        |> String.replace "\\term_" "\\termx"


mapChars2 : String -> String
mapChars2 str =
    str
        |> String.replace "_" "\\_"



-- BEGIN DICTIONARIES


functionDict : Dict String String
functionDict =
    Dict.fromList
        [ ( "italic", "textit" )
        , ( "i", "textit" )
        , ( "bold", "textbf" )
        , ( "b", "textbf" )
        , ( "image", "imagecenter" )
        , ( "contents", "tableofcontents" )
        ]



-- MACRODICT


macroDict : Dict String (RenderSettings -> List Expression -> String)
macroDict =
    Dict.fromList
        [ ( "link", \_ -> link )
        , ( "ilink", \_ -> ilink )
        , ( "mark", \_ -> markwith )
        , ( "par", \_ -> par )
        , ( "eqref", \_ -> eqref )
        , ( "index_", \_ _ -> blindIndex )
        , ( "image", Render.Export.Image.export )
        , ( "vspace", \_ -> vspace )
        , ( "bolditalic", \_ -> bolditalic )
        , ( "brackets", \_ -> brackets )
        , ( "lb", \_ -> lb )
        , ( "rb", \_ -> rb )
        , ( "bt", \_ -> bt )
        , ( "underscore", \_ -> underscore )
        , ( "tags", dontRender )
        ]


dontRender : RenderSettings -> List Expression -> String
dontRender _ _ =
    ""



-- BLOCKDICT


blockDict : ETeX.MathMacros.MathMacroDict -> Dict String (RenderSettings -> List String -> String -> String)
blockDict mathMacroDict =
    Dict.fromList
        [ ( "title", \_ _ _ -> "" )
        , ( "subtitle", \_ _ _ -> "" )
        , ( "author", \_ _ _ -> "" )
        , ( "date", \_ _ _ -> "" )
        , ( "contents", \_ _ _ -> "" )
        , ( "hide", \_ _ _ -> "" )
        , ( "texComment", \_ lines _ -> texComment lines )
        , ( "tags", \_ _ _ -> "" )
        , ( "docinfo", \_ _ _ -> "" )
        , ( "banner", \_ _ _ -> "" )
        , ( "set-key", \_ _ _ -> "" )
        , ( "endnotes", \_ _ _ -> "" )
        , ( "index", \_ _ _ -> "Index: not implemented" )

        --
        , ( "chapter", \settings_ args body -> chapter settings_ args body )
        , ( "section", \settings_ args body -> section settings_ args body )
        , ( "subheading", \settings_ args body -> subheading settings_ args body )
        , ( "smallsubheading", \settings_ args body -> smallsubheading settings_ args body )
        , ( "item", \_ _ body -> "\\item " ++ body )
        , ( "itemList", \_ _ body -> body )
        , ( "descriptionItem", \_ args body -> descriptionItem args body )
        , ( "numbered", \_ _ body -> "\\item " ++ body )
        , ( "desc", \_ args body -> descriptionItem args body )
        , ( "beginBlock", \_ _ _ -> "\\begin{itemize}" )
        , ( "endBlock", \_ _ _ -> "\\end{itemize}" )
        , ( "beginNumberedBlock", \_ _ _ -> "\\begin{enumerate}" )
        , ( "endNumberedBlock", \_ _ _ -> "\\end{enumerate}" )
        , ( "beginDescriptionBlock", \_ _ _ -> "\\begin{description}" )
        , ( "endDescriptionBlock", \_ _ _ -> "\\end{description}" )
        , ( "mathmacros", \_ _ body -> body ++ "\nHa ha ha!" )
        , ( "setcounter", \_ _ _ -> "" )
        ]


verbatimExprDict =
    Dict.fromList
        [ ( "code", inlineCode )
        , ( "math", inlineMath )
        ]


texComment lines =
    lines |> List.map putPercent |> String.join "\n"


putPercent str =
    if String.left 1 str == "%" then
        str

    else
        "% " ++ str



-- END DICTIONARIES


inlineMath : String -> String
inlineMath str =
    "$" ++ str ++ "$"


inlineCode : String -> String
inlineCode str =
    "\\verb`" ++ str ++ "`"


link : List Expression -> String
link exprs =
    let
        args =
            Render.Export.Util.getTwoArgs exprs
    in
    [ "\\href{", args.second, "}{", args.first, "}" ] |> String.join ""


vspace : List Expression -> String
vspace exprs =
    let
        arg =
            Render.Export.Util.getOneArg exprs
                |> String.toFloat
                |> Maybe.withDefault 0
                |> (\x -> x / 4.0)
                |> String.fromFloat
                |> (\x -> x ++ "pt")
    in
    [ "\\par\\vspace{", arg, "}" ] |> String.join ""


eqref : List Expression -> String
eqref exprs =
    let
        arg =
            Render.Export.Util.getOneArg exprs
                |> String.trim
    in
    [ "\\eqref{", arg, "}" ] |> String.join ""


par : List Expression -> String
par _ =
    [ "\\par\\par" ] |> String.join ""


markwith : List Expression -> String
markwith exprs =
    let
        arg =
            Render.Export.Util.getOneArg exprs
    in
    [ "\\markwith{", arg, "}" ] |> String.join ""


ilink : List Expression -> String
ilink exprs =
    let
        args : { first : String, second : String }
        args =
            Render.Export.Util.getTwoArgs exprs
    in
    [ "\\href{", "https://scripta.io/s/", args.second, "}{", args.first, "}" ] |> String.join ""


bolditalic : List Expression -> String
bolditalic exprs =
    let
        args =
            Render.Export.Util.getArgs exprs |> String.join " "
    in
    "\\textbf{\\emph{" ++ args ++ "}}"


brackets : List Expression -> String
brackets exprs =
    "[" ++ (Render.Export.Util.getArgs exprs |> String.join " ") ++ "]"


lb : List Expression -> String
lb _ =
    "["


rb : List Expression -> String
rb _ =
    "]"


bt : List Expression -> String
bt _ =
    "`"


underscore : List Expression -> String
underscore _ =
    "$\\_$"


blindIndex : String
blindIndex =
    ""


setcounter : List String -> String
setcounter args =
    [ "\\setcounter{section}{", Utility.getArg "0" 0 args, "}" ] |> String.join ""


subheading : RenderSettings -> List String -> String -> String
subheading settings args body =
    "\\vspace{8pt{\\Large{" ++ body ++ "}"


smallsubheading : RenderSettings -> List String -> String -> String
smallsubheading settings args body =
    "\\vspace{4pt{\\large{" ++ body ++ "}"


descriptionItem : List String -> String -> String
descriptionItem args body =
    let
        arg =
            argString args
    in
    case args of
        [] ->
            "\\item{" ++ body ++ "}"

        _ ->
            "\\item[" ++ arg ++ "]{" ++ body ++ "}"


argString : List String -> String
argString args =
    List.filter (\arg -> not <| String.contains "label:" arg) args |> String.join " "


chapter : RenderSettings -> List String -> String -> String
chapter _ _ body =
    let
        tag =
            body
                |> String.words
                |> MicroLaTeX.Util.normalizedWord

        label =
            " \\label{" ++ tag ++ "}"
    in
    "\\chapter{" ++ body ++ "}" ++ label


section : RenderSettings -> List String -> String -> String
section settings args body =
    let
        maxNumberedLevel : Float
        maxNumberedLevel =
            Dict.get "number-to-level" settings.properties
                |> Maybe.andThen String.toFloat
                |> Maybe.withDefault 3

        tag =
            body
                |> String.words
                |> MicroLaTeX.Util.normalizedWord

        label =
            " \\label{" ++ tag ++ "}"

        suffix =
            case List.Extra.getAt 1 args of
                Nothing ->
                    ""

                Just "-" ->
                    "*"

                Just _ ->
                    ""

        levelAsString =
            Utility.getArg "4" 0 args

        levelAsFloat =
            case String.toFloat levelAsString of
                Just n ->
                    n

                Nothing ->
                    0

        -- Depth is level minus 1 (since level 1 is title, level 2 is depth 1, etc.)
        depthForNumbering =
            levelAsFloat - 1
    in
    case levelAsString of
        "1" ->
            -- For documents with multiple sections, treat level 1 as section, not title
            -- This ensures they appear in the table of contents
            if depthForNumbering < maxNumberedLevel then
                macro1 ("section" ++ suffix) body ++ label

            else
                macro1 ("section*" ++ suffix) body ++ label

        "2" ->
            if depthForNumbering < maxNumberedLevel then
                macro1 ("subsection" ++ suffix) body ++ label

            else
                macro1 ("subsection*" ++ suffix) body ++ label

        "3" ->
            if depthForNumbering < maxNumberedLevel then
                macro1 ("subsubsection" ++ suffix) body ++ label

            else
                macro1 ("subsubsection*" ++ suffix) body ++ label

        "4" ->
            if depthForNumbering < maxNumberedLevel then
                macro1 ("paragraph" ++ suffix) body ++ label

            else
                macro1 ("paragraph*" ++ suffix) body ++ label

        _ ->
            macro1 ("subheading" ++ suffix) body ++ label


section2 : List String -> String -> String
section2 args body =
    let
        tag =
            body
                |> String.words
                |> MicroLaTeX.Util.normalizedWord

        label =
            " \\label{" ++ tag ++ "}"

        suffix =
            case List.Extra.getAt 1 args of
                Nothing ->
                    ""

                Just "-" ->
                    "*"

                Just _ ->
                    ""
    in
    case Utility.getArg "4" 0 args of
        "1" ->
            macro1 ("section" ++ suffix) body ++ label

        "2" ->
            macro1 ("subsection" ++ suffix) body ++ label

        "3" ->
            macro1 ("subsubsection" ++ suffix) body ++ label

        _ ->
            macro1 ("subheading" ++ suffix) body ++ label


macro1 : String -> String -> String
macro1 name arg =
    if name == "math" then
        "$" ++ arg ++ "$"

    else if name == "group" then
        arg

    else if name == "tags" then
        ""

    else
        case Dict.get name functionDict of
            Nothing ->
                "\\" ++ unalias name ++ "{" ++ mapChars2 (String.trimLeft arg) ++ "}"

            Just fName ->
                "\\" ++ fName ++ "{" ++ mapChars2 (String.trimLeft arg) ++ "}"


exportExprList : ETeX.MathMacros.MathMacroDict -> RenderSettings -> List Expression -> String
exportExprList mathMacroDict settings exprs =
    List.map (exportExpr mathMacroDict settings) exprs |> String.join "" |> mapChars1


{-| -}
exportExpr : ETeX.MathMacros.MathMacroDict -> RenderSettings -> Expression -> String
exportExpr mathMacroDict settings expr =
    case expr of
        Fun name exps_ _ ->
            if name == "lambda" then
                case Generic.TextMacro.extract expr of
                    Just lambda ->
                        Generic.TextMacro.toString (exportExpr mathMacroDict settings) lambda

                    Nothing ->
                        "Error extracting lambda"

            else
                case Dict.get name macroDict of
                    Just f ->
                        f settings exps_

                    Nothing ->
                        -- For nested expressions, we need to combine the content properly
                        let
                            exportedExprs =
                                List.map (exportExpr mathMacroDict settings) exps_

                            combinedContent =
                                String.join "" exportedExprs
                        in
                        "\\" ++ unalias name ++ "{" ++ combinedContent ++ "}"

        Text str _ ->
            mapChars2 str

        VFun name body _ ->
            renderVerbatim mathMacroDict name body

        ExprList itemExprs _ ->
            -- Export the list of expressions
            exportExprList mathMacroDict settings itemExprs


{-| Use this to unalias names
-}
unalias : String -> String
unalias str =
    case Dict.get str aliases of
        Nothing ->
            str

        Just realName_ ->
            realName_


aliases : Dict String String
aliases =
    Dict.fromList
        [ ( "i", "textit" )
        , ( "italic", "textit" )
        , ( "b", "textbf" )
        , ( "bold", "textbf" )
        , ( "large", "large" )
        ]


encloseWithBraces : String -> String
encloseWithBraces str_ =
    "{" ++ String.trim str_ ++ "}"


renderVerbatim : ETeX.MathMacros.MathMacroDict -> String -> String -> String
renderVerbatim mathMacroDict name body =
    case Dict.get name verbatimExprDict of
        Nothing ->
            name ++ "(" ++ body ++ ") — unimplemented "

        Just f ->
            if List.member name [ "equation", "aligned", "math" ] then
                body |> MicroLaTeX.Util.transformLabel |> ETeX.Transform.transformETeX mathMacroDict |> f

            else
                body |> fixChars |> MicroLaTeX.Util.transformLabel |> f



-- HELPERS


tagged name body =
    "\\" ++ name ++ "{" ++ body ++ "}"


environment name body =
    [ tagged "begin" name, body, tagged "end" name ] |> String.join "\n"
