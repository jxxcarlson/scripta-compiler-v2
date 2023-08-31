module ScriptaV2.Compiler exposing
    ( CompilerOutput, compile, parse, parseFromString, render, renderForest, view, viewTOC
    , p
    )

{-|

@docs CompilerOutput, compile, parse, parseFromString, render, renderForest, view, viewTOC

-}

import Element exposing (Element)
import Element.Font as Font
import Generic.ASTTools
import Generic.Acc
import Generic.Compiler
import Generic.Forest exposing (Forest)
import Generic.ForestTransform exposing (Error)
import Generic.Language exposing (ExpressionBlock)
import M.Expression
import M.PrimitiveBlock
import MicroLaTeX.Expression
import MicroLaTeX.PrimitiveBlock
import Render.Block
import Render.Msg exposing (MarkupMsg(..))
import Render.Settings
import Render.TOC
import Render.Tree
import ScriptaV2.Config as Config
import ScriptaV2.Language exposing (Language(..))
import XMarkdown.Expression
import XMarkdown.PrimitiveBlock


view : Int -> CompilerOutput -> List (Element MarkupMsg)
view width_ compiled =
    [ Element.column [ Element.width (Element.px (width_ - 60)) ] (header compiled)
    , body compiled
    ]


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


body : CompilerOutput -> Element MarkupMsg
body compiled =
    Element.column [ Element.spacing 18, Element.moveUp 96 ] compiled.body


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
compile : Language -> Int -> Int -> String -> List String -> CompilerOutput
compile lang width outerCount selectedId lines =
    case lang of
        L0Lang ->
            compileM width outerCount selectedId lines

        MicroLaTeXLang ->
            compileL width outerCount selectedId lines

        XMarkdownLang ->
            compileX width outerCount selectedId lines


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
    parseM "!!" 0 (String.lines str) |> Result.map (Generic.Forest.map Generic.Language.simplifyExpressionBlock)


{-| -}
parseFromString : Language -> String -> Result Error (Forest ExpressionBlock)
parseFromString lang str =
    parse lang Config.idPrefix 0 (String.lines str)


{-|

    parse lang idPrefix counter lines
    Used only in CurrentDocument.setInPhone

-}
parse : Language -> String -> Int -> List String -> Result Error (Forest ExpressionBlock)
parse lang idPrefix outerCount lines =
    case lang of
        L0Lang ->
            parseM idPrefix outerCount lines

        MicroLaTeXLang ->
            parseL idPrefix outerCount lines

        XMarkdownLang ->
            parseX idPrefix outerCount lines


parseM : String -> Int -> List String -> Result Error (Forest ExpressionBlock)
parseM idPrefix outerCount lines =
    Generic.Compiler.parse_ L0Lang M.PrimitiveBlock.parse M.Expression.parse idPrefix outerCount lines


parseX : String -> Int -> List String -> Result Error (Forest ExpressionBlock)
parseX idPrefix outerCount lines =
    Generic.Compiler.parse_ XMarkdownLang XMarkdown.PrimitiveBlock.parse XMarkdown.Expression.parse idPrefix outerCount lines



-- M compiler


{-| -}
type alias CompilerOutput =
    { body : List (Element MarkupMsg)
    , banner : Maybe (Element MarkupMsg)
    , toc : List (Element MarkupMsg)
    , title : Element MarkupMsg
    }


p str =
    parseM Config.idPrefix 0 (String.lines str)


compileM : Int -> Int -> String -> List String -> CompilerOutput
compileM width outerCount selectedId lines =
    case parseM Config.idPrefix outerCount lines of
        Err err ->
            { body = [ Element.text "Oops something went wrong" ], banner = Nothing, toc = [], title = Element.text "Oops! (Error)" }

        Ok forest_ ->
            render width selectedId outerCount forest_


compileX : Int -> Int -> String -> List String -> CompilerOutput
compileX width outerCount selectedId lines =
    case parseX Config.idPrefix outerCount lines of
        Err err ->
            { body = [ Element.text "Oops something went wrong" ], banner = Nothing, toc = [], title = Element.text "Oops! (Error)" }

        Ok forest_ ->
            render width selectedId outerCount forest_



-- LaTeX compiler


{-|

    > pl str = parseL "!!" (String.lines str) |> Result.map (F.map simplifyExpressionBlock)

-}
parseL : String -> Int -> List String -> Result Error (Forest ExpressionBlock)
parseL idPrefix outerCount lines =
    Generic.Compiler.parse_ MicroLaTeXLang MicroLaTeX.PrimitiveBlock.parse MicroLaTeX.Expression.parse idPrefix outerCount lines


compileL : Int -> Int -> String -> List String -> CompilerOutput
compileL width outerCount selectedId lines =
    case parseL Config.idPrefix outerCount lines of
        Err err ->
            { body = [ Element.text "Oops something went wrong" ], banner = Nothing, toc = [], title = Element.text "Oops! (Error)" }

        Ok forest_ ->
            render width selectedId outerCount forest_


{-|

    render width selectedId counter forest

-}
render : Int -> String -> Int -> Forest ExpressionBlock -> CompilerOutput
render width selectedId outerCount forest_ =
    let
        renderSettings =
            Generic.Compiler.defaultRenderSettings width selectedId

        ( accumulator, forest ) =
            Generic.Acc.transformAccumulate Generic.Acc.initialData forest_

        toc : List (Element MarkupMsg)
        toc =
            Render.TOC.view selectedId outerCount accumulator [] forest

        banner : Maybe (Element MarkupMsg)
        banner =
            Generic.ASTTools.banner forest
                |> Maybe.map (Render.Block.renderBody outerCount accumulator renderSettings [ Font.color (Element.rgb 1 0 0) ])
                |> Maybe.map (Element.row [ Element.height (Element.px 40) ])

        title : Element MarkupMsg
        title =
            Element.paragraph [] [ Element.text <| Generic.ASTTools.title forest ]
    in
    { body =
        renderForest outerCount renderSettings accumulator forest
    , banner = banner
    , toc = toc
    , title = title
    }


{-|

    renderForest count renderSettings accumulator

-}
renderForest : Int -> Render.Settings.RenderSettings -> Generic.Acc.Accumulator -> Forest ExpressionBlock -> List (Element MarkupMsg)
renderForest count renderSettings accumulator =
    List.map (Render.Tree.renderTreeQ count accumulator renderSettings [])



--
