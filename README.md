The purpose of this package is to compile Scripta Markup
into Elm Html.  Below is a typical example. We first define
some Scripta source code as a string:

```
input = """
| title
Test Document

This is a [b very simple] test of the Scripta compiler.

| theorem
There are infinitely many prime numbers.

| equation
int_0^1 x^n dx = tfrac(1,n+1)
"""

Then we compile it into Elm Html:

```
import ScriptaV2.APISimple exposing (compile)
import ScriptaV2.Msg exposing (MarkupMsg)
import ScriptaV2.Types exposing (defaultCompilerParameters)

output = compile defaultCompilerParameters input
```
