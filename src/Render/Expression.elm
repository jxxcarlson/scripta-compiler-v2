module Render.Expression exposing (nonstandardElements, render)

import Dict exposing (Dict)
import Element exposing (Element, column, el, newTabLink, spacing)
import Element.Background as Background
import Element.Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Generic.ASTTools as ASTTools
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (Expr(..), Expression)
import Generic.MathMacro
import Html
import Html.Attributes
import List.Extra
import Maybe.Extra
import MicroScheme.Interpreter
import Render.Graphics
import Render.Math
import Render.Msg exposing (MarkupMsg(..))
import Render.Settings exposing (RenderSettings)
import Render.Utility as Utility


render : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> Expression -> Element MarkupMsg
render generation acc settings attrs expr =
    case expr of
        Text string meta ->
            Element.el ([ Events.onClick (SendMeta meta), htmlId meta.id ] ++ attrs) (Element.text string)

        Fun name exprList meta ->
            Element.el [ htmlId meta.id ] (renderMarked name generation acc settings attrs exprList)

        VFun name str meta ->
            renderVerbatim name generation acc settings meta str


renderVerbatim name generation acc settings meta str =
    case Dict.get name verbatimDict of
        Nothing ->
            errorText 1 name

        Just f ->
            f generation acc settings meta str


renderMarked name generation acc settings attrs exprList =
    case Dict.get name markupDict of
        Nothing ->
            Element.paragraph [ spacing 8 ]
                (Element.el [ Background.color errorBackgroundColor, Element.paddingXY 4 2 ]
                    (Element.text name)
                    :: List.map (render generation acc settings attrs) exprList
                )

        Just f ->
            f generation acc settings attrs exprList


errorBackgroundColor =
    Element.rgb 1 0.8 0.8



-- DICTIONARIES


markupDict :
    Dict
        String
        (Int
         -> Accumulator
         -> RenderSettings
         -> List (Element.Attribute MarkupMsg)
         -> List Expression
         -> Element MarkupMsg
        )
