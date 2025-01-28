#!/bin/bash

# Input data containing Elm packages
data='
"folkertdev/elm-deque": "3.0.1",
"folkertdev/one-true-path-experiment": "6.0.0",
"folkertdev/svg-path-lowlevel": "4.0.1",
"gampleman/elm-rosetree": "1.1.0",
"gampleman/elm-visualization": "2.4.1",
"ianmackenzie/elm-1d-parameter": "1.0.1",
"ianmackenzie/elm-float-extra": "1.1.0",
"ianmackenzie/elm-geometry": "3.11.0",
"ianmackenzie/elm-interval": "3.1.0",
"ianmackenzie/elm-triangular-mesh": "1.1.0",
"ianmackenzie/elm-units": "2.10.0",
"ianmackenzie/elm-units-interval": "3.2.0",
"ianmackenzie/elm-units-prefixed": "2.8.0",
"justinmimbs/date": "4.0.1",
"justinmimbs/time-extra": "1.1.1",
"jxxcarlson/elm-stat": "6.0.3",
"mdgriffith/elm-ui": "1.1.8",
"myrho/elm-round": "1.0.4",
"pilatch/flip": "1.0.0",
"rtfeldman/console-print": "1.0.1",
"rtfeldman/elm-hex": "1.0.0",
"terezka/charts": "20.0.1",
"terezka/intervals": "2.0.1",
"toastal/either": "3.6.3",
"zgohr/elm-csv": "1.0.1",
"zwilias/elm-rosetree": "1.5.0"
'

# Extract package names and install each one
echo "$data" | sed -n 's/^\s*"\([^"]*\)":.*/\1/p' | while read -r package; do
    echo "Installing $package..."
    echo "y" | elm install "$package" || echo "Failed to install $package"
done

echo "All packages have been processed."
