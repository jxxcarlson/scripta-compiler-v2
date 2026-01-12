module ScriptaV2.DifferentialCompiler exposing
    ( EditRecord, init, update, messagesFromForest, editRecordToCompilerOutput
    , AccInitialData
    )

{-|

@docs EditRecord, init, update, renderEditRecord, messagesFromForest, editRecordToCompilerOutput

-}

-- Previous exposing list
--exposing
--    ( EditRecord, init, update, renderEditRecord, messagesFromForest, editRecordToCompilerOutput
--    , pp, toExprBlock
--    )

import Dict exposing (Dict)
import Differential.AbstractDifferentialParser
import Differential.Differ
import Differential.Utility
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Font as Font
import Generic.ASTTools
import Generic.Acc
import Generic.BlockUtilities
import Generic.Forest exposing (Forest)
import Generic.ForestTransform
import Generic.Language exposing (ExpressionBlock, PrimitiveBlock)
import Generic.Pipeline
import Generic.PrimitiveBlock
import Library.Tree
import MiniLaTeX.Expression
import MiniLaTeX.PrimitiveBlock
import Render.Block
import Render.Settings
import Render.TOCTree
import Render.Theme
import RoseTree.Tree as Tree exposing (Tree)
import Scripta.Expression
import Scripta.PrimitiveBlock
import ScriptaV2.Compiler
import ScriptaV2.Config
import ScriptaV2.Language exposing (Language(..))
import ScriptaV2.Msg exposing (MarkupMsg)
import ScriptaV2.Settings
import ScriptaV2.Types
import XMarkdown.Expression
import XMarkdown.PrimitiveBlock



{- For testing -}


pp : String -> List ExpressionBlock
pp str =
    Scripta.PrimitiveBlock.parse ScriptaV2.Config.idPrefix 0 (String.lines str) |> List.map (toExprBlock ScriptaV2.Language.ScriptaLang)


{-| -}
renderEditRecord : ScriptaV2.Types.CompilerParameters -> EditRecord -> List (Element MarkupMsg)
renderEditRecord params editRecord =
    let
        renderSettings =
            ScriptaV2.Settings.renderSettingsFromCompilerParameters params
    in
    ScriptaV2.Compiler.renderForest params renderSettings editRecord.accumulator editRecord.tree


{-| -}
editRecordToCompilerOutput : ScriptaV2.Types.CompilerParameters -> EditRecord -> ScriptaV2.Compiler.CompilerOutput
editRecordToCompilerOutput params editRecord =
    let
        renderSettings : ScriptaV2.Settings.RenderSettings
        renderSettings =
            ScriptaV2.Settings.renderSettingsFromCompilerParameters params

        viewParameters =
            { idsOfOpenNodes = params.idsOfOpenNodes
            , selectedId = params.selectedId
            , counter = params.editCount
            , attr = []
            , settings = renderSettings
            }

        toc : List (Element MarkupMsg)
        toc =
            Render.TOCTree.view params.theme viewParameters editRecord.accumulator editRecord.tree

        --view : Render.Theme.Theme -> ViewParameters -> Accumulator -> Forest ExpressionBlock -> List (Element MarkupMsg)
        --view theme viewParameters acc documentAst
        banner : Maybe (Element MarkupMsg)
        banner =
            Generic.ASTTools.banner editRecord.tree
                |> Maybe.map (Render.Block.renderBody params.editCount editRecord.accumulator renderSettings [ Font.color (Element.rgb 1 0 0) ])
                |> Maybe.map (Element.row [ Element.height (Element.px 40) ])

        titleData : Maybe ExpressionBlock
        titleData =
            Generic.ASTTools.getBlockByName "title" editRecord.tree

        properties =
            Maybe.map .properties titleData
                |> Maybe.withDefault Dict.empty
                |> Dict.insert "number-to-level" (String.fromInt params.numberToLevel)

        chapterNumber : String
        chapterNumber =
            case editRecord.accumulator.headingIndex |> .content >> List.head of
                Nothing ->
                    ""

                Just k ->
                    if k == 0 then
                        ""

                    else
                        String.fromInt k ++ ". "

        title : Element MarkupMsg
        title =
            Element.paragraph [] [ Element.text <| chapterNumber ++ Generic.ASTTools.title editRecord.tree ]
    in
    { body =
        ScriptaV2.Compiler.renderForest params { renderSettings | properties = properties } editRecord.accumulator (ScriptaV2.Compiler.filterForest2 editRecord.tree)
    , banner = banner
    , toc = toc -- THIS IS WHERE THE SIDEBAR TOC IS COMPUTED
    , title = title
    }


