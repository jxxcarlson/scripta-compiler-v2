module ScriptaV2.Test exposing (..)

import Generic.Language exposing (..)
import Generic.Pipeline
import M.Expression
import M.PrimitiveBlock
import ScriptaV2.Language


exprBlock : Generic.Language.PrimitiveBlock -> Generic.Language.ExpressionBlock
exprBlock =
    Generic.Pipeline.toExpressionBlock M.Expression.parse


exprBlocks : String -> List Generic.Language.ExpressionBlock
exprBlocks str =
    List.map exprBlock (M.PrimitiveBlock.parse "0" 0 (String.lines str))


ib =
    """
| indent
1234Vivamus dignissim tristique enim, et fringilla enim vulputate at. Vestibulum ornare, odio vitae pharetra laoreet, elit nibh iaculis augue, sit amet sodales massa quam sit amet sem.
In et placerat neque, eget faucibus nisl.
"""


py =
    """
| code python
for i = 12 to n:
  x = x + 3*i
print(x)
"""
