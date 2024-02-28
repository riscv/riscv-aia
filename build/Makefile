# Makefile for RISC-V ISA Manuals
#
# This work is licensed under the Creative Commons Attribution-ShareAlike 4.0
# International License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-sa/4.0/ or send a letter to
# Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
#
# SPDX-License-Identifier: CC-BY-SA-4.0
#
# Description:
# 
# This Makefile is designed to automate the process of building and packaging 
# the documentation for RISC-V ISA Manuals. It supports multiple build targets 
# for generating documentation in various formats (PDF, HTML).

# Build Targets
TARGETS := aia aia-html aia-latex

# Declare phony targets
.PHONY: all $(TARGETS) clean

# Default target builds all
all: $(TARGETS)

# Asciidoctor options
ASCIIDOCTOR_OPTS := -a --compress \
					--attribute=mathematical-format=svg \
					--attribute=pdf-fontsdir=../src/docs-resources/fonts \
					--attribute=pdf-style=../src/docs-resources/themes/riscv-pdf.yml \
                    --failure-level=ERROR \
                    --require=asciidoctor-diagram \
                    --require=asciidoctor-mathematical \
                    --trace

# Source directory
SRCDIR := ../src

# LaTeX source and related files
SRCS := $(wildcard $(SRCDIR)/latex/*.tex)
FIGS := $(wildcard $(SRCDIR)/images/*)
#BIBS := $(SRCDIR)/latex/riscv-spec.bib

# LaTeX build tools
PDFLATEX := TEXINPUTS=$(SRCDIR)/latex: pdflatex -interaction=nonstopmode -halt-on-error
#BIBTEX := BIBINPUTS=$(SRCDIR)/latex: bibtex

# Temporary files to clean up for LaTeX build
JUNK := *.pdf *.aux *.log *.bbl *.blg *.toc *.out *.fdb_latexmk *.fls *.synctex.gz

# AIA Specification AsciiDoc Build 
aia: riscv-interrupts.pdf

riscv-interrupts.pdf: $(SRCDIR)/riscv-interrupts.adoc $(SRCDIR)/*.adoc
	@echo "Building AIA Specification"
	rm -f $@.tmp
	asciidoctor-pdf $(ASCIIDOCTOR_OPTS) --out-file=$@.tmp $<
	mv $@.tmp $@

# AIA Specification HTML build
aia-html: riscv-interrupts.html

riscv-interrupts.html: $(SRCDIR)/riscv-interrupts.adoc
	@echo "Building AIA HTML Specification"
	asciidoctor $(ASCIIDOCTOR_OPTS) --out-file=$@ $<

# LaTeX build 
aia-latex: riscv-interrupts-latex.pdf

riscv-interrupts-latex.pdf: $(SRCDIR)/latex/preamble.tex $(SRCS) $(FIGS) $(BIBS)
	$(PDFLATEX) preamble
#	$(BIBTEX) riscv-privileged
	$(PDFLATEX) preamble
	$(PDFLATEX) preamble

clean:
	@if [ -f riscv-interrupts.pdf ]; then \
		echo "Removing riscv-interrupts.pdf"; \
		rm -f riscv-interrupts.pdf; \
	fi
	@if [ -f riscv-interrupts.html ]; then \
		echo "Removing riscv-interrupts.html"; \
		rm -f riscv-interrupts.html; \
	fi
	@echo "Cleaning up files from LaTeX build"
	@cd $(SRCDIR)/latex; \
	for file in $(JUNK); do \
		if [ -f "$$file" ]; then \
			echo "Removing $$file"; \
			rm -f "$$file"; \
		fi; \
	done