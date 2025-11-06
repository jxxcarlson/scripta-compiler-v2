module ScriptaV2.Config exposing
    ( defaultLanguage
    , expressionIdPrefix
    , idPrefix
    , indentationQuantum
    , largeTitleSize
    , smallTitleSize
    )

import ScriptaV2.Language exposing (Language(..))


defaultLanguage =
    MiniLaTeXLang


idPrefix =
    "L"


expressionIdPrefix =
    "e-"


indentationQuantum =
    2


largeTitleSize =
    24


smallTitleSize =
    18
