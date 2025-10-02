module ETeX.KaTeX exposing (greekLetters, isKaTeX)

import Set exposing (Set)


isKaTeX : String -> Bool
isKaTeX command =
    Set.member command katexCommands


{-|

  - A set of all commands supported by KaTeX.
    This includes Greek letters, binary operators, relation symbols, arrows,
    delimiters, big operators, math functions, accents, fonts, spacing,
    logic and set theory symbols, miscellaneous symbols, fractions,
    binomials, roots, and text operators as defined in the KaTeX documentation.

    513 commands

    TODO: ldots, ellipsis, and other common symbols that are not included.

-}
katexCommands : Set String
katexCommands =
    Set.fromList
        (List.concat
            [ greekLetters
            , binaryOperators
            , relationSymbols
            , arrows
            , delimiters
            , bigOperators
            , mathFunctions
            , accents
            , fonts
            , spacing
            , logicAndSetTheory
            , miscSymbols
            , fractions
            , binomials
            , roots
            , textOperators
            ]
        )



-- Greek Letters


greekLetters : List String
greekLetters =
    [ -- Lowercase
      "alpha"
    , "beta"
    , "gamma"
    , "delta"
    , "epsilon"
    , "varepsilon"
    , "zeta"
    , "eta"
    , "theta"
    , "vartheta"
    , "iota"
    , "kappa"
    , "varkappa"
    , "lambda"
    , "mu"
    , "nu"
    , "xi"
    , "pi"
    , "varpi"
    , "rho"
    , "varrho"
    , "sigma"
    , "varsigma"
    , "tau"
    , "upsilon"
    , "phi"
    , "varphi"
    , "chi"
    , "psi"
    , "omega"

    -- Uppercase
    , "Gamma"
    , "Delta"
    , "Theta"
    , "Lambda"
    , "Xi"
    , "Pi"
    , "Sigma"
    , "Upsilon"
    , "Phi"
    , "Psi"
    , "Omega"

    -- Other
    , "digamma"
    , "varGamma"
    , "varDelta"
    , "varTheta"
    , "varLambda"
    , "varXi"
    , "varPi"
    , "varSigma"
    , "varUpsilon"
    , "varPhi"
    , "varPsi"
    , "varOmega"
    ]



-- Binary Operators


binaryOperators : List String
binaryOperators =
    [ "pm"
    , "mp"
    , "times"
    , "div"
    , "cdot"
    , "ast"
    , "star"
    , "circ"
    , "bullet"
    , "oplus"
    , "ominus"
    , "otimes"
    , "oslash"
    , "odot"
    , "dagger"
    , "ddagger"
    , "vee"
    , "lor"
    , "wedge"
    , "land"
    , "cap"
    , "cup"
    , "setminus"
    , "smallsetminus"
    , "triangleleft"
    , "triangleright"
    , "bigtriangleup"
    , "bigtriangledown"
    , "lhd"
    , "rhd"
    , "unlhd"
    , "unrhd"
    , "amalg"
    , "uplus"
    , "sqcap"
    , "sqcup"
    , "boxplus"
    , "boxminus"
    , "boxtimes"
    , "boxdot"
    , "leftthreetimes"
    , "rightthreetimes"
    , "curlyvee"
    , "curlywedge"
    , "dotplus"
    , "divideontimes"
    , "doublebarwedge"
    ]



-- Relation Symbols


relationSymbols : List String
relationSymbols =
    [ "leq"
    , "le"
    , "geq"
    , "ge"
    , "neq"
    , "ne"
    , "sim"
    , "simeq"
    , "approx"
    , "cong"
    , "equiv"
    , "prec"
    , "succ"
    , "preceq"
    , "succeq"
    , "ll"
    , "gg"
    , "subset"
    , "supset"
    , "subseteq"
    , "supseteq"
    , "nsubseteq"
    , "nsupseteq"
    , "sqsubset"
    , "sqsupset"
    , "sqsubseteq"
    , "sqsupseteq"
    , "in"
    , "ni"
    , "notin"
    , "notni"
    , "propto"
    , "varpropto"
    , "perp"
    , "parallel"
    , "nparallel"
    , "smile"
    , "frown"
    , "doteq"
    , "fallingdotseq"
    , "risingdotseq"
    , "coloneq"
    , "eqcirc"
    , "circeq"
    , "triangleq"
    , "bumpeq"
    , "Bumpeq"
    , "doteqdot"
    , "thicksim"
    , "thickapprox"
    , "approxeq"
    , "backsim"
    , "backsimeq"
    , "preccurlyeq"
    , "succcurlyeq"
    , "curlyeqprec"
    , "curlyeqsucc"
    , "precsim"
    , "succsim"
    , "precapprox"
    , "succapprox"
    , "vartriangleleft"
    , "vartriangleright"
    , "trianglelefteq"
    , "trianglerighteq"
    , "between"
    , "pitchfork"
    , "shortmid"
    , "shortparallel"
    , "therefore"
    , "because"
    , "eqcolon"
    , "simcolon"
    , "approxcolon"
    , "colonapprox"
    , "colonsim"
    , "Colon"
    , "ratio"
    ]



