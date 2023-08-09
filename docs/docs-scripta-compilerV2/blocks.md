# Blocks

[visualize!](https://mango-dune-07a8b7110.1.azurestaticapps.net/?repo=jxxcarlson%2Fscripta-compiler-v2)

## Module Generic.Language


Scripta uses two kinds of blocks, `PrimitiveBlock`
and `ExpressionBlock`.  The latter is derived
from the former by applying a parser to the content,
which is a string.  The content of an `ExpressionBlock`
is therefore

```elm
Either String (List Expression)
```

When an `ExpressionBlock` is created from a `PrimitiveBlock`,
the `ExprMeta` field of the `Expression` is updated
so that in 

```elm
{ begin : Int, end : Int, index : Int, id : String }
```

the `begin` and `end` fields are positions
in the source string.

### Kinds of blocks

`ExpressionBlocks` and `PrimitiveBlocks` are 
defined by specializing the type parameters 
`content` and `blockMetaData` of the generic `Block` type.


```elm
type alias ExpressionBlock =
    Block (Either String (List Expression)) BlockMeta
```

```elm
type alias PrimitiveBlock =
    Block (List String) BlockMeta
```

```elm
type alias Block content blockMetaData =
    { heading : Heading
    , indent : Int
    , args : List String
    , properties : Dict String String
    , firstLine : String
    , body : content
    , meta : blockMetaData
    }
```
### Block metadata


```elm
type alias BlockMeta =
    { position : Int
    , lineNumber : Int
    , numberOfLines : Int
    , id : String
    , messages : List String
    , sourceText : String
    , error : Maybe String
    }
`

### Expressions


```elm
type alias Expression =
Expr ExprMeta
```


```elm
type Expr metaData
    = Fun String (List (Expr metaData)) metaData
    | VFun String String metaData
    | Text String metaData
```



```elm
type Expr metaData
    = Fun String (List (Expr metaData)) metaData
    | VFun String String metaData
    | Text String metaData

```

```elm
type alias ExprMeta =
    { begin : Int, end : Int, index : Int, id : String }

```

