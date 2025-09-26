module AppData exposing (defaultDocumentText, processImagesText)


defaultDocumentText : String
defaultDocumentText =
    """| title number-to-level:1
Announcement

[vspace 30]
[large [italic This is what you can do with Scripta Live:]]

| image figure:1 caption: Humming bird
https://www.realsimple.com/thmb/7xn0oIF6a9eJ-y_4OO5vN0lJhCg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/humming-bird-flowers-GettyImages-1271839175-b515cb4f06a34e66b084ba617995f00a.jpg

| equation label:wave-equation
pdd(u,x) + pdd(u,y) + pdd(u,z) = frac(1,c^2) pdd(u,t))


[large [i ...make beautiful things with simple tools.]]
[vspace 30]


[i Note: See [eqref heat-equation] for the heat equation in three dimensions.]

# About Scripta Live

Scripta is a markup language much like LaTeX, but with a simplified, ergonomic syntax.
Better yet: what you write (here, on the left) is rendered
[i instantaneously ] in the right-hand window pane. No setup required.
Just click the "New" button and start writing.

- Your documents are saved in the browser's local storage or in an
sqlite database, depending on the version.  If you refresh the
browser or close it and come back to it later, it will be there, waiting for you.

- Use the megaphone icon on the right to report bugs, ask questions, and make suggestions.

- Scripta documents can be exported to standard LaTeX or to PDF.


# Examples

| mathmacros
pdd:  frac(partial^2 #1, partial #2^2)
nat:    mathbb N
reals: mathbb R
pd:  frac(partial #1, partial #2)
set:    \\{ #1 \\}
sett:   \\{ #1 \\ | \\ #2 \\}

Pythagoras said: $a^2 + b^2 = c^2$.

This will be on the test:

| equation
int_0^1 x^n dx = frac(1,n+1)


Both of the above equalities were written using an `equation` block.  If you look
at the source text on the left,
you will see that [eqref wave-equation] a
a property, namely  `label:wave-equation`. The property is used for cross-referencing: we say `[eqref wave-equation]` to make a hot link to [eqref wave-equation].  Click on it now
to see what happens.

Here is an [u aligned] block:

| aligned
nat &= set("positive whole numbers and zero")
nat &= sett(n " is a whole number", n > 0)

| equation
\\begin{pmatrix}
2 & 1 \\
1 & 2
\\end{pmatrix}
\\begin{pmatrix}
2 & 1 \\
1 & 2
\\end{pmatrix}
=
\\begin{pmatrix}
5 & 4 \\
4 & 5
\\end{pmatrix}

| hide
| image caption: Cloud Chamber
https://www.researchgate.net/publication/329220318/figure/fig2/AS:697638865338375@1543341475684/Trajectories-in-a-Cloud-Chamber-the-core-evidence-for-the-local-particle-nature-of.png

| equation label:heat-equation
alpha \\left( pdd(u,x) + pdd(u,y) + pdd(u,z) \\right) =  pd(u,t))
qquad "Heat Equation"
"""


text2 =
    """
| title
The Scripta Markup Language

Scripta is a markup language for making documents with equations and images:

| equation
int_0^1 x^n dx = frac(1, n + 1)

| image caption: Cloud Chamber
https://www.researchgate.net/publication/329220318/figure/fig2/AS:697638865338375@1543341475684/Trajectories-in-a-Cloud-Chamber-the-core-evidence-for-the-local-particle-nature-of.png

Here is how we wrote it:

| code
| equation
int_0^1 x^n dx = frac(1, n + 1)

In TeX, we would have written

| code
\\begin{equation}
\\int_0^1 x^n dx = \\frac{1, n + 1}
\\end{equation}

A Scripta document

If you already know TeX or LaTeX, you already know how to do $90^\u{0003}%$ guess most of what you need to know:

. Write simple subscripts as in `x_1` and compliadted ones as in `x_{32}`

| mathmacros
secpder:  frac(partial^2 #1, partial #2^2)
nat:    mathbb N
reals: mathbb R
pder:  frac(partial #1, partial #2)
set:    \\{ #1 \\}
sett:   \\{ #1 \\ | \\ #2 \\}


| image figure:1 caption: Humming bird
https://www.realsimple.com/thmb/7xn0oIF6a9eJ-y_4OO5vN0lJhCg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/humming-bird-flowers-GettyImages-1271839175-b515cb4f06a34e66b084ba617995f00a.jpg

| equation numbered
\\label{wave-equation}
secpder(u,x) + secpder(u,y) + secpder(u,z) = frac(1,c^2) secpder(u,t)) 1

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
    fi/
else
    echo "Warning: pdflatex not found. Skipping PDF generation."
fi

# Cleanup auxiliary files
echo
echo "Cleaning up auxiliary files..."
rm -f *.aux *.log *.toc *.out *.synctex.gz *.fls *.fdb_latexmk

echo "Done!"
"""
