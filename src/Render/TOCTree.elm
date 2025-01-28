module Render.TOCTree exposing (ViewParameters, view)

import Dict exposing (Dict)
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Events as Events
import Element.Font as Font
import Generic.ASTTools
import Generic.Acc exposing (Accumulator)
import Generic.Forest exposing (Forest)
import Generic.Language exposing (Expr(..), ExpressionBlock, Heading(..))
import Library.Forest
import Library.Tree
import Render.Expression
import Render.Settings
import Render.Utility
import RoseTree.Tree as Tree exposing (Tree)
import ScriptaV2.Config as Config
import ScriptaV2.Msg exposing (MarkupMsg(..))


type alias ViewParameters =
    { idsOfOpenNodes : List String
    , selectedId : String
    , counter : Int
    , attr : List (Element.Attribute MarkupMsg)
    , settings : Render.Settings.RenderSettings
    }


view : ViewParameters -> Accumulator -> Forest ExpressionBlock -> List (Element MarkupMsg)
view viewParameters acc documentAst =
    let
        tocAST : List ExpressionBlock
        tocAST =
            Generic.ASTTools.tableOfContents 8 documentAst
                -- This is correct for document HoTT
                |> Debug.log "@@:tocAST"

        -- I. The raw data: List TOCNodeValue
        nodes : List TOCNodeValue
        nodes =
            -- Levels should be : [1,1,1,2,2,2,2]
            -- But the actual result is [1]
            List.map (makeNodeValue viewParameters.idsOfOpenNodes) tocAST
                |> Debug.log "@@::tocNodes"

        _ =
            Debug.log "@@::tocLEN" (List.length nodes)

        forest : List (Tree TOCNodeValue)
        forest =
            Library.Forest.makeForest Library.Forest.lev nodes
                |> Debug.log "@@::tocForest"

        _ =
            Debug.log "@@::tocForest:SANITY_CHECK"
                { equalitCheck = forest == Library.Forest.hottForest
                , depthsComputedForest = List.map Library.Tree.depth forest
                , depthsLibraryForest = List.map Library.Tree.depth forest

                -- depthsComputedForest is [1,1,1,1], should be depthsLibraryForest [1,1,2,1]
                }

        _ =
            Debug.log "@@:LibraryHottChildren" (Library.Forest.getChildren Library.Forest.hottForest)
    in
    -- Library.Forest.hottForest |> List.map (viewTOCTree viewParameters acc 4 0 Nothing)
    forest |> List.map (viewTOCTree viewParameters acc 4 0 Nothing)


viewTOCTree : ViewParameters -> Accumulator -> Int -> Int -> Maybe (List String) -> Tree TOCNodeValue -> Element MarkupMsg
viewTOCTree viewParameters acc depth indentation maybeFoundIds tocTree =
    let
        _ =
            Debug.log "@@::TOC_ROOT" ( (Tree.value tocTree).block.firstLine, List.length (Tree.children tocTree) )

        level =
            indentation + 1

        children : List (Tree TOCNodeValue)
        children =
            Tree.children tocTree

        ----if level == 1 && List.member (Generic.Language.getIdFromBlock val.block) (List.map Just viewParameters.idsOfOpenNodes) then
        --if List.member (Generic.Language.getIdFromBlock val.block) (List.map Just viewParameters.idsOfOpenNodes) then
        --    Tree.children tocTree
        --
        --else
        --    []
        _ =
            Debug.log "@@::TOC_CHILDREN(1)" (List.length children)

        val : TOCNodeValue
        val =
            Tree.value tocTree
    in
    if depth < 0 || val.visible == False then
        Element.none

    else if List.isEmpty children then
        let
            _ =
                Debug.log "@@::TOC_NO_CHILDREN" val.block.firstLine
        in
        viewNode viewParameters acc indentation val

    else
        let
            _ =
                Debug.log "@@::TOC_CHILDREN(2)" (List.length children)
        in
        Element.column [ Element.spacing 8 ]
            (viewNode viewParameters acc indentation val
                :: List.map (viewTOCTree viewParameters acc (depth - 1) (indentation + 1) maybeFoundIds)
                    children
            )


