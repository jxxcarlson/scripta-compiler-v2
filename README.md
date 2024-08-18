# Scripta Compiler

The Scripta compiler handles markup text in three languages, MicroLaTeX, Scientific Markdown, and Enclosure,
transforming source text into HTML. The output of the Scripta compiler is designed to work with [elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/).

Below is how you would render MicroLaTeX source text in a window 500 pixels wide.
The `lang` parameter can be set to `SMarkdown` or `Enclosure` to render text in those languages.

```elm
ScriptaV2.APISimple.compile
    { lang = MicroLaTex, width = 500 }  sourceText 
       |> Element.map Render
```
where  you have


```elm
type Msg
    = ...
    | Render MarkupMsg


```

and you also have

```elm
import ScriptaV2.Msg exposing (MarkupMsg)
import ScriptaV2.APISimple
import ScriptaV2.Language
```

See XX for a demo.  The source code for the demo is at XXX.

## Live Editing

If you need to render source text in a live editing environment, use

```elm
ScriptaV2.API.compileLive
    { defaultSettings | lang = MicroLaTex, width = 500 }
    counter
    selectedId 
    sourceText |> Element.map Render
```

Here `counter` is an integer that needs to be updated on each edit.  This is necessary to force 
re-rendering of the text. The `selectedId` can be set to the empty string if you wish.  It is used to synchronize the editor with the rendered text.
If you click on a rendered element, the editor will scroll to the corresponding source text and highlight it.

See XX for a demo.  The source code for the demo is at XXX.

