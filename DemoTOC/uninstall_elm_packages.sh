#!/bin/bash

# List of packages to uninstall
packages=(
    "folkertdev/elm-deque"
    "folkertdev/one-true-path-experiment"
    "folkertdev/svg-path-lowlevel"
    "gampleman/elm-rosetree"
    "gampleman/elm-visualization"
    "ianmackenzie/elm-1d-parameter"
    "ianmackenzie/elm-float-extra"
    "ianmackenzie/elm-geometry"
    "ianmackenzie/elm-interval"
    "ianmackenzie/elm-triangular-mesh"
    "ianmackenzie/elm-units"
    "ianmackenzie/elm-units-interval"
    "ianmackenzie/elm-units-prefixed"
    "justinmimbs/date"
    "justinmimbs/time-extra"
    "jxxcarlson/elm-stat"
    "mdgriffith/elm-ui"
    "myrho/elm-round"
    "pilatch/flip"
    "rtfeldman/console-print"
    "rtfeldman/elm-hex"
    "terezka/charts"
    "terezka/intervals"
    "toastal/either"
    "zgohr/elm-csv"
    "zwilias/elm-rosetree"
)

# Uninstall each package
for package in "${packages[@]}"; do
    echo "Uninstalling $package..."
    echo "yes" | elm-json uninstall "$package" || echo "Failed to uninstall $package"
done

echo "All requested packages have been processed."
