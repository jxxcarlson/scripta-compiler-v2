module Data.XMarkdown exposing (text)


text1 =
    """

# Stuff

## More Stuff

!! XMarkdown Test Document

- Breakfast

  - Eggs

  - Bacon

  - Coffee

    - Expresso

    - Latte

## Still more stuff

Ho ho ho!

"""


text =
    """


!! XMarkdown Test Document

# Stuff

- **some of its history**

## More stuff

- @[red Introduce] notions that will be studied in detail in what follows.

@[hrule]

# Lists

. This

. That

  . Foo

  . Bar



Another list:

. This

. That

  . Foo

  . Bar

# Links and images

I read the [New York Times](https://nytimes.com) every day.

![Divorce party](https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/663d702e-ba37-4227-1019-85fe74261900/public)


# Type Theory

*Type theory* brings together programming, logic, and mathematics.
 We outline



# Mathematics

Pythagoras said that $z^2 = x^2 + y^2$.

Newton said that

 $$
 \\int_0^1 x^2 dx = \\frac{1}{3}

# Code


Here is some inline code: `a[0] = $1`.

Here is some Python code:

```
def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n - 1)
```

 """
