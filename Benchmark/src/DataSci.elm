module DataSci exposing (str)


str =
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



[i The word dimension stems from the Latin word dīmensiō. It is derived from dīmetīrī, meaning “to measure out.” 
In data science, a vector in $n$-space is typically an ordered list of measurements $(v_1, v_2, \\ldots, v_n)$.]

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



## Minima and Maxima

In the last section we saw that if the derivative
of a twice differentiable function is positive at $x = a$
then it is increasing near $a$ and that if the derivative
is negative, then the function is decreasing near $x = a$. 
What happens if the derivative is zero?  There are 
three possibilities, all illustrated in the figure below:
 minimum,  maximum, or inflection point. In (a), the minimum
 value is an [term absolute minimum]: it is the smallest
 of all values of the function.  In (b), there are two minima.
 the ifrst one is an absolute minimum, the second is a [term local minimum]: it is the smallest of all nearby values.  In (c)
 there is an [term inflection point].  At an infection point a function turns from increasing to decreasing (or [i vice versa].)
 At all these so-called [term critical points], the derivative vanishes.  [i Geometrically,
 thai means that the tangent line is horizontal.]


[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/b1ce5ac8-7ce6-4db1-80b8-6a38af9f2200/public]

There is something else that we can read from these graphs.
In (a), the case of an absolute minimum, the graph is convex 
and the second derivative is positive.  In (b) the fuction is
convex near the two local minima.  In (c) the second derivative
is zero at the inflection point.  What can you say about the 
graph of (b) at the maxiumum?

[b Example Problem]

Let's do an example.
Suppose that you have a piece of wire $L$
units long.  You want to bend it into a rectangle that
encloses the largest possible area.  A rectangle has
a width $w$ and and a height $h$.  We know that 
$L = 2w + 2h$ and that the area is $A = wh$.  It looks
like we have a minimization problem for a function $A(w,h)$
of two variables.  But we can solve for one of the
variables in terms of the other using the first equation:
$h = L/2 - w$. Substituting into the formula for the 
area, we obtain $A = wL/2 - w^2$.  To find the maximum
area, we compute the derivative and set it to zero.  Using the
formula for the derivative of a quadratic function (section [ref derivatives]), we have $A'(w) = L/2 - 2w$. Solving the equation 
$A'(w) = 0$, we obtain $w = L/4$.  Therefore $h = L/4$, as well, and the shape in question is a square.


## Second derivative

Remember that we are working in the context of functions that are twice differentiable:
wherever the function $f(x)$ is defined, so is its derivative, and also the derivative
of the derivative, or [term second derivative], the second derivative
as $f''(x)$.  

What does the second derivative tell us? Consider a function such that $f''(x)$ is positive for all $x$ in 
an interval $a \\le x \\le b$. According to the discussion of section [ref increasing-functions], this means the first derivative is increasing.  To say that the
first derivative is increasing is to say that the slope of the tangent line
is increasing as we travel from left to right.  That is, it is turning up.  Therefore graph is curved upwards, as in the figure below. (Notice how the slope of tangent line 2 is bigger than the slope of tangent line 1, and  
he slope of tangent line 3 is bigger than the slope of tangent line 2.)

[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/35feb608-562e-492b-f51c-be8533740000/public width:300]



Function with positive second derivative are [term convex] or (very roughly) "bowl-shaped."  The technical defintion is that the line drawn between
points $A$ and $B$ of the graph lies above the graph between $A$ and $B$,
as in the figure below.  The line joining $A$ to $B$ is the [term secant line].  The term comes from the Latin [i secare], "to cut."

[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/212555fa-12d0-4616-3613-6aef577f8900/public width:300]

 Our example suggests (but does not prove) the following result:

| theorem
A twice-differentiable function for which the second derivative is positive on an interval $a < x < b$ is convex on that interval.


Consider once again a quadratic function $f(x) = ax^2 + b + c$.  Its derivative
is $f'(x) = 2ax + b$ and its second derivative is  $f''(x) = 2a$.  Thererfore 
$f(x)$ is a convex function if and only if $a > 0$.


## Gradient descent