markupDict =
    Dict.fromList
        [ ( "bibitem", \_ _ _ attr exprList -> bibitem exprList )

        -- STYLE
        , ( "scheme", \g acc s attr exprList -> renderScheme g acc s attr exprList )
        , ( "button", \g acc s attr exprList -> renderButton g acc s attr exprList )
        , ( "strong", \g acc s attr exprList -> strong g acc s attr exprList )
        , ( "bold", \g acc s attr exprList -> strong g acc s attr exprList )
        , ( "textbf", \g acc s attr exprList -> strong g acc s attr exprList )
        , ( "b", \g acc s attr exprList -> strong g acc s attr exprList )
        , ( "var", \g acc s attr exprList -> var g acc s attr exprList )
        , ( "italic", \g acc s attr exprList -> italic g acc s attr exprList )
        , ( "textit", \g acc s attr exprList -> italic g acc s attr exprList )
        , ( "bi", \g acc s attr exprList -> boldItalic g acc s attr exprList )
        , ( "i", \g acc s attr exprList -> italic g acc s attr exprList )
        , ( "boldItalic", \g acc s attr exprList -> boldItalic g acc s attr exprList )
        , ( "strike", \g acc s attr exprList -> strike g acc s attr exprList )
        , ( "underscore", \g acc s attr exprList -> underscore g acc s attr exprList )
        , ( "ref", \_ acc _ attr exprList -> ref acc exprList )
        , ( "reflink", \_ acc _ attr exprList -> reflink acc exprList )
        , ( "eqref", \_ acc _ attr exprList -> eqref acc exprList )
        , ( "underline", \g acc s attr exprList -> underline g acc s attr exprList )
        , ( "hide", \_ _ _ _ _ -> Element.none )
        , ( "author", \_ _ _ _ _ -> Element.none )
        , ( "date", \_ _ _ _ _ -> Element.none )
        , ( "today", \_ _ _ _ _ -> Element.none )
        , ( "comment", \g acc s attr exprList -> blue g acc s attr exprList )
        , ( "lambda", \_ _ _ _ _ -> Element.none )
        , ( "hrule"
          , \_ _ s _ _ ->
                Element.column
                    [ Element.width (Element.px s.width)
                    ]
                    [ Element.el
                        [ Element.Border.width 1
                        , Element.width (Element.px s.width)
                        , Element.centerX
                        , Element.Border.color (Element.rgb 0.75 0.75 0.75)
                        ]
                        (Element.text "")
                    ]
          )

        -- LATEX
        -- , ( "title", \g acc s attr  exprList -> title g acc s attr exprList )
        , ( "setcounter", \_ _ _ _ _ -> Element.none )

        -- COLOR
        , ( "red", \g acc s attr exprList -> red g acc s attr exprList )
        , ( "blue", \g acc s attr exprList -> blue g acc s attr exprList )
        , ( "green", \g acc s attr exprList -> green g acc s attr exprList )
        , ( "pink", \g acc s attr exprList -> pink g acc s attr exprList )
        , ( "magenta", \g acc s attr exprList -> magenta g acc s attr exprList )
        , ( "violet", \g acc s attr exprList -> violet g acc s attr exprList )
        , ( "highlight", \g acc s attr exprList -> highlight g acc s attr exprList )
        , ( "gray", \g acc s attr exprList -> gray g acc s attr exprList )
        , ( "errorHighlight", \g acc s attr exprList -> errorHighlight g acc s attr exprList )

        --
        --, ( "skip", \_ _ _ exprList -> skip exprList )
        , ( "link", \g acc s attr exprList -> link g acc s attr exprList )
        , ( "href", \g acc s attr exprList -> href g acc s attr exprList )
        , ( "ilink", \g acc s attr exprList -> ilink g acc s attr exprList )
        , ( "ulink", \g acc s attr exprList -> ulink g acc s attr exprList )
        , ( "cslink", \g acc s attr exprList -> cslink g acc s attr exprList )
        , ( "abstract", \g acc s attr exprList -> abstract g acc s attr exprList )
        , ( "large", \g acc s attr exprList -> large g acc s attr exprList )
        , ( "mdash", \_ _ _ _ _ -> Element.el [] (Element.text "—") )
        , ( "ndash", \_ _ _ _ _ -> Element.el [] (Element.text "–") )
        , ( "label", \_ _ _ _ _ -> Element.none )
        , ( "cite", \_ acc _ attr exprList -> cite acc attr exprList )
        , ( "table", \g acc s attr exprList -> table g acc s attr exprList )
        , ( "image", \_ _ s attr exprList -> Render.Graphics.image s attr exprList )
        , ( "tags", \_ _ _ _ _ -> Element.none )
        , ( "vspace", vspace )

        -- , ( "par", par )
        -- MiniLaTeX stuff
        , ( "term", \g acc s attr exprList -> term g acc s attr exprList )
        , ( "term_", \_ _ _ _ _ -> Element.none )
        , ( "footnote", \_ acc _ attr exprList -> footnote acc exprList )
        , ( "emph", \g acc s attr exprList -> emph g acc s attr exprList )

        -- , ( "group", \g acc s attr  exprList -> identityFunction g acc s attr exprList )
        --
        , ( "dollarSign", \_ _ _ _ _ -> Element.el [] (Element.text "$") )
        , ( "dollar", \_ _ _ _ _ -> Element.el [] (Element.text "$") )
        , ( "brackets", \g acc s attr exprList -> brackets g acc s attr exprList )
        , ( "rb", \_ _ _ _ _ -> rightBracket )
        , ( "lb", \_ _ _ _ _ -> leftBracket )
        , ( "bt", \_ _ _ _ _ -> backTick )
        , ( "ds", \_ _ _ _ _ -> Element.el [] (Element.text "$") )

        --, ( "bs", \g acc s attr  exprList -> Element.paragraph [] (Element.text "\\" :: List.map (render g acc s) exprList) )
        -- , ( "texarg", \g acc s attr  exprList -> Element.paragraph [] ((Element.text "{" :: List.map (render g acc s) exprList) ++ [ Element.text " }" ]) )
        , ( "backTick", \_ _ _ _ _ -> Element.el [] (Element.text "`") )
        ]


verbatimDict =
    Dict.fromList
        [ ( "$", \g a _ m str -> math g a m str )
        , ( "`", \_ _ s m str -> code s m str )
        , ( "code", \_ _ s m str -> code s m str )
        , ( "math", \g a _ m str -> math g a m str )
        ]


