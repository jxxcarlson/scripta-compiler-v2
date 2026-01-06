module Render.Blocks.Stack exposing (Stack, newStack, push, top)

{-| Stack for tracking nested list numbering.

Used to generate sequential labels (1, 2, 3...) at each nesting level
for numbered lists. When descending to a deeper level, push a new counter.
When ascending, pop and increment the parent level's counter.

-}


type alias Stack =
    List Int


top : Stack -> Maybe Int
top stack =
    List.head stack


level : Stack -> Int
level stack =
    List.length stack


push : Int -> Stack -> Stack
push k stack =
    k :: stack


pop : Int -> Stack -> Stack
pop k stack =
    List.drop k stack


inc : Stack -> Stack
inc stack =
    case top stack of
        Just a ->
            (a + 1) :: List.drop 1 stack

        Nothing ->
            stack


{-| Update the stack based on the new nesting level.

  - Empty stack: initialize with 1
  - Same level: increment current counter
  - Deeper level: push new counter starting at 1
  - Shallower level: pop to target level and increment

-}
newStack : Int -> Stack -> Stack
newStack newLevel stack =
    if stack == [] then
        push 1 stack

    else if newLevel == level stack then
        inc stack

    else if newLevel > level stack then
        push 1 stack

    else
        inc (pop (level stack - newLevel) stack)
