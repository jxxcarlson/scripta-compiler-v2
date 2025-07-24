module Util exposing
    ( Step(..), loop
    , alphanumOnly, compressWhitespace, makeSlug, removeVersionNumber, substituteForITEM, discardLines
    , insertInList, insertInListOrUpdate
    , applyIf, andThenApply, cond, liftToMaybe, ignore
    , delay, performLater, trigger, beTrigger, toSeconds
    , engineeringNotation, expansionModK
    , data
    )

{-| General utility functions used throughout the application.

This module provides common helpers for:

  - String manipulation
  - List operations
  - Control flow
  - Timing and delays
  - Number formatting

@docs Step, loop


# String Utilities

@docs alphanumOnly, compressWhitespace, makeSlug, removeVersionNumber, substituteForITEM, discardLines


# List Utilities

@docs insertInList, insertInListOrUpdate


# Control Flow

@docs applyIf, andThenApply, cond, liftToMaybe, ignore


# Timing and Commands

@docs delay, performLater, trigger, beTrigger, toSeconds


# Number Formatting

@docs engineeringNotation, expansionModK


# Data Access

@docs data

-}

import Basics.Extra
import Duration
import Effect.Command as Commmand exposing (Command)
import Effect.Process
import Effect.Task
import Effect.Time
import List.Extra
import Regex


{-| A stand-in for Debug.log that does nothing.
Useful for leaving debug statements in code without output.
-}
ignore : String -> a -> a
ignore _ a =
    a


{-| Format a number with engineering notation (comma separators).

    engineeringNotation 1234567 == "1,234,567"

    engineeringNotation 123 == "123"

-}
engineeringNotation : Int -> String
engineeringNotation k =
    let
        digits =
            k
                |> expansionModK 10
                |> List.map String.fromInt

        numberOfLeadingDigits =
            modBy 3 (List.length digits)

        lastDigits =
            List.drop numberOfLeadingDigits digits
                |> List.Extra.greedyGroupsOf 3
                |> List.map (\group -> String.join "" group)
                |> String.join ","

        firstDigits =
            List.take numberOfLeadingDigits digits
                |> String.join ""
    in
    if numberOfLeadingDigits == 0 then
        lastDigits

    else if lastDigits == "" then
        firstDigits

    else
        firstDigits ++ "," ++ lastDigits



--|> List.Extra.greedyGroupsOf 3
--               |> List.map (\group -> String.join "" group)
--               |> String.join ","


{-| Convert a number to its base-k digit expansion.

    expansionModK 10 123 == [ 1, 2, 3 ]

    expansionModK 2 5 == [ 1, 0, 1 ]

-}
expansionModK : Int -> Int -> List Int
expansionModK modulus k =
    expansionModK_ modulus k []


{-| Internal helper for expansionModK.
-}
expansionModK_ : Int -> Int -> List Int -> List Int
expansionModK_ modulus k acc =
    let
        r_ =
            Basics.Extra.safeModBy modulus k

        q_ =
            Basics.Extra.safeIntegerDivide k modulus
    in
    case ( r_, q_ ) of
        ( Just r, Just q ) ->
            if q == 0 then
                r :: acc

            else
                expansionModK_ modulus q (r :: acc)

        _ ->
            []


{-| Trigger a message immediately on the next frame.
-}
trigger : msg -> Command restriction toMsg msg
trigger msg =
    performLater 0 msg


{-| Alternative implementation of trigger using Process.sleep.
-}
beTrigger : msg -> Command restriction toMsg msg
beTrigger msg =
    Effect.Process.sleep (Duration.milliseconds 0)
        |> Effect.Task.perform (always msg)


{-| Delay a message by the given number of milliseconds.
-}
performLater : Float -> msg -> Command restriction toMsg msg
performLater sleepInterval msg =
    Effect.Process.sleep (Duration.milliseconds sleepInterval)
        |> Effect.Task.perform (always msg)


