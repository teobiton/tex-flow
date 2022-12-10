# Project's name is used to generate the pdf output
PRJ_NAME=MY_PROJECT # Adapt to your own project

SOURCE = main
OUT_DIR = ./temp
LATEX_CMD = latex -output-format='pdf' -output-directory=$(OUT_DIR) $(SOURCE).tex

draw_src = $(shell find ./figure -type f -name "*.drawio.svg")
draw_target = $(draw_src:./figure/%.drawio.svg=./figure/%.drawio.png)

#https://unix.stackexchange.com/questions/140912/no-target-error-using-make


# Needed: "latex" and "texlive-bibtex-extra"
./$(OUT_DIR)/$(SOURCE).aux: *.tex ./texContent/* $(draw_target) makefile
	if [ ! -d "temp/" ]; then mkdir temp;  mkdir temp/texContent; fi
	$(LATEX_CMD)
	bibtex ./$(OUT_DIR)/$(SOURCE)
# https://www.dickimaw-books.com/software/bib2gls/
# Java needed to execute
	bib2gls ./$(OUT_DIR)/$(SOURCE)
	mv ./temp/main.pdf ./$(PRJ_NAME).pdf

# Generate png from svg
#	Input svg file, <name>.drawio.svg
#	Output png file, <name>.drawio.png
./figure/%.drawio.png: ./figure/%.drawio.svg
	inkscape --export-area-drawing --export-dpi=300 --export-png=$@ $<

# Delete .aux files (to force recompile)
clean:
	find . -name '*.aux' -delete

# Delete all compilation output files
reset:
	make clean
	rm -f $(SOURCE).pdf
	rm -R -f temp

# Copy the current version of the report at the root of the project
release:
	make
# For a release, it is recommended to compile thrice (for labels and references)
	$(LATEX_CMD)
	$(LATEX_CMD)
	mv ./temp/main.pdf ./$(PRJ_NAME).pdf
	cp -f ./$(PRJ_NAME).pdf ../
