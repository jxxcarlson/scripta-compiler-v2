# AST

The AST is defined at the level of running text
and of blocks.  Running text is parsed to a value of 
type `List Expression`.


```javascrpt
type Expression
    = Fun String (List (Expression)) MetaData
    | VFun String String MetaData
    | Text String MetaData
```

Blocks are parsed to a value of type  `ExpressionBlock`.

```javascript
type alias ExpressionBlock =
    { heading : Heading
    , indent : Int
    , args : List String
    , properties : Dict String String
    , firstLine : String
    , body : Either String (List Expression)
    , meta : BlockMetaData
    }
```

The source text of the languages parsed has a 
an indentation structure, so that the text
can be thought of as a list of trees. 

```text
All organisms that have ever lived form a tree 
whose main branches are

    1.  Bacteria
        1. Proteobacteria
        2.  Cyanobacteria
        3.  Spirochaetes
        4.  Bacteroidetes
        5.  Firmicutes
        6.  Actinobacteria
    2.  Archaea
        1.  Euryarchaeota
        2.  Crenarchaeota
        3.  Korarchaeota
        4.  Nanoarchaeota
        5.  Thaumarchaeota
    3.  Eukaryota
        1.  Animals
        2.  Plants
        3.  Fungi
        4.  Protists
```

This outline can be though of as a tree, where the base of the
tree is LUCA, the last universal common ancestor. 

![tree of life](https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/a9a119b5-9309-46d3-ec79-bf4e4a39bc00/public)

Here is an example of text in L0:

```text
| title
Introduction

Until very recently, the tree of life was constructed
on the basis of [i anatomical similarities and differences]. 
Nowadays, comparisons of [i DNA] and [i RNA] sequences 
gives a far more detailed and accurate reconstruction of this
tree, including estimates of the time of divergence of the
various branches.

  [b Note 1.] The tree of life is a metaphor. It is not a tree, but a graph.
  
  [b Note 2.] DNA is a long double-stranded molecule that contains the genetic instructions
  written in a code of four letters. The letters are A, C, G, and T,
  corresponding to the amino acids alanine, cysteine, glycine, and threonine.
    
  [b Note 3.] RNA is a molecule that is used to make proteins. 
  It is a  single strand of nucleotides. The nucleotides are
    A, C, G, and U, corresponding to the amino acids alanine, 
    cysteine, glycine, and threonine.
    
  [b Note 4.] Mechanisms inside the nucleus of the cell "read" the DNA,
  transcribing it into RNA. The RNA is then read by ribosomes, which
  assemble the amino acids into proteins.
  
  [b Note 5.] This is all pretty amazing!
```




![Tree formed by an L0 document](https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/40e3dc83-0cdc-442d-498d-b2fe768a8d00/public)

The AST for this document is a _forest_, that is, a list 
of trees.  Each tree is a list of blocks.  In the
case at hand, there are two trees in the forest.
The first tree consists of a single block, which we write
in shorthand form as

```text
    { heading =  Ordinary "title"
    , indent = 0
    , body = Right [Text "Introduction")
    }
```

The second tree as its root the block

```text
    { heading =  Paragraph
    , indent = 0
    , body = Right [Text "IUntil very recently, ...",
           Fun "italic" [Text "anatomical similarities and differences"]
         , Text ". Nowadays, comparisons of ", ...
    }
```

That root block has five daughter blocks, the first of which is

```text
    { heading =  Paragraph
    , indent = 2
    , body = Right [Text "Note 1. The tree of life ..."]
    }
    }
```


![PDF version of above document](https://imagedelivery.net/9U-0Y4sEzXlO6BXzTnQnYQ/c2596964-d3f2-4cfd-7bb5-4a6bfd181500/public)