One of the main uses of the derivative in data science
is [term optimization]: finding the minimum (or maximum) values of functions.  According
to our discussion of minima and maxima in section [ref minima-and-maxima],
one way to do this is to solve the equation $f'(x) = 0$.  Unfortunately,
being able to compute the derivative doesn't mean it is easy to solve
the equation $f'(x) = 0$.  It gets worse for functions of more than one variable where we need to solve systems of equations to find
the critical points.  What is needed instead is a way to 
find good [term approximations] of the minima without having to solve equations for them.
We will describe such a method here for functions of one variable. As we shall see in the next chapter, the
method works perfectly well for functions
of many variables. 

The method is called [term gradient descent].  The idea is as follows.  Start
at some point $x_0$ where the function has value $y_0 = f(x_0)$.  Think of
$x_0$ as giving the location of an approximate minimum value $y_0$.  Our immediate
goal is to find a somewhat better approximation by moving a certain distance
to the left or right.  But which direction to choose?  The derivative $f'(x_0)$
will tell us which way.  We move to the
left if $f'(x_0)$ is positive and move to the right if $f'(x_0)$ is negative. If we do that, the value of $f$ decreases, decreasing
the distance to the minimum.
We also need to decide how far to move.  For this we choose a number $\\eta > 0$, 
the [term learning rate], and set 

|| equation
x_1 = x_0 - \\eta f'(x_0)

Read this equation as: [i compute $x_1$ by moving an amount $dx = \\eta|f'(x_0)|$ from 
$x_0$ in the direction in which $f$ is decreasing.] Given an approximation to the location of the minimum $x_n$, we can always improve it by computing

|| equation
x_{n+1} = x_n - \\eta f'(x_n)

Very good!  We know how to improve the approximation, but
how do we know when to stop? One answer is to stop when successive approximations
differ by less than some prescribed tolerance $\\epsilon > 0$:

| indent
Stop if $|x_{n+1} - x_n| < \\epsilon$

But it may happen that the quantity $|x_{n+1} - x_n|$ never gets small enough, or it may happen that we simply run out patience.  
Therefore we amend the rule:

| indent
Stop if $|x_{n+1} - x_n| < \\epsilon$ or if $n > \\text{max\\_iterations}$

To see how this works, let's compute the sequence $x_0, x_1, x_2, \\ldots$ either by hand, or (better) using
a computer program. We will do this for the function $f(x) = x^2$.
Of course, we already know the answer: the minimum value is $y = 0$,
which occurs at $x = 0$.  By running a known case, we can tell
whether or not the algorithm works. Let's take the initial value to be $x_0 = 2$, the maximumn number
of iterations $n$ to be 1000, with a tolerance of $0.003$.
Below is  the result of running  a small Python program (see below) to do the computation.   The last column
displays the change in $x$, $\\Delta x = x_{n+1} - x_n$:

|| datatable
n, x, f'(x), Δx
0, 2.0000, 4.0000, -1.2000
1, 0.8000, 1.6000, -0.4800
2, 0.3200, 0.6400, -0.1920
3, 0.1280, 0.2560, -0.0768
4, 0.0512, 0.1024, -0.0307
5, 0.0205, 0.0410, -0.0123
6, 0.0082, 0.0164, -0.0049
7, 0.0033, 0.0066, -0.0020
8, 0.0013, 0.0026, -0.0008

Below is a visual representation of what is going on.  In 
the left panel the red dots sliding down from $(2.0, 4.0)$
give the values $(x_n, f(x_n))$.  In the right panel you see $x_n$
plotted against $n$.

[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/0e486899-d6c7-40a6-25df-46d48af11800/public  Gradient Descent]

Here is the Python program that produced the table  Run it from the command line with `python gradient-descent-simplest.py`.

[vspace 15]

|| code
  # file: gradient-descent-simplest.py
  
  import numpy as np
  
  def f(x):
      return x**2
  
  def df(x):
      return 2*x
  
  # Initial conditions
  x = 2.0              # Starting point
  learning_rate = 0.1  # Step size
  n_iterations = 20    # Number of iterations
  
  # Print header
  print("n      x_n    f(x_n)   Δx_n")
  print("-" * 25)
  
  x_prev = x
  print(f"0   {x:.3f}        ---")
  
  # Gradient descent
  for n in range(1, n_iterations + 1):
      x_new = x - learning_rate * df(x)
      delta = x_new - x
      print(f"{n:2d}   {x_new:.3f}   {f(x_new):.3f}   {delta:.3f}")
      x = x_new

