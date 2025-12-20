module DataSci exposing (str)


str n =
    head ++ "\n\n" ++ String.repeat n (body ++ "\n\n")


head =
    """
| title
01 Basic Notions

[tags jxxcarlson:00-introduction]

|| mathmacros
\\newcommand{\\reals}{\\mathbb{R}}
\\newcommand{\\ba}{\\mathbf a}
\\newcommand{\\bu}{\\mathbf u}
\\newcommand{\\bv}{\\mathbf v}
\\newcommand{\\bw}{\\mathbf w}
\\newcommand{\\bx}{\\mathbf x}
\\newcommand{\\by}{\\mathbf y}
\\newcommand{\\sett}[2]{\\{\\  {#1} \\ |\\ {#2} \\ \\}}



[i The word dimension stems from the Latin word dīmensiō. It is derived from dīmetīrī, meaning "to measure out."
In data science, a vector in $n$-space is typically an ordered list of measurements $(v_1, v_2, \\ldots, v_n)$.]
"""


body =
    """
# Prologue

The goal of this chapter is to introduce the basic notions
of calculus and linear algebra, developing just enough
vocabulary to show some applications to data science and prepare
the way for more advanced work.  Among these applications are:

- gradient descent


- clustering algorithms

- finding good projections by principal component analysis (PCA).

Gradient descent is (among other things) part of the technology that makes it possible for neural networks to learn.
Clustering algorithms are used to find patterns in data, resolving
"clouds" of data points into subclouds of points that are related
to eachother. PCA is used to reduce
the dimension of large data sets so that computation with them becomes
feasible and
also to visualize them by projecting
data from $n$ dimensions to two or three.  PCA can also help to find
meaningful ways of describing the data.

# Calculus

Let's begin with calculus, the basic notions of which are the [i derivative] and the [i integral].  In this introductory chapter,
we will only talk about derivatives and integrals for functions
of one variable.  But it will be important for applications
to data science and machine learning to extend this
as soon as possible to functions of more
than one variable. We do this in the next chapter.

## Derivatives

The derivative of a function $f(x)$ is another function $f'(x)$ that
measures how fast $f(x)$ changes as $x$ changes.  The derivative
has a simple geometric definition:

| equation
f'(x) = \\text{slope of the tangent line  at $(x,f(x))$}

To understand this, look at the graph of
the function $f(x)$ in Figure 1 below. There you see
the tangent line $AB$ to the graph drawn through a point $P = (x,f(x))$. The slope of the tangent line is its [term rise] divided
by its [term run].  You can read these numbers off from the triangle $PQR$:

|| equation
f'(x) = \\frac{\\text{rise}}{\\text{run}} = \\frac{3.0}{4.5} = 0.67

The derivative = slope = rise/run is a measure of how rapidly $f(x)$
changes as $x$ increases. If the derivative is positive, as in
the figure below, $f(x)$ increases as $x$ increases.  If the derivative
is negative, $f(x)$ decreases as $x$ increases.


[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/fa46a52c-79cc-4679-d90f-8006c8eb2b00/public Figure 1. Derivative as slope width:350]

If we have a formula for a function, it is natural
to ask for a formula for its derivative. We will see how
to get such formulas in the next chapter.  There we will learn, for example, that the derivative of the quadratic function $f(x) = ax^2 + bx + x$ is the function $f'(x) = 2ax + b$.

| problem
Consider the graph of a function $f(x)$ below.  Calculate
the derivative of $f$ at  $x = 4, 6, 8$.  Do this by drawing little triangles and measuring the rise and run, as in the example above. (If you want, click on the image to open it in a new tab, then print it).

[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/183e307c-10c7-4333-37d2-d0c1e283cd00/public width:350]


## Differentiable functions

A function is [term differentiable] if its derivative exists for all
$x$ for which $f$ is defined.  The function pictured in Figure 1 above is differentiable, as is any polynomial function, e.g.,  $f(x) = x^2 + 2x +5$. On the other hand, the function whoe graph you see in the figure below
is not differentable at $x = 0$, the "point of the vee." The function
is the absolute value function $f(x) = |x|$. We will come back to it
in the next chapter, when we give a rigorous definition of the derivative.



[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/a2167390-f701-4fae-e3cc-62abe1036200/public width:300]



The slope of the graph above is $-1$ for $x < 0$ and is $+1$ for $x > 0$.
The abrupt change in the slope at $x = 0$ what makes the function non-differentiable there.




A twice differentiable function has the nice property that
as we move along its graph, its tangent line turns with no sudden jumps.


| problem
For what values of $x$ is the function pictured below not differentiable?
On which intervals is it convex?


[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/24ff5ec6-e668-418b-2138-c9231bb7a400/public width:300]


Unless otherwise specified, we will assume that all the functions we
use in these notes are [term twice differentiable].  That means that the derivative of $f$ exists
at every point where $f$ is defined, and so does the derivative of the derivative, the so-called [term second derivative] $f''(x)$.  All polynomials, exponentials, and products of exponentials  are twice differentiable.  In fact, they are [term infinitely differentiable]: you can calculate the derivative, the
derivative of the derivative, the derivative of the derivative of the derivative, and so on.


| problem
Consider the quadratic function $f(x) = ax^2 + bx + c$.  Its
derivative is $f'(x) = 2ax + b$.  What is its second derivative $f''(x)$?


## Increasing functions

We all have an intuitive
idea of what it means for a function to be increasing. For example, in Figure 1, the function $f$ is increasing on the interval $x > 3$ and is decreasing
on the interval $x < 3$.
An intuitive understanding is good, indeed valuable.  But we also need a formal definition:

| definition
A function $f$ is increasing on an interval $a < x < b$
if for all $x$ and $x'$ in the interval
 such that $x < x'$, we have $f(x) < f(x')$.


Loosely speaking, we say that $f$ is increasing on the interval when

| indent
[i $x'$ is bigger than $x$ implies that $f(x')$ is bigger than
$f(x)$.]




One of the most useful properties of the derivative is that
its [term sign] tells us whether the function is increasing or decreasing:

| theorem
If $f$ is a  twice differentiable function and if $f'(a) > 0$,
then $f(x)$ is increasing for all $x$  suffciently near to $x = a$.


Mathematicians' favorite name for a "small quantity" is the
Greek letter $\\epsilon$, pronounced [i epsilon].
"Sufficiently near" means that there is some number $\\epsilon > 0$ which
 such that $f(x)$ is increasing on the
interval $a - \\epsilon < x < a + \\epsilon$. The whole point of this
epsilon business is that without more information, we can't say
more about how big epsilon is.  In the case of the function of
Figure 1, we do have more inforamation, so we can take $\\epsilon = 2.5$.  The function
is increasing on the interval $3 < x < 8$.
"""
