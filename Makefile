SRC_NAME := rad
DICT_FILENAME := dictionary.txt
BUILD_DIR := build
TEST_DIR := tests
FLAGS := -halt-on-error

# For testing
# CAUTION: GH Actions Upload test artifacts depends on this
TEST_TEX_DPL := $(TEST_DIR)/test_diplomski.tex
TEST_TEX_ZVR := $(TEST_DIR)/test_zavrsni.tex
TEST_TEX_SEM := $(TEST_DIR)/test_seminar.tex

TEST_BUILD_DIR_DPL := $(BUILD_DIR)/$(TEST_DIR)/test_diplomski
TEST_BUILD_DIR_ZVR := $(BUILD_DIR)/$(TEST_DIR)/test_zavrsni
TEST_BUILD_DIR_SEM := $(BUILD_DIR)/$(TEST_DIR)/test_seminar

TEST_AUX_DPL := $(TEST_BUILD_DIR_DPL)/test_diplomski.aux
TEST_AUX_ZVR := $(TEST_BUILD_DIR_ZVR)/test_zavrsni.aux
TEST_AUX_SEM := $(TEST_BUILD_DIR_SEM)/test_seminar.aux

SRC_BUILD_DIR:= $(BUILD_DIR)
SRC_TEX:= $(SRC_NAME).tex
SRC_AUX := $(BUILD_DIR)/$(SRC_NAME).aux

# $(call export_to_pdf,build_dir,tex_path,aux_path,flags)
define export_to_pdf
	mkdir -p $(1)
	pdflatex $(4) -output-directory $(1) $(2)
	bibtex $(3)
	pdflatex $(4) -output-directory $(1) $(2)
	pdflatex $(4) -output-directory $(1) $(2)
endef

.PHONY: all setup build spellcheck test clean help

all: build

setup:
	sudo apt-get install -y texlive-latex-recommended texlive-lang-european texlive-fonts-recommended aspell-hr

build:
	$(call export_to_pdf,$(SRC_BUILD_DIR),$(SRC_TEX),$(SRC_AUX),$(FLAGS))

spellcheck:
	@bash scripts/spellcheck.sh -d $(DICT_FILENAME) -s $(SRC_TEX)

test:
	$(call export_to_pdf,$(TEST_BUILD_DIR_DPL),$(TEST_TEX_DPL),$(TEST_AUX_DPL),$(FLAGS))
	$(call export_to_pdf,$(TEST_BUILD_DIR_ZVR),$(TEST_TEX_ZVR),$(TEST_AUX_ZVR),$(FLAGS))
	$(call export_to_pdf,$(TEST_BUILD_DIR_SEM),$(TEST_TEX_SEM),$(TEST_AUX_SEM),$(FLAGS))

clean:
	rm -rf $(BUILD_DIR)

help:
	@echo all setup build spellcheck test clean help
