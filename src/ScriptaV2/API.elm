module ScriptaV2.API exposing
    ( compileOutput
    , compileStringWithTitle
    , viewBodyOnly, viewTOC
    )

{-| ScriptaV2.API provides the core compilation interface for converting markup text
into renderable elm-ui Elements. This module supports three markup languages:
MicroLaTeX, SMarkdown/XMarkdown, and Enclosure/L0.


# Overview

The API follows a two-step workflow:

1.  **Compile** source text into a `CompilerOutput` using `compileOutput`
2.  **View** the compiled output using `viewBodyOnly` or `viewTOC`

This separation allows you to compile once and render different parts (body, table
of contents) independently, which is useful for building rich document viewers with
navigation panels.


# Compilation

@docs compileOutput


# Viewing

@docs viewBodyOnly, viewTOC


# Usage Example

    import ScriptaV2.API
    import ScriptaV2.Language exposing (Language(..))
    import ScriptaV2.Types exposing (defaultCompilerParameters)


    -- Configure compiler
    params =
        { defaultCompilerParameters
            | lang = MicroLaTeXLang
            , docWidth = 600
            , editCount = 0
        }

    -- Compile source text
    output =
        ScriptaV2.API.compileOutput params
            [ "\\section{Introduction}"
            , "This is a document with \\strong{bold} text."
            , ""
            , "\\subsection{Details}"
            , "More content here."
            ]

    -- Render the document body
    bodyElements =
        ScriptaV2.API.viewBodyOnly 600 output

    -- Render table of contents separately
    tocElements =
        ScriptaV2.API.viewTOC output


# Supported Languages

  - **MicroLaTeXLang** - LaTeX-like syntax with mathematical expressions via KaTeX
  - **SMarkdownLang** - Extended Markdown with scientific notation support
  - **EnclosureLang** - L0 language with bracket-based syntax
  - **MarkdownLang** - Standard Markdown (currently handled as SMarkdown)


# See Also

For a simpler API that handles both compilation and rendering in one step,
see `ScriptaV2.APISimple`.

-}

import Element exposing (Element)
import Element.Font
import ScriptaV2.Compiler
import ScriptaV2.Language exposing (Language(..))
import ScriptaV2.Msg
import ScriptaV2.Types


{-| Compile source text into a CompilerOutput structure.

This is the main compilation function that parses and processes markup text according
to the language specified in `CompilerParameters`. The output contains the rendered
body, optional banner, table of contents, and title, which can then be displayed
using the view functions.

    params =
        { defaultCompilerParameters
            | lang = MicroLaTeXLang
            , docWidth = 600
        }

    output =
        compileOutput params
            [ "\\title{My Document}"
            , "\\section{Introduction}"
            , "Content here."
            ]

The language field in CompilerParameters determines which parser to use:

  - MicroLaTeXLang → MicroLaTeX parser
  - SMarkdownLang/MarkdownLang → XMarkdown parser
  - EnclosureLang → L0/Enclosure parser

-}
compileOutput : ScriptaV2.Types.CompilerParameters -> List String -> ScriptaV2.Compiler.CompilerOutput
compileOutput params lines =
    ScriptaV2.Compiler.compile params lines


{-| Render only the body content from a CompilerOutput.

Takes a width parameter (in pixels) and returns a list of elm-ui Elements
representing the document body without the title or banner.

    bodyElements =
        viewBodyOnly 600 output

This is useful when you want to display the main content separately from other
document parts like the table of contents or title.

-}
viewBodyOnly : Int -> ScriptaV2.Compiler.CompilerOutput -> List (Element ScriptaV2.Msg.MarkupMsg)
viewBodyOnly =
    ScriptaV2.Compiler.viewBodyOnly


{-| Render the table of contents from a CompilerOutput.

Generates a navigable table of contents based on the document structure
(sections, subsections, etc.).

    tocElements =
        viewTOC output

The table of contents automatically includes links to document sections and
respects the document hierarchy.

-}
viewTOC : ScriptaV2.Compiler.CompilerOutput -> List (Element ScriptaV2.Msg.MarkupMsg)
viewTOC =
    ScriptaV2.Compiler.viewTOC


settings : { filter : ScriptaV2.Types.Filter, lang : ScriptaV2.Language.Language, width : Int }
settings =
    { filter = ScriptaV2.Types.NoFilter
    , lang = ScriptaV2.Language.MiniLaTeXLang
    , width = 800
    }


{-| -}
compile : ScriptaV2.Types.CompilerParameters -> List String -> List (Element ScriptaV2.Msg.MarkupMsg)
compile params lines =
    ScriptaV2.Compiler.compile params lines |> ScriptaV2.Compiler.view params.docWidth


{-| -}
compileString : ScriptaV2.Types.CompilerParameters -> String -> List (Element ScriptaV2.Msg.MarkupMsg)
compileString params str =
    ScriptaV2.Compiler.compile params (String.lines str) |> ScriptaV2.Compiler.view params.docWidth


compileStringWithTitle : String -> ScriptaV2.Types.CompilerParameters -> String -> List (Element ScriptaV2.Msg.MarkupMsg)
compileStringWithTitle title params str =
    ScriptaV2.Compiler.compile params (String.lines str)
        |> ScriptaV2.Compiler.viewBodyOnly params.docWidth
        |> (\x -> Element.el [ Element.height (Element.px 130), Element.Font.size 24, Element.paddingEach { left = 0, right = 0, top = 8, bottom = 24 } ] (Element.text title) :: x)
