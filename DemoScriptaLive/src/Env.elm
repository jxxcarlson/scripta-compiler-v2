module Env exposing (Mode(..), mode)


type Mode
    = Development
    | Production


mode : Mode
mode =
    -- Change this to Development when working locally
    Development