module Differential.AbstractDifferentialParser exposing (EditRecord, InitialData, UpdateFunctions, differentialParser, init, update)

import Differential.Differ as Differ
import Differential.DifferForest as DifferForest
import Generic.Acc
import ScriptaV2.Language exposing (Language)
import Tree exposing (Tree)


type alias EditRecord chunk parsedChunk accumulator =
    { chunks : List chunk
    , parsed : List parsedChunk
    , tree : List (Tree parsedChunk)
    , accumulator : accumulator
    , lang : Language
    , messages : List String
    , initialData : InitialData
    }


type alias UpdateFunctions chunk parsedChunk acc =
    { chunker : String -> List chunk
    , chunkEq : chunk -> chunk -> Bool
    , chunkLevel : chunk -> Int
    , lineNumber : chunk -> Int
    , pLineNumber : parsedChunk -> Int
    , setLineNumber : Int -> parsedChunk -> parsedChunk
    , changeLineNumber : Int -> parsedChunk -> parsedChunk
    , diffPostProcess : Differ.DiffRecord chunk -> Differ.DiffRecord chunk
    , chunkParser : chunk -> parsedChunk
    , forestFromBlocks : List parsedChunk -> List (Tree parsedChunk)
    , getMessages : List (Tree parsedChunk) -> List String
    , accMaker : Generic.Acc.InitialAccumulatorData -> List (Tree parsedChunk) -> ( acc, List (Tree parsedChunk) )
    }


type alias InitialData =
    { mathMacros : String
    , textMacros : String
    , vectorSize : Int
    , language : Language
    }


init :
    UpdateFunctions chunk parsedChunk acc
    -> InitialData
    -> String
    -> EditRecord chunk parsedChunk acc
init f initialData content =
    let
        chunks =
            f.chunker content

        parsed_ =
            List.map f.chunkParser chunks

        tree_ =
            f.forestFromBlocks parsed_

        ( newAccumulator, tree ) =
            f.accMaker initialData tree_
    in
    { chunks = chunks
    , parsed = parsed_
    , tree = tree
    , lang = initialData.language
    , accumulator = newAccumulator
    , messages = f.getMessages tree
    , initialData = initialData
    }


{-| The update function takes an EditRecord and a string, the "text",
breaks the text into a list of logical paragraphs, diffs it with the list
of paragraphs held by the EditRecord, uses `differentialRender` to
render the changed paragraphs while copying the unchanged rendered paragraphs to
produce an updated list of rendered paragraphs. The 'differentialRender'
accomplishes this using the transformer. The seed is used to produces
a differential idList. This last step is perhaps unnecessary. To investigate.
(This was part of an optimization scheme.)
-}
update :
    UpdateFunctions chunk parsedChunk acc
    -> String
    -> EditRecord chunk parsedChunk acc -- accumulator
    -> EditRecord chunk parsedChunk acc
update f sourceText editRecord =
    let
        newChunks =
            f.chunker sourceText

        newLineNumbers =
            List.map f.lineNumber newChunks

        renumber : List Int -> List parsedChunk -> List parsedChunk
        renumber lineNumbers chunks =
            List.map2 f.setLineNumber lineNumbers chunks

        renumberIf : Differ.DiffRecord chunk -> List parsedChunk -> List parsedChunk
        renumberIf dr chunks =
            if dr.middleSegmentInSource == [] && dr.middleSegmentInTarget == [] && dr.commonSuffix == [] then
                renumber newLineNumbers chunks

            else
                chunks

        diffRecord : Differ.DiffRecord chunk
        diffRecord =
            DifferForest.diff f.chunkEq f.chunkLevel editRecord.chunks newChunks |> f.diffPostProcess

        parsed_ : List parsedChunk
        parsed_ =
            differentialParser f.lineNumber f.pLineNumber f.changeLineNumber f.chunkParser diffRecord editRecord
                |> renumberIf diffRecord

        tree_ : List (Tree parsedChunk)
        tree_ =
            f.forestFromBlocks parsed_

        ( newAccumulator, tree ) =
            f.accMaker editRecord.initialData tree_
    in
    -- TODO: real update of accumulator
    { lang = editRecord.lang
    , chunks = newChunks
    , parsed = parsed_
    , tree = tree
    , accumulator = newAccumulator
    , messages = f.getMessages tree
    , initialData = editRecord.initialData
    }


differentialParser :
    (chunk -> Int)
    -> (parsedChunk -> Int)
    -> (Int -> parsedChunk -> parsedChunk)
    -> (chunk -> parsedChunk)
    -> Differ.DiffRecord chunk
    -> EditRecord chunk parsedChunk acc
    -> List parsedChunk
differentialParser lineNumber pLineNumber pChangeLineNumber parser diffRecord editRecord =
    let
        ii =
            List.length diffRecord.commonPrefix

        it =
            List.length diffRecord.commonSuffix

        leadingLineIndexOfCommonSuffix =
            diffRecord.commonSuffix
                |> List.head
                |> Maybe.map lineNumber

        initialSegmentParsed =
            List.take ii editRecord.parsed

        terminalSegmentParsed_ =
            takeLast it editRecord.parsed

        leadingLineIndexOfCommonSuffixParsed =
            terminalSegmentParsed_
                |> List.head
                |> Maybe.map pLineNumber

        delta =
            Maybe.map2 (-) leadingLineIndexOfCommonSuffix leadingLineIndexOfCommonSuffixParsed

        middleSegmentParsed =
            List.map parser diffRecord.middleSegmentInTarget

        newTerminalSegmentParsed =
            case delta of
                Nothing ->
                    terminalSegmentParsed_

                Just delta_ ->
                    List.map (pChangeLineNumber delta_) terminalSegmentParsed_

        leadingLineIndexOfNewTerminaSegmentParsed =
            newTerminalSegmentParsed
                |> List.head
                |> Maybe.map pLineNumber
    in
    initialSegmentParsed ++ middleSegmentParsed ++ newTerminalSegmentParsed


takeLast : Int -> List a -> List a
takeLast k x =
    x |> List.reverse |> List.take k |> List.reverse
