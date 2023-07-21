module ScriptaV2.Config exposing
    ( defaultLanguage
    , expressionIdPrefix
    , idPrefix
    , indentationQuantum
    )

import ScriptaV2.Language exposing (Language(..))


defaultLanguage =
    MicroLaTeXLang


idPrefix =
    "@"


expressionIdPrefix =
    "e-"


indentationQuantum =
    2
