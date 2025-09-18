module Sync exposing (SelectionOffsets, selectionOffsetsDecoder, stringOfSelectionOffsets)

{-| This module handles text selection synchronization.

It provides types and functions for tracking cursor positions and text selections,
which is essential for collaborative editing and maintaining editor state.

@docs SelectionOffsets, selectionOffsetsDecoder, stringOfSelectionOffsets

-}

import Json.Decode


{-| JSON decoder for SelectionOffsets.

Expects a JSON object with fields:

  - "anchorOffset": number
  - "focusOffset": number
  - "text": string

-}
selectionOffsetsDecoder : Json.Decode.Decoder SelectionOffsets
selectionOffsetsDecoder =
    Json.Decode.map3 SelectionOffsets
        (Json.Decode.field "anchorOffset" Json.Decode.int)
        (Json.Decode.field "focusOffset" Json.Decode.int)
        (Json.Decode.field "text" Json.Decode.string)


{-| Represents a text selection with cursor positions.

  - `anchorOffset` - The starting position of the selection
  - `focusOffset` - The ending position of the selection
  - `text` - The selected text content

When anchorOffset equals focusOffset, it represents a cursor position
rather than a selection.

-}
type alias SelectionOffsets =
    { anchorOffset : Int
    , focusOffset : Int
    , text : String
    }


{-| Convert SelectionOffsets to a human-readable string for debugging.

    stringOfSelectionOffsets { anchorOffset = 5, focusOffset = 10, text = "hello" }
    -- Returns "(5, 10, hello)"

-}
stringOfSelectionOffsets : SelectionOffsets -> String
stringOfSelectionOffsets selectionOffsets =
    "(" ++ String.fromInt selectionOffsets.anchorOffset ++ ", " ++ String.fromInt selectionOffsets.focusOffset ++ ", " ++ selectionOffsets.text ++ ")"
