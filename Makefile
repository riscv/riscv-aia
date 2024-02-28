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
TARGETS := aia aia-html

# Declare phony targets
.PHONY: all $(TARGETS) clean

# Default target builds all
all: $(TARGETS)

#ifneq ($(SKIP_DOCKER),true)
#	DOCKER_CMD := docker run --rm -v ${PWD}:/build -w /build \
#	riscvintl/riscv-docs-base-container-image:latest \
#	/bin/sh -c
#	DOCKER_QUOTE := "
#endif

# Asciidoctor options
ASCIIDOCTOR_OPTS := -a --compress \
					--attribute=mathematical-format=svg \
                    --failure-level=ERROR \
                    --require=asciidoctor-diagram \
                    --require=asciidoctor-mathematical \
                    --trace

# Source directory
SRCDIR := src


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

clean:
	@if [ -f riscv-interrupts.pdf ]; then \
		echo "Removing riscv-interrupts.pdf"; \
		rm -f riscv-interrupts.pdf; \
	fi
	@if [ -f riscv-interrupts.html ]; then \
		echo "Removing riscv-interrupts.html"; \
		rm -f riscv-interrupts.html; \
	fi
	done