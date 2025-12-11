port module Main exposing (main)

port results : String -> Cmd msg

main : Program () () ()
main =
    Platform.worker
        { init = \_ -> ( (), runBenchmark )
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        }

runBenchmark : Cmd msg
runBenchmark =
    -- your benchmark logic here
    results "Benchmark complete: ..."