module Generic.Language exposing
    ( Block
    , BlockMeta
    , Expr(..)
    , ExprMeta
    , Expression
    , ExpressionBlock
    , Heading(..)
    , PrimitiveBlock
    , SimpleExpressionBlock
    , SimplePrimitiveBlock
    , emptyBlockMeta
    , expressionBlockEmpty
    , getExpressionContent
    , getFunctionName
    , getName
    , getNameFromHeading
    , getVerbatimContent
    , prefixIdInBlockMeta
    , primitiveBlockEmpty
    , setName
    , simplifyBlock
    , simplifyExpr
    , simplifyExpressionBlock
    , simplifyPrimitiveBlock
    , textWidthWithPixelsPerCharacter
    , toExpressionBlock
    , updateMeta
    , updateMetaInBlock
    )

import Dict exposing (Dict)
import Either exposing (Either(..))
import List.Extra
import Tools.Utility



-- PARAMETRIZED TYPES


type Expr metaData
    = Fun String (List (Expr metaData)) metaData
    | VFun String String metaData
    | Text String metaData


{-|

    PrimitiveBlocks, content = String
    ExpressionBlocks, content = Either String (List Expression)

-}
type alias Block content blockMetaData =
    { heading : Heading
    , indent : Int
    , args : List String
    , properties : Dict String String
    , firstLine : String
    , body : content
    , meta : blockMetaData
    }



-- HEADINGS


type Heading
    = Paragraph
    | Ordinary String -- block name
    | Verbatim String -- block name



-- METADATA TYPES


type alias ExprMeta =
    { begin : Int, end : Int, index : Int, id : String }


prefixIdInBlockMeta : String -> BlockMeta -> BlockMeta
prefixIdInBlockMeta prefix meta =
    { meta | id = prefix ++ String.replace prefix "e-" meta.id }


type alias BlockMeta =
    { position : Int
    , lineNumber : Int
    , numberOfLines : Int
    , id : String
    , messages : List String
    , sourceText : String
    , error : Maybe String
    }



-- CONCRETE TYPES


type alias Expression =
    Expr ExprMeta


getMeta : Expression -> ExprMeta
getMeta expr =
    case expr of
        Fun _ _ meta ->
            meta

        VFun _ _ meta ->
            meta

        Text _ meta ->
            meta


setMeta : ExprMeta -> Expression -> Expression
setMeta meta expr =
    case expr of
        Fun name args _ ->
            Fun name args meta

        VFun name arg _ ->
            VFun name arg meta

        Text text _ ->
            Text text meta


updateMeta : (ExprMeta -> ExprMeta) -> Expression -> Expression
updateMeta update expr =
    setMeta (update (getMeta expr)) expr


updateMetaInBlock : (ExprMeta -> ExprMeta) -> ExpressionBlock -> ExpressionBlock
updateMetaInBlock updater block =
    let
        newBody =
            case block.body of
                Left str ->
                    Left str

                Right exprs ->
                    Right (List.map (updateMeta updater) exprs)
    in
    { block | body = newBody }


{-| A block whose content is a list of expressions.
-}
type alias ExpressionBlock =
    Block (Either String (List Expression)) BlockMeta


{-| A block whose content is a list of strings.
-}
type alias PrimitiveBlock =
    Block (List String) BlockMeta


toExpressionBlock : (String -> List Expression) -> PrimitiveBlock -> ExpressionBlock
toExpressionBlock parse block =
    { heading = block.heading
    , indent = block.indent
    , args = block.args
    , properties =
        case block.heading of
            Ordinary "table" ->
                let
                    cellsAsString : List (List String)
                    cellsAsString =
                        String.join "\n" block.body
                            |> String.split "\\\\\n"
                            |> List.map (String.split "&")

                    effectiveFontWidth_ =
                        9.0

                    columnWidths : List Int
                    columnWidths =
                        List.map (List.map (textWidthWithPixelsPerCharacter effectiveFontWidth_)) cellsAsString
                            |> List.Extra.transpose
                            |> List.map (\column -> List.maximum column |> Maybe.withDefault 1)
                            |> List.map round
                in
                block.properties
                    |> Dict.insert "columnWidths" (String.join "," (List.map String.fromInt columnWidths) |> (\x -> "[" ++ x ++ "]"))
                    |> Dict.insert "format" (block.args |> String.join " ")

            _ ->
                block.properties
    , firstLine = block.firstLine
    , body =
        case block.heading of
            Paragraph ->
                Right (parse <| String.join "\n" block.body)

            Ordinary "table" ->
                let
                    t1 : List Expression
                    t1 =
                        prepareTable parse (String.join "\n" block.body)
                in
                Right t1

            Ordinary _ ->
                Right (parse <| String.join "\n" block.body)

            Verbatim _ ->
                Left <| String.join "\n" block.body
    , meta = block.meta
    }


