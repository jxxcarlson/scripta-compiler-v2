module BlockTest exposing (..)

import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Generic.Language exposing (Heading(..), PrimitiveBlock)
import M.PrimitiveBlock as L
import MicroLaTeX.PrimitiveBlock as M
import Test exposing (..)
import XMarkdown.PrimitiveBlock as X


lPrimitiveBlocks : Test
lPrimitiveBlocks =
    describe "l.PrimitiveBlock Parser"
        [ contentTest L.parse "l paragraph" lt1 lb1
        , contentTest L.parse "l equation with pmatrix" lt2 lb2
        , contentTest L.parse "l theorem" lt3 lb3
        , contentTest L.parse "l items" items xitems
        , contentTest L.parse "l numbered" numbered xnumbered
        , contentTest L.parse "l code" code xcode

        --
        , contentTest M.parse "latex paragraph" lt1 lbb2
        , contentTest M.parse "latex equation with pmatrix" mt2 mb2
        , contentTest M.parse "latex theorem" mt3 mb3
        , contentTest M.parse "latex items" items rendered_items
        , contentTest M.parse "latex litems" litems rendered_litems
        , contentTest M.parse "latex numbered" numbered xnumbered_latex
        , contentTest M.parse "latex code" code xcode

        --
        , contentTest X.parse "markdown paragraph" lt1 lb1
        , contentTest X.parse "markdown equation" xt2 xb2
        , contentTest X.parse "markdown items" items xitems
        , contentTest X.parse "markdown numbered" numbered xnumbered
        , contentTest X.parse "markdown code" code xcode
        ]


contentTest : (String -> Int -> List String -> List PrimitiveBlock) -> String -> String -> List PrimitiveBlock -> Test
contentTest parser desc sourceText blocks =
    test desc <|
        \_ -> Expect.equal (parser "x" 0 (String.lines sourceText)) blocks



-- TEST 1


lt1 =
    """This is a test

So is this
"""


lb1 =
    [ { args = []
      , body = [ "This is a test" ]
      , firstLine = "This is a test"
      , heading = Paragraph
      , indent = 0
      , meta =
            { error = Nothing
            , id = "x-0"
            , lineNumber = 1
            , messages = []
            , numberOfLines = 1
            , position = 0
            , sourceText = "This is a test"
            }
      , properties = Dict.fromList []
      }
    , { args = []
      , body = [ "So is this" ]
      , firstLine = "So is this"
      , heading = Paragraph
      , indent = 0
      , meta =
            { error = Nothing
            , id = "x-1"
            , lineNumber = 3
            , messages = []
            , numberOfLines = 1
            , position = 16
            , sourceText = "So is this"
            }
      , properties = Dict.fromList []
      }
    ]


lbb2 =
    [ { args = []
      , body = [ "This is a test" ]
      , firstLine = "This is a test"
      , heading = Paragraph
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-0"
            , lineNumber = 0
            , messages = []
            , numberOfLines = 3
            , position = 0
            , sourceText = "This is a test\nThis is a test\n"
            }
      , properties = Dict.fromList []
      }
    , { args = []
      , body = [ "So is this" ]
      , firstLine = "So is this"
      , heading = Paragraph
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-2"
            , lineNumber = 2
            , messages = []
            , numberOfLines = 3
            , position = 16
            , sourceText = "So is this\nSo is this\n"
            }
      , properties = Dict.fromList []
      }
    ]



-- TEST 2


lt2 =
    """
|| equation
\\begin{pmatrix}
    1 & 2 & 3 \\\\
    a & b & c
\\end{pmatrix}
"""


lb2 =
    [ { args = []
      , body = [ "\\begin{pmatrix}", "    1 & 2 & 3 \\\\", "    a & b & c", "\\end{pmatrix}" ]
      , firstLine = "|| equation"
      , heading = Verbatim "equation"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "x-0"
            , lineNumber = 2
            , messages = []
            , numberOfLines = 5
            , position = 1
            , sourceText = "|| equation\n\\begin{pmatrix}\n    1 & 2 & 3 \\\\\n    a & b & c\n\\end{pmatrix}"
            }
      , properties = Dict.fromList []
      }
    ]



