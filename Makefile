### Build tools
#
LATEXMK := latexmk -pdflatex="luahblatex %O %S" -pdf -dvi- -ps- -quiet -logfilewarninglist
WS := wolframscript -f

### Directory variables
#
PDF_DIR := pdfs
FIG_DIR := figures
CALC_DIR := calc

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
$(CALC_DIR):
	mkdir -p $(CALC_DIR)

## Figures
#

FIGURES := $(FIG_DIR)/Cond1Im.jpg
$(FIG_DIR)/Cond1Im.jpg: scripts/Cond1ImFigure.wls | $(FIG_DIR)
	$(WS) scripts/Cond1ImFigure.wls

FIGURES += $(FIG_DIR)/Cond1Re.jpg
$(FIG_DIR)/Cond1Re.jpg: scripts/Cond1ReFigure.wls | $(FIG_DIR)
	$(WS) scripts/Cond1ReFigure.wls

.SECONDARY: $(CALC_DIR)/HighTempNam1.csv
$(CALC_DIR)/HighTempNam1.csv: scripts/HighTempNam1Calc.wls | $(CALC_DIR)
	$(WS) scripts/HighTempNam1Calc.wls

FIGURES += $(FIG_DIR)/HighTempNam1.jpg
$(FIG_DIR)/HighTempNam1.jpg: scripts/HighTempNam1Plot.wls | $(FIG_DIR) $(CALC_DIR)/HighTempNam1.csv
	$(WS) scripts/HighTempNam1Plot.wls

## Making main.pdf and other pdfs
#
$(PDF_DIR)/paper.pdf: paper.tex $(MAIN_PDF_DEPS) | $(PDF_DIR) $(FIGURES)
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
