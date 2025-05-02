module RenderTest exposing (suite)

import Element
import Expect
import Generic.Acc
import Generic.Language exposing (ExpressionBlock, Heading(..))
import Render.Compatibility.Tree as CompatibilityTree
import Render.Settings
import RoseTree.Tree exposing (Tree)
import Test exposing (..)
import ScriptaV2.Msg exposing (MarkupMsg)


suite : Test
suite =
    describe "Render Module"
        [ test "renderTree correctly renders a simple tree" <|
            \_ ->
                let
                    -- Create a simple tree with a box and a paragraph
                    tree =
                        RoseTree.Tree.singleton boxBlock
                            |> RoseTree.Tree.addChild (RoseTree.Tree.singleton paragraphBlock)

                    -- Render the tree
                    rendered =
                        CompatibilityTree.renderTree 
                            0 
                            Generic.Acc.initialData 
                            defaultSettings 
                            [] 
                            tree
                in
                    -- Verify something was rendered (basic smoke test)
                    rendered
                        |> elementToString
                        |> String.length
                        |> Expect.greaterThan 0
        ]


-- Helper to convert an Element to a debug string
elementToString : Element.Element MarkupMsg -> String
elementToString element =
    Element.layout [] element
        |> Debug.toString


-- Sample blocks for testing
boxBlock : ExpressionBlock
boxBlock =
    { args = []
    , body = Generic.Language.Right []
    , heading = Ordinary "box"
    , indent = 0
    , meta =
        { id = "1"
        , lineNumber = 1
        , numberOfLines = 1
        , error = Nothing
        }
    , properties = Dict.empty
    }


paragraphBlock : ExpressionBlock
paragraphBlock =
    { args = []
    , body = Generic.Language.Right []
    , heading = Paragraph
    , indent = 0
    , meta =
        { id = "2"
        , lineNumber = 2
        , numberOfLines = 1
        , error = Nothing
        }
    , properties = Dict.empty
    }


-- Default render settings for testing
defaultSettings : Render.Settings.RenderSettings
defaultSettings =
    { width = 500
    , titleSize = 24
    , paragraphSpacing = 10
    , displayed = True
    , selectedId = ""
    , backgroundColor = Element.rgb 1 1 1
    , titlePrefix = "test-"
    , isLight = True
    , leftIndent = 0
    , rightIndent = 0
    , leftMargin = 0
    , rightMargin = 0
    , showTOC = True
    , showErrorMessages = True
    , topMarginForChildren = 0
    , seed = 0
    , counterValue = 0
    , selectedSlug = Nothing
    , headingFontSize = 16
    , maxHeadingFontSize = 32
    , redColor = Element.rgb 0.8 0 0
    }