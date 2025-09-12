module Markdown.Compiler exposing (compile, compileForScripta, renderToHtml)

{-| Markdown compiler using dillonkearns/elm-markdown.

This module provides compilation and rendering for standard Markdown documents,
with support for math rendering via KaTeX.

@docs compile, compileForScripta, renderToHtml

-}

import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font
import Element.Region
import Html exposing (Html)
import Html.Attributes
import Json.Encode
import Markdown.Block exposing (HeadingLevel, ListItem(..))
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Render.Settings
import Render.Theme
import ScriptaV2.Msg exposing (MarkupMsg(..))


{-| Compile Markdown for ScriptaV2 Compiler interface.

Returns a CompilerOutput record with body, banner, toc, and title.

-}
compileForScripta : Render.Settings.DisplaySettings -> Render.Theme.Theme -> String -> CompilerOutput
compileForScripta displaySettings theme markdownBody =
    let
        elements =
            compile displaySettings theme markdownBody

        -- Extract title from first H1 if present
        title =
            extractTitle markdownBody
    in
    { body = [ Element.map (\_ -> MMNoOp) elements ]
    , banner = Nothing
    , toc = [] -- TODO: Could extract headings for TOC
    , title = Element.text title |> Element.map (\_ -> MMNoOp)
    }


type alias CompilerOutput =
    { body : List (Element MarkupMsg)
    , banner : Maybe (Element MarkupMsg)
    , toc : List (Element MarkupMsg)
    , title : Element MarkupMsg
    }


extractTitle : String -> String
extractTitle markdown =
    markdown
        |> String.lines
        |> List.filter (String.startsWith "# ")
        |> List.head
        |> Maybe.map (String.dropLeft 2)
        |> Maybe.map String.trim
        |> Maybe.withDefault "Untitled"


{-| Compile Markdown string to Element msg.

This is the main entry point for rendering Markdown documents.
It includes support for math rendering through custom HTML elements.

-}
compile : Render.Settings.DisplaySettings -> Render.Theme.Theme -> String -> Element msg
compile displaySettings theme markdownBody =
    render (renderer theme) markdownBody


{-| Render Markdown to Html for export or preview.
-}
renderToHtml : Render.Theme.Theme -> String -> Html msg
renderToHtml theme markdownBody =
    Markdown.Parser.parse markdownBody
        |> Result.withDefault []
        |> (\parsed ->
                parsed
                    |> Markdown.Renderer.render (htmlRenderer theme)
                    |> Result.withDefault [ Html.text "Error rendering markdown" ]
                    |> Html.div []
           )


render : Markdown.Renderer.Renderer (Element msg) -> String -> Element msg
render chosenRenderer markdownBody =
    Markdown.Parser.parse markdownBody
        |> Result.withDefault []
        |> (\parsed ->
                parsed
                    |> Markdown.Renderer.render chosenRenderer
                    |> (\res ->
                            case res of
                                Ok elements ->
                                    elements

                                Err err ->
                                    [ Element.text "Something went wrong rendering this page"
                                    , Element.text err
                                    ]
                       )
                    |> Element.column
                        [ Element.width Element.fill
                        , Element.spacing 20
                        ]
           )


