module ToExpressionBlockTest exposing (suite)

import Dict
import Expect
import Generic.Language exposing (Block, Heading(..), PrimitiveBlock)
import Generic.Pipeline
import Scripta.Expression
import Scripta.PrimitiveBlock
import Test exposing (..)


suite : Test
suite =
    describe "Scripta's primitive block parser"
        [ describe "Selected metadata of an equation block is correct"
            [ test "generic text" <|
                \_ ->
                    Scripta.PrimitiveBlock.parse "@@" 0 (String.lines paragraph)
                        |> List.map (Generic.Pipeline.toExpressionBlock Scripta.Expression.parse)
                        |> List.map (\block -> { heading = block.heading })
                        |> Expect.equal [ { heading = Paragraph } ]
            , test "theorem" <|
                \_ ->
                    Scripta.PrimitiveBlock.parse "@@" 0 (String.lines theorem)
                        |> List.map (Generic.Pipeline.toExpressionBlock Scripta.Expression.parse)
                        |> List.map (\block -> { heading = block.heading, label = Dict.get "label" block.properties, args = block.args })
                        |> Expect.equal [ { args = [ "Pythagoras", "Senior" ], heading = Ordinary "theorem", label = Nothing } ]
            , test "equation" <|
                \_ ->
                    Scripta.PrimitiveBlock.parse "@@" 0 (String.lines equation)
                        |> List.map (Generic.Pipeline.toExpressionBlock Scripta.Expression.parse)
                        |> List.map (\block -> { heading = block.heading, label = Dict.get "label" block.properties, args = block.args })
                        |> Expect.equal [ { args = [ "numbered" ], heading = Verbatim "equation", label = Just "pythagoras" } ]
            ]
        ]


getBody : PrimitiveBlock -> List String
getBody block =
    block.body


getMeta : Generic.Language.Block content meta -> meta
getMeta block =
    block.meta


paragraph =
    """abc
def
"""


equation =
    """| equation label:pythagoras
a^2 + b^2 = c^2
"""


theorem =
    """| theorem Pythagoras Senior
If $a, b, c$ are the sides of a right triangle
with hypotenuse $c$, then $a^ + b^2 c^2$
"""
