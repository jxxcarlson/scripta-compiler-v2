module Render.TOCTree exposing
    ( TOCNodeValue
    , ViewParameters
    , nodeLevel
    , view
    )

import Array
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
import Library.TestForest2
import Library.Tree
import Render.Expression
import Render.Settings
import Render.Utility
import RoseTree.Tree exposing (Tree)
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
            Library.Forest.makeForest Library.Tree.lev nodes
                |> Debug.log "@@::tocForest"

        testForest : List (Tree TOCNodeValue)
        testForest =
            Library.TestForest2.hottForestOfTOCNodeValue

        ff =
            [ RoseTree.Tree.Tree { block = { args = [ "1" ], body = Right [ Text " Path Space of " { begin = 1275, end = 1289, id = "xye-41.0", index = 0 }, VFun "math" "\\nat" { begin = 1290, end = 1290, id = "xye-41.1", index = 1 } ], firstLine = "# Path Space of $\\nat$", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 41, messages = [], numberOfLines = 1, position = 1275, sourceText = "# Path Space of $\\nat$" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "path-space-of-nat" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "1" ], body = Right [ Text " Types that are not Sets" { begin = 1930, end = 1953, id = "xye-69.0", index = 0 } ], firstLine = "# Types that are not Sets", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-11", lineNumber = 69, messages = [], numberOfLines = 1, position = 1930, sourceText = "# Types that are not Sets" }, properties = Dict.fromList [ ( "id", "@-11" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "types-that-are-not-sets" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "1" ], body = Right [ Text " Higher Inductive Types" { begin = 3168, end = 3190, id = "xye-102.0", index = 0 } ], firstLine = "# Higher Inductive Types", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-19", lineNumber = 102, messages = [], numberOfLines = 1, position = 3168, sourceText = "# Higher Inductive Types" }, properties = Dict.fromList [ ( "id", "@-19" ), ( "label", "3" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "higher-inductive-types" ) ], style = Nothing }, visible = True } (Array.fromList [ RoseTree.Tree.Tree { block = { args = [ "2" ], body = Right [ Text " The circle" { begin = 3194, end = 3204, id = "xye-104.0", index = 0 } ], firstLine = "## The circle", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-20", lineNumber = 104, messages = [], numberOfLines = 1, position = 3194, sourceText = "## The circle" }, properties = Dict.fromList [ ( "id", "@-20" ), ( "label", "3.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "the-circle" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "2" ], body = Right [ Text " " { begin = 3317, end = 3317, id = "xye-109.0", index = 0 }, VFun "math" "\\integers" { begin = 3318, end = 3318, id = "xye-109.1", index = 1 }, Text " (Notes)" { begin = 3329, end = 3336, id = "xye-109.4", index = 4 } ], firstLine = "## $\\integers$ (Notes)", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-22", lineNumber = 109, messages = [], numberOfLines = 1, position = 3317, sourceText = "## $\\integers$ (Notes)" }, properties = Dict.fromList [ ( "id", "@-22" ), ( "label", "3.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers-notes" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "2" ], body = Right [ Text " " { begin = 3539, end = 3539, id = "xye-117.0", index = 0 }, VFun "math" "\\integers" { begin = 3540, end = 3540, id = "xye-117.1", index = 1 }, Text " (Mortberg)" { begin = 3551, end = 3561, id = "xye-117.4", index = 4 } ], firstLine = "## $\\integers$ (Mortberg)", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-24", lineNumber = 117, messages = [], numberOfLines = 1, position = 3539, sourceText = "## $\\integers$ (Mortberg)" }, properties = Dict.fromList [ ( "id", "@-24" ), ( "label", "3.3" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers-mortberg" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "2" ], body = Right [ Text " " { begin = 6503, end = 6503, id = "xye-203.0", index = 0 }, VFun "math" "\\integers" { begin = 6504, end = 6504, id = "xye-203.1", index = 1 } ], firstLine = "## $\\integers$", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-27", lineNumber = 203, messages = [], numberOfLines = 1, position = 6503, sourceText = "## $\\integers$" }, properties = Dict.fromList [ ( "id", "@-27" ), ( "label", "3.4" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers" ) ], style = Nothing }, visible = True } (Array.fromList []), RoseTree.Tree.Tree { block = { args = [ "2" ], body = Right [ Text " " { begin = 7029, end = 7029, id = "xye-225.0", index = 0 }, VFun "math" "\\integers/N" { begin = 7030, end = 7030, id = "xye-225.1", index = 1 } ], firstLine = "## $\\integers/N$", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-29", lineNumber = 225, messages = [], numberOfLines = 1, position = 7029, sourceText = "## $\\integers/N$" }, properties = Dict.fromList [ ( "id", "@-29" ), ( "label", "3.5" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "integers-n" ) ], style = Nothing }, visible = True } (Array.fromList []) ]), RoseTree.Tree.Tree { block = { args = [ "1" ], body = Right [ Text " References" { begin = 7879, end = 7889, id = "xye-263.0", index = 0 } ], firstLine = "# References", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-34", lineNumber = 263, messages = [], numberOfLines = 1, position = 7879, sourceText = "# References" }, properties = Dict.fromList [ ( "id", "@-34" ), ( "label", "4" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "references" ) ], style = Nothing }, visible = True } (Array.fromList []) ]

        _ =
            Debug.log "@@::SANITYCHECK" Library.TestForest2.sanityCheck
    in
    -- Library.TestForest2.ff
    forest
        |> List.map
            (RoseTree.Tree.mapValues
                (\x ->
                    if Library.Tree.lev x > 1 then
                        { x | visible = False }

                    else
                        x
                )
            )
        |> List.map (viewTOCTree viewParameters acc 4 0 Nothing)


viewTOCTree : ViewParameters -> Accumulator -> Int -> Int -> Maybe (List String) -> Tree TOCNodeValue -> Element MarkupMsg
viewTOCTree viewParameters acc depth indentation maybeFoundIds tocTree =
    let
        children : List (Tree TOCNodeValue)
        children =
            RoseTree.Tree.children tocTree

        val : TOCNodeValue
        val =
            RoseTree.Tree.value tocTree
    in
    if depth < 0 || val.visible == False then
        Element.none

    else if List.isEmpty children then
        viewNode viewParameters acc indentation val

    else
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
        |> List.map (makeNodeValue idsOfOpenNodes)
        |> Library.Forest.makeForest nodeLevel


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


nodeLevel : TOCNodeValue -> Int
nodeLevel =
    \node -> Dict.get "level" node.block.properties |> Maybe.andThen String.toInt |> Maybe.withDefault 1 |> (\x -> x - 1)