nonstandardElements =
    [ "button" ]



-- FUNCTIONS


identityFunction g acc s attrs exprList =
    Element.paragraph [] (List.map (render g acc s attrs) exprList)


abstract g acc s attr exprList =
    Element.paragraph [] [ Element.el [ Font.size 18 ] (Element.text "Abstract."), simpleElement [] g acc s attr exprList ]


large : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> List Expression -> Element MarkupMsg
large g acc s attr exprList =
    simpleElement [ Font.size 18 ] g acc s attr exprList


link : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> List Expression -> Element MarkupMsg
link _ _ _ attr exprList =
    case List.head <| ASTTools.exprListToStringList exprList of
        Nothing ->
            errorText_ "Please provide label and url"

        Just argString ->
            let
                args =
                    String.words argString

                n =
                    List.length args
            in
            if n == 0 then
                errorText_ "Please provide url"

            else if n == 1 then
                let
                    url =
                        argString

                    label =
                        argString |> String.replace "https://" "" |> String.replace "http://" ""
                in
                newTabLink []
                    { url = url
                    , label = el [ Font.color linkColor ] (Element.text label)
                    }

            else
                let
                    label =
                        List.take (n - 1) args |> String.join " "

                    url =
                        List.drop (n - 1) args |> String.join " "
                in
                newTabLink []
                    { url = url
                    , label = el [ Font.color linkColor ] (Element.text label)
                    }


href : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> List Expression -> Element MarkupMsg
href _ _ _ attr exprList =
    let
        url =
            List.Extra.getAt 0 exprList |> Maybe.andThen ASTTools.getText |> Maybe.withDefault ""

        label =
            List.Extra.getAt 1 exprList |> Maybe.andThen ASTTools.getText |> Maybe.withDefault ""
    in
    newTabLink []
        { url = url
        , label = el [ Font.color linkColor ] (Element.text label)
        }


{-|

    An ilink element ("internal link") links to another scripta document.

    Usage: [ilink LINK TEXT USERNAME:SLUG]

    Example: [ilink Read more about it here. jxxcarlson:smart-folders]

-}
ilink _ _ _ attr exprList =
    case List.head <| ASTTools.exprListToStringList exprList of
        Nothing ->
            errorText_ "Please provide label and url"

        Just argString ->
            let
                args =
                    String.words argString

                n =
                    List.length args

                slug =
                    List.Extra.last args |> Maybe.withDefault "((nothing))"

                label =
                    List.take (n - 1) args |> String.join " "
            in
            Input.button attr
                { onPress = Just (GetDocumentWithSlug Render.Msg.MHStandard slug)
                , label = Element.el [ Element.centerX, Element.centerY, Font.size 14, Font.color (Element.rgb 0 0 0.8) ] (Element.text label)
                }


ulink _ _ _ attr exprList =
    case List.head <| ASTTools.exprListToStringList exprList of
        Nothing ->
            errorText_ "Please provide label and url"

        Just argString ->
            let
                args =
                    String.words argString

                n =
                    List.length args

                label =
                    List.take (n - 1) args |> String.join " "

                fragment =
                    List.drop (n - 1) args |> String.join " "

                username =
                    String.split ":" fragment |> List.head |> Maybe.withDefault "---"
            in
            Input.button attr
                { onPress = Just (GetPublicDocumentFromAuthor Render.Msg.MHStandard username fragment)
                , label = Element.el [ Element.centerX, Element.centerY, Font.size 14, Font.color (Element.rgb 0 0 0.8) ] (Element.text label)
                }


cslink _ _ _ attr exprList =
    case List.head <| ASTTools.exprListToStringList exprList of
        Nothing ->
            errorText_ "Please: id or slug"

        Just argString ->
            let
                args =
                    String.words argString

                n =
                    List.length args

                label =
                    List.take (n - 1) args |> String.join " "

                fragment =
                    List.drop (n - 1) args |> String.join " "

                username =
                    String.split ":" fragment |> List.head |> Maybe.withDefault "---"
            in
            Input.button attr
                { onPress = Just (GetPublicDocumentFromAuthor Render.Msg.MHAsCheatSheet username fragment)
                , label = Element.el [ Element.centerX, Element.centerY, Font.size 14, Font.color (Element.rgb 0 0 0.8) ] (Element.text label)
                }