{-| Example data for demonstrating the cond function.
Maps number ranges to color names.
-}
data : List ( number -> Bool, number -> String )
data =
    [ ( \x -> x >= 0 && x < 1, \x -> "red" )
    , ( \x -> x >= 1 && x < 2, \x -> "green" )
    , ( \x -> x >= 2 && x < 3, \x -> "blue" )
    ]


{-| Convert a Posix time to seconds since epoch.
-}
toSeconds : Effect.Time.Posix -> Float
toSeconds time =
    Effect.Time.toMillis Effect.Time.utc time
        |> toFloat
        |> (/) 1000


{-| Take an action based on a condition

> cond data "undefined" 0.5
> "red" : String

> cond data "undefined" -1
> "undefined" : String

-}
cond : List ( a -> Bool, a -> b ) -> b -> a -> b
cond data_ default input =
    loop
        { conditions = List.map Tuple.first data_
        , actions = List.map Tuple.second data_
        , input = input
        , default = default
        }
        nextCondStep


type alias CondState a b =
    { conditions : List (a -> Bool)
    , actions : List (a -> b)
    , input : a
    , default : b
    }


nextCondStep : CondState a b -> Step (CondState a b) b
nextCondStep state =
    case ( List.head state.conditions, List.head state.actions ) of
        ( Nothing, _ ) ->
            Done state.default

        ( _, Nothing ) ->
            Done state.default

        ( Just condition, Just action ) ->
            if condition state.input then
                Done (action state.input)

            else
                Loop { state | conditions = List.drop 1 state.conditions, actions = List.drop 1 state.actions }


cond2 : List ( a -> Bool, a -> b ) -> b -> a -> b
cond2 data_ default input =
    loop { data = data_, input = input, default = default } nextCondStep2


type alias CondState2 a b =
    { data : List ( a -> Bool, a -> b ), input : a, default : b }


nextCondStep2 : CondState2 a b -> Step (CondState2 a b) b
nextCondStep2 state =
    case List.head state.data of
        Nothing ->
            Done state.default

        Just datum ->
            if Tuple.first datum state.input then
                Done (Tuple.second datum state.input)

            else
                Loop { state | data = List.drop 1 state.data }


apply : (a -> ( a, b )) -> a -> ( a, b )
apply f a =
    f a


{-| Apply a function and combine results using a batch function.
-}
andThenApply : (a -> ( a, b )) -> (List b -> b) -> ( a, b ) -> ( a, b )
andThenApply f batch ( a, b ) =
    let
        ( a2, b2 ) =
            f a
    in
    ( a2, batch [ b, b2 ] )


{-|

    Apply f to a if the flag is true, otherwise return a

-}
applyIf : Bool -> (a -> a) -> a -> a
applyIf flag f x =
    if flag then
        f x

    else
        x


{-| Lift a function to work with Maybe values.

    liftToMaybe String.toUpper (Just "hello") == Just "HELLO"

    liftToMaybe String.toUpper Nothing == Nothing

-}
liftToMaybe : (a -> b) -> (Maybe a -> Maybe b)
liftToMaybe f ma =
    case ma of
        Nothing ->
            Nothing

        Just a ->
            Just (f a)



-- LISTS


{-|

    > l1 = iou {id = "a", val = 1} []
    [{ id = "a", val = 1 }]

    > l2 = iou {id = "b", val = 1} l1
    [{ id = "b", val = 1 },{ id = "a", val = 1 }]

    > l3 = iou {id = "a", val = 3} l2
    [{ id = "b", val = 1 },{ id = "a", val = 3 }]

-}
insertInListOrUpdate : (a -> a -> Bool) -> a -> List a -> List a
insertInListOrUpdate equal a list =
    case List.head (List.filter (\b -> equal a b) list) of
        Nothing ->
            a :: list

        Just _ ->
            List.Extra.setIf (\x -> equal x a) a list


{-| Insert an element into a list only if it's not already present.
-}
insertInList : a -> List a -> List a
insertInList a list =
    if List.Extra.notMember a list then
        a :: list

    else
        list


