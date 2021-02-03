### Build tools
#
LATEXMK := latexmk -pdflatex="luahblatex %O %S" -pdf -dvi- -ps- -quiet -logfilewarninglist
WS := wolframscript -f

### Directory variables
#
PDF_DIR := pdfs
FIG_DIR := figures

### Here we go
#
OUT_PDF:= $(PDF_DIR)/paper.pdf

.PHONY: all
all: $(OUT_PDF)

### How we do that
#

## setup main pdf deps as variable that subdirs can add to
MAIN_PDF_DEPS := bibliography.bib

## Defining common directory recipes
$(PDF_DIR):
	mkdir $(PDF_DIR)
$(FIG_DIR):
	mkdir -p $(FIG_DIR)

## Making main.pdf and other pdfs
#
$(PDF_DIR)/paper.pdf: paper.tex $(MAIN_PDF_DEPS) | $(PDF_DIR)
	$(LATEXMK) $(<F)
	cp $(@F) $@

### Convenience scripts for tidying tex
.PHONY: declutter
declutter:
	@rm -f *.tdo
	@rm -f *.run.xml
	@rm -f *.bbl

.PHONY: tidy
tidy: declutter
	@latexmk -c
.PHONY: clean
clean: declutter
	rm -rf $(PDF_DIR)
	@latexmk -C
