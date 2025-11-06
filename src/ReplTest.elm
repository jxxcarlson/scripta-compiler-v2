module ReplTest exposing (..)

import Generic.Forest
import Generic.Language
import Generic.Pipeline
import Scripta.Expression
import Scripta.PrimitiveBlock
import MicroLaTeX.PrimitiveBlock
import Render.Settings
import ScriptaV2.Compiler


p : String -> List Generic.Language.PrimitiveBlock
p str =
    Scripta.PrimitiveBlock.parse "0" 0 (String.lines str)


pL : String -> List Generic.Language.PrimitiveBlock
pL str =
    MicroLaTeX.PrimitiveBlock.parse "0" 0 (String.lines str)


q : String -> List Generic.Language.ExpressionBlock
q =
    p >> List.map expressionBlockFromPrimitiveBlock


qL : String -> List Generic.Language.ExpressionBlock
qL =
    pL >> List.map expressionBlockFromPrimitiveBlock


t : String -> Generic.Forest.Forest Generic.Language.ExpressionBlock
t str =
    ScriptaV2.Compiler.ps str


dfrs : Render.Settings.RenderSettings
dfrs =
    Render.Settings.defaultRenderSettings Render.Settings.defaultDisplaySettings


expressionBlockFromPrimitiveBlock : Generic.Language.PrimitiveBlock -> Generic.Language.ExpressionBlock
expressionBlockFromPrimitiveBlock =
    Generic.Pipeline.toExpressionBlock Scripta.Expression.parse


t1 =
    """
| image caption:Entropy
https://upload.wikimedia.org/wikipedia/commons/3/3d/Entropy_diagram.png

"""


t2 =
    """
\\begin{figure}[h]
  \\centering
  % scale image to 50% of text width
  \\includegraphics[width=0.5\\textwidth]{hummingbird.jpg}
  \\caption{A hummingbird drinking from a flower.}
  \\label{fig:hummingbird}
\\end{figure}

"""


t3 =
    """
\\begin{enumerate}

\\item{First}

\\item{Second}

\\end{enumerate}

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
