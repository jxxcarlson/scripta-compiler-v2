# The Scripta Compiler V2


The Scripta compiler is a markup-to-html compiler
suitable for real-time applications such as online
editing and rendering.  See [Scripta.io](https://scripta.io).
Its modular design
enables it to accept any language that can be
parsed to a common AST which we describe in XX.  We demonstrate the 
feasibility of this idea by implementing parsers
for MicroLaTeX, XMarkdown, and L0.  The first two
are variants of LaTeX and Markdown respectively, while
the third has a simple Lisp-like syntax.

This is a rewrite-in-progress of the original compiler.
At the moment of this writing, we have a rough draft of the 
L0 parser and of the compiler back-end, that is, the 
renderer, which transforms the AST to Html.  There is
a second backend which transforms the AST to standard LaTeX.
It is used both for export and for generation of PDF versions
of the source text.

A notable feature of the parser is its robust handling of 
syntax errors, which are of course inevitable in the
editing process.  The goal is catch errors, discreetly note
them in the rendered text, carry on with out messing up the 
text following the error.
