module Data.M exposing (text)


text1 =
    """
. AAA

. BBB

. CCC

. DDD

. EEE

. FFF

. GGG

"""


text =
    """

| title
Introduction

[tags jxxcarlson:type-theory-course-introduction]

| banner
[ilink Type Theory Course jxxcarlson:type-theory-course]

| contents

[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/5479f0db-9558-4549-137f-766759241b00/public]

| center
Type theory brings together programming, logic, and mathematics.
We outline some of its history, introducing notions that will be studied in detail in what follows.


| box
  Type theory brings together programming, logic, and mathematics.
We outline some of its history, introducing notions that will be studied in detail in what follows.


[hrule]

|| aligned
a &= x + y\\\\
b &= x - y\\\\
c &= a b \\\\
  &= (x + y)(x - y) \\\\
  & = x^2 - y^2

[hrule]

Here is some inline code: `a[0] = $1`.

Here is some Python code:

|| code
def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n - 1)


```
def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n - 1)
```


[hrule]




[large Groceries:]

- Bread

- Milk

- Coffee

[large Groceries:]

| list

. Bread

. Milk

. Coffee

[large More Groceries:]

| list

. Bread

. Milk

. Coffee

[hrule]

| section
Russell's paradox

The earliest type theories are due to the British philosopher
Bertrand Russell, who
introduced them in the early 1900s to deal with a paradox that he spotted in Frege's
attampt to formalize the foundations of mathematics: consider the
set $R$ of all sets which are not members of themselves:

|| equation
\\label{russell}
R = \\{ x\\ |\\ x \\not\\in x \\}

One asks: [i is $R$ a member of itself?]. One sees that if it is,
then it is not, and if it is not, then it is.

| section
Lambda Calculus

The next major develpment (1930s) was the American mathematician
Alonzo Church's invention of the lambda calculus, which he intended to use as a foundation for logic.  The lambda calculus
formalizes the notion of function and application of a function
to its arguments.  As such, it is a programming language, though
at the time there were no computers to run programs of any kind.
Fundamental to it are the notions of [term abstraction] and
[term application].  An expression like $\\lambda x. x + 1$
is an abstraction. It consists of a [term binder]  $\\lambda x$
and a body $x + 1$. We say that the variable $x$ is [term bound] to the body of the expression. An expression like $(\\lambda x. x +1) 2$ is an application.  Applications can be simplified, in this case by replacing every occurrence of the bound variable
in the body by the number 2.  We write the simplification process as

|| equation
(\\lambda x. x +1) 2 \\to 3

Thus an abstraction is an anonymous function.  Simplification can be repeated:



|| equation
(\\lambda x . 2x)(\\lambda x . x + 1)\\ 2 \\to (\\lambda x . 2x)\\ 3 \\to 6



The process stops at 6 because there is no rule to apply
to make further simplififcations.  A lambda expression that cannot be
simplified called a [term value], and the
process of finding that value for an arbitrary expression
is called [term evaluation].


Church was also interested in Hilbert's [term Entscsheidungsproblem]:
is there an algorithm which given a Diophantine equation as
input produces True of False as output: True if the equation
has a solution, False if it does not. A Diophantine equation
is a polynomial equation with integer coefficients for which
one seeks integer coefficients.  The conclusion was "no": there
is no such algorithm.  The lamdbda calculus gave a precise
notion of the notion of algorithm, and
it was via this calculus that Church settled the Entscheidungsproblem.

By curious coincidence,
the British mathematician Alan Turing was also studying the
the same problem. Contemporaneously with Church,
he found a solution, but via completely different means,
using what is now called a [term Turing machine].
A Turing machine executes the instructions of a stored
program stored on a fictional paper tape which also serves
as the machine's working memory.  While Turing's machine was an abstract mathematical
object, one he needed in order to formalize the notion of algorithm,
it had no physical embodiement since, once again, there were
no computers in those days.

The work of Church lays the theoretical foundation for
[term functional programming languages],
of which LISP (McCarthy, 1958)
is the avatar, as well as Agda, Haskell, ML, Elm, etc.  The work of Turing lays the foundation for [term imperative programming languages], of which FORTRAN (Backus, 1957) is the avatar.
Programming languages loosely related by a kind of evolutionry
tree with two great branches, the functional branch and the
imperative branch.

Returning to the lambda calculus, the Italian mathematician and computer scientist Corrado Böhm and his student Giuseppe "Pino" Cardone realized (1986) that the lambda calculus had a flaw somewhat similar to
Russell's paradox. To address this flaw, they invented the
SLTC (simply-typed lambda calculus). In the SLTC, every object
(variable, number, etc) has a type.  For example, the number
2 has integer type, a fact we write as $2 : \\text{Int}$.  The
function $\\lambda x . (x + 1)$ has the function type $\\text{Int} \\to \\text{Int}$, since it takes an integer as input and
produces an integer as output.  There are various rules
that govern types.  One says that if $f : A \\to B$ and $a : A$,
then the application $f\\, a$ has type $B$.


The SLTC outlaws certain lambda
expression which cannot be evaluated.  Consider, for example
the expression $\\Omega = \\lambda x . x x$.  Then we have the infinite chain of simplifications of

$$
\\Omega \\Omega \\to \\Omega \\Omega \\to \\Omega \\Omega \\to ...

A pure lambda calculus computer would never produce any
output if asked to evaluate $\\Omega\\Omega$.  It would "hang"
in the functional analogue of an infinite loop.  It turns
out to be impossible to assign a type to $\\Omega$.  For if it had
some type $t$, the $\\Omega\\Omega$ would have type $t\\; t$.
Since the left-hand $t$ is applied to $t$, it must have type
$t \\to a$ for some type $a$. That is, $t = t \\to a$. But
a lambda expression cannot belong to two different types.

The SLTC, which we will study in chapter 1, is commonly used today in the design of
functional programming languages.  For example, The Haskell compiler uses lambda calculus to represent functions and expressions as trees of lambda abstractions and applications. This representation, known as the abstract syntax tree (AST), is used to perform type checking and optimization, as well as to generate efficient machine code.

| section
Martin-Löf Type Theory

The main focus of these notes is the type theory
of the Swedish philospher-logician Per Martin-Löf (MLTT), formulated
in the late 1960s and early 1970s. Martin-Löf's original motivation was to develop a constructive alternative to classical mathematics, a program which goes back to the work of ... XXX ...  An important feature of MLTT is that it is
a formal system in which one can formulate (a) mathematical notions, e.g., natural number, prime number, and (b) logical
notions, e.g., proposition and proof.  The logic of MLTT
is more restrictive than classical logic in that it
does not admit the law of the excluded middle, but more
general in that quantification over arbitrary objects.
It is a kind of higher-order intuitionistic logic.
The things about which MLTT speaks are [term terms] and [term types].  For example, one can say $5 : \\mathbb{N}$, meaning
that $5$ is a term of the type $\\mathbb{N}$, the type of natural
numbers. In MLTT, this type is defined by the rules
of the form

$$
\\frac{A, B, C, ...}{Z}

The numerator is a list of hypotheses and the denominator
is the conclusion.  If the hypotheses are valid, then
so is the conclusion.  A rule of the form

$$
\\frac{}{\\text{ Z }}

which has no hypotheses is an [term axiom].  Here are the rules
defining the natural numbers:

$$
\\frac{}{\\mathbb{N} \\text{ Type}}


This rule is the [term introduction rule] for $\\mathbb{N}$.  Next we introduce the term zero:

$$
\\frac{}{0 : \\mathbb{N}}

and a way of manufacturing new numbers from old:

$$
\\frac{}{\\text{suc} : \\mathbb{N} \\to \\mathbb{N}}

There is also a rule defining matheamtical induction, so that we can prove things.  We will discuss it later, in XXX.

The denominators of the last two rules are introduction rules
for the [term constructors] $0$ and $suc$.  The only way to
contstruct natural numbers is via the constructors.  Thus
terms listed below are terms of $\\mathbb{N}$.  Moreover, [i any] term of $\\mathbb{N}$ has this form.

$$
0,\\ \\text{suc } 0,\\ \\text{suc }\\text{suc } 0,\\ \\text{suc }\\text{suc }\\text{suc } 0, ...

To define the operations of addition and multiplication,
we add more rules:

$$
\\frac{ a : \\mathbb{N},\\quad b : \\mathbb{N}}{a + b : \\mathbb{N}}

This is the introduction rule for addition. Next, we add
a rule for simplifying expressions in which we add 0:

$$
\\frac{ 0 + n}{ n }

and another rule in which the successor function appears:

$$
\\frac{ (\\text{suc } m) + n}{ \\text{suc } (m + n) }

| section
Propositions as types


| section
Homotopy Type Theory

We also give
a brief introduction to the ideas of [term Homotopy Type Theory].


[b Note.] Lectures and these lecture notes will be accompanied by reading assignments, beginning with [bibitem Andrej].




| section
Reading

Let's talk about the work of Russel (see [eqref russell]).

| bibitem Andrej
[link Logic in CS https://www.andrej.com/zapiski/ISRM-LOGRAC-2022/01-first-steps-with-agda.lagda.html]



| section 2
Supplementary Readings

| bibitem Loader
[i Termination of Lambda Calculus Computations.] This paper provides a detailed discussion of various methods for ensuring termination of lambda calculus computations, including the use of measure functions.


"""