{-| -}
type alias EditRecord =
    Differential.AbstractDifferentialParser.EditRecord PrimitiveBlock ExpressionBlock Generic.Acc.Accumulator


type alias ExpBlockData =
    { name : Maybe String, args : List String, properties : Dict String String, indent : Int, lineNumber : Int, numberOfLines : Int, id : String, tag : String, content : Either String (List Generic.Language.Expression), messages : List String, sourceText : String }


type alias AccInitialData =
    { language : Language, mathMacros : String, textMacros : String, vectorSize : Int, shiftAndSetCounter : Maybe Int }


{-| -}
init : Maybe Int -> Dict String String -> Language -> String -> EditRecord
init shiftAndSetCounter_ inclusionData lang str =
    let
        initialData : AccInitialData
        initialData =
            makeInitialData shiftAndSetCounter_ inclusionData lang
    in
    Differential.AbstractDifferentialParser.init (updateFunctions lang) initialData (str ++ "\n")


makeInitialData : Maybe Int -> Dict String String -> Language -> AccInitialData
makeInitialData shiftAndSetCounter_ filesToIncludeDict lang =
    let
        keys =
            Dict.keys filesToIncludeDict

        macroKeys =
            List.filter (\k -> String.contains "texmacros" (String.toLower k)) keys

        getMacroText key =
            case Dict.get key filesToIncludeDict of
                Nothing ->
                    Nothing

                Just macroText_ ->
                    Just
                        { mathmacros = Differential.Utility.getKeyedParagraph "|| mathmacros" macroText_ |> Maybe.withDefault ""
                        , textmacros = Differential.Utility.getKeyedParagraph "|| textmacros" macroText_ |> Maybe.withDefault ""
                        }

        folder new acc =
            { mathmacros = new.mathmacros ++ "\n" ++ acc.mathmacros, textmacros = new.textmacros ++ "\n" ++ acc.textmacros }

        macroTexts : { mathmacros : String, textmacros : String }
        macroTexts =
            List.map getMacroText keys
                |> List.filterMap identity
                |> List.foldl folder { mathmacros = "", textmacros = "" }
                |> (\r -> { mathmacros = fixup "|| mathmacros" r.mathmacros, textmacros = fixup "|| textmacros" r.textmacros })

        fixup key str =
            str
                |> String.lines
                |> List.map (\str_ -> String.replace key "" str_ |> String.trim)
                |> List.filter (\str_ -> String.length str_ > 0)
                |> String.join "\n"
                |> (\x -> key ++ "\n" ++ x)
    in
    { language = lang
    , mathMacros = macroTexts.mathmacros
    , textMacros = macroTexts.textmacros
    , vectorSize = 4
    , shiftAndSetCounter = shiftAndSetCounter_
    }


updateFunctions : Language -> Differential.AbstractDifferentialParser.UpdateFunctions PrimitiveBlock ExpressionBlock Generic.Acc.Accumulator
updateFunctions lang =
    { chunker = chunker lang -- String -> List PrimitiveBlock
    , chunkEq = Generic.PrimitiveBlock.eq -- PrimitiveBlock -> PrimitiveBlock -> Bool
    , lineNumber = pGetLineNumber -- PrimitiveBlock -> Maybe Int
    , pLineNumber = eGetLineNumber
    , changeLineNumber = changeLineNumber
    , setLineNumber = Generic.BlockUtilities.setLineNumber
    , chunkLevel = chunkLevel -- PrimitiveBlock -> Bool
    , diffPostProcess = identity
    , chunkParser = toExprBlock lang --  PrimitiveBlock -> parsedChunk
    , forestFromBlocks = Generic.ForestTransform.forestFromBlocks .indent -- : List parsedChunk -> List (Tree parsedChunk)
    , getMessages = messagesFromForest -- : List parsedChunk -> List String
    , accMaker = Generic.Acc.transformAccumulate -- : Scripta.Language.Language -> Forest parsedChunk -> (acc, Forest parsedChunk)
    }


pGetLineNumber : PrimitiveBlock -> Int
pGetLineNumber block =
    block.meta.lineNumber


eGetLineNumber : ExpressionBlock -> Int
eGetLineNumber block =
    block.meta.lineNumber