-- Arrows


arrows : List String
arrows =
    [ "leftarrow"
    , "gets"
    , "rightarrow"
    , "to"
    , "leftrightarrow"
    , "Leftarrow"
    , "Rightarrow"
    , "Leftrightarrow"
    , "iff"
    , "uparrow"
    , "downarrow"
    , "updownarrow"
    , "Uparrow"
    , "Downarrow"
    , "Updownarrow"
    , "mapsto"
    , "hookleftarrow"
    , "hookrightarrow"
    , "leftharpoonup"
    , "rightharpoonup"
    , "leftharpoondown"
    , "rightharpoondown"
    , "rightleftharpoons"
    , "longleftarrow"
    , "longrightarrow"
    , "longleftrightarrow"
    , "Longleftarrow"
    , "impliedby"
    , "Longrightarrow"
    , "implies"
    , "Longleftrightarrow"
    , "longmapsto"
    , "nearrow"
    , "searrow"
    , "swarrow"
    , "nwarrow"
    , "dashleftarrow"
    , "dashrightarrow"
    , "leftleftarrows"
    , "rightrightarrows"
    , "leftrightarrows"
    , "rightleftarrows"
    , "Lleftarrow"
    , "Rrightarrow"
    , "twoheadleftarrow"
    , "twoheadrightarrow"
    , "leftarrowtail"
    , "rightarrowtail"
    , "looparrowleft"
    , "looparrowright"
    , "curvearrowleft"
    , "curvearrowright"
    , "circlearrowleft"
    , "circlearrowright"
    , "multimap"
    , "leftrightsquigarrow"
    , "rightsquigarrow"
    , "leadsto"
    , "restriction"
    ]



-- Delimiters


delimiters : List String
delimiters =
    [ "lbrace"
    , "rbrace"
    , "lbrack"
    , "rbrack"
    , "langle"
    , "rangle"
    , "vert"
    , "Vert"
    , "lvert"
    , "rvert"
    , "lVert"
    , "rVert"
    , "lfloor"
    , "rfloor"
    , "lceil"
    , "rceil"
    , "lgroup"
    , "rgroup"
    , "lmoustache"
    , "rmoustache"
    , "ulcorner"
    , "urcorner"
    , "llcorner"
    , "lrcorner"
    ]



-- Big Operators


bigOperators : List String
bigOperators =
    [ "sum"
    , "prod"
    , "coprod"
    , "bigcup"
    , "bigcap"
    , "bigvee"
    , "bigwedge"
    , "bigoplus"
    , "bigotimes"
    , "bigodot"
    , "biguplus"
    , "bigsqcup"
    , "int"
    , "oint"
    , "iint"
    , "iiint"
    , "iiiint"
    , "intop"
    , "smallint"
    ]



-- Math Functions


mathFunctions : List String
mathFunctions =
    [ "sin"
    , "cos"
    , "tan"
    , "cot"
    , "sec"
    , "csc"
    , "sinh"
    , "cosh"
    , "tanh"
    , "coth"
    , "sech"
    , "csch"
    , "arcsin"
    , "arccos"
    , "arctan"
    , "arctg"
    , "arcctg"
    , "ln"
    , "log"
    , "lg"
    , "exp"
    , "deg"
    , "det"
    , "dim"
    , "hom"
    , "ker"
    , "lim"
    , "liminf"
    , "limsup"
    , "max"
    , "min"
    , "sup"
    , "inf"
    , "Pr"
    , "gcd"
    , "lcm"
    , "arg"
    , "mod"
    , "bmod"
    , "pmod"
    , "pod"
    ]



-- Accents


accents : List String
accents =
    [ "hat"
    , "widehat"
    , "check"
    , "widecheck"
    , "tilde"
    , "widetilde"
    , "acute"
    , "grave"
    , "dot"
    , "ddot"
    , "breve"
    , "bar"
    , "vec"
    , "mathring"
    , "overline"
    , "underline"
    , "overleftarrow"
    , "overrightarrow"
    , "overleftrightarrow"
    , "underleftarrow"
    , "underrightarrow"
    , "underleftrightarrow"
    , "overgroup"
    , "undergroup"
    , "overbrace"
    , "underbrace"
    , "overparen"
    , "underparen"
    , "overrightleftharpoons"
    , "boxed"
    , "underlinesegment"
    , "overlinesegment"
    ]



