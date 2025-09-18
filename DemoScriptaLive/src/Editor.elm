module Editor exposing (..)

import Document
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Element.Keyed
import Html
import Html.Attributes
import Html.Events
import Json.Decode
import Json.Encode
import Model exposing (Model, Msg(..))


view model =
    Element.Keyed.el
        [ -- RECEIVE INFORMATION FROM CODEMIRROR
          Element.htmlAttribute onSelectionChange -- receive info from codemirror
        , Element.alignTop
        , Element.htmlAttribute onTextChange -- receive info from codemirror

        -- , Element.htmlAttribute onCursorChange -- receive info from codemirror
        , htmlId "editor-here"
        , Element.height (Element.px <| editorHeight model)
        , Element.width (Element.px <| panelWidth model)
        , Background.color (Element.rgb255 0 68 85)

        --, Background.color (View.Color.gray 0.1)
        , Font.color (Element.rgb 0.85 0.85 0.85)
        , Font.size 12
        ]
        ( "codemirror-editor-instance"
          -- Keep the same key always to prevent DOM recreation
        , Element.html
            (Html.node "codemirror-editor"
                [ -- SEND INFORMATION TO CODEMIRROR
                  if model.loadDocumentIntoEditor then
                    Html.Attributes.attribute "load" model.sourceText

                  else
                    Html.Attributes.attribute "noOp" "true"
                , Html.Attributes.attribute "text" model.initialText
                , Html.Attributes.attribute "editordata" (encodeEditorData model.editorData)
                , case model.maybeSelectionOffset of
                    Nothing ->
                        Html.Attributes.attribute "noOp" "true"

                    Just refinedSelection ->
                        Html.Attributes.attribute "refineselection" (encodeRefinedSelection refinedSelection model.editorData)

                -- TODO: remove this hardcoded value
                , Html.Attributes.attribute "selection" (stringOfBool model.doSync)
                ]
                []
            )
        )


panelWidth : Model -> Int
panelWidth model =
    max 200 ((appWidth model - sidebarWidth - 16 - 4 - 16) // 2)


editorHeight : Model -> Int
editorHeight model =
    max 100 (model.windowHeight - headerHeight - 1)



-- -1 for the border


appWidth : Model -> Int
appWidth model =
    model.windowWidth


sidebarWidth =
    260


headerHeight =
    90



-- HELPERS


onSelectionChange =
    textDecoder
        |> Json.Decode.map SelectedText
        |> Html.Events.on "selected-text"


dataDecoder : Json.Decode.Decoder Document.SourceTextRecord
dataDecoder =
    dataDecoder_
        |> Json.Decode.at [ "detail" ]


dataDecoder_ : Json.Decode.Decoder Document.SourceTextRecord
dataDecoder_ =
    Json.Decode.map2 Document.SourceTextRecord
        (Json.Decode.field "position" Json.Decode.int)
        (Json.Decode.field "source" Json.Decode.string)


textDecoder : Json.Decode.Decoder String
textDecoder =
    Json.Decode.string
        |> Json.Decode.at [ "detail" ]


onTextChange : Html.Attribute Msg
onTextChange =
    dataDecoder
        |> Json.Decode.map InputText2
        |> Html.Events.on "text-change"


encodeRefinedSelection : { focusOffset : Int, anchorOffset : Int, text : String } -> { begin : Int, end : Int } -> String
encodeRefinedSelection { focusOffset, anchorOffset, text } { begin, end } =
    Json.Encode.object
        [ ( "focusOffset", Json.Encode.int focusOffset )
        , ( "anchorOffset", Json.Encode.int anchorOffset )
        , ( "text", Json.Encode.string text )
        , ( "begin", Json.Encode.int begin )
        , ( "end", Json.Encode.int end )
        ]
        |> Json.Encode.encode 2


encodeEditorData : { begin : Int, end : Int } -> String
encodeEditorData { begin, end } =
    Json.Encode.object
        [ ( "begin", Json.Encode.int begin )
        , ( "end", Json.Encode.int end )
        ]
        |> Json.Encode.encode 2


stringOfBool : Bool -> String
stringOfBool bool =
    if bool then
        "true"

    else
        "false"


htmlId str =
    Element.htmlAttribute (Html.Attributes.id str)
