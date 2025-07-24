#!/bin/bash

# Check if correct number of arguments provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    echo "Example: $0 document.tex"
    exit 1
fi

INPUT_FILE="$1"

# Copy file from Downloads to current directory
if [ -f ~/Downloads/"$INPUT_FILE" ]; then
    echo "Copying $INPUT_FILE from ~/Downloads to current directory..."
    cp ~/Downloads/"$INPUT_FILE" ./"$INPUT_FILE"
else
    echo "Error: File ~/Downloads/$INPUT_FILE not found"
    exit 1
fi

# Check if input file exists in current directory
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Failed to copy file to current directory"
    exit 1
fi

# Create output directory
OUTPUT_DIR="./image"
mkdir -p "$OUTPUT_DIR"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed. Please install it first."
    exit 1
fi

# Create a temporary file for the modified LaTeX
TEMP_FILE=$(mktemp)
cp "$INPUT_FILE" "$TEMP_FILE"

echo "Searching for image URLs in $INPUT_FILE..."
echo "Output directory: $OUTPUT_DIR"
echo

# Extract URLs ending with .jpg, .jpeg, or .png
# Using grep with extended regex to find URLs (including those with spaces before them)
grep -Eo 'https?://[^"{}]+\.(jpg|jpeg|png)(\?[^"{}]*)?' "$INPUT_FILE" | sort -u | while read -r url; do
    # Remove query parameters if present
    url_without_query="${url%%\?*}"
    
    # Extract path after domain
    # Remove protocol and domain to get just the path
    path_after_domain=$(echo "$url_without_query" | sed -E 's|https?://[^/]*/?||')
    # Remove file extension
    path_without_ext="${path_after_domain%.*}"
    # Replace slashes with hyphens and remove special characters
    eps_base_name=$(echo "$path_without_ext" | tr '/' '-' | tr -d '():=')
    eps_filename="${eps_base_name}.eps"
    
    # Get original filename for download
    original_filename=$(basename "$url")
    original_filename="${original_filename%%\?*}"
    
    echo "Processing: $url"
    echo "  Path after domain: $path_after_domain"
    echo "  Path without ext: $path_without_ext"
    echo "  EPS base name: $eps_base_name"
    echo "  Downloading as: $original_filename"
    echo "  EPS filename: $eps_filename"
    
    # Download the image
    if curl -s -L -o "$OUTPUT_DIR/$original_filename" "$url"; then
        echo "  Converting to EPS..."
        
        # Convert to EPS using ImageMagick
        if convert "$OUTPUT_DIR/$original_filename" -compress lzw "$OUTPUT_DIR/$eps_filename" 2>/dev/null; then
            echo "  ✓ Successfully converted to EPS"
            
            # Replace URL with EPS filename in the temporary file
            # Use perl for more reliable replacement
            perl -i -pe "s|\Q$url\E|$eps_filename|g" "$TEMP_FILE"
            echo "  ✓ Replaced URL in LaTeX file"
            
            # Remove the original downloaded file
            rm "$OUTPUT_DIR/$original_filename"
        else
            echo "  ✗ Failed to convert to EPS"
            rm "$OUTPUT_DIR/$original_filename"
        fi
    else
        echo "  ✗ Failed to download"
    fi
    echo
done

# Replace the original file with the modified one
mv "$TEMP_FILE" "$INPUT_FILE"

# Count results
eps_count=$(find "$OUTPUT_DIR" -name "*.eps" -type f | wc -l)
echo "Completed! Created $eps_count EPS files in $OUTPUT_DIR"
echo "LaTeX file has been updated with local EPS references"
echo "Cleaning up"
rm -f *.aux *.log *.toc  *.synctex.gz