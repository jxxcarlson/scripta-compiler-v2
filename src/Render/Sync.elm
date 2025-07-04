module Render.Sync exposing
    ( attributes
    , highlightIfIdIsSelected
    , highlightIfIdSelected
    , highlighter
    , rightToLeftSyncHelper
    )

import Element exposing (Element, paddingEach)
import Element.Background as Background
import Element.Events as Events
import Generic.Language
import Render.Settings
import ScriptaV2.Msg exposing (MarkupMsg(..))


{-| Use this function to add all needed properties to an element for LR sync
-}
attributes : Render.Settings.RenderSettings -> Generic.Language.ExpressionBlock -> List (Element.Attribute MarkupMsg)
attributes settings block =
    [ rightToLeftSyncHelper block.meta.lineNumber block.meta.numberOfLines
    ]
        |> highlightIfIdSelected block.meta.id settings


highlightIfIdSelected : String -> { b | selectedId : String } -> List (Element.Attr () msg) -> List (Element.Attr () msg)
highlightIfIdSelected id settings attrs =
    if id == settings.selectedId then
        Background.color selectedColor :: attrs

    else
        attrs


highlightIfIdIsSelected : Int -> Int -> { a | selectedId : String } -> List (Element.Attribute MarkupMsg)
highlightIfIdIsSelected firstLineNumber numberOfLines settings =
    if String.fromInt firstLineNumber == settings.selectedId then
        [ rightToLeftSyncHelper firstLineNumber (firstLineNumber + numberOfLines)
        , Background.color (Element.rgb 0.8 0.8 1.0)
        ]

    else
        []


rightToLeftSyncHelper : Int -> Int -> Element.Attribute MarkupMsg
rightToLeftSyncHelper firstLineNumber numberOfLines =
    Events.onClick (SendLineNumber { begin = firstLineNumber, end = firstLineNumber + numberOfLines })


highlighter : List String -> List (Element.Attr () msg) -> List (Element.Attr () msg)
highlighter args attrs =
    if List.member "highlight" args then
        Background.color selectedColor :: attrs

    else
        attrs


selectedColor : Element.Color
selectedColor =
    Element.rgb 0.9 0.9 1.0