-- TEST 3


lt3 =
    """
| Theorem
There are infinitely many primes.
"""


lb3 =
    [ { args = []
      , body = [ "There are infinitely many primes." ]
      , firstLine = "| Theorem"
      , heading = Ordinary "Theorem"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "x-0"
            , lineNumber = 2
            , messages = []
            , numberOfLines = 2
            , position = 1
            , sourceText = "| Theorem\nThere are infinitely many primes."
            }
      , properties = Dict.fromList []
      }
    ]



-- M TEST 2


mt2 =
    """
\\begin{equation}
\\begin{pmatrix}
    1 & 2 & 3 \\\\
    a & b & c
\\end{pmatrix}
\\end{equation}
"""


mb2 =
    [ { args = []
      , body = [ "\\begin{pmatrix}", "    1 & 2 & 3 \\\\", "    a & b & c", "\\end{pmatrix}" ]
      , firstLine = "\\begin{equation}"
      , heading = Verbatim "equation"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-1"
            , lineNumber = 1
            , messages = []
            , numberOfLines = 6
            , position = 0
            , sourceText = "\\begin{equation}\n\\begin{pmatrix}\n    1 & 2 & 3 \\\\\n    a & b & c\n\\end{pmatrix}\n\\end{equation}"
            }
      , properties = Dict.fromList []
      }
    ]


mt3 =
    """
\\begin{theorem}
There are infinitely many primes.
\\end{theorem}
"""


mb3 =
    [ { args = []
      , body = [ "There are infinitely many primes." ]
      , firstLine = "\\begin{theorem}"
      , heading = Ordinary "theorem"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-1"
            , lineNumber = 1
            , messages = []
            , numberOfLines = 3
            , position = 0
            , sourceText = "\\begin{theorem}\nThere are infinitely many primes.\n\\end{theorem}"
            }
      , properties = Dict.fromList []
      }
    ]



-- X TEST 2


xt2 =
    """
$$
a^2 + b^2` = c^2
"""


xb2 =
    [ { args = []
      , body = [ "a^2 + b^2` = c^2" ]
      , firstLine = "$$"
      , heading = Verbatim "math"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "x-0"
            , lineNumber = 2
            , messages = []
            , numberOfLines = 2
            , position = 1
            , sourceText = "$$\na^2 + b^2` = c^2"
            }
      , properties = Dict.fromList []
      }
    ]


items =
    """
- Apples
  and Oranges

- Pears
"""


litems =
    """
\\item Apples
  and Oranges
  
\\item Pears
"""


xitems =
    [ { args = []
      , body = [ "Apples", "  and Oranges" ]
      , firstLine = "- Apples"
      , heading = Ordinary "item"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "x-0"
            , lineNumber = 2
            , messages = []
            , numberOfLines = 2
            , position = 1
            , sourceText = "- Apples\n  and Oranges"
            }
      , properties = Dict.fromList [ ( "firstLine", "Apples" ) ]
      }
    , { args = []
      , body = [ "Pears" ]
      , firstLine = "- Pears"
      , heading = Ordinary "item"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "x-1"
            , lineNumber = 5
            , messages = []
            , numberOfLines = 1
            , position = 25
            , sourceText = "- Pears"
            }
      , properties = Dict.fromList [ ( "firstLine", "Pears" ) ]
      }
    ]


xitems2 =
    [ { args = []
      , body = [ "- Apples", "  and Oranges" ]
      , firstLine = "- Apples"
      , heading = Paragraph
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-1"
            , lineNumber = 1
            , messages = []
            , numberOfLines = 4
            , position = 0
            , sourceText = "- Apples\n- Apples\n  and Oranges\n"
            }
      , properties = Dict.fromList []
      }
    , { args = []
      , body = [ "- Pears" ]
      , firstLine = "- Pears"
      , heading = Paragraph
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-4"
            , lineNumber = 4
            , messages = []
            , numberOfLines = 3
            , position = 23
            , sourceText = "- Pears\n- Pears\n"
            }
      , properties = Dict.fromList []
      }
    ]