bibitem : List Expression -> Element MarkupMsg
bibitem exprs =
    Element.paragraph [ Element.width Element.fill ] [ Element.text (ASTTools.exprListToStringList exprs |> String.join " " |> (\s -> "[" ++ s ++ "]")) ]


cite : Accumulator -> List (Element.Attribute MarkupMsg) -> List Expression -> Element MarkupMsg
cite acc attr str =
    let
        tag : String
        tag =
            ASTTools.exprListToStringList str |> String.join ""

        id =
            Dict.get tag acc.reference |> Maybe.map .id |> Maybe.withDefault ""
    in
    Element.paragraph
        ([ Element.width Element.fill

         -- , Events.onClick (SendLineNumber _)
         , Events.onClick (SelectId id)
         , Font.color (Element.rgb 0.2 0.2 1.0)
         ]
            ++ attr
        )
        [ Element.text (tag |> (\s -> "[" ++ s ++ "]")) ]


code s m str =
    verbatimElement (codeStyle s) m str


math g a m str =
    mathElement g a m str


table : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> List Expression -> Element MarkupMsg
table g acc s attr rows =
    Element.column [ Element.spacing 8 ] (List.map (tableRow g acc s attr) rows)


tableRow : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> Expression -> Element MarkupMsg
tableRow g acc s attr expr =
    case expr of
        Fun "tableRow" items _ ->
            Element.row [ spacing 8 ] (List.map (tableItem g acc s attr) items)

        _ ->
            Element.none


tableItem : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> Expression -> Element MarkupMsg
tableItem g acc s attr expr =
    case expr of
        Fun "tableItem" exprList _ ->
            Element.paragraph [ Element.width (Element.px 100) ] (List.map (render g acc s attr) exprList)

        _ ->
            Element.none


skip exprList =
    let
        numVal : String -> Int
        numVal str =
            String.toInt str |> Maybe.withDefault 0

        f : String -> Element MarkupMsg
        f str =
            column [ Element.spacingXY 0 (numVal str) ] [ Element.text "" ]
    in
    f1 f exprList


vspace _ _ _ _ exprList =
    let
        h =
            ASTTools.exprListToStringList exprList |> String.join "" |> String.toInt |> Maybe.withDefault 1
    in
    -- Element.column [ Element.paddingXY 0 100 ] (Element.text "-")
    Element.column [ Element.height (Element.px h) ] [ Element.text "" ]


par _ _ _ _ attr =
    Element.column ([ Element.height (Element.px 15) ] ++ attr) [ Element.text "" ]


strong g acc s attr exprList =
    simpleElement [ Font.bold ] g acc s attr exprList


renderScheme g acc s attr exprList =
    let
        inputText : String
        inputText =
            ASTTools.exprListToStringList exprList |> String.join " "
    in
    Element.text (MicroScheme.Interpreter.runProgram ";" inputText)


renderButton _ _ _ attr exprList =
    let
        arguments : List String
        arguments =
            ASTTools.exprListToStringList exprList
                |> String.join " "
                |> String.split ","
                |> List.map (\item -> String.trim item)
                |> List.filter (\item -> item /= "")
    in
    case arguments of
        [ labelText, rawMsg ] ->
            case Dict.get rawMsg msgDict of
                Nothing ->
                    Input.button attr { onPress = Just MMNoOp, label = Element.text "Nothing (1)" }

                Just msg ->
                    Input.button
                        ([ Font.size 14
                         , Font.color (Element.rgb 1 1 1)
                         , Element.padding 8
                         , Background.color (Element.rgb 0.1 0.1 0.9)
                         ]
                            ++ attr
                        )
                        { onPress = Just msg, label = Element.text labelText }

        _ ->
            Input.button [] { onPress = Just MMNoOp, label = Element.text "Nothing (2)" }


msgDict : Dict String MarkupMsg
msgDict =
    Dict.fromList
        [ ( "CopyDocument", RequestCopyOfDocument )
        , ( "ToggleIndex", RequestToggleIndexSize )
        ]


