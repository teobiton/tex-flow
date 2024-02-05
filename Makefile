DOCNAME = example

# Document type
DOCCLASS = docs

# Template used
TEMPLATE = default

ifeq ($(DOCNAME), example)
	TEMPLATE = tches
	DOCCLASS = articles
endif

DOCPATH = $(DOCCLASS)/$(DOCNAME)
OUTDIR  = temp/$(DOCNAME)

# Find all available documents
ARTICLES = $(shell ls -d articles/*/ | sed 's/articles\///' | sed 's/\///')
ALL      = $$(ARTICLES)

# Path to a CSV acronym database
CSV = acronyms.csv
DELIMITER = ';'

# Produce document in .pdf format
all: $(OUTDIR)/$(DOCNAME).pdf

# Produce document in PDF format
$(OUTDIR)/$(DOCNAME).pdf:

	@bash util/compile.sh -n $(DOCNAME) -p $(DOCPATH) -o $(OUTDIR) -c $(DOCCLASS) -t $(TEMPLATE)

# Generate all available documentats
build-all: $(ALL)

$(ALL):

	@echo "Generating $@ document."
	@$(MAKE) --quiet all DOCNAME=$@ > /dev/null
	@echo "Generated $@ at $@.pdf"

# Generate acronyms database
acronyms:

	@rm -f common/acronyms.tex
	@touch common/acronyms.tex
	@python3 util/gen_acronyms.py $(CSV) --output=common/acronyms.tex -d$(DELIMITER)
	@echo "Generated common/acronyms.tex from $(CSV) database."

# Delete temp files (to force recompile) FOR ONE DOC
clean:

	@rm -rf $(OUTDIR)
	@rm -f $(DOCNAME).pdf
	@echo "Removed $(OUTDIR) and $(DOCNAME).pdf."

# Delete all compilation output files FOR ALL DOCS
reset:

	@rm -rf temp
	@rm -f *.pdf
	@echo "Removed folder temp/ and all pdfs."
