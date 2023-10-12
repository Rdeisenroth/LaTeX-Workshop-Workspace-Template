
OUT_DIR := build/
TOPTARGETS := clean all
FILES := $(wildcard *.tex)

define compile_latex_with_jobname_and_env
	cd $(4) && $(3) latexmk --shell-escape -synctex=1 -interaction=nonstopmode -file-line-error -lualatex -jobname=$(2) "$(1)"
endef

define build_latex_with_jobname_and_env
	$(eval DIR := $(dir $(1)))
	$(eval FILE := $(notdir $(1)))
	@echo -e "\e[1;32mCompiling \"$(FILE)\" in \"$(DIR)\" with jobname \"$(2)\"$<\e[0m"
	@$(call compile_latex_with_jobname_and_env,$(FILE),$(2),$(3),$(DIR))
	@echo -e "\e[1;32mSuccessfully compiled \"$(FILE)\" in \"$(DIR)\" with jobname \"$(2)\"$<\e[0m"
	@mkdir -p $(OUT_DIR)
	@mv $(DIR)/$(2).pdf $(OUT_DIR)/
endef


all:
	$(MAKE) clean
	$(MAKE) compile

$(FILES:.tex=.tex.regular):
	$(eval FILE := $(patsubst %.tex.regular,%.tex,$@))
	$(call build_latex_with_jobname_and_env,$(FILE),$(patsubst %.tex,%,$(FILE)),)

# $(FILES:.tex=.tex.darkmode):
# 	$(eval FILE := $(patsubst %.tex.darkmode,%.tex,$@))
# 	$(call build_latex_with_jobname_and_env,$(FILE),$(patsubst %.tex,%-darkmode,$(FILE)),DARK_MODE=1)

compile: $(FILES:.tex=.tex.regular) # $(FILES:.tex=.tex.darkmode)
	@echo -e "\e[1;42mAll Done. PDFs can be found in \"$(OUT_DIR)\"\e[0m"

clean:
	@echo -e "\e[1;34mCleaning up leftover build files...$<\e[0m"
	@latexmk -C -f
	@find . -wholename '**/options.cfg' -delete
	@find . -maxdepth 1 -wholename '**/*.pdf' -delete
	@find . -wholename '**/*.aux' -delete
	@find . -wholename '**/*.fdb_latexmk' -delete
	@find . -wholename '**/*.fls' -delete
	@find . -wholename '**/*.len' -delete
	@find . -wholename '**/*.listing' -delete
	@find . -wholename '**/*.log' -delete
	@find . -wholename '**/*.out' -delete
	@find . -wholename '**/*.synctex.gz' -delete
	@find . -wholename '**/*.toc' -delete
	@find . -wholename '**/*.nav' -delete
	@find . -wholename '**/*.snm' -delete
	@find . -wholename '**/*.vrb' -delete
	@find . -wholename '**/*.bbl' -delete
	@find . -wholename '**/*.blg' -delete
	@find . -wholename '**/*.idx' -delete
	@find . -wholename '**/*.ilg' -delete
	@find . -wholename '**/*.ind' -delete
	@find . -wholename '**/*.pyg' -delete
	@find . -wholename '**/*.bak[0-9]*' -delete
	@find . -wholename '**/_minted-*' -delete
	@echo -e "\e[1;44mDone cleaning up leftover build files.$<\e[0m"

cleanBuild:
	@echo -e "\e[1;34mCleaning up build directory...$<\e[0m"
	@rm -rf build
	@echo -e "\e[1;44mDone cleaning up build directory.$<\e[0m"

cleanAll: clean cleanBuild

.PHONY: $(TOPTARGETS) $(FILES)
