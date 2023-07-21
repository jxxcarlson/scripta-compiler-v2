module Generic.Pipeline exposing
    ( toExpressionBlock
    , toExpressionBlockForestFromStringlist
    , toPrimitiveBlockForest
    )

import Generic.Forest exposing (Forest)
import Generic.ForestTransform exposing (Error)
import Generic.Language exposing (Expression, ExpressionBlock, PrimitiveBlock)
import M.PrimitiveBlock


toExpressionBlockForestFromStringlist : String -> Int -> (Int -> String -> List Expression) -> List String -> Result Error (Forest ExpressionBlock)
toExpressionBlockForestFromStringlist idPrefix outerCount parser lines =
    lines
        |> M.PrimitiveBlock.parse idPrefix outerCount
        |> toPrimitiveBlockForest
        |> Result.map (Generic.Forest.map (toExpressionBlock parser))


toExpressionBlock : (Int -> String -> List Expression) -> PrimitiveBlock -> ExpressionBlock
toExpressionBlock parser block =
    Generic.Language.toExpressionBlock (parser block.meta.lineNumber) block


toPrimitiveBlockForest : List PrimitiveBlock -> Result Error (Forest PrimitiveBlock)
toPrimitiveBlockForest blocks =
    let
        input : List PrimitiveBlock
        input =
            blocks

        output =
            Generic.ForestTransform.forestFromBlocks emptyBlock .indent input

        _ =
            Debug.log "INPUT" (input |> List.map (Generic.Language.simplifyBlock (\c -> ())))

        mapperF =
            Generic.Forest.map (Generic.Language.simplifyBlock (\c -> ()))

        _ =
            Debug.log "OUTPUT" (output |> Result.map mapperF)
    in
    Generic.ForestTransform.forestFromBlocks { emptyBlock | indent = -2 } .indent blocks


emptyBlock : PrimitiveBlock
emptyBlock =
    { emptyBlock_ | indent = -2 }


emptyBlock_ : PrimitiveBlock
emptyBlock_ =
    Generic.Language.primitiveBlockEmpty
