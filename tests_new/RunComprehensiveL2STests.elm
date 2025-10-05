module RunComprehensiveL2STests exposing (main)

import Html exposing (Html)
import Html.Attributes
import Render.Export.LaTeXToScriptaTest as Tests


main : Html msg
main =
    Html.div
        [ Html.Attributes.style "font-family" "monospace"
        , Html.Attributes.style "padding" "20px"
        , Html.Attributes.style "max-width" "1200px"
        ]
        [ Html.h1 [] [ Html.text "LaTeX to Scripta Comprehensive Test Suite (15 Tests)" ]
        , Html.pre
            [ Html.Attributes.style "white-space" "pre-wrap"
            , Html.Attributes.style "background" "#f5f5f5"
            , Html.Attributes.style "padding" "20px"
            , Html.Attributes.style "border" "1px solid #ccc"
            ]
            [ Html.text Tests.runTests ]
        ]
