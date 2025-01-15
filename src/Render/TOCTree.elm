module Render.TOCTree exposing (view)

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
import Library.Tree
import Render.Expression
import Render.Settings
import Render.Utility
import RoseTree.Tree as Tree exposing (Tree)
import ScriptaV2.Config as Config
import ScriptaV2.Msg exposing (MarkupMsg(..))



--view : String -> Int -> Accumulator -> List (Element.Attribute MarkupMsg) -> Forest ExpressionBlock -> List (Element ScriptaV2.Msg.MarkupMsg)
--view selectedId counter acc attr ast =


type alias ViewParameters =
    { idsOfOpenNodes : List String
    , selectedId : String
    , counter : Int
    , attr : List (Element.Attribute MarkupMsg)
    }


view : List String -> String -> Int -> Accumulator -> List (Element.Attribute MarkupMsg) -> Forest ExpressionBlock -> List (Element MarkupMsg)
view idsOfOpenNodes selectedId counter acc attr documentAst =
    let
        defaultSettings =
            Render.Settings.defaultSettings

        settings =
            { defaultSettings | selectedId = selectedId }

        rawTOC : List ExpressionBlock
        rawTOC =
            -- = Generic.ASTTools.tableOfContents 8 documentAst
            [ { args = [ "1" ], body = Right [ Text " Intro " { begin = 46, end = 52, id = "e-6.0", index = 0 } ], firstLine = "# Intro ", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-2", lineNumber = 6, messages = [], numberOfLines = 1, position = 46, sourceText = "# Intro " }, properties = Dict.fromList [ ( "id", "@-2" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "intro" ) ] }
            , { args = [ "1" ], body = Right [ Text " Particles" { begin = 56, end = 65, id = "e-8.0", index = 0 } ], firstLine = "# Particles", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 8, messages = [], numberOfLines = 1, position = 56, sourceText = "# Particles" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "particles" ) ] }
            , { args = [ "2" ], body = Right [ Text " Bosons" { begin = 69, end = 75, id = "e-10.0", index = 0 } ], firstLine = "## Bosons", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-4", lineNumber = 10, messages = [], numberOfLines = 1, position = 69, sourceText = "## Bosons" }, properties = Dict.fromList [ ( "id", "@-4" ), ( "label", "2.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "bosons" ) ] }
            , { args = [ "2" ], body = Right [ Text " Fermions" { begin = 80, end = 88, id = "e-12.0", index = 0 } ], firstLine = "## Fermions", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-5", lineNumber = 12, messages = [], numberOfLines = 1, position = 80, sourceText = "## Fermions" }, properties = Dict.fromList [ ( "id", "@-5" ), ( "label", "2.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "fermions" ) ] }
            ]

        nodesApp : List TOCNodeValue
        nodesApp =
            -- List.map (makeNodeValue idsOfOpenNodes) rawTOC
            List.map (makeNodeValue idsOfOpenNodes) (Generic.ASTTools.tableOfContents 8 documentAst)

        _ =
            -- OK: [1,1,2,2]
            Debug.log "@@:TOC_NODES_LEVELS" (List.map Library.Forest.lev nodesApp)

        _ =
            -- True
            Debug.log "@@:TOC_COMPARE 1. (nodeRepl == nodesApp)" (nodesRepl == nodesApp)

        _ =
            -- True
            Debug.log "@@:TOC_COMPARE 2. (fX == fApp)" (fX == fApp)

        _ =
            -- False
            Debug.log "@@:TOC_COMPARE 3. (fApp == fRepl)" (fApp == fRepl)

        nodesRepl =
            -- FROM REPL
            -- for the test document, nodes == nodeData : True
            --> List.map nodeLevel nodeData
            --  [1,1,2,2] : List Int
            [ { block = { args = [ "1" ], body = Right [ Text " Intro " { begin = 46, end = 52, id = "xye-6.0", index = 0 } ], firstLine = "# Intro ", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-2", lineNumber = 6, messages = [], numberOfLines = 1, position = 46, sourceText = "# Intro " }, properties = Dict.fromList [ ( "id", "@-2" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "intro" ) ] }, visible = True }
            , { block = { args = [ "1" ], body = Right [ Text " Particles" { begin = 56, end = 65, id = "xye-8.0", index = 0 } ], firstLine = "# Particles", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 8, messages = [], numberOfLines = 1, position = 56, sourceText = "# Particles" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "particles" ) ] }, visible = True }
            , { block = { args = [ "2" ], body = Right [ Text " Bosons" { begin = 69, end = 75, id = "xye-10.0", index = 0 } ], firstLine = "## Bosons", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-4", lineNumber = 10, messages = [], numberOfLines = 1, position = 69, sourceText = "## Bosons" }, properties = Dict.fromList [ ( "id", "@-4" ), ( "label", "2.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "bosons" ) ] }, visible = True }
            , { block = { args = [ "2" ], body = Right [ Text " Fermions" { begin = 80, end = 88, id = "xye-12.0", index = 0 } ], firstLine = "## Fermions", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-5", lineNumber = 12, messages = [], numberOfLines = 1, position = 80, sourceText = "## Fermions" }, properties = Dict.fromList [ ( "id", "@-5" ), ( "label", "2.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "fermions" ) ] }, visible = True }
            ]

        _ =
            -- @@:TOC_DEPTHS (f3 == f4REPL): ([1,2],[1,1],False)
            -- Something very odd here.  f3 and f4REPL are different
            -- However, nodeData == nodes, where nodeData is taken from the repl
            -- and nodes is derived from documentAst by applying 'makeForest nodeLevel_'
            -- But both are made in the same way from data that is the same: nodeData and nodes
            Debug.log "@@:TOC_DEPTHS (f3 == f4REPL)!!!" ( List.map Library.Tree.depth f3, List.map Library.Tree.depth fX, f3 == fX )

        fX =
            Library.Forest.makeForest Library.Forest.lev nodesRepl

        fApp =
            Library.Forest.makeForest Library.Forest.lev nodesApp

        fRepl =
            -- rRepl COMES FROM REPL, where the import statements are:
            -- import Dict
            -- import Either exposing (Either(..))
            -- import Generic.Language exposing (Expr(..), Heading(..))
            -- import Library.Tree
            -- import RoseTree.Tree exposing (Tree)
            --
            -- NOTE: in the repl, we did
            -- fRepl = makeForest lev nodesRepl
            -- to get the following:
            [ Tree.Tree
                { block = { args = [ "1" ], body = Right [ Text " Intro " { begin = 46, end = 52, id = "xye-6.0", index = 0 } ], firstLine = "# Intro ", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-2", lineNumber = 6, messages = [], numberOfLines = 1, position = 46, sourceText = "# Intro " }, properties = Dict.fromList [ ( "id", "@-2" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "intro" ) ] }
                , visible = True
                }
                (Array.fromList [])
            , Tree.Tree
                { block = { args = [ "1" ], body = Right [ Text " Particles" { begin = 56, end = 65, id = "xye-8.0", index = 0 } ], firstLine = "# Particles", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 8, messages = [], numberOfLines = 1, position = 56, sourceText = "# Particles" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "particles" ) ] }
                , visible = True
                }
                (Array.fromList
                    [ Tree.Tree
                        { block = { args = [ "2" ], body = Right [ Text " Bosons" { begin = 69, end = 75, id = "xye-10.0", index = 0 } ], firstLine = "## Bosons", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-4", lineNumber = 10, messages = [], numberOfLines = 1, position = 69, sourceText = "## Bosons" }, properties = Dict.fromList [ ( "id", "@-4" ), ( "label", "2.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "bosons" ) ] }
                        , visible = True
                        }
                        (Array.fromList [])
                    , Tree.Tree
                        { block = { args = [ "2" ], body = Right [ Text " Fermions" { begin = 80, end = 88, id = "xye-12.0", index = 0 } ], firstLine = "## Fermions", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-5", lineNumber = 12, messages = [], numberOfLines = 1, position = 80, sourceText = "## Fermions" }, properties = Dict.fromList [ ( "id", "@-5" ), ( "label", "2.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "fermions" ) ] }
                        , visible = True
                        }
                        (Array.fromList [])
                    ]
                )
            ]

        f3 =
            -- Renders correct TOC
            -- f3 = makeForest nodeLevel nodeData
            -- ^^^ IN REPL, nodeData is defined in repl
            -- nodeData == nodes : True,
            [ Tree.Tree
                { block = { args = [ "1" ], body = Right [ Text " Intro " { begin = 46, end = 52, id = "xye-6.0", index = 0 } ], firstLine = "# Intro ", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-2", lineNumber = 6, messages = [], numberOfLines = 1, position = 46, sourceText = "# Intro " }, properties = Dict.fromList [ ( "id", "@-2" ), ( "label", "1" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "intro" ) ] }
                , visible = True
                }
                (Array.fromList [])
            , Tree.Tree
                { block = { args = [ "1" ], body = Right [ Text " Particles" { begin = 56, end = 65, id = "xye-8.0", index = 0 } ], firstLine = "# Particles", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-3", lineNumber = 8, messages = [], numberOfLines = 1, position = 56, sourceText = "# Particles" }, properties = Dict.fromList [ ( "id", "@-3" ), ( "label", "2" ), ( "level", "1" ), ( "section-type", "markdown" ), ( "tag", "particles" ) ] }
                , visible = True
                }
                (Array.fromList
                    [ Tree.Tree { block = { args = [ "2" ], body = Right [ Text " Bosons" { begin = 69, end = 75, id = "xye-10.0", index = 0 } ], firstLine = "## Bosons", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-4", lineNumber = 10, messages = [], numberOfLines = 1, position = 69, sourceText = "## Bosons" }, properties = Dict.fromList [ ( "id", "@-4" ), ( "label", "2.1" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "bosons" ) ] }, visible = True } (Array.fromList [])
                    , Tree.Tree { block = { args = [ "2" ], body = Right [ Text " Fermions" { begin = 80, end = 88, id = "xye-12.0", index = 0 } ], firstLine = "## Fermions", heading = Ordinary "section", indent = 0, meta = { error = Nothing, id = "@-5", lineNumber = 12, messages = [], numberOfLines = 1, position = 80, sourceText = "## Fermions" }, properties = Dict.fromList [ ( "id", "@-5" ), ( "label", "2.2" ), ( "level", "2" ), ( "section-type", "markdown" ), ( "tag", "fermions" ) ] }, visible = True } (Array.fromList [])
                    ]
                )
            ]
    in
    --documentAst
    --    |> tocForest idsOfOpenNodes
    fRepl |> List.map (viewTOCTree idsOfOpenNodes settings counter acc attr 4 0 Nothing)


viewTOCTree : List String -> Render.Settings.RenderSettings -> Int -> Accumulator -> List (Element.Attribute MarkupMsg) -> Int -> Int -> Maybe (List String) -> Tree TOCNodeValue -> Element MarkupMsg
viewTOCTree idsOfOpenNodes settings count acc attr depth indentation maybeFoundIds tocTree =
    let
        children : List (Tree TOCNodeValue)
        children =
            Tree.children tocTree

        val : TOCNodeValue
        val =
            Tree.value tocTree
    in
    if depth < 0 || val.visible == False then
        Element.none

    else if List.isEmpty children then
        viewNode count acc settings attr indentation val

    else
        Element.column [ Element.spacing 8 ]
            (viewNode count acc settings attr indentation val
                :: List.map (viewTOCTree idsOfOpenNodes settings count acc attr (depth - 1) (indentation + 1) maybeFoundIds)
                    children
            )


viewNode : Int -> Accumulator -> Render.Settings.RenderSettings -> List (Element.Attribute MarkupMsg) -> Int -> TOCNodeValue -> Element MarkupMsg
viewNode count acc settings attr indentation node =
    viewTocItem_ settings.selectedId count acc settings attr node.block


tocForest : List String -> Forest ExpressionBlock -> List (Tree TOCNodeValue)
tocForest idsOfOpenNodes ast =
    Generic.ASTTools.tableOfContents 8 ast
        --|> Debug.log "@@:TOC_AST"
        |> List.map (makeNodeValue idsOfOpenNodes)
        --|> Debug.log "@@:TOC_NODE_VALUES"
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


viewTocItem_ : String -> Int -> Accumulator -> Render.Settings.RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
viewTocItem_ selectedId count acc settings attr ({ args, body, properties } as block) =
    let
        maximumNumberedTocLevel =
            1
    in
    case body of
        Left _ ->
            Element.none

        Right exprs ->
            let
                foo : List Generic.Language.Expression
                foo =
                    exprs

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
                    Element.paragraph [ tocIndent args ] (sectionNumber :: List.map (Render.Expression.render count acc settings attr) exprs)

                color =
                    if id == selectedId then
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
    \node -> Dict.get "level" node.block.properties |> Maybe.andThen String.toInt |> Maybe.withDefault 1