viewNode : ViewParameters -> Accumulator -> Int -> TOCNodeValue -> Element MarkupMsg
viewNode viewParameters acc indentation node =
    viewTocItem_ viewParameters acc node.block


tocForest : List String -> Forest ExpressionBlock -> List (Tree TOCNodeValue)
tocForest idsOfOpenNodes ast =
    Generic.ASTTools.tableOfContents 8 ast
        |> Debug.log "@@:TOC_AST"
        |> List.map (makeNodeValue idsOfOpenNodes)
        |> Debug.log "@@:TOC_NODE_VALUES"
        |> Library.Forest.makeForest nodeLevel



--|> Debug.log "@@:TOC_FOREST"


type alias TOCNodeValue =
    { block : ExpressionBlock, visible : Bool }


makeNodeValue : List String -> ExpressionBlock -> TOCNodeValue
makeNodeValue idsOfOpenNodes block =
    let
        level : Int
        level =
            tocLevel block

        visibility =
            (level <= 3) || List.member block.meta.id idsOfOpenNodes

        newBlock =
            -- The "xy" line below is needed because we also have the possibility of
            -- the TOC in the sidebar. We do not want click on a TOC item in the sidebar
            -- targeting the TOC item in the main text.
            Generic.Language.updateMetaInBlock (\m -> { m | id = "xy" ++ m.id }) block
    in
    { block = newBlock, visible = visibility }


viewTocItem_ : ViewParameters -> Accumulator -> ExpressionBlock -> Element MarkupMsg
viewTocItem_ viewParameters acc ({ args, body, properties } as block) =
    let
        maximumNumberedTocLevel =
            1
    in
    case body of
        Left _ ->
            Element.none

        Right exprs ->
            let
                id =
                    Config.expressionIdPrefix ++ String.fromInt block.meta.lineNumber ++ ".0"

                sectionNumber =
                    case Dict.get "level" properties |> Maybe.andThen String.toInt of
                        Nothing ->
                            Element.none

                        Just level ->
                            if level <= maximumNumberedTocLevel then
                                case Dict.get "label" properties of
                                    Nothing ->
                                        Element.none

                                    Just label ->
                                        Element.el [] (Element.text (label ++ "."))

                            else
                                Element.none

                content : Element MarkupMsg
                content =
                    Element.paragraph [ tocIndent args ] (sectionNumber :: List.map (Render.Expression.render viewParameters.counter acc viewParameters.settings viewParameters.attr) exprs)

                color =
                    if id == viewParameters.selectedId then
                        Element.rgb 0.8 0 0.0

                    else
                        Element.rgb 0 0 0.8
            in
            Element.el [ Events.onClick (SelectId id), Font.size 14 ]
                (Element.link [ Font.color color ] { url = Render.Utility.internalLink id, label = content })


blockLabel : Dict String String -> String
blockLabel properties =
    Dict.get "label" properties |> Maybe.withDefault "??"


tocIndent args =
    Element.paddingEach { left = tocIndentAux args, right = 0, top = 0, bottom = 0 }


tocIndentAux args =
    case List.head args of
        Nothing ->
            0

        Just str ->
            String.toInt str |> Maybe.withDefault 0 |> (\x -> 12 * (x - 1))


tocLevel : ExpressionBlock -> Int
tocLevel block =
    case Dict.get "level" block.properties of
        Just level ->
            String.toInt level |> Maybe.withDefault 0

        Nothing ->
            0


nodeLevel =
    \node -> Dict.get "level" node.block.properties |> Maybe.andThen String.toInt |> Maybe.withDefault 1 |> (\x -> x - 1)
