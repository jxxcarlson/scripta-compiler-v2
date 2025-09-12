module ReplTest exposing (..)

import Generic.Language
import Generic.Pipeline
import M.Expression
import M.PrimitiveBlock


p : String -> List Generic.Language.PrimitiveBlock
p str =
    M.PrimitiveBlock.parse "0" 0 (String.lines str)


q : String -> List Generic.Language.ExpressionBlock
q =
    p >> List.map expressionBlockFromPrimitiveBlock


expressionBlockFromPrimitiveBlock : Generic.Language.PrimitiveBlock -> Generic.Language.ExpressionBlock
expressionBlockFromPrimitiveBlock =
    Generic.Pipeline.toExpressionBlock M.Expression.parse


t =
    "abc\ndef\n\nXYZ"


t1 =
    """
Hello there [anchor one [i two] three]
YADA [b YADA] YADA
"""


t2 =
    """
The notion of entropy stems from the observation that
early steam engines were grossly inefficient: a large
input of heat energy resulted in a small output of 
mechanical energy. The efficiency of the Newcomen engine, 
discussed in section [ref heat-engines] below was estimated 
to be only $0.02\\%$! [anchor The first
forward step in understanding
the cause] of this poor result came from Sadi Carnot
in 1824.  He defined efficiency of a heat engine as
 

| equation numbered
\\label{efficiency-def}
eta = frac("work produced","heat supplied") = frac(W,Q_H)
"""


t3 =
    """
| title
Remarks on Optics (Test)

aaa

bbb

ccc

[tags jxxcarlson:remarks-on-optics-test]

In this article we trace some important developments in optics, 
beginning with Roman Aliexandria in the period 10 to 200 CE.
While Egypt came under Roman rule after the defeat of Cleopatra
by Marc Antony in the battle of Actium in 30 BCE, it remained
a cosmopolitan hub of Greek-speaking culture, philosophy, science,
and commerce, inhabited by a mix of Greeks, Egyptians, Jews, and Romans.

# Hero of Alexandria

[anchor Our first real phyiscal theory goes back to Hero of 
Alexandria (10-70 CE)], A mathematican and engineer who 
explained in precise terms the law that governs 
reflection in a mirror: as in Figure 1 below,
the angle of incidence $alpha$ of a light ray $AP$ is 
equal to the angle $beta$ of the reflected ray $PB$.
"""


t4 =
    """
| title
Remarks on Optics (Test)

abc

def

In this article we trace some [i important developments in optics],
beginning with [b Roman Alexandria in the period 10 to 200 CE.]
  """


tt4 =
    """
In this article we trace some [i important developments in optics],
beginning with [b Roman Alexandria in the period 10 to 200 CE.]
"""


tt5 =
    """
abc

def

ghi


In this article we trace some [i important developments in optics],
beginning with [b Roman Alexandria in the period 10 to 200 CE.]
"""


t5 =
    """
| title
Remarks on Optics (Test)

[tags jxxcarlson:remarks-on-optics-test]

In this article we trace some important developments in optics, 
beginning with Roman Aliexandria in the period 10 to 200 CE.
  
Egypt came under Roman rule after the defeat of Cleopatra
by Marc Antony in the battle of Actium in 30 BCE.
"""


t6 =
    """
Ho ho ho! [anchor Our first real phyiscal theory goes back to Hero of 
Alexandria (10-70 CE)], A mathematican and engineer who 
explained in precise terms the law that governs 
reflection in a mirror: as in Figure 1 below,
the angle of incidence $alpha$ of a light ray $AP$ is 
equal to the angle $beta$ of the reflected ray $PB$.
"""


t7 =
    "| equation numbered label:foo-bar\nx^ = y^2 + z^2\n"



-- http://localhost:8007/g/jxxcarlson:remarks-on-optics-test#highlight=e-9.0
-- http://localhost:8007/g/jxxcarlson:remarks-on-optics-test
-- [ilink first real physical theory jxxcarlson:remarks-on-optics-test]