fixTable : List Expression -> List Expression
fixTable exprs =
    case List.head exprs of
        Just (Fun "table" innerExprs meta) ->
            let
                foo2 : List Expression
                foo2 =
                    fixInner innerExprs
            in
            [ Fun "table" (fixInner innerExprs |> List.map fixRow) meta ]

        _ ->
            exprs


fixInner : List Expression -> List Expression
fixInner exprs =
    List.filter
        (\e ->
            case e of
                Text str _ ->
                    if compress str == "" then
                        False

                    else
                        True

                _ ->
                    True
        )
        exprs


fixRow : Expression -> Expression
fixRow expr =
    case expr of
        Fun "row" innerExprs meta ->
            Fun "row" (fixInner innerExprs) meta

        _ ->
            expr


prepareTable : (String -> List Expression) -> String -> List Expression
prepareTable parse str =
    let
        inner : String -> String
        inner row =
            String.split "&" row
                |> List.filter (\s -> compress s /= "")
                |> List.map (\cell -> "[cell " ++ cell ++ "]")
                |> String.join " "

        cells =
            str
                |> String.split "\\\\\n"
                |> List.filter (\s -> compress s /= "")
                |> List.map (\r -> "[row " ++ inner r ++ " ]")
                |> (\rows -> "[table " ++ String.join " " rows ++ "]")
    in
    parse cells
        |> fixTable


textWidthWithPixelsPerCharacter : Float -> String -> Float
textWidthWithPixelsPerCharacter pixelsPerCharacter str =
    textWidth_ str * pixelsPerCharacter


textWidth_ : String -> Float
textWidth_ str__ =
    let
        str_ =
            compress str__
    in
    if String.contains "\\\\" str_ then
        str_
            |> String.split "\\\\"
            |> List.map basicTextWidth
            |> List.maximum
            -- TODO: is 30.0 the correct value?
            |> Maybe.withDefault 30.0

    else
        basicTextWidth str_


basicTextWidth : String -> Float
basicTextWidth str_ =
    let
        -- \\[a-z]*([^a-z])
        str =
            str_ |> String.words |> List.map compress |> String.join " "

        letters =
            String.split "" str
    in
    letters |> List.map charWidth |> List.sum


charWidth : String -> Float
charWidth c =
    Dict.get c charDict |> Maybe.withDefault 1.0


compress string =
    string
        ++ " "
        |> Tools.Utility.userReplace "\\\\[a-z].*[^a-zA-Z0-9]" (\_ -> "a")
        |> Tools.Utility.userReplace "\\[A-Z].*[^a-zA-Z0-9]" (\_ -> "A")
        |> String.trim


charDict : Dict String Float
charDict =
    Dict.fromList
        [ ( "a", 1.0 )
        , ( "b", 1.0 )
        , ( "c", 1.0 )
        , ( "d", 1.0 )
        , ( "e", 1.0 )
        , ( "f", 1.0 )
        , ( "g", 1.0 )
        , ( "h", 1.0 )
        , ( "i", 1.0 )
        , ( "j", 1.0 )
        , ( "k", 1.0 )
        , ( "l", 1.0 )
        , ( "m", 1.0 )
        , ( "n", 1.0 )
        , ( "o", 1.0 )
        , ( "p", 1.0 )
        , ( "q", 1.0 )
        , ( "r", 1.0 )
        , ( "s", 1.0 )
        , ( "t", 1.0 )
        , ( "u", 1.0 )
        , ( "v", 1.0 )
        , ( "w", 1.0 )
        , ( "x", 1.0 )
        , ( "y", 1.0 )
        , ( "z", 1.0 )
        , ( "A", 2.0 )
        , ( "B", 2.0 )
        , ( "C", 2.0 )
        , ( "D", 2.0 )
        , ( "E", 2.0 )
        , ( "F", 2.0 )
        , ( "G", 2.0 )
        , ( "H", 2.0 )
        , ( "I", 2.0 )
        , ( "J", 2.0 )
        , ( "K", 2.0 )
        , ( "L", 2.0 )
        , ( "M", 2.0 )
        , ( "N", 2.0 )
        , ( "O", 2.0 )
        , ( "P", 2.0 )
        , ( "Q", 2.0 )
        , ( "R", 2.0 )
        , ( "S", 2.0 )
        , ( "T", 2.0 )
        , ( "U", 2.0 )
        , ( "V", 2.0 )
        , ( "W", 2.0 )
        , ( "X", 2.0 )
        , ( "Y", 2.0 )
        , ( "Z", 2.0 )
        , ( "$", 1.0 )
        ]