numbered =
    """
. Apples
  and Oranges

. Pears
"""


xnumbered_latex =
    [ { args = []
      , body = [ "Apples", "and Oranges", "" ]
      , firstLine = ". Apples"
      , heading = Ordinary "numbered"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-1"
            , lineNumber = 1
            , messages = []
            , numberOfLines = 5
            , position = 0
            , sourceText = ". Apples\nApples\nand Oranges\n\n"
            }
      , properties = Dict.fromList []
      }
    , { args = []
      , body = [ "Pears", "" ]
      , firstLine = ". Pears"
      , heading = Ordinary "numbered"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-4"
            , lineNumber = 4
            , messages = []
            , numberOfLines = 4
            , position = 23
            , sourceText = ". Pears\nPears\n\n"
            }
      , properties = Dict.fromList []
      }
    ]


xnumbered =
    [ { args = []
      , body = [ "Apples", "  and Oranges" ]
      , firstLine = ". Apples"
      , heading = Ordinary "numbered"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "x-0"
            , lineNumber = 2
            , messages = []
            , numberOfLines = 2
            , position = 1
            , sourceText = ". Apples\n  and Oranges"
            }
      , properties = Dict.fromList [ ( "firstLine", "Apples" ) ]
      }
    , { args = []
      , body = [ "Pears" ]
      , firstLine = ". Pears"
      , heading = Ordinary "numbered"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "x-1"
            , lineNumber = 5
            , messages = []
            , numberOfLines = 1
            , position = 25
            , sourceText = ". Pears"
            }
      , properties = Dict.fromList [ ( "firstLine", "Pears" ) ]
      }
    ]


code =
    """
```
yuuk = 1
bar = 2
foo = 3
```
"""


xcode =
    [ { args = []
      , body = [ "yuuk = 1", "bar = 2", "foo = 3" ]
      , firstLine = "```"
      , heading = Verbatim "code"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "x-0"
            , lineNumber = 2
            , messages = []
            , numberOfLines = 5
            , position = 1
            , sourceText = "```\nyuuk = 1\nbar = 2\nfoo = 3"
            }
      , properties = Dict.fromList []
      }
    ]


rendered_litems =
    [ { args = []
      , body = [ "Apples", "and Oranges", "" ]
      , firstLine = "\\item Apples"
      , heading = Ordinary "item"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-1"
            , lineNumber = 1
            , messages = []
            , numberOfLines = 5
            , position = 0
            , sourceText = "\\item Apples\nApples\nand Oranges\n\n"
            }
      , properties = Dict.fromList []
      }
    , { args = []
      , body = [ "Pears", "" ]
      , firstLine = "\\item Pears"
      , heading = Ordinary "item"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-4"
            , lineNumber = 4
            , messages = []
            , numberOfLines = 4
            , position = 29
            , sourceText = "\\item Pears\nPears\n\n"
            }
      , properties = Dict.fromList []
      }
    ]


rendered_items =
    [ { args = []
      , body = [ "Apples", "and Oranges", "" ]
      , firstLine = "- Apples"
      , heading = Ordinary "item"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-1"
            , lineNumber = 1
            , messages = []
            , numberOfLines = 5
            , position = 0
            , sourceText = "- Apples\nApples\nand Oranges\n\n"
            }
      , properties = Dict.fromList []
      }
    , { args = []
      , body = [ "Pears", "" ]
      , firstLine = "- Pears"
      , heading = Ordinary "item"
      , indent = 0
      , meta =
            { error = Nothing
            , id = "@-4"
            , lineNumber = 4
            , messages = []
            , numberOfLines = 4
            , position = 23
            , sourceText = "- Pears\nPears\n\n"
            }
      , properties = Dict.fromList []
      }
    ]
