module TestBbbContent exposing (main)

import Either exposing (Either(..))
import Html exposing (..)
import Html.Attributes exposing (style)
import RoseTree.Tree as Tree
import ScriptaV2.Compiler as Compiler
import ScriptaV2.Language exposing (Language(..))
import Generic.Language exposing (ExpressionBlock)


sourceText =
    """AAA

- Outer 1

  - Inner 1

  - Inner 2

- Outer 2

BBB"""


main =
    let
        -- Parse the source text
        ast =
            Compiler.parseFromString SMarkdownLang sourceText

        tree3 =
            List.drop 3 ast |> List.head

        tree3Info =
            case tree3 of
                Nothing ->
                    "Tree 3 doesn't exist!"

                Just tree ->
                    let
                        block : ExpressionBlock
                        block =
                            Tree.value tree

                        bodyInfo =
                            case block.body of
                                Left str ->
                                    "Left: '" ++ str ++ "'"

                                Right exprs ->
                                    "Right: " ++ String.fromInt (List.length exprs) ++ " expressions"
                    in
                    "Tree 3 exists!\n"
                        ++ "Heading: " ++ Debug.toString block.heading ++ "\n"
                        ++ "Body: " ++ bodyInfo ++ "\n"
                        ++ "Source text: " ++ block.meta.sourceText
    in
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "BBB Content Debug" ]
        , h2 [] [ text "Source (Scripta):" ]
        , pre [ style "background" "#f0f0f0", style "padding" "10px" ] [ text sourceText ]
        , h2 [] [ text "Tree 3 (BBB) Info:" ]
        , pre
            [ style "background" "#ffe0e0"
            , style "padding" "10px"
            , style "white-space" "pre-wrap"
            ]
            [ text tree3Info ]
        ]