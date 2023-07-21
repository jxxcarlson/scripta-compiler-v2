module Generic.Language exposing
    ( BlockMeta
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
    , primitiveBlockEmpty
    , setName
    , simplifyBlock
    , simplifyExpr
    , simplifyExpressionBlock
    , simplifyPrimitiveBlock
    , toExpressionBlock
    , updateMeta
    )

import Dict exposing (Dict)
import Either exposing (Either(..))



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
    , properties = block.properties
    , firstLine = block.firstLine
    , body =
        case block.heading of
            Paragraph ->
                Right (parse <| String.join "\n" block.body)

            Ordinary _ ->
                Right (parse <| String.join "\n" block.body)

            Verbatim _ ->
                Left <| String.join "\n" block.body
    , meta = block.meta
    }



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
