module ScriptaV2.Compiler exposing
    ( CompilerOutput, compile, parse, parseFromString, renderForest, view, viewTOC, px, viewBody
    , filterForest2, header_, parseMiniLaTeX, parseSMarkdown, parseScripta, parseToForestWithAccumulator, pl, ps, viewBodyOnly
    )

{-|

@docs CompilerOutput, Filter, compile, parse, parseFromString, render, renderForest, view, viewTOC, filterForest, p, px, viewBody

-}

-- Previous exposing list:
--( CompilerOutput, Filter(..), compile, parse, parseFromString, render, renderForest, view, viewTOC, filterForest, px, viewBody
--, CompilerParameters, filterForest2, header, header_, parseM, pl, pm, ps, viewBodyOnly, view_
--)
-- import Markdown.Compiler

import Dict
import Element exposing (Element)
import Element.Font as Font
import Generic.ASTTools
import Generic.Acc exposing (Accumulator)
import Generic.Compiler
import Generic.Forest exposing (Forest)
import Generic.Language exposing (ExpressionBlock)
import Scripta.Expression
import Scripta.PrimitiveBlock
import MicroLaTeX.Expression
import MicroLaTeX.PrimitiveBlock
import Render.Block
import Render.Settings
import Render.TOCTree
import Render.Theme
import Render.Tree
import RoseTree.Tree
import ScriptaV2.Config as Config
import ScriptaV2.Language exposing (Language(..))
import ScriptaV2.Msg exposing (MarkupMsg(..))
import ScriptaV2.Types exposing (CompilerParameters, Filter(..))
import XMarkdown.Expression
import XMarkdown.PrimitiveBlock


{-| -}
type alias CompilerParametersOLD =
    { lang : Language
    , docWidth : Int
    , editCount : Int
    , selectedId : String
    , idsOfOpenNodes : List String
    , filter : Filter
    }


type alias DisplaySettings =
    { windowWidth : Int
    , longEquationLimit : Float
    , counter : Int
    , selectedId : String
    , selectedSlug : Maybe String
    , scale : Float
    , data : Dict.Dict String String
    , idsOfOpenNodes : List String
    , numberToLevel : Int
    }


{-| -}
view : Int -> CompilerOutput -> List (Element MarkupMsg)
view width_ compiled =
    [ Element.column [ Element.width (Element.px (width_ - 60)) ]
        (header compiled)
    , body compiled
    ]


view_ : Int -> CompilerOutput -> List (Element MarkupMsg)
view_ width_ compiled =
    [ Element.column [ Element.width (Element.px (width_ - 60)) ]
        (header_ compiled)
    , body compiled
    ]


{-| -}
viewBody : Int -> CompilerOutput -> List (Element MarkupMsg)
viewBody width_ compiled =
    [ Element.column [ Element.width (Element.px (width_ - 60)) ]
        (header_ compiled)
    , body compiled
    ]



--viewBodyOnly : Int -> CompilerOutput -> List (Element MarkupMsg)


viewBodyOnly : Int -> CompilerOutput -> List (Element MarkupMsg)
viewBodyOnly width_ compiled =
    [ Element.column [ Element.width (Element.px (width_ - 60)) ]
        [ body compiled ]
    ]


header_ : CompilerOutput -> List (Element MarkupMsg)
header_ compiled =
    case compiled.banner of
        Nothing ->
            Element.el [] compiled.title
                :: []

        Just banner ->
            Element.el [] banner
                :: (Element.el [] compiled.title
                        :: []
                   )


{-| -}
header : CompilerOutput -> List (Element MarkupMsg)
header compiled =
    case compiled.banner of
        Nothing ->
            Element.el [ Font.size 32, bottomPadding 18 ] compiled.title
                :: Element.column [ Element.spacing 8, bottomPadding 72 ] compiled.toc
                :: []

        Just banner ->
            Element.el [] banner
                :: (Element.el [ Font.size 32, bottomPadding 18 ] compiled.title
                        :: Element.column [ Element.spacing 8, bottomPadding 36 ] compiled.toc
                        :: []
                   )