{-| Delay a message by the given number of milliseconds.
Similar to performLater.
-}
delay : Float -> msg -> Command restriction toMsg msg
delay time msg =
    Effect.Process.sleep (time |> Duration.milliseconds)
        |> Effect.Task.perform (\_ -> msg)


type alias DiscardLinesState =
    { input : List String }


{-| Discard lines from the beginning of a list until the predicate is satisfied.
The line that satisfies the predicate is also discarded.
-}
discardLines : (String -> Bool) -> List String -> List String
discardLines predicate lines =
    loop { input = lines } (discardLinesNextStep predicate)


{-| Discard lines until the predicate is satisfied; discard that line, then return the rest
-}
discardLinesNextStep : (String -> Bool) -> DiscardLinesState -> Step DiscardLinesState (List String)
discardLinesNextStep predicate state =
    case List.head state.input of
        Nothing ->
            Done state.input

        Just line ->
            if predicate line then
                Done (List.drop 1 state.input)

            else
                Loop { state | input = List.drop 1 state.input }


{-| Control flow type for tail-recursive loops.

  - `Loop`: Continue with new state
  - `Done`: Terminate with result

-}
type Step state a
    = Loop state
    | Done a


{-| Run a tail-recursive loop until Done is reached.

    loop 0
        (\n ->
            if n >= 10 then
                Done n

            else
                Loop (n + 1)
        )
        == 10

-}
loop : state -> (state -> Step state a) -> a
loop s nextState_ =
    case nextState_ s of
        Loop s_ ->
            loop s_ nextState_

        Done b ->
            b


{-| Replace regex matches in a string using a custom function.
-}
userReplace : String -> (Regex.Match -> String) -> String -> String
userReplace regexString replacer string =
    case Regex.fromString regexString of
        Nothing ->
            string

        Just regex ->
            Regex.replace regex replacer string


{-| Find a regex match in source and replace "ITEM" with that match in target.

    substituteForITEM "[0-9]+" "Page 42" "Item ITEM" == "Item 42"

-}
substituteForITEM : String -> String -> String -> String
substituteForITEM regexString source target =
    case firstMatch regexString source of
        Nothing ->
            source

        Just match ->
            String.replace "ITEM" match target



-- > firstMatch "\\[subheading (.+?)\\]" "[subheading Intro]"
-- Just "Intro" : Maybe String


{-| Find the first submatch of a regex in a string.
-}
firstMatch : String -> String -> Maybe String
firstMatch regexString src =
    Regex.find (userRegex regexString) src
        |> List.map .submatches
        |> List.map (List.filterMap identity)
        |> List.concat
        |> List.head


{-| Extract the matched string from a Regex.Match.
-}
matchToString : Regex.Match -> String
matchToString match =
    match.match


{-| Create a regex from a string, defaulting to Regex.never on failure.
-}
userRegex : String -> Regex.Regex
userRegex str =
    Maybe.withDefault Regex.never <|
        Regex.fromString str


{-| Remove a version number suffix from a string.

    removeVersionNumber "document.3" == "document"

-}
removeVersionNumber : String -> String
removeVersionNumber string =
    userReplace "\\.[0-9]*$" (\_ -> " ") string |> String.trim


{-| Compress multiple whitespace characters into single spaces.

    compressWhitespace "hello   world" == "hello world"

-}
compressWhitespace : String -> String
compressWhitespace string =
    userReplace "\\s\\s+" (\_ -> " ") string |> String.trim


{-| Keep only alphanumeric characters and spaces.

    alphanumOnly "hello@world#123" == "hello world 123"

-}
alphanumOnly : String -> String
alphanumOnly string =
    userReplace "[^a-z0-9 ]+" (\_ -> " ") string


{-| Convert a string to a URL-friendly slug.

    makeSlug "Hello World!" == "hello-world"

    makeSlug "My Document v2.0" == "my-document-v2-0"

-}
makeSlug : String -> String
makeSlug str =
    str |> String.toLower |> alphanumOnly |> compressWhitespace |> String.replace " " "-"
