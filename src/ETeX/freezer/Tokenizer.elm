module ETeX.Tokenizer exposing (..)


type Token
    = S String
    | F String


run : String -> List Token
run source =
    loop (init source) nextStep


type alias State =
    { source : String
    , words = String.words source
    , current : String
    , tokens : List Token
    }



----


type Step state a
    = Loop state
    | Done a


loop : state -> (state -> Step state a) -> a
loop s f =
    case f s of
        Loop s_ ->
            loop s_ f

        Done b ->
            b


nextStep : State -> Step State (List Token)
nextStep state =
    case state.source of
        [] ->
            Done (List.reverse state.tokens)

        str ->
            case String.uncons str of
                Nothing ->
                    Done (List.reverse state.tokens)

                Just (c, rest) ->
                    if c == ' ' || c == '\n' || c == '\t' then
                        nextStep { state | source = rest, current = "" }
                    else if c == '\\' then
                        parseFunction state rest
                    else
                        parseString state (c :: rest)
            Loop { state | source = rest, tokens = token :: state.tokens }
