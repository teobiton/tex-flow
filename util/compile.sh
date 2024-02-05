#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -n <docname> -p <docpath> -o <outdir> -c <docclass> -t <template>"
    echo "Options:"
    echo "  -n, --docname    Document name"
    echo "  -p, --docpath    Document path"
    echo "  -o, --outdir     Output directory"
    echo "  -c, --docclass   Document class"
    echo "  -t, --template   Template"
    exit 1
}

# Default values
# Number of log lines printed
LINES=35

# Available documents
ARTICLES=$(ls -d articles/*/ | sed 's/articles\///' | sed 's/\///')
ALL=$ARTICLES

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -n|--docname)
            DOCNAME="$2"
            shift
            shift
            ;;
        -p|--docpath)
            DOCPATH="$2"
            shift
            shift
            ;;
        -o|--outdir)
            OUTDIR="$2"
            shift
            shift
            ;;
        -c|--docclass)
            DOCCLASS="$2"
            shift
            shift
            ;;
        -t|--template)
            TEMPLATE="$2"
            shift
            shift
            ;;
        *)
            usage
            ;;
    esac
done

# Check if required arguments are provided
if [ -z "$DOCNAME" ] || [ -z "$DOCPATH" ] || [ -z "$OUTDIR" ] || [ -z "$DOCCLASS" ] || [ -z "$TEMPLATE" ]; then
    usage
fi

echo "Generating $DOCNAME documentation."

if [ ! -f "$DOCPATH/main.tex" ]; then
    echo "Invalid document name: $DOCNAME"
    echo "Available documents:"
    echo "$ALL"
    exit 1
fi

mkdir -p "$OUTDIR"
echo "\newcommand{\docname}{$DOCNAME}" > "$OUTDIR/$DOCNAME.tex"
echo "\newcommand{\docclass}{$DOCCLASS}" >> "$OUTDIR/$DOCNAME.tex"
echo "\input{cls/$TEMPLATE/body}" >> "$OUTDIR/$DOCNAME.tex"

# Functions to run latex commands and check for errors
run_pdflatex() {
    echo -n "  $1 ... "
    if ! pdflatex --halt-on-error --shell-escape --output-directory=$OUTDIR $OUTDIR/$DOCNAME.tex > "$OUTDIR/$2.log"; then
        echo "ERROR! Last pdflatex log lines:"
        tail -n $LINES "$OUTDIR/$2.log" | grep --color .
        exit 1
    fi
    echo "done"
}

run_makeglossary() {
    echo -n "  $1 ... "
    if ! makeglossaries -l -d $OUTDIR/ $DOCNAME > "$OUTDIR/$2.log"; then
        echo "ERROR! Last makeglossary log lines:"
        tail -n $LINES "$OUTDIR/$2.log" | grep --color .
        exit 1
    fi
    echo "done"
}

run_bibtex() {
    echo -n "  $1 ... "
    if ! bibtex $OUTDIR/$DOCNAME > "$OUTDIR/$2.log"; then
        echo "ERROR! Last bibtex log lines:"
        tail -n $LINES "$OUTDIR/$2.log" | grep --color .
        exit 1
    fi
    echo "done"
}

# Run latex commands
run_pdflatex "First pass" "pdflatex_1"
run_makeglossary "Making glossary" "makeglossary"
run_bibtex "Running bibtex" "bibtex"
run_pdflatex "Second pass" "pdflatex_2"
run_pdflatex "Final pass" "pdflatex_3"

mv "$OUTDIR/$DOCNAME.pdf" "./$DOCNAME.pdf"
echo "Added $DOCNAME.pdf to the root directory."
