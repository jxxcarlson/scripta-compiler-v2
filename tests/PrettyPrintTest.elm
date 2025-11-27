module PrettyPrintTest exposing (..)

import Expect
import Render.Pretty
import Scripta.PrimitiveBlock exposing (parse)
import ScriptaV2.Language
import Test exposing (..)


suite : Test
suite =
    describe "Scripta's Pretty printer"
        [ test "long text" <|
            \_ ->
                Render.Pretty.print ScriptaV2.Language.ScriptaLang sourceTextLong
                    |> Debug.log "@@OUTPUT"
                    |> String.length
                    |> Expect.equal 25774
        ]


sourceTextLong =
    """
 | title number-to-level:3
 Scripta Manual (TEST)
 
 [tags jxxcarlson:scripta-language-manual]
 
 | indent
 [i Sections 1—4 below give an overview of Scripta. 
 The remaining sections are organized by topic. Blocks are discussed in sections 5–11 and elements in sections 14 and onward.]
 
 Lorem ipsum dolor sit amet, 
 consectetur adipiscing elit. Proin rutrum vehicula 
 ligula ut 
 bibendum. Suspendisse 
 sodales cursus dui, ut euismod tellus. Pellentesque a 
 ligula vehicula, 
 facilisis arcu
 at, dignissim urna. Nullam convallis, dolor bibendum
 interdum euismod,
 ipsum est sodales est,
 eu vestibulum erat
 arcu iaculis eros.
 Aenean tempus neque
 non neque sollicitudin, at condimentum
 massa porttitor. In at magna a augue
 auctor dapibus in porttitor justo. Donec
 nec tellus ex. Nulla 
 viverra nunc et odio convallis, sed ornare ante placerat. Suspendisse ligula massa, dignissim id viverra at, fringilla ac eros.
 
 | section 1 level:1 section-type:markdown
  What Scripta.io does
 
 Scripta.io is a web app for writing, sharing, and publishing documents with words, images and mathematical formulas. Beautiful
 things, ike this:
 
 | equation
 \\frac{\\partial^2 u}{{\\partial x}^2}
   + 
 \\frac{\\partial^2 u}{{\\partial y}^2} 
   +
 \\frac{\\partial^2 u}{{\\partial z}^2}
   =
 \\frac{1}{c^2}
 \\frac{\\partial^2 u}{{\\partial t}^2}
 
 and this:
 
 [image 
 https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/f757b563-20dc-4ccd-24b5-f72940b8a400/public  caption:Humming bird]
 
 Click on the pen icon to see how the equation and the
 image were made.  
 
 Documents created with the Scripta.io app are written
 in the [i Scripta markup language] — similar in power
 to LaTeX, but more ergonomic. Mathematical formulas are 
 written directly in TeX. Scripta can handle ordinary 
 text, links, images, math, code, charts, etc. If you need
 hard copy or need to submit to a publisher, you can
 export your document to PDF or standard LaTeX.  Because Scripta accepts unicode so you can use emojis
 
 | indent
 ☀️☀️☀️
 
 and non-Latin alphabets, e.g., 
 
 | indent
 Πρῶτοι ἀριθμοὶ ἄπειροί εἰσιν 
 
 meaning that there are infinitely many prime numbers. Or you can say 
 
 | indent
 დო რე მი ფა სოლ, 
 
 whose meaning is left as a puzzle.
 
 [large Features] 
 
 . [b Real-time rendering:]           As you edit a document, the rendered version is updated as you type.                     In real time,           [u           instantaneosly]    , along
 with cross-references and the automatically generated table of contents.
 
 . [b Any device:]           The documents you produce are           [u           web pages]    , and
 so                     can be read on any device: phone, table, laptop, desktop, large monitor. 
 
 . [b Share]                                                                   a link to any document.                     Print it, publish it on any web page include Scripta.io, or email a link
 to a friend or colleague or to a class you are teaching.
 
 We appreciate feedback: suggestions, bug reports, etc.  Use the 
 [quote bullhorn] button on the right-hand border of this page. 
 
 | section 1 level:1 section-type:markdown
  The Scripta Language
 
 A Scripta document is built from just two
 things: [i blocks] and [i elements].  A block
 is a series of contiguous non-blank lines with
 at least one blank line above and at least one
 below.  A paragraph is a block.  There
 are also [i named blocks].  Here is an example, 
 an [i indent] block:
 
 | code
 | indent
 This text is indented.  [i Isn't that cool?]
 
 It looks like this when rendered:
 
 | indent
 This text is indented.                                                                   [i           Isn't that cool?]
 
 The text of the indent block consists of two elements:
 
 | numberedList firstLine:Some ordinary text:`This text is indented.` [//]
 
 
 The first element is a plain text element.  The second
 element is an [i italic] element. Elements can be nested:
 
 | code
 [red [i Red hot chili peppers.]]
 
 This renders as
 
 | indent
 [red [i           Red hot chili peppers.]]
 
 Nice, eh?
 
 | section 1 level:1 section-type:markdown
  Comparison with LaTeX
 
 LaTeX environments correspond to named Scripta blocks.
 
 | section 2 level:2 section-type:markdown
  Equations
 
 | equation
 \\int_0^1 x^n dx = \\frac{1}{n + 1}
 
 | section 3 level:3 section-type:markdown
  Scripta:
 
 | code
 | equation
 \\int_0^1 x^n dx = \\frac{1}{n + 1}
 
 | section 3 level:3 section-type:markdown
  LaTeX:
 
 | code
 \\begin{equation}
 \\int_0^1 x^n dx = \\frac{1}{n + 1}
 \\end{equation}
 
 In LaTeX, failure to write `\\end{equation}` is a syntax
 error. Because a Scripta block is terminated by a blank line,
 it is impossible to have errors of this kind.
 
 | section 2 level:2 section-type:markdown
  Theorems
 
 | theorem Pythagoras, circa 500 BC
 Let           $a$           and           $b$           be the legs of a right triangle with hypotenuse           $c$    .
 Then                                                                   $a^2 + b^2 = c^2$    .
 
 | section 3 level:3 section-type:markdown
  Scripta
 
 | code
 | theorem Pythagoras, circa 500 BC
 Let $a$ and $b$ be the legs of a right triangle with hypotenuse $c$.
 The  $a^2 + b^2 = c^2$.
 
 | section 3 level:3 section-type:markdown
  LaTeX
 
 | code
 \\begin{theorem}
 Let $a$ and $b$ be the legs of a right triangle with hypotenuse $c$.
 The  $a^2 + b^2 = c^2$.
 \\end{theorem}
 
 | section 2 level:2 section-type:markdown
  Section headings
 
 | section 3 level:3 section-type:markdown
  Numbering
 
 | section 3 level:3 section-type:markdown
  Scripta
 
 Section headings are as in Markdown, but 
 can be numbered automatically.  The default
 is to number sections three levels deep.
 To change the numbering, modify the document
 title.
 
 Here is the default:
 
 | code
 | title
 Evolution
 
 It produces sections as below
 
 | code
 The Tree of Life  
   
   # Bacteria            1. Bacteria
   
   ## Actinobacteria     1.1. Actinobacteria
   
   ## Cyanobacteria      1.2. Cyanobacteria
   
   ### About oxygen ...  1.2.1 About oxygen ...
   
   #### Remarks          Remarks
   
   ## Archaea            2. Archaea
   
   ## Eukaria            3. Eucaria
 
 The next title block numbers only top-level 
 sections
 
 | code
 | title number-to-level:1
 Evolution
 
 Use `number-to-level:0` to turn numbering off
 
 To start section number at 7, do this:
 
 | code
 | title first-section:7 
 Evolution
 
 | section 3 level:3 section-type:markdown
  LaTeX
 
 | code
   \\section{The Tree of Life}
   
   \\subsection{Bacteria}
   
   \\subsection{Archaea}
   
   \\subsection{Eukaria}
 
 As a general rule, Scripta is more ergonomic and concise than is LaTeX,
 even though both accomplish the same thing.
 
 | section 2 level:2 section-type:markdown
  Lists
 
 Lists, both itemized and numbered, take inspiration from
 Markdown.  Writing lists in Scripta is a it more ergomic
 than in LaTeX and also less error-prone.
 
 | section 3 level:3 section-type:markdown
  Itemized lists in Scripta
 -
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean nunc nunc, rutrum eu dolor vitae, tincidunt semper leo. 
 - Donec in purus facilisis, suscipit erat interdum, interdum dui. Proin id lorem lorem. Donec a purus eu turpis ullamcorper finibus ac ac ipsum. 
 - Nam aliquam, nibh at tincidunt ultricies, diam nulla pretium dui, in consectetur sapien dui vitae sapien. Nulla cursus venenatis fermentum. 
 - Aliquam pretium tellus eu mattis hendrerit. Curabitur nec dapibus odio.
 
 A list counts as a single block:
 
 | code
 - Lorem ipsum dolor sit amet, consectetur ...
 - Donec in purus facilisis, suscipit erat ...
 - Nam aliquam, nibh at tincidunt ultricies ...
 - Aliquam pretium tellus eu mattis hendrerit. ... 
 
 [red ^^ We haven't yet implemented nested lists, but
 that is coming.]
 
 | section 3 level:3 section-type:markdown
  Itemized Lists in LaTeX:
 
 | code
   \\begin{itemized}
   
   \\item Lorem ipsum dolor sit amet, consectetur ...
   
   \\item Donec in purus facilisis, suscipit erat ...
   
   \\item Nam aliquam, nibh at tincidunt ultricies ...
   
   \\item Aliquam pretium tellus eu mattis hendrerit. ... 
   
   \\end{itemized}
 
 Woe unto he who forgets or mistypes the closing tag
 `\\end{itemized}`.
 
 | section 3 level:3 section-type:markdown
  Numbered lists in Scripta
 
 Numbered lists are similar to Markdown but not the same:
 
 | numberedList firstLine:Lorem ipsum dolor sit amet, consectetur adipiscing elitAenean nunc nunc, rutrum eu dolor vitae, tincidunt semper leo.
 
 
 A numbered list also counts as a single block:
 
 | code
 . Lorem ipsum dolor sit amet, consectetur ...
 . Donec in purus facilisis, suscipit erat ...
 . Nam aliquam, nibh at tincidunt ultricies ...
 . Aliquam pretium tellus eu mattis hendrerit. ...
 
 [red ^^ We haven't yet implemented nested numbered lists.]
 
 | section 3 level:3 section-type:markdown
  Numbered Lists in LaTeX
 
 | code
   \\begin{numbered}
   
   \\item Lorem ipsum dolor sit amet, consectetur ...
   
   \\item Donec in purus facilisis, suscipit erat ...
   
   \\item Nam aliquam, nibh at tincidunt ultricies ...
   
   \\item Aliquam pretium tellus eu mattis hendrerit. ... 
   
   \\end{numbered}
 
 | section 1 level:1 section-type:markdown
  Examples
 
 In the text below, open the editor to see how
 images, links, etc. are made.  By comparing
 what you see in the left window (the editor)
 with what you see in the right window (the
 rendered text), you will see how to write
 your own documents.
 
 | section 2 level:2 section-type:markdown
  Hints
 
 When you bring up the editor (with the pen icon), you will see
 the editor window on the left and the rendered text window on the right.
 
 | item firstLine:Select something in the rendered text window. The corresponding
  firstLine:Select something in the rendered text window. The corresponding
  firstLine:Select something in the rendered text window.      The corresponding
 Select something in the rendered text window.                     The corresponding
 source text will be brouht into view and highlighted.
 
 | item firstLine:Select something in the editor and do ctrl-S. The corresponding
  firstLine:Select something in the editor and do ctrl-S. The corresponding
  firstLine:Select something in the editor and do ctrl-S.      The corresponding
 Select something in the editor and do ctrl-S.                     The corresponding
 rendered text will be brought into view and highlighted.
 
 If you do cmd-F in the editor, you will see a search panel at
 the bottom of the editor.  Click ESC in the editor 
 to hide the search panel.
 
 | section 2 level:2 section-type:markdown
  Links
 
 I read the [link newspaper https://nytimes.com]
 every morning.
 
 | section 2 level:2 section-type:markdown
  Images
 
 You can place images in your documents:
 
 | image caption:Humming bird
 https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/f757b563-20dc-4ccd-24b5-f72940b8a400/public 
 
 | section 2 level:2 section-type:markdown
  Lists
 
 | section 3 level:3 section-type:markdown
  Itemized list
 
 | itemList firstLine:Milk, bread, raspberry jam at grocery store.
 
 
 | section 3 level:3 section-type:markdown
  Numbered List
 
 | numberedList firstLine:Milk, bread, raspberry jam at grocery store.
 
 
 | section 2 level:2 section-type:markdown
  Math 
 
 We learned this formula in 
 high school: $a^2 + b^2 = c^2$.
 
 | equation
 \\label{integral}
 \\int_0^1 x^n dx = \\frac{1}{n + 1}
 
 | section 2 level:2 section-type:markdown
  Chemistry
 
 It is easy to write chemical formulas.  Here is the formula
 for glucose: $\\ce{C6H12O6}$.  (Note the use of `\\ce{...}` in 
 the source text.)
 
 This is fun! $a^2 + b^2 = c^2$.  Isn't it?!
 
 | section 2 level:2 section-type:markdown
  Code
 
 If you need to write code,
 you can do that too:
 
 | code python
   total = 0
   for x in range(1, 11):
       total += x**3
   
   print("Sum of cubes from 1 to 10:", total)
 
 | section 1 level:1 section-type:markdown
  The Editor
 
 | itemList firstLine:TAB and shift-TAB:indent, unindent
 
 
 | numberedList firstLine:TAB and shift-TAB:indent, unindent
 
 
 | section 2 level:2 section-type:markdown
  Synchronization
 
 | item Sync:Select rendered text. The corresponding source text firstLine:RL
  Sync:Select rendered text. The corresponding source text firstLine:RL
  firstLine:RL Sync: Select rendered text.      The corresponding source text
 RL Sync: Select rendered text.                     The corresponding source text
 will be scrolled into view and highlighted.                     Press ctrl-1 to
 deselect.
 
 | item Sync:Select source text and press ctrl-S. The corresponding rendered text firstLine:LR
  Sync:Select source text and press ctrl-S. The corresponding rendered text firstLine:LR
  firstLine:LR Sync:      Select source text and press ctrl-S. The corresponding rendered text
 LR Sync:                     Select source text and press ctrl-S. The corresponding rendered text
 will be scrolled into view and highlighted.
 
 | section 2 level:2 section-type:markdown
  Keyboard shortcuts
 
 Miscellaneous
 
 | itemList firstLine:TAB and shift-TAB:indent, unindent
 
 
 Search and Replace.  
 
 | itemList firstLine:cmd-F to open the search panel,
 
 
 Deleting things:
 
 | itemList firstLine:ctrl-D delete next character
 
 
 Adding thigs:
 
 | item firstLine:ctrl-O add new line
  firstLine:ctrl-O add new line
  firstLine:ctrl-O: add new line
 ctrl-O: add new line
 
 Moving around:
 
 | item firstLine:ctrl-A go to beginning of line
  firstLine:ctrl-A go to beginning of line
  firstLine:ctrl-A: go to beginning of line
 ctrl-A: go to beginning of line
 
 | section 2 level:2 section-type:markdown
  Notes
 
 | item TIP:] If you are working on a small screen and firstLine:[b
  TIP: [errorHighlight  extra ]?]  If you are working on a small screen and firstLine: [errorHighlight [b
 ] [errorHighlight ]  firstLine:  [b    TIP:]    If you are working on a small screen and
   [b    TIP:]           If you are working on a small screen and
 want to save your place in the rendered text
 when you open a document in the editor,
 select some rendered text, then open the editor.
 
 | item firstLine:Saving documents is automatic, done every few seconds
  firstLine:Saving documents is automatic, done every few seconds
  firstLine:Saving documents is automatic, done every few seconds
 Saving documents is automatic, done every few seconds
 if the user has made a change.
 
 | section 1 level:1 section-type:markdown
  System
 
 | section 2 level:2 section-type:markdown
  Signing up, in, and out
 
 When you sign in, your credentials remain valid for 30 days.
 This means that you can close the browser tab or window in 
 which Scripta is running, then open up Scripta any time before
 30 days and still be signed in.
 
 If you sign out, you will immediately be signed out of all 
 machines, everywhere.  Always sign out when you are finished
 working on a public machne.
 
 | section 2 level:2 section-type:markdown
  Sharing documents
 
 | itemList firstLine:links
 
 
 | section 1 level:1 section-type:markdown
  Graphics blocks
 
 | section 2 level:2 section-type:markdown
  Image
 
 | image caption:Allen's hummingbird figure:1 width:fill
 https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/f757b563-20dc-4ccd-24b5-f72940b8a400/public 
 
 How it is done:
 
 | code
 | image caption: Allen's hummingbird figure:1 width:fill
 https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/f757b563-20dc-4ccd-24b5-f72940b8a400/public 
 
 https://cdn.download.ams.birds.cornell.edu/api/v1/asset/633039124/1200
 
 All the [quote properties] are optional.  We can, for example,
 say
 
 | code
 | image
 https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/f757b563-20dc-4ccd-24b5-f72940b8a400/public 
 
 Options to try:
 
 | itemList firstLine:width
 
 
 | section 2 level:2 section-type:markdown
  SVG
 
 You can render SVG data as in the example below.  The syntax 
 follows this pattern:
 
 | code
 | svg
 <svg width="100" height="100">
    YOUR SVG CODE 
    />
 </svg>
 
 | svg
 <svg width="100" height="100">
    <circle 
       cx="50" cy="50" r="40" 
       stroke="green" stroke-width="1" fill="yellow" 
    />
    <circle 
        cx="50" cy="50" r="20" stroke="green"
        stroke-width="1" fill="palegreen" 
    />
 </svg>
 
 | section 2 level:2 section-type:markdown
  Line chart from CSV data
 
 | section 3 level:3 section-type:markdown
  xy Plot
 
 | chart
 caption: Simple x-y data
 ====
 0, 0
 0.25, 0.1
 0.5, 0.5
 0.75, 1.75
 0.8, 1.9
 0.9, 2.0
 1.1, 2.0
 1.2, 1.9
 1.25, 1.75
 1.5, 0.5
 1.75, 0.1
 2, 0
 
 Use 
 
 | code
 | chart
 caption: Simple x-y data
 0, 0
 0.25, 0.1
 0.5, 0.5
 ...
 
 See [b [ilink this article jxxcarlson:line-chart ]] for more information. 
 
 | section 3 level:3 section-type:markdown
  Time series
 
 | chart timeseries
 reverse:yes 
 dark:yes
 columns:2 
 lowest:3700 
 label:S&P  Index, 06/14/2021 to 06/10/2022
 ====
 Date,Close/Last,Volume,Open,High,Low
 06/10/2022,3900.86,--,3974.39,3974.39,3900.16
 06/09/2022,4017.82,--,4101.65,4119.1,4017.17
 06/08/2022,4115.77,--,4147.12,4160.14,4107.2
 06/07/2022,4160.68,--,4096.47,4164.86,4080.19
 06/06/2022,4121.43,--,4134.72,4168.78,4109.18
 06/03/2022,4108.54,--,4137.57,4142.67,4098.67
 06/02/2022,4176.82,--,4095.41,4177.51,4074.37
 06/01/2022,4101.23,--,4149.78,4166.54,4073.85
 05/31/2022,4132.15,--,4151.09,4168.34,4104.88
 05/27/2022,4158.24,--,4077.43,4158.49,4077.43
 05/26/2022,4057.84,--,3984.6,4075.14,3984.6
 05/25/2022,3978.73,--,3929.59,3999.33,3925.03
 05/24/2022,3941.48,--,3942.94,3955.68,3875.13
 05/23/2022,3973.75,--,3927.02,3981.88,3909.04
 05/20/2022,3901.36,--,3927.76,3943.42,3810.32
 05/19/2022,3900.79,--,3899,3945.96,3876.58
 05/18/2022,3923.68,--,4051.98,4051.98,3911.91
 05/17/2022,4088.85,--,4052,4090.72,4033.93
 05/16/2022,4008.01,--,4013.02,4046.46,3983.99
 05/13/2022,4023.89,--,3963.9,4038.88,3963.9
 05/12/2022,3930.08,--,3903.95,3964.8,3858.87
 05/11/2022,3935.18,--,3990.08,4049.09,3928.82
 05/10/2022,4001.05,--,4035.18,4068.82,3958.17
 05/09/2022,3991.24,--,4081.27,4081.27,3975.48
 05/06/2022,4123.34,--,4128.17,4157.69,4067.91
 05/05/2022,4146.87,--,4270.43,4270.43,4106.01
 05/04/2022,4300.17,--,4181.18,4307.66,4148.91
 05/03/2022,4175.48,--,4159.78,4200.1,4147.08
 05/02/2022,4155.38,--,4130.61,4169.81,4062.51
 04/29/2022,4131.93,--,4253.75,4269.68,4124.28
 04/28/2022,4287.5,--,4222.58,4308.45,4188.63
 04/27/2022,4183.96,--,4186.52,4240.71,4162.9
 04/26/2022,4175.2,--,4278.14,4278.14,4175.04
 04/25/2022,4296.12,--,4255.34,4299.02,4200.82
 04/22/2022,4271.78,--,4385.83,4385.83,4267.62
 04/21/2022,4393.66,--,4489.17,4512.94,4384.47
 04/20/2022,4459.45,--,4472.26,4488.29,4448.76
 04/19/2022,4462.21,--,4390.63,4471.03,4390.63
 04/18/2022,4391.69,--,4385.63,4410.31,4370.3
 04/14/2022,4392.59,--,4449.12,4460.46,4390.77
 04/13/2022,4446.59,--,4394.3,4453.92,4392.7
 04/12/2022,4397.45,--,4437.59,4471,4381.34
 04/11/2022,4412.53,--,4462.64,4464.35,4408.38
 04/08/2022,4488.28,--,4494.15,4520.41,4474.6
 04/07/2022,4500.21,--,4474.65,4521.16,4450.3
 04/06/2022,4481.15,--,4494.17,4503.94,4450.04
 04/05/2022,4525.12,--,4572.45,4593.45,4514.17
 04/04/2022,4582.64,--,4547.97,4583.5,4539.21
 04/01/2022,4545.86,--,4540.32,4548.7,4507.57
 03/31/2022,4530.41,--,4599.02,4603.07,4530.41
 03/30/2022,4602.45,--,4624.2,4627.77,4581.32
 03/29/2022,4631.6,--,4602.86,4637.3,4589.66
 03/28/2022,4575.52,--,4541.09,4575.65,4517.69
 03/25/2022,4543.06,--,4522.91,4546.03,4501.07
 03/24/2022,4520.16,--,4469.98,4520.58,4465.17
 03/23/2022,4456.24,--,4493.1,4501.07,4455.81
 03/22/2022,4511.61,--,4469.1,4522,4469.1
 03/21/2022,4461.18,--,4462.4,4481.75,4424.3
 03/18/2022,4463.12,--,4407.34,4465.4,4390.57
 03/17/2022,4411.67,--,4345.11,4412.67,4335.65
 03/16/2022,4357.86,--,4288.14,4358.9,4251.99
 03/15/2022,4262.45,--,4188.82,4271.05,4187.9
 03/14/2022,4173.11,--,4202.75,4247.57,4161.72
 03/11/2022,4204.31,--,4279.5,4291.01,4200.49
 03/10/2022,4259.52,--,4252.55,4268.28,4209.8
 03/09/2022,4277.88,--,4223.1,4299.4,4223.1
 03/08/2022,4170.7,--,4202.66,4276.94,4157.87
 03/07/2022,4201.09,--,4327.01,4327.01,4199.85
 03/04/2022,4328.87,--,4342.12,4342.12,4284.98
 03/03/2022,4363.49,--,4401.31,4416.78,4345.56
 03/02/2022,4386.54,--,4322.56,4401.48,4322.56
 03/01/2022,4306.26,--,4363.14,4378.45,4279.54
 02/28/2022,4373.94,--,4354.17,4388.84,4315.12
 02/25/2022,4384.65,--,4298.38,4385.34,4286.83
 02/24/2022,4288.7,--,4155.77,4294.73,4114.65
 02/23/2022,4225.5,--,4324.93,4341.51,4221.51
 02/22/2022,4304.76,--,4332.74,4362.12,4267.11
 02/18/2022,4348.87,--,4384.57,4394.6,4327.22
 02/17/2022,4380.26,--,4456.06,4456.06,4373.81
 02/16/2022,4475.01,--,4455.75,4489.55,4429.68
 02/15/2022,4471.07,--,4429.28,4472.77,4429.28
 02/14/2022,4401.67,--,4412.61,4426.22,4364.84
 02/11/2022,4418.64,--,4506.27,4526.33,4401.41
 02/10/2022,4504.08,--,4553.24,4588.92,4484.31
 02/09/2022,4587.18,--,4547,4590.03,4547
 02/08/2022,4521.54,--,4480.02,4531.32,4465.4
 02/07/2022,4483.87,--,4505.75,4521.86,4471.47
 02/04/2022,4500.53,--,4482.79,4539.66,4451.5
 02/03/2022,4477.44,--,4535.41,4542.88,4470.39
 02/02/2022,4589.38,--,4566.39,4595.31,4544.32
 02/01/2022,4546.54,--,4519.57,4550.49,4483.53
 01/31/2022,4515.55,--,4431.79,4516.89,4414.02
 01/28/2022,4431.85,--,4336.19,4432.72,4292.46
 01/27/2022,4326.51,--,4380.58,4428.74,4309.5
 01/26/2022,4349.93,--,4408.43,4453.23,4304.8
 01/25/2022,4356.45,--,4366.64,4411.01,4287.11
 01/24/2022,4410.13,--,4356.32,4417.35,4222.62
 01/21/2022,4397.94,--,4471.38,4494.52,4395.34
 01/20/2022,4482.73,--,4547.35,4602.11,4477.95
 01/19/2022,4532.76,--,4588.03,4611.55,4530.2
 01/18/2022,4577.11,--,4632.24,4632.24,4568.7
 01/14/2022,4662.85,--,4637.99,4665.13,4614.75
 01/13/2022,4659.03,--,4733.56,4744.13,4650.29
 01/12/2022,4726.35,--,4728.59,4748.83,4706.71
 01/11/2022,4713.07,--,4669.14,4714.13,4638.27
 01/10/2022,4670.29,--,4655.34,4673.02,4582.24
 01/07/2022,4677.03,--,4697.66,4707.95,4662.74
 01/06/2022,4696.05,--,4693.39,4725.01,4671.26
 01/05/2022,4700.58,--,4787.99,4797.7,4699.44
 01/04/2022,4793.54,--,4804.51,4818.62,4774.27
 01/03/2022,4796.56,--,4778.14,4796.64,4758.17
 12/31/2021,4766.18,--,4775.21,4786.83,4765.75
 12/30/2021,4778.73,--,4794.23,4808.93,4775.33
 12/29/2021,4793.06,--,4788.64,4804.06,4778.08
 12/28/2021,4786.35,--,4795.49,4807.02,4780.04
 12/27/2021,4791.19,--,4733.99,4791.49,4733.99
 12/23/2021,4725.79,--,4703.96,4740.74,4703.96
 12/22/2021,4696.56,--,4650.36,4697.67,4645.53
 12/21/2021,4649.23,--,4594.96,4651.14,4583.16
 12/20/2021,4568.02,--,4587.9,4587.9,4531.1
 12/17/2021,4620.64,--,4652.5,4666.7,4600.22
 12/16/2021,4668.67,--,4719.13,4731.99,4651.89
 12/15/2021,4709.85,--,4636.46,4712.6,4611.22
 12/14/2021,4634.09,--,4642.99,4660.47,4606.52
 12/13/2021,4668.97,--,4710.3,4710.3,4667.6
 12/10/2021,4712.02,--,4687.64,4713.57,4670.24
 12/09/2021,4667.45,--,4691,4695.26,4665.98
 12/08/2021,4701.21,--,4690.86,4705.06,4674.52
 12/07/2021,4686.75,--,4631.97,4694.04,4631.97
 12/06/2021,4591.67,--,4548.37,4612.6,4540.51
 12/03/2021,4538.43,--,4589.49,4608.03,4495.12
 12/02/2021,4577.1,--,4504.73,4595.46,4504.73
 12/01/2021,4513.04,--,4602.82,4652.94,4510.27
 11/30/2021,4567,--,4640.25,4646.02,4560
 11/29/2021,4655.27,--,4628.75,4672.95,4625.26
 11/26/2021,4594.62,--,4664.63,4664.63,4585.43
 11/24/2021,4701.46,--,4675.78,4702.87,4659.89
 11/23/2021,4690.7,--,4678.48,4699.39,4652.66
 11/22/2021,4682.94,--,4712,4743.83,4682.17
 11/19/2021,4697.96,--,4708.44,4717.75,4694.22
 11/18/2021,4704.54,--,4700.72,4708.8,4672.78
 11/17/2021,4688.67,--,4701.5,4701.5,4684.41
 11/16/2021,4700.9,--,4679.42,4714.95,4679.42
 11/15/2021,4682.8,--,4689.3,4697.42,4672.86
 11/12/2021,4682.85,--,4655.24,4688.47,4650.77
 11/11/2021,4649.27,--,4659.39,4664.55,4648.31
 11/10/2021,4646.71,--,4670.26,4684.85,4630.86
 11/09/2021,4685.25,--,4707.25,4708.53,4670.87
 11/08/2021,4701.7,--,4701.48,4714.92,4694.39
 11/05/2021,4697.53,--,4699.26,4718.5,4681.32
 11/04/2021,4680.06,--,4662.93,4683,4662.59
 11/03/2021,4660.57,--,4630.65,4663.46,4621.19
 11/02/2021,4630.65,--,4613.34,4635.15,4613.34
 11/01/2021,4613.67,--,4610.62,4620.34,4595.06
 10/29/2021,4605.38,--,4572.87,4608.08,4567.59
 10/28/2021,4596.42,--,4562.84,4597.55,4562.84
 10/27/2021,4551.68,--,4580.22,4584.57,4551.66
 10/26/2021,4574.79,--,4578.69,4598.53,4569.17
 10/25/2021,4566.48,--,4553.69,4572.62,4537.36
 10/22/2021,4544.9,--,4546.12,4559.67,4524
 10/21/2021,4549.78,--,4532.24,4551.44,4526.89
 10/20/2021,4536.19,--,4524.42,4540.87,4524.4
 10/19/2021,4519.63,--,4497.34,4520.4,4496.41
 10/18/2021,4486.46,--,4463.72,4488.75,4447.47
 10/15/2021,4471.37,--,4447.69,4475.82,4447.69
 10/14/2021,4438.26,--,4386.75,4439.73,4386.75
 10/13/2021,4363.8,--,4358.01,4372.87,4329.92
 10/12/2021,4350.65,--,4368.31,4374.89,4342.09
 10/11/2021,4361.19,--,4385.44,4415.88,4360.59
 10/08/2021,4391.34,--,4406.51,4412.02,4386.22
 10/07/2021,4399.76,--,4383.73,4429.97,4383.73
 10/06/2021,4363.55,--,4319.57,4365.57,4290.49
 10/05/2021,4345.72,--,4309.87,4369.23,4309.87
 10/04/2021,4300.46,--,4348.84,4355.51,4278.94
 10/01/2021,4357.04,--,4317.16,4375.19,4288.52
 09/30/2021,4307.54,--,4370.67,4382.55,4306.24
 09/29/2021,4359.46,--,4362.41,4385.57,4355.08
 09/28/2021,4352.63,--,4419.54,4419.54,4346.33
 09/27/2021,4443.11,--,4442.12,4457.3,4436.19
 09/24/2021,4455.48,--,4438.04,4463.12,4430.27
 09/23/2021,4448.98,--,4406.75,4465.4,4406.75
 09/22/2021,4395.64,--,4367.43,4416.75,4367.43
 09/21/2021,4354.19,--,4374.45,4394.87,4347.96
 09/20/2021,4357.73,--,4402.95,4402.95,4305.91
 09/17/2021,4432.99,--,4469.74,4471.52,4427.76
 09/16/2021,4473.75,--,4477.09,4485.87,4443.8
 09/15/2021,4480.7,--,4447.49,4486.87,4438.37
 09/14/2021,4443.05,--,4479.33,4485.68,4435.46
 09/13/2021,4468.73,--,4474.81,4492.99,4445.7
 09/10/2021,4458.58,--,4506.92,4520.47,4457.66
 09/09/2021,4493.28,--,4513.02,4529.9,4492.07
 09/08/2021,4514.07,--,4518.09,4521.79,4493.95
 09/07/2021,4520.03,--,4535.38,4535.38,4513
 09/03/2021,4535.43,--,4532.42,4541.45,4521.3
 09/02/2021,4536.95,--,4534.48,4545.85,4524.66
 09/01/2021,4524.09,--,4528.8,4537.11,4522.02
 08/31/2021,4522.68,--,4529.75,4531.39,4515.8
 08/30/2021,4528.79,--,4513.76,4537.36,4513.76
 08/27/2021,4509.37,--,4474.1,4513.33,4474.1
 08/26/2021,4470,--,4493.75,4495.9,4468.99
 08/25/2021,4496.19,--,4490.45,4501.71,4485.66
 08/24/2021,4486.23,--,4484.4,4492.81,4482.28
 08/23/2021,4479.53,--,4450.29,4489.88,4450.29
 08/20/2021,4441.67,--,4410.56,4444.35,4406.8
 08/19/2021,4405.8,--,4382.44,4418.61,4367.73
 08/18/2021,4400.27,--,4440.94,4454.32,4397.59
 08/17/2021,4448.08,--,4462.12,4462.12,4417.83
 08/16/2021,4479.71,--,4461.65,4480.26,4437.66
 08/13/2021,4468,--,4464.84,4468.37,4460.82
 08/12/2021,4460.83,--,4446.08,4461.77,4435.96
 08/11/2021,4447.7,--,4442.18,4449.44,4436.42
 08/10/2021,4436.75,--,4435.79,4445.21,4430.03
 08/09/2021,4432.35,--,4437.77,4439.39,4424.74
 08/06/2021,4436.52,--,4429.07,4440.82,4429.07
 08/05/2021,4429.1,--,4408.86,4429.76,4408.86
 08/04/2021,4402.66,--,4415.95,4416.17,4400.23
 08/03/2021,4423.15,--,4392.74,4423.79,4373
 08/02/2021,4387.16,--,4406.86,4422.18,4384.81
 07/30/2021,4395.26,--,4395.12,4412.25,4389.65
 07/29/2021,4419.15,--,4403.59,4429.97,4403.59
 07/28/2021,4400.64,--,4402.95,4415.47,4387.01
 07/27/2021,4401.46,--,4416.38,4416.38,4372.51
 07/26/2021,4422.3,--,4409.58,4422.73,4405.45
 07/23/2021,4411.79,--,4381.2,4415.18,4381.2
 07/22/2021,4367.48,--,4361.27,4369.87,4350.06
 07/21/2021,4358.69,--,4331.13,4359.7,4331.13
 07/20/2021,4323.06,--,4265.11,4336.84,4262.05
 07/19/2021,4258.49,--,4296.4,4296.4,4233.13
 07/16/2021,4327.16,--,4367.43,4375.09,4322.53
 07/15/2021,4360.03,--,4369.02,4369.02,4340.7
 07/14/2021,4374.3,--,4380.11,4393.68,4362.36
 07/13/2021,4369.21,--,4381.07,4392.37,4366.92
 07/12/2021,4384.63,--,4372.41,4386.68,4364.03
 07/09/2021,4369.55,--,4329.38,4371.6,4329.38
 07/08/2021,4320.82,--,4321.07,4330.88,4289.37
 07/07/2021,4358.13,--,4351.01,4361.88,4329.79
 07/06/2021,4343.54,--,4356.46,4356.46,4314.37
 07/02/2021,4352.34,--,4326.6,4355.43,4326.6
 07/01/2021,4319.94,--,4300.73,4320.66,4300.73
 06/30/2021,4297.5,--,4290.65,4302.43,4287.96
 06/29/2021,4291.8,--,4293.21,4300.52,4287.04
 06/28/2021,4290.61,--,4284.9,4292.14,4274.67
 06/25/2021,4280.7,--,4274.45,4286.12,4271.16
 06/24/2021,4266.49,--,4256.97,4271.28,4256.97
 06/23/2021,4241.84,--,4249.27,4256.6,4241.43
 06/22/2021,4246.44,--,4224.61,4255.84,4217.27
 06/21/2021,4224.79,--,4173.4,4226.24,4173.4
 06/18/2021,4166.45,--,4204.78,4204.78,4164.4
 06/17/2021,4221.86,--,4220.37,4232.29,4196.05
 06/16/2021,4223.7,--,4248.87,4251.89,4202.45
 06/15/2021,4246.59,--,4255.28,4257.16,4238.35
 06/14/2021,4255.15,--,4248.31,4255.59,4234.07
 
 Here an extract of the source text:
 
 | code
 | chart timeseries
 reverse:yes 
 dark:yes
 columns:2
 lowest:3700 
 label:S&P  Index, 06/14/2021 to 06/10/2022
 ====
 Date,Close/Last,Volume,Open,High,Low
 06/10/2022,3900.86,--,3974.39,3974.39,3900.16
 06/09/2022,4017.82,--,4101.65,4119.1,4017.17
 
 And [link here is the source https://www.nasdaq.com/market-activity/index/spx/historical] for the data.
 
 | section 2 level:2 section-type:markdown
  Quiver
 
 The site [link https://q.uiver.app] is a tool for constructing
 commutative diagrams like the one you see below.  Take a look at the 
 source text to see how this is done.
 
 | quiver caption:Natural Transformation width:400
 https://i.ibb.co/gPNzgFC/image.png
 ---
 % https://q.uiver.app/?q=WzAsNixbMCwwLCJYIl0sWzAsMiwiWSJdLFsyLDAsIkYoWCkiXSxbMiwyLCJGKFkpIl0sWzUsMCwiRyhYKSJdLFs1LDIsIkcoWSkiXSxbMCwxLCJmIiwyXSxbMiwzLCJGKGYpIiwyXSxbNCw1LCJHKGYpIl0sWzIsNCwiXFxldGFfWCJdLFszLDUsIlxcZXRhX1kiLDJdXQ==
 \\[\\begin{tikzcd}
 \tX && {F(X)} &&& {G(X)} \\\\
 \t\\\\
 \tY && {F(Y)} &&& {G(Y)}
 \t\\arrow["f"', from=1-1, to=3-1]
 \t\\arrow["{F(f)}"', from=1-3, to=3-3]
 \t\\arrow["{G(f)}", from=1-6, to=3-6]
 \t\\arrow["{\\eta_X}", from=1-3, to=1-6]
 \t\\arrow["{\\eta_Y}"', from=3-3, to=3-6]
 \\end{tikzcd}\\]
 
 | quiver
 https://d.img.vision/scripta/3471908172-image.png caption:Cureved Arrows width:400
 ---
 % https://q.uiver.app/?q=WzAsNixbMiwzLCJBIl0sWzQsMywiQiJdLFszLDIsIlUiXSxbMywwLCJYIl0sWzAsMywiUyJdLFs2LDMsIlQiXSxbMiwwLCJwIiwxXSxbMiwxLCJxIiwxXSxbMywwLCJmIiwxLHsiY3VydmUiOjJ9XSxbMywxLCJnIiwxLHsiY3VydmUiOi0yfV0sWzMsMiwibSIsMV0sWzAsNF0sWzEsNV0sWzMsNCwiZSIsMSx7ImN1cnZlIjozfV0sWzMsNSwiaCIsMSx7ImN1cnZlIjotM31dXQ==
 \\[\\begin{tikzcd}
 \t&&& X \\\\
 \t\\\\
 \t&&& U \\\\
 \tS && A && B && T
 \t\\arrow["p"{description}, from=3-4, to=4-3]
 \t\\arrow["q"{description}, from=3-4, to=4-5]
 \t\\arrow["f"{description}, curve={height=12pt}, from=1-4, to=4-3]
 \t\\arrow["g"{description}, curve={height=-12pt}, from=1-4, to=4-5]
 \t\\arrow["m"{description}, from=1-4, to=3-4]
 \t\\arrow[from=4-3, to=4-1]
 \t\\arrow[from=4-5, to=4-7]
 \t\\arrow["e"{description}, curve={height=18pt}, from=1-4, to=4-1]
 \t\\arrow["h"{description}, curve={height=-18pt}, from=1-4, to=4-7]
 \\end{tikzcd}\\]
 
 | section 1 level:1 section-type:markdown
  Text blocks
 
 | section 2 level:2 section-type:markdown
  Quotation
 
 | quotation title:Gettysburg Address
 Four score and seven years ago our fathers brought forth on this 
 continent a new nation, conceived in liberty, and dedicated to the
 proposition that all men are created equal.
                                                                                                                                                                                                                                        Now we are engaged in a great civil war, testing whether that nation,
 or any nation so conceived and so dedicated, can long endure. We are 
 met on a great battlefield of that war. We have come to dedicate a 
 portion of that field as a final resting place for those who here                     
 gave their lives that that nation might live. It is altogether                     
 fitting and proper that we should do this.
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     — Abraham Lincoln
 
 [red ^^ Not rendering as I would like when there is just a 
 single paragraph.]
 
 | section 2 level:2 section-type:markdown
  Verse
 
 | verse
   ’Twas brillig, and the slithy toves
   Did gyre and gimble in the wabe;
   All mimsy were the borogoves,
   And the mome raths outgrabe.
   
   “Beware the Jabberwock, my son!
   The jaws that bite, the claws that catch!
   Beware the Jubjub bird, and shun
   The frumious Bandersnatch!”
   
   He took his vorpal sword in hand;
   Long time the manxome foe he sought—
   So rested he by the Tumtum tree,
   And stood awhile in thought.
   
   And as in uffish thought he stood,
   The Jabberwock, with eyes of flame,
   Came whiffling through the tulgey wood,
   And burbled as it came!
   
   One, two! One, two! And through and through
   The vorpal blade went snicker-snack!
   He left it dead, and with its head
   He went galumphing back.
   
   “And hast thou slain the Jabberwock?
   Come to my arms, my beamish boy!
   O frabjous day! Callooh! Callay!”
   He chortled in his joy.
   
   ’Twas brillig, and the slithy toves
   Did gyre and gimble in the wabe;
   All mimsy were the borogoves,
   And the mome raths outgrabe.
 
 | section 2 level:2 section-type:markdown
  Box
 
 | box
 [b Lorem ipsum dolor sit amet]    , consectetur adipiscing elit. Curabitur blandit eleifend nibh eu aliquet. Sed sit amet nisl est. Nam sem tellus, vestibulum eu porttitor sed, maximus lacinia arcu. 
                                                                                                                                                                                                                                        Pythagoras said:    $a^2 + b^2 = c^2$  .
       | equation
       \\int_0^1 x^n dx = \\frac{1}{n+1}
                                                                                                                                                                                                                                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur blandit eleifend nibh eu aliquet. Sed sit amet nisl est. Nam sem tellus, vestibulum eu porttitor sed, maximus lacinia arcu. 
 
 | section 2 level:2 section-type:markdown
  Bibitem
 
 Use bibitem for bibliographic references.  To make a clickable
 link, use `[cite REFERENCE]`, e.g., `[cite NE]`. [red This reference
 is not clickable at the moment]
 
 | bibitem NE
 [link Newcomen Engine (Wikipedia) https://en.wikipedia.org/wiki/Newcomen_atmospheric_engine]
 
 [bibitem WA] [link Watt Engine (Wikipedia) https://en.wikipedia.org/wiki/Watt_steam_engine]
 
 [bibitem UH] [link High Pressure Steam Engines]
 
 [red ^^ We should use the standard block syntax.]
 
 | section 2 level:2 section-type:markdown
  Indent
 
 Line above
 
 | indent
 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur blandit eleifend nibh eu aliquet. Sed sit amet nisl est. Nam sem tellus, vestibulum eu porttitor sed, maximus lacinia arcu.
 
 Line below
 
 Nested indentend blocks
 
 | indent
 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur blandit eleifend nibh eu aliquet. Sed sit amet nisl est. Nam sem tellus, vestibulum eu porttitor sed, maximus lacinia arcu.
       | indent 12
                      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur blandit eleifend nibh eu aliquet. Sed sit amet nisl est. Nam sem tellus, vestibulum eu porttitor sed, maximus lacinia arcu.
 
 | section 2 level:2 section-type:markdown
  Options
 
 The indent block takes optional arguments as in the example below:
 
 | code
 | indent 24 color:red  style:italic title:Some Latin
 
 The first argument, 24, sets the indentation.  If it is not
 present, the identation defaults to 12 (pixels). The remaining
 arguments, if present, set properties.  The values for the `color`
 property are `red`, `blue`, and `gray`. The `style` property
 has one possible value, `italic`.
 
 The indentation argument, if present, always comes first. The
 other arguments may come in any order.  Here is the rendered text:
 
 | indent 24 color:red style:italic title:Some Latin
 Vivamus dignissim tristique enim, et fringilla enim vulputate at. Vestibulum ornare, odio vitae pharetra laoreet, elit nibh iaculis augue, sit amet sodales massa quam sit amet sem.
 
 | section 2 level:2 section-type:markdown
  Hiding text
 
 Sometimes you want to hide text:
 
 | code
 | hide
 Lorem ipsum dolor sit amet, consectetur adipiscing
 elit. Curabitur blandit eleifend nibh eu aliquet.
 Sed sit amet nisl est. Nam sem tellus, vestibulum 
 eu porttitor sed, maximus lacinia arcu.
 
 The Lorem ipsum text below is hidden.
 
 | hide
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur blandit eleifend nibh eu aliquet. Sed sit amet nisl est. Nam sem tellus, vestibulum eu porttitor sed, maximus lacinia arcu.
 
 | section 1 level:1 section-type:markdown
  Teaching
 
 | section 2 level:2 section-type:markdown
  Question/Answer Pairs
 
 Use the [b q] and [b a] blocks for creating quesition-answer,
 problem-solution pairs.
 
 | q Question
 How long ago did the last common ancestor of bird
 and man live?
 
 | a Answer
 320 to 340 million years ago. (It was a small reptile-like creature.)
 
 | q Problem
 Is 37 a prime number?
 
 | a Solution
 No. If 37 is not prime, then it has a prime factor.
 The square of this factor is less than 37. (Why?)
 The square of 6 is 36 and the square of 7 is 49.                     So if 
 37 has a prime factor, it is less than                     7.                     The primes
 less than 7 are 2, 3, 5.                     None of these divide 37.
 Therefore 37 is prime.
 
 | section 2 level:2 section-type:markdown
  Reveal blocks
 
 Use reveal blocks to reveal additional information.  Click on the 
 block below to see how this works. Click again to close the block.
 
 | reveal More about primes
 Around 300 BC, Euclid wrote down a proof that there are infinitely
 many primes numbers.           [link           Still more ... https://claude.ai/share/48336ea3-4a76-4a82-b90f-9662eae3fd6c]
 
 | section 2 level:2 section-type:markdown
  Desmos
 
 You can embed apps from [link https://desmos.com] by pasting the embed code into the body of an | iframe block:
 
 | code
 | iframe
 <iframe 
 ...
 </iframe>
 
 For more details, open the editor and compare.
 
 | iframe caption:Sine Waves
 <iframe src="https://www.desmos.com/calculator/2gfoptfwsr?embed" width="300" height="300" style="border: 1px solid #ccc" frameborder=0></iframe>
 
 | section 2 level:2 section-type:markdown
  Geogebra
 
 You can embed apps from [link geogebra.org "https://www.geogebra.org] by pasting the embed code into the
 body of an `| iframe` block:
 
 | iframe caption:Linkage
 <iframe scrolling="no" title="Linkage with non-90° joint" src="https://www.geogebra.org/material/iframe/id/FuCTAmZG/width/702/height/443/border/888888/sfsb/true/smb/false/stb/false/stbh/false/ai/false/asb/false/sri/true/rc/false/ld/false/sdz/true/ctl/false" width="702px" height="443px" style="border:0px;"> </iframe>
 
 Even though they are very small, you can lay with the sliders and also click on the pause button (lower left corner). Here is the [link original link https://www.geogebra.org/material/iframe/id/FuCTAmZG].
 
 | section 1 level:1 section-type:markdown
  Code
 
 | section 2 level:2 section-type:markdown
  Inline
 
 Use backticks for inline code: 
 
 | code
 `x = 1; y = 2`
 
 This text renders as `x = 1; y = 2`.
 
 | section 2 level:2 section-type:markdown
  Block
 
 Use code blocks for paragraphs of code.  The source text
 
 | code
 | code javascript
 function loadMhchem() {
     var mhChemJs = document.createElement('script');
     mhChemJs.type = 'text/javascript';
     mhChemJs.onload = function() {
       console.log("elm-katex: mhchem loaded");
     };
 
 renders as
 
 | code javascript
 function loadMhchem() {
     var mhChemJs = document.createElement('script');
     mhChemJs.type = 'text/javascript';
     mhChemJs.onload = function() {
       console.log("elm-katex: mhchem loaded");
     };
 
 The first argument of the code block determines the language
 for syntax highlighting.  Thus
 
 | code
 | code python
 for i = 1 to n:
   x = x + i
 print(x)
 
 renders as 
 
 | code python
 for i = 1 to n:
   x = x + i
 print(x)
 
 [b Multiparagraph code blocks] 
 
 | itemList firstLine:all content is indented. To indent all
 
 
 | code python
   x = 0
   y = 0
   
   for i = 1 to n:
     x = x + i
   print(x)
   
   for j = 1 to n:
     y = y + i*i
   print(y)
 
 [b Above:] Look at the source code to see how this is done.
 
 | section 1 level:1 section-type:markdown
  Mathematics
 
 | section 2 level:2 section-type:markdown
  Theorems
 
 Use theorem blocks to write theorems.  These are automatically
 numbered.
 
 | theorem
 There are infinitely many primes.
 
 If a theorem block consists of more than one paragraph, then
 you must follow the indentation rules. [red (XXX Explain or Reference)]
 
 | theorem
 If           $a$    ,           $b$    ,           $c$           are the sides of a right triangle,
 where           $c$           is the hypotenuse, then
       | math
       a^2 + b^2 = c^2
            [errorHighlight  [???? ]]  
                                                                                                                                                                                                                                        This is the Pythagorean theorem
 
 The following blocks act just like the theorem block:
 
 | code
 - axiom
 - construction
 - corollary
 - definition
 - example
 - exercise
 - lemma
 - note
 - principle
 - problem
 - proposition
 - question     -- ??
 - remark
 
 | section 2 level:2 section-type:markdown
  Equation
 
 | equation
 \\label{integral-on-test}
 \\int_0^1 x^n dx = \\frac{1}{n+1}
 
 | section 2 level:2 section-type:markdown
  Aligned
 
 | aligned
 a &= x + y
 b &= x - y
 ab &= (x + y)(x - y)
   &= x^2 - y^2
 
 | section 2 level:2 section-type:markdown
  Macros
 
 blah blah ...
 
 | section 2 level:2 section-type:markdown
  Quiver 
 
 Use quiver for commuative diagrams. Build and then insert [link https://q.uiver.app] images in Scripta like this:
 
 | code
 | quiver
 IMAGE URL
 ---
 QUIVER LATEX CODE
 
 Both image url and the LaTeX code are produced by q.uiver.app
 via a graphical user interface.
 
 [ilink More info ... jxxcarlson:manual-commutative-diagrams]
 
 [red ^^ ilink not working.]
 
 | quiver
 https://d.img.vision/scripta/3471908172-image.png Figure 1
 ---
 % https://q.uiver.app/?q=WzAsNixbMiwzLCJBIl0sWzQsMywiQiJdLFszLDIsIlUiXSxbMywwLCJYIl0sWzAsMywiUyJdLFs2LDMsIlQiXSxbMiwwLCJwIiwxXSxbMiwxLCJxIiwxXSxbMywwLCJmIiwxLHsiY3VydmUiOjJ9XSxbMywxLCJnIiwxLHsiY3VydmUiOi0yfV0sWzMsMiwibSIsMV0sWzAsNF0sWzEsNV0sWzMsNCwiZSIsMSx7ImN1cnZlIjozfV0sWzMsNSwiaCIsMSx7ImN1cnZlIjotM31dXQ==
 \\[\\begin{tikzcd}
 \t&&& X \\\\
 \t\\\\
 \t&&& U \\\\
 \tS && A && B && T
 \t\\arrow["p"{description}, from=3-4, to=4-3]
 \t\\arrow["q"{description}, from=3-4, to=4-5]
 \t\\arrow["f"{description}, curve={height=12pt}, from=1-4, to=4-3]
 \t\\arrow["g"{description}, curve={height=-12pt}, from=1-4, to=4-5]
 \t\\arrow["m"{description}, from=1-4, to=3-4]
 \t\\arrow[from=4-3, to=4-1]
 \t\\arrow[from=4-5, to=4-7]
 \t\\arrow["e"{description}, curve={height=18pt}, from=1-4, to=4-1]
 \t\\arrow["h"{description}, curve={height=-18pt}, from=1-4, to=4-7]
 \\end{tikzcd}\\]
 
 | section 2 level:2 section-type:markdown
  Tikz blocks
 
 In LaTeX, Tikz provides a way to do complex graphics, often
 through a tool that generates the LaTeX, e.g., [link mathcha.io https://mathcha.io].  Here is an example
 
 | tikz caption:Triangle width:300
 https://i.postimg.cc/jj2d9YNs/image.png
 ---
 \\tikzset{every picture/.style={line width=0.75pt}} %set default line width to 0.75pt        
 %
 \\begin{tikzpicture}[x=0.75pt,y=0.75pt,yscale=-1,xscale=1]
 %uncomment if require: \\path (0,300); %set diagram left start at 0, and has height of 300
 %
 %Straight Lines [id:da5728995010079783] 
 \\draw [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ]   (294,51) -- (294,124.29) ;
 \\draw [shift={(294,124.29)}, rotate = 90] [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ][fill={rgb, 255:red, 74; green, 144; blue, 226 }  ,fill opacity=1 ][line width=0.75]      (0, 0) circle [x radius= 3.35, y radius= 3.35]   ;
 \\draw [shift={(294,51)}, rotate = 90] [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ][fill={rgb, 255:red, 74; green, 144; blue, 226 }  ,fill opacity=1 ][line width=0.75]      (0, 0) circle [x radius= 3.35, y radius= 3.35]   ;
 %Straight Lines [id:da45604615155427286] 
 \\draw [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ]   (447.58,121) -- (289.5,121) ;
 \\draw [shift={(289.5,121)}, rotate = 180] [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ][fill={rgb, 255:red, 74; green, 144; blue, 226 }  ,fill opacity=1 ][line width=0.75]      (0, 0) circle [x radius= 3.35, y radius= 3.35]   ;
 \\draw [shift={(447.58,121)}, rotate = 180] [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ][fill={rgb, 255:red, 74; green, 144; blue, 226 }  ,fill opacity=1 ][line width=0.75]      (0, 0) circle [x radius= 3.35, y radius= 3.35]   ;
 %Straight Lines [id:da36278375740570823] 
 \\draw [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ]   (290.5,53) -- (447.5,121) ;
 \\draw [shift={(447.5,121)}, rotate = 23.42] [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ][fill={rgb, 255:red, 74; green, 144; blue, 226 }  ,fill opacity=1 ][line width=0.75]      (0, 0) circle [x radius= 3.35, y radius= 3.35]   ;
 \\draw [shift={(290.5,53)}, rotate = 23.42] [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ][fill={rgb, 255:red, 74; green, 144; blue, 226 }  ,fill opacity=1 ][line width=0.75]      (0, 0) circle [x radius= 3.35, y radius= 3.35]   ;
 %Straight Lines [id:da47493855001371243] 
 \\draw [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ]   (291.5,52) -- (341.5,124) ;
 \\draw [shift={(341.5,124)}, rotate = 55.22] [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ][fill={rgb, 255:red, 74; green, 144; blue, 226 }  ,fill opacity=1 ][line width=0.75]      (0, 0) circle [x radius= 3.35, y radius= 3.35]   ;
 \\draw [shift={(291.5,52)}, rotate = 55.22] [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ][fill={rgb, 255:red, 74; green, 144; blue, 226 }  ,fill opacity=1 ][line width=0.75]      (0, 0) circle [x radius= 3.35, y radius= 3.35]   ;
 %Shape: Arc [id:dp5434791661893299] 
 \\draw  [draw opacity=0][fill={rgb, 255:red, 74; green, 144; blue, 226 }  ,fill opacity=0.22 ] (331.81,108.37) .. controls (333.42,108.12) and (335.12,107.99) .. (336.87,108) .. controls (347.75,108.07) and (356.54,113.5) .. (356.5,120.12) .. controls (356.5,120.34) and (356.49,120.56) .. (356.47,120.78) -- (336.8,120) -- cycle ; \\draw  [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ] (331.81,108.37) .. controls (333.42,108.12) and (335.12,107.99) .. (336.87,108) .. controls (347.75,108.07) and (356.54,113.5) .. (356.5,120.12) .. controls (356.5,120.34) and (356.49,120.56) .. (356.47,120.78) ;
 %Straight Lines [id:da9645777961014412] 
 \\draw [color={rgb, 255:red, 74; green, 144; blue, 226 }  ,draw opacity=1 ]   (294,111) -- (307.04,111) -- (307.04,121.78) ;
 % Text Node
 \\draw (359,105) node  [font=\\footnotesize,color={rgb, 255:red, 74; green, 144; blue, 226 }  ,opacity=1 ,rotate=-333.43]  {$\\alpha $};
 % Text Node
 \\draw (284,40) node  [font=\\footnotesize,color={rgb, 255:red, 74; green, 144; blue, 226 }  ,opacity=1 ]  {$C$};
 % Text Node
 \\draw (293,135) node  [font=\\footnotesize,color={rgb, 255:red, 74; green, 144; blue, 226 }  ,opacity=1 ]  {$D$};
 % Text Node
 \\draw (340,135) node  [font=\\footnotesize,color={rgb, 255:red, 74; green, 144; blue, 226 }  ,opacity=1 ]  {$A$};
 % Text Node
 \\draw (449,133) node  [font=\\footnotesize,color={rgb, 255:red, 74; green, 144; blue, 226 }  ,opacity=1 ]  {$B$};
 \\end{tikzpicture}
 
 | section 2 level:2 section-type:markdown
  Computations
 
 Using the `compute` element, you can add calculations to your documents.
 This feature uses the [link mathjs package https://mathjs.org/].
 
 $\\sqrt{5} = $ [compute sqrt(5)] // `[compute sqrt(5)`
 
 $1 + 1/2 + 1/3 = $ [compute 1 + 1/2 + 1/3] // `[compute 1 + 1/2 + 1/3]`
 
 $\\log(2) \\approx 1 - 1/2 + 1/3 - 1/4 +
   1/5 - 1/6 + 1/7 - 1/8 + 1/9 - 1/10$
   
 [compute log(2) ] $\\approx$ [
   compute 1 - 1/2 + 1/3 - 1/4 +
   1/5 - 1/6 + 1/7 - 1/8 + 1/9 - 1/10]
 
 $\\exp(i\\pi)$ = [compute exp(i*pi)] 
 
 $\\sqrt{-1}$ = [compute sqrt(-1)] 
 
 $i^2$ = [compute sqrt(-1)*sqrt(-1)] 
 
 | section 1 level:1 section-type:markdown
  Chemistry 
 
 The formula for water is [chem H2O]. (Use `[chem H2O]`)
 
 The [link carbon dioxide reduction reaction  https://claude.ai/share/48336ea3-4a76-4a82-b90f-9662eae3fd6c] is 
 
 | chem
 CO2 + C -> 2 CO
 
 Use
 
 | code
 | chem
 CO2 + C -> 2 CO
 
 See the [link mhchem GitHub pages http://mhchem.github.io/MathJax-mhchem/] for more information.
 
 | section 1 level:1 section-type:markdown
  Data
 
 | section 2 level:2 section-type:markdown
  Table
 
 LaTeX-style tables:
 
 | code
 | table ccl
 1 & 2 & 3.123
 4 & 5 & 6.11
 
 | table ccl
 1 & 2 & 3.123
 4 & 5 & 6.11
 
 | code
 | table ccr
 $x$ & $y^2$ & $z^3$
 4 & 5 & 6.11
 
 | table ccr
 $x$ & $y^2$ & $z^3$
 4 & 5 & 6.11
 
 | section 2 level:2 section-type:markdown
  CSV tables
 
 Make a table from a CSV file:
 
 | section 3 level:3 section-type:markdown
  Example 1
 
 | code
 | csvtable
 A, B, C
 1, 2, 3
 4, 5, 6
 
 | csvtable
 A, B, C
 1, 2, 3
 4, 5, 6
 
 | section 3 level:3 section-type:markdown
  Example 2
 
 You can select which columns you wish to display, like this:
 
 | code
 | csvtable columns:1,2,3,4,8,9 title:Periodic Table
 <THE DATA>
 
 No row selectors yet.
 
 | hide
 columns:1,2,3,4,5,8,10,16,25,28
 
 | csvtable columns:1,2,3,4,8,9 title:Periodic Table
 N___,Element,Sym,Mass,Ns,NumberofProtons,NumberofElectrons,Per,Group,Phase,Radioactive,Natural,Metal,Nonmetal,Metalloid,Type,AtomicRadius,Electronegativity,FirstIonization,Density,MeltingPoint,BoilingPoint,NumberOfIsotopes,Discoverer,Year,SpecificHeat,NumberofShells,Val
 1,Hydrogen,H,1.007,0,1,1,1,1,gas,,yes,,yes,,Nonmetal,0.79,2.2,13.5984,8.99E-05,14.175,20.28,3,Cavendish,1766,14.304,1,1
 2,Helium,He,4.002,2,2,2,1,18,gas,,yes,,yes,,Noble Gas,0.49,,24.5874,1.79E-04,,4.22,5,Janssen,1868,5.193,1,
 3,Lithium,Li,6.941,4,3,3,2,1,solid,,yes,yes,,,Alkali Metal,2.1,0.98,5.3917,5.34E-01,453.85,1615,5,Arfvedson,1817,3.582,2,1
 4,Beryllium,Be,9.012,5,4,4,2,2,solid,,yes,yes,,,Alkaline Earth Metal,1.4,1.57,9.3227,1.85E+00,1560.15,2742,6,Vaulquelin,1798,1.825,2,2
 5,Boron,B,10.811,6,5,5,2,13,solid,,yes,,,yes,Metalloid,1.2,2.04,8.298,2.34E+00,2573.15,4200,6,Gay-Lussac,1808,1.026,2,3
 6,Carbon,C,12.011,6,6,6,2,14,solid,,yes,,yes,,Nonmetal,0.91,2.55,11.2603,2.27E+00,3948.15,4300,7,Prehistoric,,0.709,2,4
 7,Nitrogen,N,14.007,7,7,7,2,15,gas,,yes,,yes,,Nonmetal,0.75,3.04,14.5341,1.25E-03,63.29,77.36,8,Rutherford,1772,1.04,2,5
 8,Oxygen,O,15.999,8,8,8,2,16,gas,,yes,,yes,,Nonmetal,0.65,3.44,13.6181,1.43E-03,50.5,90.2,8,Priestley/Scheele,1774,0.918,2,6
 9,Fluorine,F,18.998,10,9,9,2,17,gas,,yes,,yes,,Halogen,0.57,3.98,17.4228,1.70E-03,53.63,85.03,6,Moissan,1886,0.824,2,7
 10,Neon,Ne,20.18,10,10,10,2,18,gas,,yes,,yes,,Noble Gas,0.51,,21.5645,9.00E-04,24.703,27.07,8,Ramsay and Travers,1898,1.03,2,8
 
 [ilink more info ... jxxcarlson:microlatex-display-data]
 
 | section 1 level:1 section-type:markdown
  Elements
 
 [mark 2d9a0cdf-55c8-4c80-ae56-e3c4bd81a799 [anchor Below is a list of Scripta elements, organized by category]].
 
 | item firstLine:Fonts
  firstLine:Fonts
  firstLine:Fonts
 Fonts
 
 | itemList b:] Render text in bold firstLine:[u bold,
 
 
 | item firstLine:Colors
  firstLine:Colors
  firstLine:Colors
 Colors
 
 | itemList firstLine:[u red:] [red The chili peppers are very hot.]
 
 
 | item firstLine:Boxes
  firstLine:Boxes
  firstLine:Boxes
 Boxes
 
 | itemList box:] [box] firstLine:[u
 
 
 | item firstLine:Structure
  firstLine:Structure
  firstLine:Structure
 Structure
 
 | itemList firstLine:[u subheading, sh:] A subheading (not numbered)
 
 
 | item firstLine:Links and references
  firstLine:Links and references
  firstLine:Links and references
 Links and references
 
 | itemList firstLine:[u link:]
 
 
 | item firstLine:Editing
  firstLine:Editing
  firstLine:Editing
 Editing
 
 | itemList firstLine:[u hide:] Hide text [hide You don't see it, but it is there]
 
 
 | item firstLine:Special
  firstLine:Special
  firstLine:Special
 Special
 
 | item compute:] `[compute sqrt(3)]` $\\to$ [compute sqrt(3)] firstLine:[u
  compute: [errorHighlight  extra ]?]   `[compute sqrt(3)]`   $\\to$   [compute  sqrt(3)]  firstLine: [errorHighlight [u
 ] [errorHighlight ]  firstLine:  [u    compute:]                 `[compute sqrt(3)]`        $\\to$                 [compute    sqrt(3)]  
   [u    compute:]                                                                                                                                                           `[compute sqrt(3)]`                                      $\\to$                                                                                                                                                           [compute           sqrt(3)]
 
 | hide
 - [u author:]
 - [u date:]
 - [u today:]
 - [u data:]
 - [u button:]
 - [u lambda:]
 - [u ulink:]
 - [u cslink:]
 
 | item numbered firstLine:[u label:]
  numbered firstLine: [u  label:] 
  firstLine:  [u    label:]  
   [u    label:]
 
 | itemList firstLine:[u table:]
 
 
 Special characters
 
 | itemList ds:] [dollarSign] firstLine:[u dollarSign, dollar,
 
 
 | itemList firstLine:[u var:]
 
 
 | section 1 level:1 section-type:markdown
  Experiments
 
 | mathmacros
 \\newcommand{\\nat}{\\mathbb{N}}
 \\newcommand{\\space}{\\mathbb{R}^{#1}}
 
 God gave us this $\\nat$;  all the rest is man's work.
 
 In data science, we work with $\\space{n}$ all the time.
 
 | section 1 level:1 section-type:markdown
  Stuff
 """
