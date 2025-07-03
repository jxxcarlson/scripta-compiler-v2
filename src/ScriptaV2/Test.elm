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


item =
    "- Red wine"


items =
    """
- Red wine
prefer Cabernet
- White wine
prefer Pino Grigio
- Cranberry juice
"""


alpha =
    """
- A
1
- B
2
- C
3
- D
4
- E
5
"""


nl =
    """
. Plastic cups
. Red wine
. White wine
. Cheese
. Crackers
"""


alpha2Clean =
    """
- A
[i first item]
- B
- C
- D
- E

"""


alpha2Hoho =
    """
- A
[i first item]
- B
- C
- D
- E

Ho ho ho!
"""


beta2 =
    [ Text "A " { begin = 1, end = 2, id = "e-0.0", index = 0 }, Fun "i" [ Text " number 1" { begin = 4, end = 12, id = "e-0.3", index = 3 } ] { begin = 4, end = 4, id = "e-0.2", index = 2 }, Text "B 2" { begin = 1, end = 3, id = "e-0.0", index = 0 }, Text "C 3" { begin = 1, end = 3, id = "e-0.0", index = 0 }, Text "D 4" { begin = 1, end = 3, id = "e-0.0", index = 0 }, Text "E 5" { begin = 1, end = 3, id = "e-0.0", index = 0 } ]


items2 =
    """
- Red wine,
prefer Cabernet and [i something else]
- White wine,
prefer Pinot Grigio
- Cranberry juice
"""


cl2 =
    """
- Plastic cups
not too big
- Red wine
  really good stuff!
- White wine

$a^ + b^2 = c^2$
"""
