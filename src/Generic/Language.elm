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
    , boostBlock
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
    , updateMeta
    , updateMetaInBlock
    )

import Dict exposing (Dict)
import Either exposing (Either(..))
import List.Extra
import Tools.Utility



--
--
--out11 =
--    Ok
--        [ Tree
--            { args = []
--            , body =
--                Right
--                    [ Text "this is " { begin = 0, end = 7, id = "e-1.0", index = 0 }
--                    , Fun "i" [ Text " really" { begin = 10, end = 16, id = "e-0.3", index = 3 } ] { begin = 9, end = 9, id = "e-1.2", index = 2 }
--                    , Text " a test" { begin = 18, end = 24, id = "e-1.5", index = 5 }
--                    ]
--            , firstLine = "this is [i really] a test"
--            , heading = Paragraph
--            , indent = 0
--            , meta = { error = Nothing, id = "@-0", lineNumber = 1, messages = [], numberOfLines = 1, position = 0, sourceText = "this is [i really] a test" }
--            , properties = Dict.fromList []
--            }
--            []
--        , Tree
--            { args = []
--            , body = Right [ Text "Ho ho ho" { begin = 27, end = 34, id = "e-3.0", index = 0 } ]
--            , firstLine = "Ho ho ho"
--            , heading = Paragraph
--            , indent = 0
--            , meta = { error = Nothing, id = "@-1", lineNumber = 3, messages = [], numberOfLines = 1, position = 27, sourceText = "Ho ho ho" }
--            , properties = Dict.fromList []
--            }
--            []
--        ]
--
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


{-|

    Transform meta so that begin and end are positions in the source text

-}
boost : Int -> ExprMeta -> ExprMeta
boost position meta =
    { meta | begin = meta.begin + position, end = meta.end + position }


boostBlock : ExpressionBlock -> ExpressionBlock
boostBlock block =
    updateMetaInBlock (boost block.meta.position) block


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
