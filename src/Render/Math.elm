module Render.Math exposing
    ( DisplayMode(..)
    , aligned
    , array
    , chem
    , displayedMath
    , equation
    , evalMath
    , mathText
    , textarray
    , translateMathText
    )

import Dict exposing (Dict)
import ETeX.Transform
import Either exposing (Either(..))
import Element exposing (Element)
import Element.Font as Font
import Generic.Acc exposing (Accumulator)
import Generic.Language exposing (ExpressionBlock)
import Generic.MathMacro
import Generic.PTextMacro
import Generic.TextMacro
import Html exposing (Html)
import Html.Attributes as HA
import Html.Keyed
import Json.Encode
import List.Extra
import Render.Settings exposing (RenderSettings)
import Render.Sync
import Render.ThemeHelpers
import Render.Utility
import ScriptaV2.Msg exposing (MarkupMsg(..))


type DisplayMode
    = InlineMathMode
    | DisplayMathMode


chem : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
chem count acc settings attrs_ block =
    let
        newBlock =
            case block.body of
                Left s ->
                    { block | body = Left ("\\ce{" ++ s ++ "}") }

                Right _ ->
                    block
    in
    displayedMath count acc settings attrs_ newBlock


displayedMath : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
displayedMath count acc settings attrs_ block =
    let
        w =
            String.fromInt settings.width ++ "px"

        attrs =
            Element.width (Element.px settings.width) :: attrs_

        filteredLines =
            -- lines of math text to be rendered: filter stuff out
            String.lines (getContent block)
                |> List.filter (\line -> not (String.left 2 (String.trim line) == "$$"))
                |> List.filter (\line -> not (String.left 6 line == "[label"))
                |> List.filter (\line -> line /= "")
                |> List.map (ETeX.Transform.evalStr acc.mathMacroDict)
    in
    Element.column attrs
        [ Element.el (Render.Sync.highlighter block.args [ Element.centerX ])
            (mathText (Render.ThemeHelpers.themeAsStringFromSettings settings) count w block.meta.id DisplayMathMode (filteredLines |> String.join "\n"))
        ]


getContent : ExpressionBlock -> String
getContent { body } =
    case body of
        Left str ->
            str

        Right _ ->
            ""


equation : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
equation count acc settings attrs block =
    let
        isNumbered =
            List.member "numbered" block.args

        labelWidth =
            if isNumbered then
                60

            else
                0

        contentWidth =
            settings.width - labelWidth

        evalMacro line =
            if String.right 2 line == "\\\\" then
                line
                    |> String.dropRight 2
                    |> ETeX.Transform.evalStr acc.mathMacroDict
                    |> (\str -> str ++ "\\\\")

            else
                line |> ETeX.Transform.evalStr acc.mathMacroDict

        filteredLines =
            -- lines of math text to be rendered: filter stuff out
            String.lines (getContent block)
                |> List.map String.trimRight
                |> List.filter (\line -> not (String.left 2 line == "$$") && not (String.left 6 line == "[label") && not (line == "end"))
                |> List.map (ETeX.Transform.evalStr acc.mathMacroDict)

        content =
            String.join "\n" filteredLines

        label : Element msg
        label =
            if isNumbered then
                equationLabel block.properties

            else
                Element.none
    in
    Element.row []
        [ Element.el [ Element.width <| Element.px contentWidth ]
            (Element.el [ Element.centerX, Element.moveRight (toFloat labelWidth / 2) ] (mathText (Render.ThemeHelpers.themeAsStringFromSettings settings) count (String.fromInt contentWidth) block.meta.id DisplayMathMode content))
        , Element.el [ Element.width <| Element.px labelWidth ]
            (Element.el [ Element.alignRight ] label)
        ]


highlightMath : RenderSettings -> ExpressionBlock -> List (Element.Attr () msg)
highlightMath settings block =
    Render.Sync.highlightIfIdSelected block.meta.id
        settings
        (Render.Sync.highlighter block.args
            []
        )


