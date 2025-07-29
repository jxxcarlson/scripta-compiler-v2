module Constants exposing (constants)

{-| Application-wide constants and configuration values.
-}


type alias Constants =
    { maxUnsavedDuration : Int -- seconds
    , autoSaveCheckInterval : Float -- milliseconds
    }


constants : Constants
constants =
    { maxUnsavedDuration = 5
    , autoSaveCheckInterval = 1000
    }