{-| -}
body : CompilerOutput -> Element MarkupMsg
body compiled =
    -- Element.column [ Element.spacing 18, Element.moveUp 156 ] compiled.body
    Element.column [ Element.spacing 18, Element.alignTop ] compiled.body


{-| -}
viewTOC : CompilerOutput -> List (Element MarkupMsg)
viewTOC compiled =
    compiled.toc


bottomPadding k =
    Element.paddingEach { left = 0, right = 0, top = 0, bottom = k }


{-|

    compile lang width counter selectedId lines
    Used only in View.Phone (twice)

-}
compile : CompilerParameters -> List String -> CompilerOutput
compile params lines =
    render params (parseToForestWithAccumulator params lines)


{-|

    > cm "hello!\n\n  [b how are you?]\n\n  $x^2 = 7$\n\n"
    Ok [ Tree { args = [], body = Right [Text "hello!" ()], firstLine = "hello!", heading = Paragraph
           , indent = 0, meta = () , properties = Dict.fromList [] }
         [ Tree { args = [], body = Right [Text ("   ") (),Fun "b" [Text (" how are you?") ()] ()]
            , firstLine = "[b how are you?]", heading = Paragraph, indent = 2, meta = ()
            , properties = Dict.fromList [] } []
         , Tree { args = [], body = Right [Text ("   ") (),VFun "math" ("x^2 = 7") ()]
           , firstLine = "$x^2 = 7$", heading = Paragraph, indent = 2, meta = ()
           , properties = Dict.fromList [] } []]]

    -- proof that the output is a one-tree forest
    > cm "hello!\n\n  [b how are you?]\n\n  $x^2 = 7$\n\n" |> Result.map List.length
    Ok 1

-}
pm str =
    parseScripta "!!" 0 (String.lines str) |> Generic.Forest.map Generic.Language.simplifyExpressionBlock


{-| -}
parseFromString : Language -> String -> Forest ExpressionBlock
parseFromString lang str =
    parse lang Config.idPrefix 0 (String.lines str)


{-|

    parse lang idPrefix counter lines
    Used only in CurrentDocument.setInPhone

-}
parse : Language -> String -> Int -> List String -> List (RoseTree.Tree.Tree ExpressionBlock)
parse lang idPrefix outerCount lines =
    case lang of
        ScriptaLang ->
            parseScripta idPrefix outerCount lines

        MiniLaTeXLang ->
            parseMiniLaTeX idPrefix outerCount lines

        SMarkdownLang ->
            parseSMarkdown idPrefix outerCount lines

        MarkdownLang ->
            -- Markdown doesn't use the same tree-based parsing structure
            -- For now, return an empty list since Markdown is handled differently
            []


parseScripta : String -> Int -> List String -> List (RoseTree.Tree.Tree ExpressionBlock)
parseScripta idPrefix outerCount lines =
    Generic.Compiler.parse_ Scripta.PrimitiveBlock.parse Scripta.Expression.parse idPrefix outerCount lines


parseSMarkdown : String -> Int -> List String -> List (RoseTree.Tree.Tree ExpressionBlock)
parseSMarkdown idPrefix outerCount lines =
    Generic.Compiler.parse_ XMarkdown.PrimitiveBlock.parse XMarkdown.Expression.parse idPrefix outerCount lines


{-| =
-}
px : String -> List (RoseTree.Tree.Tree ExpressionBlock)
px str =
    parseSMarkdown "!!" 0 (String.lines str)


{-|

    > pl str = parseL "!!" (String.lines str) |> Result.map (F.map simplifyExpressionBlock)

-}
parseMiniLaTeX : String -> Int -> List String -> Forest ExpressionBlock
parseMiniLaTeX idPrefix outerCount lines =
    Generic.Compiler.parse_ MicroLaTeX.PrimitiveBlock.parse MicroLaTeX.Expression.parse idPrefix outerCount lines