{-| -}
messagesFromForest : Forest ExpressionBlock -> List String
messagesFromForest forest =
    List.map messagesFromTree forest |> List.concat


messagesFromTree : Tree.Tree ExpressionBlock -> List String
messagesFromTree tree =
    List.map Generic.BlockUtilities.getMessages (Library.Tree.flatten tree) |> List.concat


changeLineNumber : Int -> ExpressionBlock -> ExpressionBlock
changeLineNumber delta block =
    let
        oldMeta =
            block.meta

        newMeta =
            { oldMeta | lineNumber = oldMeta.lineNumber + delta }
    in
    { block | meta = newMeta }



-- Parser.Block.setLineNumber (lineNumber + delta) block


diffPostProcess : Differential.Differ.DiffRecord PrimitiveBlock -> Differential.Differ.DiffRecord PrimitiveBlock
diffPostProcess diffRecord =
    let
        lengthS =
            Generic.PrimitiveBlock.listLength diffRecord.middleSegmentInSource

        lengthT =
            Generic.PrimitiveBlock.listLength diffRecord.middleSegmentInTarget

        delta =
            lengthT - lengthS
    in
    shiftLines delta diffRecord


shiftLines : Int -> Differential.Differ.DiffRecord PrimitiveBlock -> Differential.Differ.DiffRecord PrimitiveBlock
shiftLines delta diffRecord =
    { diffRecord | commonSuffix = shiftLinesInBlockList delta diffRecord.commonSuffix }


shiftLinesInBlock : Int -> PrimitiveBlock -> PrimitiveBlock
shiftLinesInBlock delta block =
    let
        oldMeta =
            block.meta

        newMeta =
            { oldMeta | lineNumber = oldMeta.lineNumber + delta }
    in
    { block | meta = newMeta }


shiftLinesInBlockList : Int -> List PrimitiveBlock -> List PrimitiveBlock
shiftLinesInBlockList delta blockList =
    List.map (shiftLinesInBlock delta) blockList


chunkLevel : PrimitiveBlock -> Int
chunkLevel block =
    block.indent
        + (if Generic.BlockUtilities.getPrimitiveBlockName block == Just "item" || Generic.BlockUtilities.getPrimitiveBlockName block == Just "numbered" then
            1

           else
            0
          )


getMessages_ : List ExpressionBlock -> List String
getMessages_ blocks =
    List.map Generic.BlockUtilities.getMessages blocks |> List.concat


{-| -}
update : Maybe Int -> EditRecord -> String -> EditRecord
update shiftAndSetCounter_ editRecord text =
    let
        -- Update the initialData with the new shiftAndSetCounter
        oldInitialData =
            editRecord.initialData

        newInitialData =
            { oldInitialData | shiftAndSetCounter = shiftAndSetCounter_ }

        updatedEditRecord =
            { editRecord | initialData = newInitialData }
    in
    Differential.AbstractDifferentialParser.update (updateFunctions editRecord.lang) (text ++ "\n") updatedEditRecord


chunker : Language -> String -> List PrimitiveBlock
chunker lang str =
    case lang of
        MiniLaTeXLang ->
            MiniLaTeX.PrimitiveBlock.parse ScriptaV2.Config.idPrefix 0 (String.lines str)

        ScriptaLang ->
            Scripta.PrimitiveBlock.parse ScriptaV2.Config.idPrefix 0 (String.lines str)

        SMarkdownLang ->
            XMarkdown.PrimitiveBlock.parse ScriptaV2.Config.idPrefix 0 (String.lines str)

        MarkdownLang ->
            -- Standard Markdown doesn't use primitive blocks
            []


toExprBlock : Language -> PrimitiveBlock -> ExpressionBlock
toExprBlock lang =
    case lang of
        MiniLaTeXLang ->
            Generic.Pipeline.toExpressionBlock MiniLaTeX.Expression.parse

        ScriptaLang ->
            Generic.Pipeline.toExpressionBlock Scripta.Expression.parse

        SMarkdownLang ->
            Generic.Pipeline.toExpressionBlock XMarkdown.Expression.parse

        MarkdownLang ->
            -- Standard Markdown doesn't use expression blocks, return a minimal block
            \primitiveBlock ->
                { heading = Generic.Language.Paragraph
                , indent = 0
                , args = []
                , properties = Dict.empty
                , firstLine = ""
                , body = Right []
                , meta = Generic.Language.emptyBlockMeta
                , style = Nothing
                }
