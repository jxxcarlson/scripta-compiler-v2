module MagicToken.AddToTypes exposing (rule)

{-|

@docs rule

-}

import Elm.Syntax.Declaration as Declaration exposing (Declaration)
import Elm.Syntax.Expression as Expression exposing (Expression)
import Elm.Syntax.Node as Node exposing (Node)
import Elm.Syntax.Type
import Review.Rule as Rule exposing (Error, Rule)


{-| Reports... REPLACEME

    config =
        [ MagicToken.AddToTypes.rule
        ]


## Fail

    a =
        "REPLACEME example to replace"


## Success

    a =
        "REPLACEME example to replace"


## When (not) to enable this rule

This rule is useful when REPLACEME.
This rule is not useful when REPLACEME.


## Try it out

You can try this rule out by running the following command:

```bash
elm-review --template undefined/example --rules MagicToken.AddToTypes
```

-}
rule : Rule
rule =
    Rule.newModuleRuleSchema "MagicToken.AddToTypes" Nothing
        |> Rule.withDeclarationEnterVisitor declarationVisitor
        |> Rule.fromModuleRuleSchema


declarationVisitor : Node Declaration -> Context -> ( List nothing, Context )
declarationVisitor node _ =
    case Node.value node of
        Declaration.CustomTypeDeclaration tipe ->
            ( []
            , Just
                { typeInfo = tipe.name
                , constructors = tipe.constructors
                }
                |> Debug.log "Type context"
            )

        _ ->
            ( [], Nothing )


type alias Context =
    Maybe
        { typeInfo : Node String
        , constructors : List (Node Elm.Syntax.Type.ValueConstructor)
        }


type alias ModuleContext =
    { moduleName : String
    }