var g acc s attr exprList =
    simpleElement [] g acc s attr exprList


brackets g acc s attr exprList =
    Element.paragraph [ Element.spacing 8 ] [ Element.text "[", simpleElement [] g acc s attr exprList, Element.text " ]" ]


rightBracket =
    Element.text "]"


leftBracket =
    Element.text "["


backTick =
    Element.text "`"


italic g acc s attr exprList =
    simpleElement [ Font.italic, Element.paddingEach { left = 0, right = 2, top = 0, bottom = 0 } ] g acc s attr exprList


boldItalic g acc s attr exprList =
    simpleElement [ Font.italic, Font.bold, Element.paddingEach { left = 0, right = 2, top = 0, bottom = 0 } ] g acc s attr exprList


title g acc s attr exprList =
    simpleElement [ Font.size 36, Element.paddingEach { left = 0, right = 2, top = 0, bottom = 0 } ] g acc s attr exprList


term g acc s attr exprList =
    simpleElement [ Font.italic, Element.paddingEach { left = 0, right = 2, top = 0, bottom = 0 } ] g acc s attr exprList


footnote acc exprList =
    case exprList of
        (Text _ meta) :: [] ->
            case Dict.get meta.id acc.footnoteNumbers of
                Just k ->
                    Element.link
                        [ Font.color (Element.rgb 0 0 0.7)
                        , Font.bold
                        , Events.onClick (SelectId (meta.id ++ "_"))
                        ]
                        { url = Utility.internalLink (meta.id ++ "_")
                        , label = Element.el [] (Element.html <| Html.node "sup" [] [ Html.text (String.fromInt k) ])
                        }

                -- Element.el (htmlId meta.id :: []) (Element.text (String.fromInt k))
                _ ->
                    Element.none

        _ ->
            Element.none



-- Element.el (htmlId meta.id :: formatList) (Element.text str)


emph g acc s attr exprList =
    simpleElement [ Font.italic, Element.paddingEach { left = 0, right = 2, top = 0, bottom = 0 } ] g acc s attr exprList



-- COLOR FUNCTIONS


gray g acc s attr exprList =
    simpleElement [ Font.color (Element.rgb 0.5 0.5 0.5) ] g acc s attr exprList


red g acc s attr exprList =
    simpleElement [ Font.color (Element.rgb255 200 0 0) ] g acc s attr exprList


blue g acc s attr exprList =
    simpleElement [ Font.color (Element.rgb255 0 0 200) ] g acc s attr exprList


green g acc s attr exprList =
    simpleElement [ Font.color (Element.rgb255 0 140 0) ] g acc s attr exprList


magenta g acc s attr exprList =
    simpleElement [ Font.color (Element.rgb255 255 51 192) ] g acc s attr exprList


pink g acc s attr exprList =
    simpleElement [ Font.color (Element.rgb255 255 100 100) ] g acc s attr exprList


violet g acc s attr exprList =
    simpleElement [ Font.color (Element.rgb255 150 100 255) ] g acc s attr exprList


highlight g acc s attr exprList_ =
    let
        colorName =
            ASTTools.filterExpressionsOnName "color" exprList_
                |> List.head
                |> Maybe.andThen ASTTools.getText
                |> Maybe.withDefault "yellow"
                |> String.trim

        exprList =
            ASTTools.filterOutExpressionsOnName "color" exprList_

        colorElement =
            Dict.get colorName colorDict |> Maybe.withDefault (Element.rgb255 255 255 0)
    in
    simpleElement [ Background.color colorElement, Element.paddingXY 6 3 ] g acc s attr exprList


colorDict : Dict String Element.Color
colorDict =
    Dict.fromList
        [ ( "yellow", Element.rgb255 255 255 0 )
        , ( "blue", Element.rgb255 180 180 255 )
        ]


ref : Accumulator -> List Expression -> Element MarkupMsg
ref acc exprList =
    let
        key =
            List.map ASTTools.getText exprList |> Maybe.Extra.values |> String.join "" |> String.trim

        ref_ =
            Dict.get key acc.reference

        val =
            ref_ |> Maybe.map .numRef |> Maybe.withDefault ""

        id =
            ref_ |> Maybe.map .id |> Maybe.withDefault ""
    in
    Element.link
        [ Font.color (Element.rgb 0 0 0.7)
        , Font.bold
        , Events.onClick (SelectId id)
        ]
        { url = Utility.internalLink id
        , label = Element.paragraph [] [ Element.text val ]
        }


