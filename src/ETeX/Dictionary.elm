module ETeX.Dictionary exposing (functionDict, symbolDict)

import Dict exposing (Dict)
import Generic.MathMacro exposing (MacroBody, MathExpr)



-- MacroBody Int (List MathExpr)


functionDict : Dict String { name : String, arity : Int }
functionDict =
    Dict.fromList
        [ ( "sin", { name = "\\sin", arity = 1 } )
        , ( "cos", { name = "\\cos", arity = 1 } )
        , ( "tan", { name = "\\tan", arity = 1 } )
        , ( "cot", { name = "\\cot", arity = 1 } )
        , ( "sec", { name = "\\sec", arity = 1 } )
        , ( "csc", { name = "\\csc", arity = 1 } )
        , ( "log", { name = "\\log", arity = 1 } )
        , ( "ln", { name = "\\ln", arity = 1 } )
        , ( "exp", { name = "\\exp", arity = 1 } )
        , ( "argmax", { name = "\\argmax", arity = 2 } )
        , ( "argmin", { name = "\\argmin", arity = 2 } )
        ]


symbolDict : Dict String String
symbolDict =
    Dict.fromList
        [ ( "qquad", "\\qquad" )

        -- Lowercase Greek letters
        , ( "alpha", "\\alpha" )
        , ( "beta", "\\beta" )
        , ( "gamma", "\\gamma" )
        , ( "delta", "\\delta" )
        , ( "epsilon", "\\epsilon" )
        , ( "zeta", "\\zeta" )
        , ( "eta", "\\eta" )
        , ( "theta", "\\theta" )
        , ( "iota", "\\iota" )
        , ( "kappa", "\\kappa" )
        , ( "lambda", "\\lambda" )
        , ( "mu", "\\mu" )
        , ( "nu", "\\nu" )
        , ( "xi", "\\xi" )
        , ( "omicron", "\\omicron" )
        , ( "pi", "\\pi" )
        , ( "rho", "\\rho" )
        , ( "sigma", "\\sigma" )
        , ( "tau", "\\tau" )
        , ( "upsilon", "\\upsilon" )
        , ( "phi", "\\phi" )
        , ( "chi", "\\chi" )
        , ( "psi", "\\psi" )
        , ( "omega", "\\omega" )

        -- Uppercase Greek letters
        , ( "Alpha", "\\Alpha" )
        , ( "Beta", "\\Beta" )
        , ( "Gamma", "\\Gamma" )
        , ( "Delta", "\\Delta" )
        , ( "Epsilon", "\\Epsilon" )
        , ( "Zeta", "\\Zeta" )
        , ( "Eta", "\\Eta" )
        , ( "Theta", "\\Theta" )
        , ( "Iota", "\\Iota" )
        , ( "Kappa", "\\Kappa" )
        , ( "Lambda", "\\Lambda" )
        , ( "Mu", "\\Mu" )
        , ( "Nu", "\\Nu" )
        , ( "Xi", "\\Xi" )
        , ( "Omicron", "\\Omicron" )
        , ( "Pi", "\\Pi" )
        , ( "Rho", "\\Rho" )
        , ( "Sigma", "\\Sigma" )
        , ( "Tau", "\\Tau" )
        , ( "Upsilon", "\\Upsilon" )
        , ( "Phi", "\\Phi" )
        , ( "Chi", "\\Chi" )
        , ( "Psi", "\\Psi" )
        , ( "Omega", "\\Omega" )

        -- Common variants
        , ( "varepsilon", "\\varepsilon" )
        , ( "vartheta", "\\vartheta" )
        , ( "varpi", "\\varpi" )
        , ( "varrho", "\\varrho" )
        , ( "varsigma", "\\varsigma" )
        , ( "varphi", "\\varphi" )
        ]
