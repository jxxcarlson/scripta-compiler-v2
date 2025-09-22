module Frontend.EditorSync exposing (firstSyncLR, nextSyncLR)

{-| This module handles synchronization between the editor and rendered view.

It provides functionality to sync selected text in the editor with
corresponding elements in the rendered output, enabling bidirectional navigation.

@docs firstSyncLR, nextSyncLR

-}

--import Message

import List.Extra
import Model exposing (Model, Msg(..))
import ScriptaV2.Helper



--import Types exposing (DocumentDeleteState(..), FrontendMsg(..), LoadedModel, MessageStatus(..), PopupState(..), ToBackend(..))
--import View.Utility
--- KEYBOARD COMMANDS


{-| Perform first sync from left (editor) to right (rendered view).

Called when the message `SelectedText str` is received from the editor.
Finds matching elements in the rendered output and scrolls to the first match.

-}
firstSyncLR : Model -> String -> ( Model, Cmd msg )
firstSyncLR model sourceText =
    case model.syncState of
        SyncText str ->
            if str == sourceText then
                nextSyncLR model

            else
                let
                    data =
                        let
                            -- Find the ids of elements in the rendered text which match the
                            -- selected source text.  Do this by searching the syntax tree
                            foundIds_ =
                                ScriptaV2.Helper.matchingIdsInAST sourceText model.editRecord.tree

                            id_ =
                                List.head foundIds_ |> Maybe.withDefault "(nothing)"
                        in
                        { foundIds = foundIds_
                        , foundIdIndex = 1
                        , cmd = View.Utility.setViewportForElement (View.Utility.viewId model.popupState) id_
                        , selectedId = id_
                        , searchCount = 0
                        }
                in
                ( { model
                    | selectedId = data.selectedId
                    , syncState = SyncText sourceText
                    , foundIds = data.foundIds
                    , foundIdIndex = data.foundIdIndex
                    , searchCount = data.searchCount

                    --  , messages = Message.prepend model.messages { txt = ("[" ++ adjustId data.selectedId ++ "]") :: List.map adjustId data.foundIds |> String.join ", ", status = MSWhite }
                  }
                , data.cmd
                )


{-| Cycle to the next matching element in the rendered view.

When multiple elements match the selected text, this function
cycles through them in order, wrapping around to the beginning.

-}
nextSyncLR : LoadedModel -> ( LoadedModel, Command FrontendOnly ToBackend FrontendMsg )
nextSyncLR model =
    let
        id_ =
            List.Extra.getAt model.foundIdIndex model.foundIds |> Maybe.withDefault "(nothing)"
    in
    ( { model
        | selectedId = id_
        , foundIdIndex = modBy (List.length model.foundIds) (model.foundIdIndex + 1)
        , searchCount = model.searchCount + 1
        , messages = Message.prepend model.messages { txt = ("[" ++ adjustId id_ ++ "]") :: List.map adjustId model.foundIds |> String.join ", ", status = MSWhite }
      }
    , View.Utility.setViewportForElement (View.Utility.viewId model.popupState) id_
    )


adjustId : String -> String
adjustId str =
    case String.toInt str of
        Nothing ->
            str

        Just n ->
            String.fromInt (n + 2)
