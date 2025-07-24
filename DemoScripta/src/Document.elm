module Document exposing (text)


text =
    """

| title
Example!!

| image figure:2 caption: Humming bird
rem


# Notes

- This is a demo of the [u Scripta Markup Language].  Compare source and rendered text to see how it works. Your document is rendered as you type.  There is no setup ... just have at it.

- You can't save documents right now, but you will be able to do that as soon as the full scripta app is released.

- Use the megaphone icon on the right to report bugs, ask questions, and make suggestions.  This an early alpha release of Scripta, so you [b will] find bugs. We love to hear about them.

- Note the use of our experimental  [u ergonomic TeX]: TeX without backslashes.

- Press ctrl-E to export your file to LaTeX.  This feature does not yet work with images, so for now you will have to delete or hide them with a [u hide] or
[u code] block.  A fix is on its way


# Examples

| mathmacros
secpder:  frac(partial^2 #1, partial #2^2)
nat:    mathbb N
reals: mathbb R
pder:  frac(partial #1, partial #2)
set:    \\{ #1 \\}
sett:   \\{ #1 \\ | \\ #2 \\}

Pythagoras said: $a^2 + b^2 = c^2$.


This will be on the test:

| equation
int_0^1 x^n dx = frac(1,n+1)

and so will this:


| equation
secpder(u,x) + secpder(u,y) + secpder(u,z) = frac(1,c^2) secpder(u,t))  qquad "Wave Equation"

Note:

| aligned
nat &= set("positive whole numbers and zero")\\\\
nat &= sett(n " is a whole number", n > 0)


| equation
\\begin{pmatrix}
  2 & 1 \\\\
  1 & 2
\\end{pmatrix}
\\begin{pmatrix}
  2 & 1 \\\\
  1 & 2
\\end{pmatrix}
=
\\begin{pmatrix}
  5 & 4 \\\\
  4 & 5
\\end{pmatrix}

| hide
 | image figure:1 caption: Humming bird
 https://www.realsimple.com/thmb/7xn0oIF6a9eJ-y_4OO5vN0lJhCg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/humming-bird-flowers-GettyImages-1271839175-b515cb4f06a34e66b084ba617995f00a.jpg
  """