renderer : Render.Theme.Theme -> Markdown.Renderer.Renderer (Element msg)
renderer theme =
    let
        themeColors =
            case theme of
                Render.Theme.Light ->
                    { defaultText = Element.rgb255 30 50 46
                    , headingText = Element.rgb 0 0 0 -- Black for light mode headings
                    , mutedText = Element.rgb255 74 94 122
                    , link = Element.rgb255 12 82 200
                    , lightGrey = Element.rgb255 248 250 240
                    , grey = Element.rgb255 200 220 240
                    }

                Render.Theme.Dark ->
                    { defaultText = Element.rgb255 237 240 250
                    , headingText = Element.rgb255 220 140 50 -- Light purple tint for dark mode headings
                    , mutedText = Element.rgb255 180 190 210
                    , link = Element.rgb255 100 160 255
                    , lightGrey = Element.rgb255 46 51 55
                    , grey = Element.rgb255 80 90 100
                    }
    in
    { heading = \data -> Element.row [] [ heading themeColors data ]
    , paragraph = Element.paragraph [ Element.paddingEach { left = 0, right = 0, top = 0, bottom = 20 } ]
    , blockQuote =
        \children ->
            Element.column
                [ Element.Font.size 20
                , Element.Font.italic
                , Element.Border.widthEach { bottom = 0, left = 4, right = 0, top = 0 }
                , Element.Border.color themeColors.grey
                , Element.Font.color themeColors.mutedText
                , Element.padding 10
                ]
                children
    , html =
        -- For now, we'll disable custom HTML tags to simplify
        -- Math support can be added through preprocessing the markdown
        Markdown.Html.oneOf []

    {-
       Markdown.Html.oneOf
           [ -- Support for math rendering via custom element
             Markdown.Html.tag "math"
               (\content display ->
                   Element.html <|
                       Html.node "math-text"
                           [ Html.Attributes.property "content" (Json.Encode.string content)
                           , Html.Attributes.property "display"
                               (Json.Encode.bool (display == Just "block"))
                           , Html.Attributes.attribute "theme"
                               (if theme == Render.Theme.Dark then "dark" else "light")
                           ]
                           []
               )
               |> Markdown.Html.withAttribute "content"
               |> Markdown.Html.withOptionalAttribute "display"

           -- Support for inline math with $ delimiters (preprocessed)
           , Markdown.Html.tag "inlinemath"
               (\content ->
                   Element.html <|
                       Html.node "math-text"
                           [ Html.Attributes.property "content" (Json.Encode.string content)
                           , Html.Attributes.property "display" (Json.Encode.bool False)
                           , Html.Attributes.attribute "theme"
                               (if theme == Render.Theme.Dark then "dark" else "light")
                           ]
                           []
               )
               |> Markdown.Html.withAttribute "content"

           -- Support for display math with $$ delimiters (preprocessed)
           , Markdown.Html.tag "displaymath"
               (\content ->
                   Element.html <|
                       Html.node "math-text"
                           [ Html.Attributes.property "content" (Json.Encode.string content)
                           , Html.Attributes.property "display" (Json.Encode.bool True)
                           , Html.Attributes.attribute "theme"
                               (if theme == Render.Theme.Dark then "dark" else "light")
                           ]
                           []
               )
               |> Markdown.Html.withAttribute "content"

           -- Image support with optional width/maxwidth
           , Markdown.Html.tag "img"
               (\src width_ maxWidth_ ->
                   let
                       attrs =
                           case maxWidth_ of
                               Just maxWidth ->
                                   [ maxWidth
                                       |> String.toInt
                                       |> Maybe.map (\w -> Element.width (Element.fill |> Element.maximum w))
                                       |> Maybe.withDefault (Element.width Element.fill)
                                   , Element.centerX
                                   ]

                               Nothing ->
                                   [ width_
                                       |> Maybe.andThen String.toInt
                                       |> Maybe.map (\w -> Element.width (Element.px w))
                                       |> Maybe.withDefault (Element.width Element.fill)
                                   ]
                   in
                   Element.image attrs { src = src, description = "" }
               )
               |> Markdown.Html.withAttribute "src"
               |> Markdown.Html.withOptionalAttribute "width"
               |> Markdown.Html.withOptionalAttribute "maxwidth"

           , Markdown.Html.tag "br" (Element.html <| Html.br [] [])
           ]
    -}
    , text = \s -> Element.el [] (Element.text s)
    , codeSpan =
        \content ->
            Element.html
                (Html.code
                    [ Html.Attributes.style "color"
                        (if theme == Render.Theme.Dark then
                            "#6BA4F5"

                         else
                            "#220cb0"
                        )
                    , Html.Attributes.style "background-color"
                        (if theme == Render.Theme.Dark then
                            "#2E3337"

                         else
                            "#f5f5f5"
                        )
                    , Html.Attributes.style "padding" "2px 4px"
                    , Html.Attributes.style "border-radius" "3px"
                    ]
                    [ Html.text content ]
                )
    , strong = \list -> Element.paragraph [ Element.Font.bold ] list
    , emphasis = \list -> Element.paragraph [ Element.Font.italic ] list
    , hardLineBreak = Element.html (Html.br [] [])
    , link =
        \{ title, destination } list ->
            Element.link
                [ Element.Font.underline
                , Element.Font.color themeColors.link
                ]
                { url = destination
                , label =
                    case title of
                        Just title_ ->
                            Element.text title_

                        Nothing ->
                            Element.paragraph [] list
                }
    , image =
        \{ alt, src, title } ->
            let
                attrs =
                    [ title |> Maybe.map (\title_ -> Element.htmlAttribute (Html.Attributes.attribute "title" title_)) ]
                        |> List.filterMap identity
            in
            Element.image
                attrs
                { src = src
                , description = alt
                }
    , unorderedList =
        \items ->
            Element.column
                [ Element.spacing 15
                , Element.width Element.fill
                , Element.paddingEach { top = 0, right = 0, bottom = 20, left = 0 }
                ]
                (items
                    |> List.map
                        (\listItem ->
                            case listItem of
                                ListItem _ children ->
                                    Element.wrappedRow
                                        [ Element.spacing 5
                                        , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 20 }
                                        , Element.width Element.fill
                                        ]
                                        [ Element.paragraph
                                            [ Element.alignTop ]
                                            (Element.text " • " :: children)
                                        ]
                        )
                )
    , orderedList =
        \startingIndex items ->
            Element.column
                [ Element.spacing 15
                , Element.width Element.fill
                , Element.paddingEach { top = 0, right = 0, bottom = 20, left = 0 }
                ]
                (items
                    |> List.indexedMap
                        (\index itemBlocks ->
                            Element.wrappedRow
                                [ Element.spacing 5
                                , Element.paddingEach { top = 0, right = 0, bottom = 0, left = 20 }
                                , Element.width Element.fill
                                ]
                                [ Element.paragraph
                                    [ Element.alignTop ]
                                    (Element.text (String.fromInt (startingIndex + index) ++ ". ") :: itemBlocks)
                                ]
                        )
                )
    , codeBlock =
        \{ body, language } ->
            case language of
                Just "math" ->
                    -- Render math blocks using KaTeX
                    Element.html <|
                        Html.node "math-text"
                            [ Html.Attributes.property "content" (Json.Encode.string body)
                            , Html.Attributes.property "display" (Json.Encode.bool True)
                            , Html.Attributes.attribute "theme"
                                (if theme == Render.Theme.Dark then
                                    "dark"

                                 else
                                    "light"
                                )
                            ]
                            []

                _ ->
                    -- Regular code block
                    let
                        numberOfLines =
                            String.lines body
                                |> List.length
                                |> toFloat
                                |> (\x -> 1.35 * x)
                                |> round

                        bgColor =
                            if theme == Render.Theme.Dark then
                                Element.rgb255 46 51 55

                            else
                                Element.rgb255 245 245 245

                        textColor =
                            if theme == Render.Theme.Dark then
                                Element.rgb255 180 200 220

                            else
                                Element.rgb255 34 12 176
                    in
                    Element.column
                        [ Element.Font.family [ Element.Font.monospace ]
                        , Element.Font.size 14
                        , Element.Font.color textColor
                        , Element.Background.color bgColor
                        , Element.Border.rounded 5
                        , Element.padding 12
                        , Element.width Element.fill
                        , Element.height (Element.px <| 16 * numberOfLines + 24)
                        , Element.htmlAttribute (Html.Attributes.class "preserve-white-space")
                        , Element.htmlAttribute (Html.Attributes.style "line-height" "1.4")
                        , Element.scrollbarX
                        ]
                        [ Element.html (Html.text body) ]
    , thematicBreak =
        Element.el
            [ Element.width Element.fill
            , Element.height (Element.px 1)
            , Element.Background.color themeColors.grey
            , Element.paddingEach { top = 10, bottom = 10, left = 0, right = 0 }
            ]
            Element.none
    , table = \children -> Element.column [ Element.width Element.fill ] children
    , tableHeader = \children -> Element.column [] children
    , tableBody = \children -> Element.column [] children
    , tableRow = \children -> Element.row [ Element.width Element.fill ] children
    , tableCell = \_ children -> Element.column [ Element.width Element.fill, Element.padding 5 ] children
    , tableHeaderCell =
        \_ children ->
            Element.column
                [ Element.width Element.fill
                , Element.padding 5
                , Element.Font.bold
                ]
                children
    , strikethrough = \children -> Element.paragraph [ Element.Font.strike ] children
    }