equationLabel properties =
    let
        labelText =
            "(" ++ (Dict.get "equation-number" properties |> Maybe.withDefault "-") ++ ")"

        label_ =
            Element.el [ Font.size 12 ] (Element.text labelText)
    in
    --showIf settings content label_
    label_


showIf : Render.Settings.RenderSettings -> String -> Element msg -> Element msg
showIf settings content element =
    if Render.Utility.textWidth settings.display content > (toFloat settings.width - 140) then
        Element.none

    else
        element


getCounter : String -> Dict String Int -> String
getCounter counterName dict =
    Dict.get counterName dict |> Maybe.withDefault 0 |> String.fromInt


getLabel : String -> Dict String String -> String
getLabel label dict =
    Dict.get label dict |> Maybe.withDefault "" |> String.trim


aligned : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
aligned count acc settings attrs block =
    let
        str =
            case block.body of
                Left str_ ->
                    str_

                Right _ ->
                    ""

        filteredLines =
            -- filter stuff out of lines of math text to be rendered:
            String.lines str
                |> List.filter (\line -> not (String.left 6 line == "\\label") && not (line == ""))

        deleteTrailingSlashes inputString =
            let
                str_ =
                    String.trim inputString
            in
            if String.right 2 str_ == "\\\\" then
                String.dropRight 2 str_

            else
                str_

        adjustedLines_ =
            -- delete trailing slashes before evaluating macros
            List.map (deleteTrailingSlashes >> ETeX.Transform.evalStr acc.mathMacroDict) filteredLines
                -- remove bank lines
                |> List.filter (\line -> String.trim line /= "")

        innerContent =
            -- restore trailing slashes
            adjustedLines_
                |> String.join "\\\\\n"

        content =
            "\\begin{aligned}\n" ++ innerContent ++ "\n\\end{aligned}"

        label =
            equationLabel block.properties
    in
    Element.column ([ Element.width (Element.px settings.width) ] ++ attrs ++ Render.Sync.attributes settings block)
        [ Element.row
            -- [ Element.width (Element.px settings.width) ]
            [ Element.width (Element.px settings.width) ]
            [ Element.el
                (Element.centerX :: highlightMath settings block)
                (mathText (Render.ThemeHelpers.themeAsStringFromSettings settings) count str block.meta.id DisplayMathMode content)
            ]
        ]


deltaY lines =
    12 * List.length lines |> toFloat


array : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
array count acc settings attrs block =
    let
        format : String
        format =
            block.args
                |> List.head
                |> Maybe.withDefault ""

        -- |> String.replace " " ""
        str =
            case block.body of
                Left str_ ->
                    str_

                Right _ ->
                    ""

        filteredLines : List String
        filteredLines =
            -- filter stuff out of lines of math text to be rendered:
            String.lines str
                |> List.filter (\line -> not (String.left 6 line == "[label") && not (line == ""))

        deleteTrailingSlashes inputString =
            let
                str_ =
                    String.trim inputString
            in
            if String.right 2 str_ == "\\\\" then
                String.dropRight 2 str_

            else
                str_

        adjustedLines_ : List String
        adjustedLines_ =
            -- delete trailing slashes before evaluating macros
            List.map (deleteTrailingSlashes >> ETeX.Transform.evalStr acc.mathMacroDict) filteredLines
                -- remove bank lines
                |> List.filter (\line -> line /= "")

        innerContent =
            -- restore trailing slashes
            adjustedLines_
                |> String.join "\\\\\n"

        content =
            "\\begin{array}{" ++ format ++ "}\n" ++ innerContent ++ "\n\\end{array}"

        label =
            equationLabel block.properties
    in
    Element.column ([ Element.width (Element.px settings.width) ] ++ attrs)
        [ Element.row
            (Element.width (Element.px settings.width) :: Render.Sync.attributes settings block)
            [ Element.el
                (Element.centerX :: Render.Sync.attributes settings block)
                (mathText (Render.ThemeHelpers.themeAsStringFromSettings settings) count str block.meta.id DisplayMathMode content)
            ]
        ]


