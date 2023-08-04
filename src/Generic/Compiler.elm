module Generic.Compiler exposing
    ( DisplaySettings
    , RenderData
    , defaultRenderData
    , defaultRenderSettings
    , parse_
    )

import Generic.Acc
import Generic.Forest exposing (Forest)
import Generic.ForestTransform exposing (Error)
import Generic.Language exposing (ExpressionBlock)
import Generic.Pipeline
import Render.Settings
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
    -> Result Error (Forest ExpressionBlock)
parse_ lang primitiveBlockParser exprParser idPrefix outerCount lines =
    lines
        |> primitiveBlockParser idPrefix outerCount
        |> Generic.Pipeline.toPrimitiveBlockForest
        |> Result.map (Generic.Forest.map (Generic.Pipeline.toExpressionBlock lang exprParser))


type alias RenderData =
    { count : Int
    , idPrefix : String
    , settings : Render.Settings.RenderSettings
    , initialAccumulatorData : Generic.Acc.InitialAccumulatorData
    }



-- default selectedId width


defaultRenderData : Int -> Int -> String -> RenderData
defaultRenderData width outerCount selectedId =
    { count = outerCount
    , idPrefix = "!!"
    , settings = Render.Settings.default selectedId width
    , initialAccumulatorData = Generic.Acc.initialData
    }


defaultRenderSettings : Int -> String -> Render.Settings.RenderSettings
defaultRenderSettings width selectedId =
    Render.Settings.default selectedId width


type alias DisplaySettings =
    { windowWidth : Int
    , longEquationLimit : Float
    , counter : Int
    , selectedId : String
    , selectedSlug : Maybe String
    , scale : Float
    }