heading :
    { defaultText : Element.Color
    , headingText : Element.Color
    , mutedText : Element.Color
    , link : Element.Color
    , lightGrey : Element.Color
    , grey : Element.Color
    }
    -> { level : HeadingLevel, rawText : String, children : List (Element msg) }
    -> Element msg
heading theme { level, rawText, children } =
    Element.paragraph
        ((case Markdown.Block.headingLevelToInt level of
            1 ->
                [ Element.Font.size 36
                , Element.Font.semiBold
                , Element.Font.color theme.headingText
                , Element.paddingEach { top = 40, right = 0, bottom = 30, left = 0 }
                ]

            2 ->
                [ Element.Font.color theme.headingText
                , Element.Font.size 28
                , Element.Font.semiBold
                , Element.paddingEach { top = 20, right = 0, bottom = 20, left = 0 }
                ]

            3 ->
                [ Element.Font.color theme.headingText
                , Element.Font.size 20
                , Element.Font.semiBold
                , Element.paddingEach { top = 10, right = 0, bottom = 10, left = 0 }
                ]

            4 ->
                [ Element.Font.color theme.headingText
                , Element.Font.size 16
                , Element.Font.medium
                , Element.paddingEach { top = 0, right = 0, bottom = 10, left = 0 }
                ]

            _ ->
                [ Element.Font.size 12
                , Element.Font.medium
                , Element.Font.center
                , Element.paddingXY 0 20
                ]
         )
            ++ [ Element.Region.heading (Markdown.Block.headingLevelToInt level)
               , Element.htmlAttribute
                    (Html.Attributes.attribute "name" (rawTextToId rawText))
               , Element.htmlAttribute
                    (Html.Attributes.id (rawTextToId rawText))
               ]
        )
        children


rawTextToId : String -> String
rawTextToId rawText =
    rawText
        |> String.toLower
        |> String.replace " " "-"
        |> String.replace "." ""



-- HTML renderer for export


htmlRenderer : Render.Theme.Theme -> Markdown.Renderer.Renderer (Html msg)
htmlRenderer theme =
    Markdown.Renderer.defaultHtmlRenderer
