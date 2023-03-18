# Project's name is used to generate the pdf output
PRJ_NAME=MY_PROJECT# Adapt to your own project

SOURCE = main
OUT_DIR = ./temp
#LATEX_CMD = latex -output-format='pdf' -output-directory=$(OUT_DIR) $(SOURCE).tex
TEX_FLAGS = -halt-on-error
LATEX_CMD = pdflatex -output-directory=$(OUT_DIR) $(SOURCE).tex

draw_src = $(shell find ./img-data -type f -name "*.draw.svg")
draw_target = $(draw_src:./img-data/%.draw.svg=./img-data/%.draw.pdf)

tex_src = $(shell find ./ -name "*.tex" -type f)

#https://unix.stackexchange.com/questions/140912/no-target-error-using-make


# Needed: "latex" and "texlive-bibtex-extra"
./$(PRJ_NAME).pdf: $(tex_src) $(draw_target) makefile
	@if [ ! -d "temp/" ]; then mkdir temp;  mkdir temp/texSection; fi
	$(LATEX_CMD) | ./texConf/analyse_log_latex.sh
	bibtex ./$(OUT_DIR)/$(SOURCE) | ./texConf/analyse_log_bibTex.sh
	makeglossaries -d temp/ main
	$(LATEX_CMD) > /dev/null
	$(LATEX_CMD) > /dev/null
	@mv ./temp/main.pdf ./$(PRJ_NAME).pdf
	@echo "The compilation is finished, well done"

# Generate png from svg
#	Input svg file, <name>.drawio.svg
#	Output png file, <name>.drawio.png
./img-data/%.draw.pdf: ./img-data/%.draw.svg
	rsvg-convert -f pdf -o $@ $<

# Delete .aux files (to force recompile)
clean:
	find . -name '*.aux' -delete
	rm -f $(SOURCE).pdf

# Delete all compilation output files
reset:
	make clean
	rm -f ./$(PRJ_NAME).pdf
	rm -R -f temp

# Copy the current version of the report at the root of the project
release:
	make
# For a release, it is recommended to compile thrice (for labels and references)
	$(LATEX_CMD)
	$(LATEX_CMD)
	mv ./temp/main.pdf ./$(PRJ_NAME).pdf
	cp -f ./$(PRJ_NAME).pdf ../