-- Fonts


fonts : List String
fonts =
    [ "mathrm"
    , "mathit"
    , "mathbf"
    , "boldsymbol"
    , "pmb"
    , "mathbb"
    , "Bbb"
    , "mathcal"
    , "cal"
    , "mathscr"
    , "scr"
    , "mathfrak"
    , "frak"
    , "mathsf"
    , "sf"
    , "mathtt"
    , "tt"
    , "mathnormal"
    , "text"
    , "textbf"
    , "textit"
    , "textrm"
    , "textsf"
    , "texttt"
    , "textnormal"
    , "textup"
    , "operatorname"
    , "operatorname*"
    ]



-- Spacing


spacing : List String
spacing =
    [ "quad"
    , "qquad"
    , "space"
    , "thinspace"
    , "medspace"
    , "thickspace"
    , "enspace"
    , "negspace"
    , "negmedspace"
    , "negthickspace"
    , "negthinspace"
    , "mkern"
    , "mskip"
    , "hskip"
    , "hspace"
    , "hspace*"
    , "kern"
    , "phantom"
    , "hphantom"
    , "vphantom"
    , "mathstrut"
    , "strut"
    , "!"
    , ":"
    , ";"
    , ","
    ]



-- Logic and Set Theory


logicAndSetTheory : List String
logicAndSetTheory =
    [ "forall"
    , "exists"
    , "nexists"
    , "complement"
    , "subset"
    , "supset"
    , "mid"
    , "nmid"
    , "notsubset"
    , "nsubset"
    , "nsupset"
    , "nsupseteq"
    , "nsubseteq"
    , "subsetneq"
    , "supsetneq"
    , "subsetneqq"
    , "supsetneqq"
    , "varsubsetneq"
    , "varsupsetneq"
    , "varsubsetneqq"
    , "varsupsetneqq"
    , "isin"
    , "notin"
    , "notni"
    , "niton"
    , "in"
    , "ni"
    , "emptyset"
    , "varnothing"
    , "setminus"
    , "smallsetminus"
    , "complement"
    , "neg"
    , "lnot"
    ]



-- Miscellaneous Symbols


miscSymbols : List String
miscSymbols =
    [ "infty"
    , "aleph"
    , "beth"
    , "gimel"
    , "daleth"
    , "eth"
    , "hbar"
    , "hslash"
    , "Finv"
    , "Game"
    , "ell"
    , "wp"
    , "Re"
    , "Im"
    , "partial"
    , "nabla"
    , "Box"
    , "square"
    , "blacksquare"
    , "blacklozenge"
    , "lozenge"
    , "Diamond"
    , "triangle"
    , "triangledown"
    , "angle"
    , "measuredangle"
    , "sphericalangle"
    , "prime"
    , "backprime"
    , "degree"
    , "flat"
    , "natural"
    , "sharp"
    , "surd"
    , "top"
    , "bot"
    , "emptyset"
    , "varnothing"
    , "clubsuit"
    , "diamondsuit"
    , "heartsuit"
    , "spadesuit"
    , "blacktriangleright"
    , "blacktriangleleft"
    , "blacktriangledown"
    , "blacktriangle"
    , "bigstar"
    , "maltese"
    , "checkmark"
    , "diagup"
    , "diagdown"
    , "ddag"
    , "dag"
    , "copyright"
    , "circledR"
    , "pounds"
    , "yen"
    , "euro"
    , "cent"
    , "maltese"
    ]



-- Fractions and Binomials


fractions : List String
fractions =
    [ "frac"
    , "dfrac"
    , "tfrac"
    , "cfrac"
    , "genfrac"
    , "over"
    , "atop"
    , "choose"
    ]



-- Binomial Coefficients


binomials : List String
binomials =
    [ "binom"
    , "dbinom"
    , "tbinom"
    , "brace"
    , "brack"
    ]



-- Roots


roots : List String
roots =
    [ "sqrt"
    , "sqrtsign"
    ]



-- Text Operators


textOperators : List String
textOperators =
    [ "not"
    , "cancel"
    , "bcancel"
    , "xcancel"
    , "cancelto"
    , "sout"
    , "overline"
    , "underline"
    , "overset"
    , "underset"
    , "stackrel"
    , "atop"
    , "substack"
    , "sideset"
    ]
