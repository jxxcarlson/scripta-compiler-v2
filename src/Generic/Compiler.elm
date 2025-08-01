module Generic.Compiler exposing
    ( DisplaySettings
    , RenderData
    , defaultRenderData
    , defaultRenderSettings
    , parse_
    )

import Dict exposing (Dict)
import Generic.Acc
import Generic.Forest
import Generic.ForestTransform
import Generic.Language exposing (ExpressionBlock)
import Generic.Pipeline
import Render.Settings
import Render.Theme
import RoseTree.Tree
import ScriptaV2.Language exposing (Language)


{-|

    This is a generic compiler from source text to HTML that
    takes two parsers as arguments. The first parser parses
    the primitive blocks, and the second parser parses the
    expressions in the blocks.

-}
parse_ :
    Language
    -> (String -> Int -> List String -> List Generic.Language.PrimitiveBlock)
    -> (Int -> String -> List Generic.Language.Expression)
    -> String
    -> Int
    -> List String
    -> List (RoseTree.Tree.Tree ExpressionBlock)
parse_ lang primitiveBlockParser exprParser idPrefix outerCount lines =
    lines
        |> primitiveBlockParser idPrefix outerCount
        |> Generic.ForestTransform.forestFromBlocks .indent
        |> Generic.Forest.map (Generic.Pipeline.toExpressionBlock exprParser)


type alias RenderData =
    { count : Int
    , idPrefix : String
    , settings : Render.Settings.RenderSettings
    , initialAccumulatorData : Generic.Acc.InitialAccumulatorData
    }



-- default selectedId width


defaultRenderData : Render.Theme.Theme -> Int -> Int -> String -> RenderData
defaultRenderData theme width outerCount selectedId =
    { count = outerCount
    , idPrefix = "!!"
    , settings = Render.Settings.default theme selectedId width
    , initialAccumulatorData = Generic.Acc.initialData
    }


defaultRenderSettings : Render.Theme.Theme -> Int -> String -> Render.Settings.RenderSettings
defaultRenderSettings theme width selectedId =
    Render.Settings.default theme selectedId width


type alias DisplaySettings =
    { windowWidth : Int
    , longEquationLimit : Float
    , counter : Int
    , selectedId : String
    , selectedSlug : Maybe String
    , scale : Float
    , data : Dict String String
    , idsOfOpenNodes : List String
    }
