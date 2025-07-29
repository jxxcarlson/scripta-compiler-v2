elm make src/Main.elm --output=./assets/main.js

# Add timestamp to HTML file to force cache refresh
TIMESTAMP=$(date +%s)
if [ -f ./assets/index.html ]; then
    # Update the script tag to include timestamp
    sed -i.bak "s|<script src=\"main.js\"></script>|<script src=\"main.js?v=${TIMESTAMP}\"></script>|" ./assets/index.html
    rm ./assets/index.html.bak
    echo "Updated index.html with cache-busting timestamp: ${TIMESTAMP}"
fi

# npx elm-watch hot
