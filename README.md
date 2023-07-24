# Scripta Compiler V2

The Scripta compiler transforms source text written
in MiniLaTeX, L0, or XMarkdown into HTML.
For simple applications, use the one
of the two functions in the Scripta.API module.
the other modules are for more complex applications.


## No editing:

Use 

```elm
import Scripta.API exposing (compileString)

compileString : 
  Language 
  -> Int 
  -> String 
  -> List (Element MarkupMsg)
```

as in the following example:

```elm
import Scripta.API exposing (compileString)
import Scripta.Language exposing (MiniLaTeX)

compileString MiniLaTeX 0 "Hello, $a^2 + b^2 = c^2$!"
```

The markup language, specified by the first argument,
can be any one of MiniLaTeX, L0, or XMarkdown.

## Editing:

Use the function

```elm
compile : 
  Language 
  -> Int 
  -> Int -
  > String 
  -> List String 
  -> List (Element MarkupMsg)
```

as in 

```elm
import Scripta.API exposing (compile)
import Scripta.Language exposing (L0)

compile L0 500 model.counter "id-33" lines
```

Here "id-33" is the ID of a fragment of the rendered
text which is to be highlighted.