[vspace 20]

| problem
Try a few steps of the gradient descent method with 
$f(x) = x^2 + x$.  Is it producing a sequence $\\{ x_n \\}$
that converges rapidly to the minimum?

The gradient descent method does not always work.  There are, however, theorems
that give conditions under which it does. Here is one:

| theorem
Suppose that the function  $f$  is convex and twice continuously differentiable.  Suppose also that $m < f''(x) < L$, where $m > 0$. 
Then gradient descent with step size
satisfying $0 < \\alpha < 2/L$ converges to the unique global minimum of $f$.

| remark
Often times we work with functions for which the derivative
is difficult to or impossible to compute.  In those cases
we can use an approximate derivative.  Consider the secant line
$AB$ in the figure below.  Its rise is

|| equation
\\Delta f(x) = f(x + h/2) - f(x -h/2)

and its run in $h$.  Therefore its slope is

|| equation
\\text{slope of secant $AB$} = \\frac{\\Delta f(x)}{h} = \\frac{f(x + h/2) - f(x -h/2)}{h}

Consider also the tangent line to the graph a $C$.  Then

|| equation
f'(x) = \\text{slope of the tangent line at $C$.}

From the graph, it appears that the slope of the secant line $AB$
differs only a little from the slope of the tangent line at $C$

The idea  is this.  If we can compute values of $f$, we 
can also compute $\\Delta f(x)$.  Now look at the figure below.
$\\Delta f(x)$ is the slope of the secant line $AB$.  When $h$
is small, the slope of the secant line is a good approximation to the  slope of that tangent line at $C$.  The smaller $h$ is,
the better the approximation.  This is also the idea behind
the formal definition of the derivative.


[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/34f1934a-ab11-484e-edd0-36215c010f00/public width:350]

| remark
We are at the very beginning of our mathematiics + data science
journey.  But here is something to note: even though you
may not yet be able to compute derivatives, you know
[b what] they are, you know something about [b how] they are
used, and you can [b understand] theorems that speak to when
common algorithms can be expected to provide good answers.
Lastly, you have seen how one such algorithm can be [b implemented]
in code.
Onward!

## Integrals

In a word, [i integral is area].  To be precise, consider a
function $f(x)$ that takes positive values,
as in the Figure below.  Consider the region $R$ which you see 
there.  It is defined by two inequalities.  A point $(x,y)$ 
is in $R$ if

|| aligned
0 \\le\\ & x \\le b \\
0 \\le\\ & y \\le f(x) \\

For the integral, look at Figure 2.  The [term definite integral] of $f$ from $a$ to $b$ is the area of the region $R$. We can decode
what we see in the figure by a pair of inequalities:

|| equation
R  = \\sett{(x,y)}{a \\le x \\le b,\\quad 0 \\le y \\le f(x)}

Like the derivative, the integral has a special notation:

|| equation
\\text{area}(R) = \\int_a^b f(x) dx


We don't yet have the tools for computing integrals of functions
given to us by a formula, but we can make do with a graphical
method for the moment, just as we did for the derivative.  Assuming that we have arranged our graph so that each little square is one unit by one unit
of measure, we can count squares and estimate partial squares in order to estimate the area. 


For example, just to the right of the line $x = a$, we
see that there are three squares which lie entirely in $R$ and just a small
part — maybe one tenth — of a fourth square.  Our estimate for the area of the part of 
$R$ satisfying $2 \\le x \\le 3$ is therefore $3.1$ We do this for the rest of $R$ and add up the reults to get 

|| equation
\\int_a^b f(x)dx \\approx 20.7.

[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/eea257c6-10f9-4db9-20cb-f93a7d727a00/public Figure 2. Integral as area width:350]

| remark
You might ask: can we get more accurate answers? One way to do 
counter squares and partial squares as beforem but to use 
a smaller grid of squares.  As the squares get smaller
and smaller, the approximation gets better and better.  We
say that the true integral is the [b [term limit]] of the approximate
integrals as the grid size gets smaller and smaller.  Let
$R_n$ be region made of grid squares and partial squares.
Suppose the maximum size of a square is $1/n$. Then

