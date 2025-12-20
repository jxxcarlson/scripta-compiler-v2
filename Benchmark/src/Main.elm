port module Main exposing (main)

import DataSci
import ScriptaV2.APISimple
import ScriptaV2.Language
import ScriptaV2.Types
import Task
import Time
import Virial


port results : String -> Cmd msg


type alias Flags =
    { bodyMultiplier : Int
    , reps : Int
    }


type Msg
    = GotTime Time.Posix
    | GotBenchMarkResult (Result Never String)


main : Program Flags () Msg
main =
    Platform.worker
        { init =
            \flags ->
                let
                    input =
                        DataSci.str flags.bodyMultiplier

                    wordCount =
                        countWords input
                in
                ( (), runBenchmark compileString input flags.reps wordCount )
        , update = update
        , subscriptions = \_ -> Sub.none
        }


countWords : String -> Int
countWords str =
    str
        |> String.words
        |> List.length


update : Msg -> () -> ( (), Cmd Msg )
update msg _ =
    case msg of
        GotTime _ ->
            ( (), Cmd.none )

        GotBenchMarkResult result ->
            case result of
                Ok ms ->
                    ( (), results ms )

                Err _ ->
                    ( (), Cmd.none )


runBenchmark : (String -> ()) -> String -> Int -> Int -> Cmd Msg
runBenchmark task input reps wordCount =
    Task.attempt GotBenchMarkResult (run task input reps wordCount)


run : (b -> a) -> b -> Int -> Int -> Task.Task x String
run task input reps wordCount =
    Time.now
        |> Task.map (\startTime -> ( startTime, runBenchMarkTaskMany reps task input ))
        |> Task.andThen captureEndTime
        |> Task.map (\( ( startTime, () ), endTime ) -> compute startTime endTime reps wordCount)


compute : Time.Posix -> Time.Posix -> Int -> Int -> String
compute startTime endTime reps wordCount =
    let
        elapsedMs =
            toFloat (Time.posixToMillis endTime - Time.posixToMillis startTime)

        msPerRun =
            elapsedMs / toFloat reps
    in
    String.join "|"
        [ String.fromFloat msPerRun
        , String.fromInt reps
        , String.fromInt wordCount
        ]


captureEndTime : a -> Task.Task x ( a, Time.Posix )
captureEndTime previousResult =
    Time.now
        |> Task.map (\endTime -> ( previousResult, endTime ))


runBenchMarkTaskMany : Int -> (input -> a) -> input -> ()
runBenchMarkTaskMany n task input =
    if n == 0 then
        ()

    else if n == 1 then
        task input |> (\_ -> ())

    else
        let
            _ =
                task input
        in
        runBenchMarkTaskMany (n - 1) task input


compileString : String -> ()
compileString str =
    let
        defaultCompilerParameters =
            ScriptaV2.Types.defaultCompilerParameters

        _ =
            ScriptaV2.APISimple.compile
                { defaultCompilerParameters
                    | filter = ScriptaV2.Types.NoFilter
                    , lang = ScriptaV2.Language.ScriptaLang
                    , docWidth = 500
                    , editCount = 0
                    , selectedId = "-"
                    , idsOfOpenNodes = []
                }
                str
    in
    ()