{-|

    \reflink{LINK_TEXT LABEL}

-}
reflink : Accumulator -> List Expression -> Element MarkupMsg
reflink acc exprList =
    let
        argString =
            List.map ASTTools.getText exprList |> Maybe.Extra.values |> String.join " "

        args =
            String.words argString

        n =
            List.length args

        key =
            List.drop (n - 1) args |> String.join ""

        label =
            List.take (n - 1) args |> String.join " "

        ref_ =
            Dict.get key acc.reference

        id =
            ref_ |> Maybe.map .id |> Maybe.withDefault ""
    in
    Element.link
        [ Font.color (Element.rgb 0 0 0.7)
        , Events.onClick (SelectId id)
        ]
        { url = Utility.internalLink id
        , label = Element.paragraph [] [ Element.text label ]
        }


eqref : Accumulator -> List Expression -> Element MarkupMsg
eqref acc exprList =
    let
        key =
            List.map ASTTools.getText exprList
                |> Maybe.Extra.values
                |> String.join ""
                |> String.trim
                |> String.replace "label:" ""

        ref_ =
            Dict.get key acc.reference

        val =
            ref_ |> Maybe.map .numRef |> Maybe.withDefault ""

        id =
            ref_ |> Maybe.map .id |> Maybe.withDefault ""
    in
    Element.link
        [ Font.color (Element.rgb 0 0 0.7)
        , Events.onClick (SelectId id)

        --, Events.onClick (HighlightId id)
        ]
        { url = Utility.internalLink id
        , label = Element.paragraph [] [ Element.text ("(" ++ val ++ ")") ]
        }



-- FONT STYLE FUNCTIONS


strike g acc s attr exprList =
    simpleElement [ Font.strike ] g acc s attr exprList


underscore _ _ _ _ _ =
    Element.el [] (Element.text "_")


underline g acc s attr exprList =
    simpleElement [ Font.underline ] g acc s attr exprList


errorHighlight g acc s attr exprList =
    simpleElement [ Background.color (Element.rgb255 255 200 200), Element.paddingXY 4 2 ] g acc s attr exprList



-- HELPERS


simpleElement : List (Element.Attribute MarkupMsg) -> Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> List Expression -> Element MarkupMsg
simpleElement formatList g acc s attr exprList =
    Element.paragraph formatList (List.map (render g acc s attr) exprList)


{-| For one-element functions
-}
f1 : (String -> Element MarkupMsg) -> List Expression -> Element MarkupMsg
f1 f exprList =
    case ASTTools.exprListToStringList exprList of
        -- TODO: temporary fix: parse is producing the args in reverse order
        arg1 :: _ ->
            f arg1

        _ ->
            el [ Font.color errorColor ] (Element.text "Invalid arguments")


verbatimElement formatList meta str =
    Element.el (htmlId meta.id :: formatList) (Element.text str)


htmlId str =
    Element.htmlAttribute (Html.Attributes.id str)


errorText index str =
    Element.el [ Font.color (Element.rgb255 200 40 40) ] (Element.text <| "(" ++ String.fromInt index ++ ") not implemented: " ++ str)


errorText_ str =
    Element.el [ Font.color (Element.rgb255 200 40 40) ] (Element.text str)


mathElement generation acc meta str =
    -- "width" is not used for inline math, but some string needs to be there
    Render.Math.mathText generation "width" meta.id Render.Math.InlineMathMode (Generic.MathMacro.evalStr acc.mathMacroDict str)



-- DEFINITIONS


codeStyle settings =
    [ Font.family
        [ Font.typeface "Inconsolata"
        , Font.monospace
        ]
    , Font.unitalicized
    , Font.color settings.codeColor
    , Element.paddingEach { left = 2, right = 2, top = 0, bottom = 0 }
    ]


errorColor =
    Element.rgb 0.8 0 0


linkColor =
    Element.rgb 0 0 0.8