-- M compiler


{-| -}
type alias CompilerOutput =
    { body : List (Element MarkupMsg)
    , banner : Maybe (Element MarkupMsg)
    , toc : List (Element MarkupMsg)
    , title : Element MarkupMsg
    }


{-| -}
ps : String -> Forest ExpressionBlock
ps str =
    parseScripta Config.idPrefix 0 (String.lines str)


pl : String -> Forest ExpressionBlock
pl str =
    parseMiniLaTeX Config.idPrefix 0 (String.lines str)


{-| -}
filterForest : Filter -> Forest ExpressionBlock -> Forest ExpressionBlock
filterForest filter forest =
    case filter of
        NoFilter ->
            forest

        SuppressDocumentBlocks ->
            forest
                |> Generic.ASTTools.filterForestOnLabelNames (\name -> name /= Just "document")
                |> Generic.ASTTools.filterForestOnLabelNames (\name -> name /= Just "title")


filterForest2 : Forest ExpressionBlock -> Forest ExpressionBlock
filterForest2 forest =
    forest
        |> Generic.ASTTools.filterForestOnLabelNames (\name -> name /= Just "document")
        |> Generic.ASTTools.filterForestOnLabelNames (\name -> name /= Just "title")


parseToForestWithAccumulator : CompilerParameters -> List String -> ( Accumulator, Forest ExpressionBlock )
parseToForestWithAccumulator params lines =
    let
        parser =
            case params.lang of
                ScriptaLang ->
                    parseScripta

                MiniLaTeXLang ->
                    parseMiniLaTeX

                SMarkdownLang ->
                    parseSMarkdown

                MarkdownLang ->
                    neverUsedParser

        neverUsedParser : String -> Int -> List String -> List (RoseTree.Tree.Tree ExpressionBlock)
        neverUsedParser _ _ _ =
            []

        -- NOTE: really bad idea!
        forest =
            filterForest params.filter (parser Config.idPrefix params.editCount lines)
    in
    Generic.Acc.transformAccumulate Generic.Acc.initialData forest


render : CompilerParameters -> ( Accumulator, Forest ExpressionBlock ) -> CompilerOutput
render params ( accumulator_, forest_ ) =
    let
        renderSettings : Render.Settings.RenderSettings
        renderSettings =
            Render.Settings.defaultRenderSettings params

        --( accumulator, forest ) =
        --    Generic.Acc.transformAccumulate Generic.Acc.initialData forest_
        viewParameters =
            { idsOfOpenNodes = params.idsOfOpenNodes
            , selectedId = params.selectedId
            , counter = params.editCount
            , attr = []
            , settings = renderSettings
            }

        toc : List (Element MarkupMsg)
        toc =
            -- this value is used in DemoTOC for the document TOC
            -- it is NOT used for the documentTOC in Lamdera
            --Render.TOCTree.view viewParameters accumulator forest_
            Render.TOCTree.view params.theme viewParameters accumulator_ forest_

        banner : Maybe (Element MarkupMsg)
        banner =
            Generic.ASTTools.banner forest_
                |> Maybe.map (Render.Block.renderBody params.editCount accumulator_ renderSettings [ Font.color (Element.rgb 1 0 0) ])
                |> Maybe.map (Element.row [ Element.height (Element.px 40) ])

        title : Element MarkupMsg
        title =
            Element.paragraph [] [ Element.text <| Generic.ASTTools.title forest_ ]
    in
    { body =
        renderForest params renderSettings accumulator_ forest_
    , banner = banner
    , toc = toc
    , title = title
    }


{-|

    renderForest count renderSettings accumulator

-}
renderForest :
    ScriptaV2.Types.CompilerParameters
    -> Render.Settings.RenderSettings
    -> Generic.Acc.Accumulator
    -> List (RoseTree.Tree.Tree ExpressionBlock)
    -> List (Element MarkupMsg)
renderForest params settings accumulator forest =
    List.map (Render.Tree.renderTree params settings accumulator []) forest



--
