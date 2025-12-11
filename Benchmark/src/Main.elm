port module Main exposing (main)

import ScriptaV2.APISimple
import ScriptaV2.Language
import ScriptaV2.Types
import Task
import Time
import Virial


port results : String -> Cmd msg


type Msg
    = GotTime Time.Posix
    | GotBenchMarkResult (Result Never String)


main : Program () () Msg
main =
    Platform.worker
        { init = \_ -> ( (), runBenchmark compileString Virial.str 100 )
        , update = update
        , subscriptions = \_ -> Sub.none
        }


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


runBenchmark : (String -> ()) -> String -> Int -> Cmd Msg
runBenchmark task input reps =
    Task.attempt GotBenchMarkResult (run task input reps)


run : (b -> a) -> b -> Int -> Task.Task x String
run task input reps =
    Time.now
        |> Task.map (\start -> ( start, runBenchMarkTaskMany reps task input ))
        |> Task.andThen nowAgain
        |> Task.map (\( ( finished, () ), started ) -> compute started finished reps)


compute : Time.Posix -> Time.Posix -> Int -> String
compute finished started reps =
    let
        executionTime =
            String.fromFloat <| (toFloat <| Time.posixToMillis finished - Time.posixToMillis started) / toFloat reps
    in
    String.join " " [ executionTime, "milliseconds per run in", String.fromInt reps, "runs" ]


nowAgain : a -> Task.Task x ( a, Time.Posix )
nowAgain t =
    Time.now
        |> Task.map (\s -> ( t, s ))


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


getTime : Cmd Msg
getTime =
    Task.perform GotTime Time.now