|| equation 
\\int_a^b f(x) dx = \\lim_{n \\to 0} \\text{area}(R_n)

This idea of appromation and limit occurs throughout calculus.
We will use it in the next chapter both to define the 
derivative and to define definite integrals.

## Probability distributions

One of the main uses of the integral in data science is in probability 
theory. We will talk abou this much later, but for now consider the following problem.  An astronomer observes a star which for which the expected
position at a given time, date, and place can be calculated. But the star
always appears displaced from the expected position by an angle $\\Delta \\theta_x$
along the horizontal axis and $\\Delta \\theta_y$ along the vertical axis.  Lerge
deviations from what is expected are less common than small ones.  In fact,
these deviations follow a so-called [term normal] or [term Gaussian]
distribution.  Here is what this means.  There is a function $p(\\theta)$
called a [term probability distribution].  It is a positive (non-negative) function satisfying

|| equation
\\int_{-\\infty}^\\infty p(\\theta) d\\theta = 1

The probability that the error $\\Delta \\theta$ is less than $b$ but greater than $a$ is the integral of the probability distribution on this interval:

|| equation
P(a \\le \\Delta\\theta_x \\le b) = \\int_a^b p(\\theta) d\\theta


[image https://media.geeksforgeeks.org/wp-content/uploads/20230828135632/Probability-Density-Function.png width:300]

The German mathematician Carl Friederich Gauss discovered the 
probability distribution which governs these angular errors.  This distribtuion has the general form

|| equation
p(x) = \\frac{1}{\\sqrt{2\\pi\\sigma^2}}\\exp\\left(-\\frac{(x - \\mu)^2}{2\\sigma^2}\\right)


Here $\\exp(x)$ is $e^x$, $\\mu$ is the [term mean] of the distribution and $\\sigma$ is
the [term standard deviation].  The mean tells us where the distribution 
is centered.  The standard deviation tells us to what extent the distribution is spread out. This formula just gven defines the [term standard] or [term normal] distribution. It is one the most commonly
used distribitions, but beware: it does not apply to everything.


[image https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Standard_deviation_diagram.svg/640px-Standard_deviation_diagram.svg.png width:400]


## Summary

Derivative is slope.

Integral is area.


# Linear Algebra


## Vectors



The fundamental notions of linear algebra are [i vector] and 
[i matrix].  An $n$-dimensional vector is a  list of real numbers:

|| equation
\\bv = (v_1, v_2, \\ldots ,v_n)

The set of all such vectors, where the $v_i$ range
over the real numbers $\\reals$ is written

|| equation
\\reals^n = \\sett{ (v_1, v_2, \\ldots ,v_n) }{ v_i \\in \\reals }

When $n = 2$, $n$-space is the Cartesian plane, as
in the figure below.  The vector $(x_1, x_2) = (4,2)$
corresponds to the point $P$: it is four units to the 
right of the origin $O$ and is two units up.  Here
we think of $\\bx = (x_1, x_2)$ as a [term position vector].


[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/ccdf9c04-5e8f-4a57-9291-d3fdb0133b00/public width:380]





We can visualize position vectors in 3-space in the same way:
set up three perpendicular axes, and use them to locate
a point by giving three numbers, one for each axis.  See the figure below.


[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/386570a0-e841-4dc9-e74d-2d4eaaa0dc00/public width:300]


The typical problem in data science involves 
vectors in $n$-space where the number of dimensions
(things [i measured]) is much larger —\u{00A0}ten, a thousand, maybe 
more. In dimension greater than three, our vision fails us,
so we proceed by analogy. There are vector formulas for notions
like distance and angle in 2-space and 3-space, for object,
like lines and planes, circles and spheres. Because these formulas
work in $n$-space, so do the notions just described.

Let's begin with lengthg. The length of a vector $\\bx = (x_1, x_2)$
in 2-space is given by

|| equation
|| x || = \\sqrt{ x_1^2 + x_2^2 }

This is the Pythagorean theorem.  In the figure, we see that
the length or [term norm] if the vector $\\bx = (3,4)$ is 
$|| \\bx || = 5$.  

[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/133cef76-ec21-4325-577a-b90437823600/public width:300]

The length of a vector in $n$-space is
defined in the same way:

|| equation
|| x || = \\sqrt{ x_1^2 + x_2^2  + \\cdots + x_n^2}


The numbers $x_i$ are called the [term components] or 
[term coordinates] of the vector. 


## Distance, sum and difference


Once we have a notion of length, we have a notion 
of [term distance].  Suppose $P$ and $Q$, as in the figure
below, are points in 2-space with position vectors $\\bx = (x_1, x_2)$ and $\\by = (y_1, y_2)$.  The distance from $P$ to $Q$ is

|| equation
d(P,Q) = \\sqrt{(y_1 - x_1)^2 + (y_2 - x_2)^2}

[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/232f19d6-44fc-4ed4-edc5-a579b0d1cb00/public]

Once again, the formula makes sense for vectors in $n$-space:

|| equation
d(P,Q) = \\sqrt{(y_1 - x_1)^2 + (y_2 - x_2)^2 + \\cdots + (y_n - x_n)^2}

Notice that the terms of appearing in this formula look like
the components of a vector.  Indeed, we can define the 
[term difference] of vectors like this:

|| equation
\\by - \\bx = (y_1 - x_1, y_2 - x_2, \\ldots , y_n - x_n)

Then 

|| equation
d(P,Q) = || \\bx - \\by ||

The difference of two vectors in $n$-space is the vector whose
components are differences of corresponding components: 
$(\\by - \\bx)_i = y_i - x_i$. In the same way we define the 
sum of vectors by adding their components:

|| equation
\\by + \\bx = (y_1 + x_1, y_2 + x_2, \\ldots , y_n + x_n)

## Dot Product and Angle

So far we have defined length and distance in $n$-space.  Next,
let's do angle.  For this we need  the [term dot product] of
vectors,

|| equation
\\bx \\cdot \\by = x_1y_1 + x_2y_2 + \\cdots + x_ny_n

The dot product of vectors is not a vector, but
rather a [term scalar], that is, a number.  


Consider now two vectors $\\bx$ and $\\by$, as in the figure
below.  They enclose an angle $\\theta$.  The two vectors
are sides a triangle, where the third side runs from the 
head of one of the arrows to the head of the other.  The
third side is the vector $\\by - \\bx$  (or rather that vector
moved parallel to itself so that its tail rests on the head of $\\bx$).  Let's compute the length of the "opposite side:"


|| aligned
||\\by - \\bx ||^2 &= (\\by - \\bx) \\cdot (\\by -\\bx ) \\ 
  &= ||\\by||^2 + ||\\bx||^2 - 2(\\by\\cdot \\bx) 


[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/3941e24d-bfc8-4c7f-26e3-c1393e647800/public width:300]


In the case $n = 2$ we can compute the length of the opposite
side in another way, using the [term Law of Cosines]:

|| equation
|| \\by - \\bx ||^2 = ||\\by||^2 + ||\\bx||^2 
  - 2||\\by||\\cdot ||\\bx|| \\cos\\theta

Comparing the last two equations, we find that

|| equation
\\cos\\theta = \\frac{\\bx \\cdot \\by}{||\\bx|| \\cdot ||\\by||}



Once again, this formula makes sense not just for $2$-space,
But for $n$-space.  We take it as the deinition of angle
in higher-dimensional spaces.  (Remark, Appendix:  Cauchy-Schwarz inequality).

An immediate consequence of this last formula is that

| proposition
If $\\ a.b = 0$, then $a$ and $b$ are perpendicular.

Perpendicular vectors are also said to be [b orthogonal]

## Scalar product and unit vectors

Let $c$ be a scalar and $\\bx = (x_1, x_2, \\ldots, x_n)$
a vector.  Their [term scalar product]  is the vector 

|| equation
c\\bx = (cx_1, cx_2, \\ldots, cx_n)

That is, the $i$-th component of the scalar product
is the $c$ times the $i$-th compoent of $\\bx$.  In equations,
$(c\\bx)_i = c\\bx_i$.  The effect of multiplying a vector
by a scalar is to stretch it or shrink it, or to do one 
of those things and also reverse its direction (if $c$ is negative).



| problem
Let $\\bx = (2,4)$. On graph paper, plot the vectors
$\\bx$, $2\\bx$,  $0.5\\bx$, and $(-1)\\bx$.  In each case,
indicate whether scalar product is bigger, smaller, or reversed.

| problem
Show that $ || c\\bx || 
  = |c|\\cdot ||\\bx||$

A [term unit vector] is a vector of unit length.  Given
any nonzero vector $\\bx$, there is a unique unit vector $\\hat{\\bx}$ that points in the same direction as $\\bx$:

|| equation
\\hat{\\bx} = \\frac{\\bx}{|| \\bx ||}

That is, $\\hat{\\bx}$ is the scalar product of $\\bx$ and the scalar $1/||x||$.

| problem
Find the unit vectors associated to the following vectors:
(a) $\\bx = (3,4)$, (b) $\\bx = (1, 1)$, (c) $\\bx = (1,2,3,4)$.



## Point Clouds and Clusters

Let us now consider an example of the kind of problem
that comes up routinely in data science. A team of
medical scientists is searching for a rapid diagnostic test
for a new disease.  To this end, they have measured the
concentrations of then chemical substances in the blood
of a group of test subjects. This data is a point  $(x_1, \\ldots x_{10})$ in 10-dimensional space
$\\reals^{10}$.  Suppose that we have test results from
100 hundred subjects.  They form
a cloud of 100 points in $\\reals^{10}$ —  a so-called [term point cloud].  Suppose further that
there are two kinds of people in the test group: healthy people
chosen at random, and a random selection of people with a
certain disease.  The aim of the study is to see if the test
results can reliably determine who is healthy and who has the disease.
If it were possible to see the data with 10-dimensional eyes,
we might find that the data consisted of two clusters of points —
the big point cloud is really two smaller clouds as in the figure below.


[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/61fa5b5c-1109-4692-d353-ae559b183800/public width:300]

How might we decribe this clustering if it exists? In the figure, we see that the points cluster inside two circles.  The first cluster is described by the inequality

|| equation
d(x, A) < r_A

where $d(x,A)$ is the distance from $x$ to center $A$ 
of the first circle, where  $r_A$ is the 
radius.  The same logic applies to 3-space, except
that we have spheres instead of circles.  Is there a way of doing something like this in $n$-space? While we do not yet have
an algorithm for finding clusters, we have one of the
mathematical tools needed to do just that: a notion of
distance.  We could, for example, begin like this:

. Choose a point $p$ at random. If there are at least 5
points in the cloud withn a distace 1.5 of $p$, declare
these points to be the seed of a cluster. If not, choose
another point at random and begin this process again.

. Continue adding points to the seed cluster if they are are with 1.5 units of the seed cluster.  When there are no more such points, go back to (1) and start a new cluster 

This is simplified outline of the DBSCAN algorithm. See
the Algorithms chapter for a full description.
Below is an example that uses DBSCAN.  A Python program was used to generate
300 points in 5-space with 3 clusters — thus an artificial
point cloud
represented by a 300x5 matrix. Then the DBSCAN algorithm 
from the Python scikit-learn library was run to find the clusters.


The the output of this algorithm was fed in to another algorithm which finds a good projection of the data from 5-space to 2-space
so that it can be visualized.  This phase uses PCA (principal component analysis), something we will study later. The projected data was plotted using matplotlib.


[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/9b4737fc-472b-4492-71b9-461a6412cc00/public]



## Projections, PCA, and dimension reduction

We have already talked about projections as a way of reducing
the dimension of our data so that we can visualize and perhaps
detect patterns in it.  So far, however, our projections
were very limited in nature.  We use, for example, the 
projection $p: \\reals^n \\to \\reals^2$ given by
the formula $p(x_1, x_2, \\ldots, x_n) = (x_1, x_2)$.  Let $p_{ij}(x_1, x_2, \\ldots, x_n) = (x_i, x_j)$ be the projection onto the
$x_i$ and $x_j$ axes, in that order.  This gives $n(n-1)$ possible projections: $n$ choices for $i$ and $n-1$ for $j$. However, there are 
actually infinitely many choices, some better than others.

To describe the other projections, consider the equations

|| aligned
y_1 &= a_{11}x_1 + a_{12}x_2  + \\cdots + a_{1n}x_n \\
y_2 &= a_{21}x_1 + a_{22}x_2  + \\cdots + a_{2n}x_n \\
\\ldots  \\
y_m &= a_{m1}x_1 + a_{m2}x_2  + \\cdots + a_{mn}x_n \\

They define a function $p: \\reals^n \\to \\reals^m$.
This is our first draft of a projection.  Note that it is
determined by the numbers $a_{ij}$.  We can assemble them
in a rectangular table, a so-called [term matrix]:

|| equation
A = \\begin{pmatrix}
a_{11} & a_{12} & \\ldots & a_{1n} \\
a_{21} & a_{22} & \\ldots & a_{2n} \\
... & ... & ... & ...\\
a_{m1} & a_{m2} & \\ldots & a_{mn} \\
\\end{pmatrix}

This is an  $m\\times n$ matrix: it has $m$ rows,
each consisting of an $n$-dimensional [term row vector]

|| equation
a_i = (a_{i1}, a_{i2}, \\ldots a_{in})


The matrix $A$
contains everthing that you need to know to compute the projection
$\\by = p(\\bx)$



There is something else to notice: The components of the output vector $\\by$ are dot products
of the row vectors $\\ba_i$ with input vector $\\bx$:

|| equation
\\by_i = \\ba_i \\cdot \\bx

To put this in context, think again about the"coordinate projections" $p_{ij}$.
They fit into this scheme as follows.  Let $e_i$ be the vector
with a 1 at position $i$ and 0 in the other positions. This
is a vector of unit length pointing along the $x_i$ axis.
The matrix $A$ corresponding to our projection ihas two rows and $n$ columns.  All of its entries are 0, except for a 1 in column $i$ of the first row and a 1 in column $j$ of the second row.  Here is the matrix corresponding to the projection $p_{24}$:


|| equation
A_{24} = \\begin{pmatrix}
0 & 1 & 0 & 0 & 0 \\
0 & 0 & 0 & 1 & 0
\\end{pmatrix}

What is important about this matrix is not the 1's and 0's
but rather that its two rows are
vectors of  unit length that meet at right angles. How do 
we know this? Let $\\bu$ and $\\bv$ be the first and
second rows of the matrix $A$.  Then $\\bu\\cdot\\bu = 1$, 
so $||\\bu||  = 1$.  A vector of unit length is called a
[term unit vector].  Note also that $\\bu \\cdot \\bv = 0$.
Therefore the cosine af the angle is zero.  This means
that the angle between $\\bu$ and $\\bv$ is either $\\pi/2$ or $3\\pi/2$.  In either case, they meet at a right angle.

Let's give very simple example to show how this freedom
to choose projections can help us.  Below is a point cloud
consisting of 2D data plotted in the usual $x_1, x_2$ coordinates.
Each axis corresponds to a measurement of some definite kind.

We see a small point cloud with two kinds of points — red and
green.  If we project onto the $OA$ axis, the two point clouds
are not resolved: one is inside the other. However, let's rotate
to the OC, OD axes, then project onto the OC axis. This time
the two point clouds are cleanly to the left, the greens to the right.  An exercise in trigonometry tells us that this projection is defined by the function

|| equation
q(x_1, x_2) = x_1\\cos\\theta  + x_2 \\sin\\theta

where $\\theta$ is the angle from $OA$ to $OC$.  Note that
$\\bu = (\\cos\\theta, \\sin\\theta)$ is a unit vector, so


|| equation
q(\\bx) = \\bx\\cdot \\bu

fits the general pattern.


[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/2c91b93a-ab13-43a9-34c2-97eca7d41600/public  width:300]

The big question, of course, is how do we find
these good projections.  That is what the Principal 
Component Algorithm (PCA) is for. The theoretical
requirements for it are the notions of eigenvectors
and eigenvalues of a symmetric matrix, something we will study in XX. The projection matrix given to us by PCA will
always be a matrix whose rows are orthogonal unit vectors.

## Matrices

The notion of matrix arose naturally in the previous section
as a way to summarize the data needed to define a projection.
Let's talk a more about these objects.  Consider by way of
example the matrix 

|| equation
A = \\begin{pmatrix}
 1 &-2 &\\phantom{-}0 &3 \\
 0 &\\phantom{-}1 &-1 &1
 \\end{pmatrix}

Consider also the [term column vector]

|| equation
\\bx = \\begin{pmatrix}
 1 \\
 1 \\
 1 \\
 1
 \\end{pmatrix}

Let $\\by$ be the column vector whose components are the
dot products of the rows of $A$ with $\\bx$:

|| equation
\\by = \\begin{pmatrix}
  {\\ba}_1\\cdot \\bx \\
  {\\ba}_2\\cdot \\bx
\\end{pmatrix} 
= \\begin{pmatrix}
  2 \\ \\
  1
\\end{pmatrix} 

We can write this more compactly as the [term matrix product]

|| equation
\\by = A\\bx

The product is defined by defining the components of $A\\bx$:

|| equation
(A\\bx)_i = \\ba_i \\cdot \\bx


## Coordinate Changes


(( under construction ))

|| equation
\\begin{pmatrix}
 x_1' \\
 x_2'
 \\end{pmatrix}
 =
 \\begin{pmatrix}
 \\phantom{-}\\cos\\theta & \\sin\\theta \\
 -\\sin\\theta & \\cos\\theta
 \\end{pmatrix}
 \\begin{pmatrix}
 x_1 \\
 x_2
 \\end{pmatrix}
 

## Good projections: a case study

We said above that problems in data science
are naturally posed in the context of 
higher-dimensional spaces.  Let's look at an example
from biology.  The data consists measuremnt of 
sharks teeth, both from living and fossil specimens.
In the case of fossil sharks, their teeth are often their
only remnant.
The aim of the study is categorize the teeth at the 
level of species and genus and to find phylogenetic connections between those "taxa." For example, we humans are [i Homo sapiens] — genus [i Homo] and species [i sapiens], whereas Neanderthal man is [i Homo neanderthalenis].  We share
a common ancestor from roughly 600,000 to 800,000 years ago.  That is our [term phylogenetic relation] — our relationship in the tree of life.

The measuremnt data in the shark study are lengths and 
angles of a collection of 175 fossil teeth, as illustrated by the figure below. There are fifteen of these, so each tooth 
is represented by a 15-dimensional vector.  The data itself
is given by a matrix with 175 rows and 15 columns — one row
for each tooth.  

[image https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/7abcafac-fe48-468a-9631-ad43c58f5400/public width:300]

A data set such as the one at hand can be thought of as
a cloud of points in a 175-dimensional space. If it were
a cloud of points in a 2 or 3-dimensional space, we might
be able to "just look at it"  and
pick out several clusters of points, Our data is what it is, 


but recall that we can project our data from 



perhaps there is not just one cloud, but several, along
with a random sprinkling of a few points not belonging to any
of the easily distinguished clouds.  That is, perhaps the
2-D data looks like this:

FIGURE




Alas, it could also look like this, with no obvious clustering:

FIGURE




# Glossary

| index

# Appendix: Mathematical Addenda


## Gradient Descent

(( To be read add at your own risk :-))

Let $\\nabla f$ be the [term gradient] of $f$, that is, the column vector of first partial
derivatives.  Let $\\nabla^2f$ be the [term Hessian matrix] of $f$, that is, the matrix
of second partial derivatives.

| theorem
If the function  $f: 
\\reals^n \\rightarrow \\reals$  is convex and differentiable, and its gradient  $\\nabla f$  is Lipschitz continuous with Lipschitz constant  $L > 0$, then gradient descent with a fixed step size  $\\alpha \\in (0, \\frac{2}{L})$  converges to a global minimum of  $f$.


| theorem
Suppose that the function  $f: 
\\reals^n \\rightarrow \\reals$  is convex and twice continuously differentiable.  Suppose also that there are constants $m > 0$ and 
$L > 0$ such that $\\nabla^2 f(x) - m I$ and $\\nabla^2 f(x) - L I$ are 
positive-definite matrices. Then gradient descent with step size
satisfying $0 < \\alpha < 2/L$ converges to the unique global minimum of $f$.



# References

[bibitem AA] Anil Ananthasamy, [u Why Machines Learn]

[link Gradient Descent Algorithm — a Deep Dive https://towardsdatascience.com/gradient-descent-algorithm-a-deep-dive-cf04e8115f21]

[link EEG Spectral Density https://raphaelvallat.com/bandpower.html]

[link Steepest descent (Arizona) https://www.osti.gov/servlets/purl/983240]


"""
