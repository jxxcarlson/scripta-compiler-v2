module Render.Compatibility.Tree exposing (renderTree)

{-| This module provides compatibility for tree rendering.

@docs renderTree

-}

import Element exposing (Element)
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (ExpressionBlock)
import Render.Settings exposing (RenderSettings)
import Render.Tree as NewTree
import RoseTree.Tree exposing (Tree)
import ScriptaV2.Msg exposing (MarkupMsg)
import ScriptaV2.Types


{-| Compatibility wrapper for Tree.renderTree
-}
renderTree : ScriptaV2.Types.CompilerParameters -> RenderSettings -> Accumulator -> List (Element.Attribute MarkupMsg) -> Tree ExpressionBlock -> Element MarkupMsg
renderTree =
    NewTree.renderTree