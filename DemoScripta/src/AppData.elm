module AppData exposing (defaultDocumentText, processImagesText)


defaultDocumentText : String
defaultDocumentText =
    """| title
  Announcement
  
  | image figure:1 caption: Humming bird
   https://www.realsimple.com/thmb/7xn0oIF6a9eJ-y_4OO5vN0lJhCg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/humming-bird-flowers-GettyImages-1271839175-b515cb4f06a34e66b084ba617995f00a.jpg
  
  
  # About Scripta
  
  - This is a demo of the [u Scripta Markup Language].  Compare source and rendered text to see how it works. Your document is rendered as you type.  There is no setup ... just have at it.
  
  - You can't save documents right now, but you will be able to do that as soon as the full scripta app is released.
  
  - Use the megaphone icon on the right to report bugs, ask questions, and make suggestions.  This an early alpha release of Scripta, so you [b will] find bugs. We love to hear about them.
  
  - Note the use of our experimental  [u ergonomic TeX]: TeX without backslashes.
  
  - Press ctrl-E to export your file to LaTeX.  This feature does not yet work with images, so for now you will have to hide them with a [u hide] or
  [u code] block.  A fix is on its way
  
  
  # Examples
  
  | mathmacros
  secpder:  frac(partial^2 #1, partial #2^2)
  nat:    mathbb N
  reals: mathbb R
  pder:  frac(partial #1, partial #2)
  set:    \\{ #1 \\}
  sett:   \\{ #1 \\ | \\ #2 \\}
  
  Pythagoras said: $a^2 + b^2 = c^2$.
  
  
  This will be on the test:
  
  | equation
  int_0^1 x^n dx = frac(1,n+1)
  
  and so will this:
  
  
  | equation numbered
  \\label{wave-equation}
  secpder(u,x) + secpder(u,y) + secpder(u,z) = frac(1,c^2) secpder(u,t))  qquad "Wave Equation"
  
  Both of the above equalities were written using an `equation` block.  If you look 
  at the source text you will see that [eqref wave-equation] an [u argument] `numbered` and
  a property, namely  `label:wave-equation`. That property is used for cross-referencing: we say `[eqref wave-equation]` to make a hot link to [eqref wave-equation].  Click on it now
  to see what happens.
  
  Here is an [u aligned] block:
  
  | aligned
  nat &= set("positive whole numbers and zero")
  nat &= sett(n " is a whole number", n > 0)
  
  
  | equation
  \\begin{pmatrix}
    2 & 1 \\\\
    1 & 2
  \\end{pmatrix}
  \\begin{pmatrix}
    2 & 1 \\\\
    1 & 2
  \\end{pmatrix}
  =
  \\begin{pmatrix}
    5 & 4 \\\\
    4 & 5
  \\end{pmatrix}
  
 
"""


processImagesText =
    """
#!/bin/bash

 # Usage:
 #
 # sh ./process_images.sh <input_file> : gives a way
 #
 # Purpose: process LaTeX exported from scripta files that contain images,
 # first creating a corresponding LaTeX file, then
 # a pdf file.
 #
 # Prerequisite software installation:
 # - ImageMagick (for converting images to EPS)
 # - pdflatex (for making PDFs LaTeX files)
 #
 # Setup:
 # Make a folder call "tex" and make a subfolder "image" in it.
 # Put this script in the "tex" folder.
 # Put your file downloaded from Scripta Live or Scripta.io in the "tex" folder.
 # Run the script with the same filename as an argument: `sh ./process_file.sh myfile.tex`
 #
 # Plans:
 # This work will be automated in the near future, so that you can just
 # Press a button to do all the work
 #
 # Detail: the script processes its inputs follows:
 # First, it examines the file, finding all urls pointing to images (JPEG or PNG).
 # Next, it downloads the corresponding images, constructing a filename for each
 # image based on its URL, and converts them to EPS format using ImageMagick.
 # These images are then stored in the directory "./image". The URLS in the
 # original LaTeX file are replaced with the local EPS filenames.


# Check if correct number of arguments provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    echo "Example: $0 document.tex"
    exit 1
fi

INPUT_FILE="$1"

# Check if input file exists in current directory
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File $INPUT_FILE not found in current directory"
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
grep -Eo 'https?://[^"{}]+\\.(jpg|jpeg|png)(\\?[^"{}]*)?' "$INPUT_FILE" | sort -u | while read -r url; do
    # Remove query parameters if present
    url_without_query="${url%%\\?*}"

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
    original_filename="${original_filename%%\\?*}"

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
            perl -i -pe "s|\\Q$url\\E|$eps_filename|g" "$TEMP_FILE"
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

# Check if pdflatex is installed
if command -v pdflatex &> /dev/null; then
    echo
    echo "Running pdflatex on $INPUT_FILE..."

    # Get base filename without extension
    BASE_NAME="${INPUT_FILE%.tex}"

    # Run pdflatex twice (for references, TOC, etc.)
    for i in 1 2; do
        echo "Pass $i of 2..."
        if pdflatex -interaction=nonstopmode "$INPUT_FILE" > /dev/null 2>&1; then
            echo "  ✓ Pass $i completed"
        else
            echo "  ✗ Pass $i failed"
            echo "  Check the .log file for errors"
        fi
    done

    if [ -f "${BASE_NAME}.pdf" ]; then
        echo "✓ PDF generated: ${BASE_NAME}.pdf"
    fi
else
    echo "Warning: pdflatex not found. Skipping PDF generation."
fi

# Cleanup auxiliary files
echo
echo "Cleaning up auxiliary files..."
rm -f *.aux *.log *.toc *.out *.synctex.gz *.fls *.fdb_latexmk

echo "Done!"
"""
