module Render.Types exposing (DocumentKind(..), PublicationData)

import Either exposing (Either(..))
import Time exposing (Posix)


type alias PublicationData =
    { title : String
    , authorList : List String
    , kind : DocumentKind
    , date : Either Time.Posix String
    }


type DocumentKind
    = DKArticle
    | DKChapter
    | DKBook