textarray : Int -> Accumulator -> RenderSettings -> List (Element.Attribute MarkupMsg) -> ExpressionBlock -> Element MarkupMsg
textarray count acc settings attrs block =
    let
        format : String
        format =
            block.args
                |> List.Extra.getAt 1
                |> Maybe.withDefault defaultFormat

        str =
            case block.body of
                Left str_ ->
                    str_

                Right _ ->
                    ""

        filteredLines =
            -- filter stuff out of lines of math text to be rendered:
            String.lines str
                |> List.filter (\line -> not (String.left 6 line == "[label") && not (line == ""))
                |> List.map fixrow

        mNumberOfColumns =
            filteredLines
                |> List.head
                |> Maybe.map (String.split "&")
                |> Maybe.map List.length

        defaultFormat =
            case mNumberOfColumns of
                Nothing ->
                    ""

                Just n ->
                    List.repeat n "c" |> String.join ""

        fixrow : String -> String
        fixrow str_ =
            str_
                |> String.split "&"
                |> List.map String.trim
                |> List.map (\s -> "\\text{" ++ s ++ "}")
                |> String.join " & "

        deleteTrailingSlashes inputString =
            let
                str_ =
                    String.trim inputString
            in
            if String.right 2 str_ == "\\\\" then
                String.dropRight 2 str_

            else
                str_

        adjustedLines_ =
            -- delete trailing slashes before evaluating macros
            List.map (deleteTrailingSlashes >> ETeX.Transform.evalStr acc.mathMacroDict) filteredLines
                -- remove bank lines
                |> List.filter (\line -> line /= "")

        innerContent =
            -- restore trailing slashes
            adjustedLines_
                |> String.join "\\\\\n"

        content =
            "\\begin{array}{"
                ++ format
                ++ "}\n"
                ++ innerContent
                ++ "\n\\end{array}"
    in
    Element.column ([ Element.width (Element.px settings.width) ] ++ attrs)
        [ Element.row
            (Element.width (Element.px settings.width) :: Render.Sync.attributes settings block)
            [ Element.el
                (Element.centerX :: Render.Sync.attributes settings block)
                (mathText (Render.ThemeHelpers.themeAsStringFromSettings settings) count str block.meta.id DisplayMathMode content)
            ]
        ]


mathText : String -> Int -> String -> String -> DisplayMode -> String -> Element msg
mathText theme generation width id displayMode content =
    -- TODO Track this down at the source.
    Html.Keyed.node "span"
        [ HA.style "padding-top" "0px"
        , HA.style "padding-bottom" "0px"
        , HA.id id
        ]
        [ ( String.fromInt generation, mathText_ theme displayMode (eraseLabeMacro content) )
        ]
        |> Element.html


eraseLabeMacro content =
    content |> String.lines |> List.map (Generic.PTextMacro.eraseLeadingMacro "label") |> String.join "\n"


translateMathText : String -> String
translateMathText content =
    content
        |> String.words
        |> List.map translateWord
        |> String.join " "


translateWord : String -> String
translateWord word =
    if word == "pi" then
        "\\pi"

    else
        word


mathText_ : String -> DisplayMode -> String -> Html msg
mathText_ theme displayMode content =
    Html.node "math-text"
        [ HA.property "display" (Json.Encode.bool (isDisplayMathMode displayMode))
        , HA.property "content" (Json.Encode.string content)
        , HA.attribute "theme" theme
        ]
        []


evalMath :
    Int
    -> { a | id : String }
    -> String
    -> Element msg
evalMath generation gogo content =
    -- TODO Track this down at the source.
    Html.Keyed.node "span"
        [ HA.style "padding-top" "0px"
        , HA.style "padding-bottom" "0px"
        , HA.id gogo.id
        ]
        [ ( String.fromInt generation, evalMath_ content )
        ]
        |> Element.html


evalMath_ : String -> Html msg
evalMath_ content =
    Html.node "mathjs-compute"
        [ HA.property "content" (Json.Encode.string content)
        ]
        []


isDisplayMathMode : DisplayMode -> Bool
isDisplayMathMode displayMode =
    case displayMode of
        InlineMathMode ->
            False

        DisplayMathMode ->
            True
