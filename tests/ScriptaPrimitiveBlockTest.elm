module ScriptaPrimitiveBlockTest exposing (suite)

import Expect
import Generic.Language exposing (Block, PrimitiveBlock)
import Scripta.PrimitiveBlock exposing (parse)
import Test exposing (..)


suite : Test
suite =
    describe "Scripta's primitive block parser"
        [ describe "Parsing multi-block source text produces correct number of blocks"
            [ test "generic text" <|
                \_ ->
                    parse "@@" 0 (String.lines text1)
                        |> List.length
                        |> Expect.equal 4
            , test "body of the parsed primitive block equals the lines of the input paragraph" <|
                \_ ->
                    parse "@@" 0 (String.lines paragraph)
                        |> List.map getBody
                        |> List.head
                        |> Expect.equal (Just [ "abc", "def", "ghi" ])
            , test "selected metadata of the parsed primitive block checks" <|
                \_ ->
                    parse "@@" 0 (String.lines paragraph)
                        |> List.map (getMeta >> (\m -> { id = m.id, lineNumber = m.lineNumber, position = m.position }))
                        |> List.head
                        |> Expect.equal (Just { id = "3-0", lineNumber = 1, position = 0 })
            ]
        ]


getBody : PrimitiveBlock -> List String
getBody block =
    block.body


getMeta : Generic.Language.Block content meta -> meta
getMeta block =
    block.meta


text1 =
    """
abc
def

ghi
jkl

| theorem
There are infinitely 
many primes

| code
s = 0
for i in [1..10]:
  s = s + i
println(s)
"""


paragraph =
    """abc
def
ghi
"""