-- SIMPLIFIED TYPES


type alias SimpleExpressionBlock =
    Block (Either String (List (Expr ()))) ()


type alias SimplePrimitiveBlock =
    Block (List String) ()



-- GENERIC SIMPLIFIERS


simplifyBlock : (contentA -> contentB) -> Block contentA blockMeta -> Block contentB ()
simplifyBlock simplifyContent block =
    { heading = block.heading
    , indent = block.indent
    , args = block.args
    , properties = block.properties
    , firstLine = block.firstLine
    , body = simplifyContent block.body
    , meta = ()
    }


simplifyExpr : Expr meta -> Expr ()
simplifyExpr expr =
    case expr of
        Fun name args _ ->
            Fun name (List.map simplifyExpr args) ()

        VFun name arg _ ->
            VFun name arg ()

        Text text _ ->
            Text text ()



-- CONCRETE SIMPLIFIERS


simplifyExpressionBlock : ExpressionBlock -> SimpleExpressionBlock
simplifyExpressionBlock block =
    let
        simplifyContent : Either String (List (Expr exprMeta)) -> Either String (List (Expr ()))
        simplifyContent content =
            case content of
                Left str ->
                    Left str

                Right exprs ->
                    Right (List.map simplifyExpr exprs)
    in
    simplifyBlock simplifyContent block


simplifyPrimitiveBlock : PrimitiveBlock -> SimplePrimitiveBlock
simplifyPrimitiveBlock block =
    simplifyBlock identity block



-- VALUES


primitiveBlockEmpty : PrimitiveBlock
primitiveBlockEmpty =
    { heading = Paragraph
    , indent = 0
    , args = []
    , properties = Dict.empty
    , firstLine = ""
    , body = []
    , meta = emptyBlockMeta
    }


expressionBlockEmpty : ExpressionBlock
expressionBlockEmpty =
    { heading = Paragraph
    , indent = 0
    , args = []
    , properties = Dict.empty
    , firstLine = ""
    , body = Right []
    , meta = emptyBlockMeta
    }


emptyBlockMeta =
    { position = 0
    , lineNumber = 0
    , numberOfLines = 0
    , id = ""
    , messages = []
    , sourceText = ""
    , error = Nothing
    }



-- HELPERS


getName : ExpressionBlock -> Maybe String
getName block =
    getNameFromHeading block.heading


setName : String -> ExpressionBlock -> ExpressionBlock
setName name block =
    case block.heading of
        Paragraph ->
            block

        Ordinary _ ->
            { block | heading = Ordinary name }

        Verbatim _ ->
            { block | heading = Verbatim name }


getNameFromHeading : Heading -> Maybe String
getNameFromHeading heading =
    case heading of
        Paragraph ->
            Nothing

        Ordinary name ->
            Just name

        Verbatim name ->
            Just name


getExpressionContent : ExpressionBlock -> List Expression
getExpressionContent block =
    case block.body of
        Left _ ->
            []

        Right exprs ->
            exprs


getVerbatimContent : ExpressionBlock -> Maybe String
getVerbatimContent block =
    case block.body of
        Left str ->
            Just str

        Right _ ->
            Nothing


getFunctionName : Expression -> Maybe String
getFunctionName expression =
    case expression of
        Fun name _ _ ->
            Just name

        VFun _ _ _ ->
            Nothing

        Text _ _ ->
            Nothing
