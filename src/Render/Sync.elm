module Render.Sync exposing
    ( attributes
    , highlightIfIdIsSelected
    , highlightIfIdSelected
    , highlighter
    , rightToLeftSyncHelper
    )

import Element exposing (Element)
import Element.Background as Background
import Element.Events as Events
import Generic.Language
import Render.Settings
import Render.Utility
import ScriptaV2.Msg exposing (MarkupMsg(..))


{-| Use this function to add all needed properties to an element for LR sync
-}
attributes : Render.Settings.RenderSettings -> Generic.Language.ExpressionBlock -> List (Element.Attribute MarkupMsg)
attributes settings block =
    [ rightToLeftSyncHelper block.meta.lineNumber block.meta.numberOfLines
    , Render.Utility.idAttribute block.meta.id
    ]
        |> highlightIfIdSelected block.meta.id settings



{-
   The Issue:
    The function compares id (which is block.meta.id) with settings.selectedId. However, when clicking on rendered text:

    1. The rightToLeftSyncHelper sends line numbers (SendLineNumber { begin = firstLineNumber, end = firstLineNumber + numberOfLines })
    2. This sets editorData with line numbers, not the block's meta.id
    3. The highlighting check compares the block's meta.id against selectedId, which likely contains line number information

    Why it fails:
    - The system is mixing two different identification schemes:
      - block.meta.id: A unique identifier for the block
      - block.meta.lineNumber: The line number in the source

    Recommendations:
    1. The highlightIfIdSelected function should compare line numbers instead of IDs when the selection comes from right-to-left sync
    2. Or, ensure that settings.selectedId is set to the block's meta.id when a right-to-left sync occurs
    3. The scrolling issue is related - the system needs to find elements by their ID attribute, but the selection mechanism is using line numbers

    The mismatch between what's being sent (line numbers) and what's being compared (meta.id) prevents both highlighting and scrolling from working
    correctly.
-}


highlightIfIdSelected : String -> Render.Settings.RenderSettings -> List (Element.Attr () msg) -> List (Element.Attr () msg)
highlightIfIdSelected id settings attrs =
    if id == settings.selectedId then
        Background.color (Render.Settings.getThemedElementColor .highlight settings.theme) :: Element.padding 8 :: attrs

    else
        attrs


highlightIfIdIsSelected : Int -> Int -> Render.Settings.RenderSettings -> List (Element.Attribute MarkupMsg)
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
    Element.rgba 0.1 0.1 0.8 0.5
