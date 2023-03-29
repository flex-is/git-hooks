SHELL := /bin/bash
SRC_FILES := $(shell find src -type f -name '*.sh' | sort)
HEADER_TMP_FILE := .tmp

.PHONY: help build lint header-comments dist

help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#' Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

build: lint dist # Build and test application.

lint: header-comments # Fix coding standards violations.

header-comments: # Add or replace header comment on all source files.
	@for file in ${SRC_FILES}; do \
		if ! diff --strip-trailing-cr .header.src <(head -n +8 $${file}) &>/dev/null; then \
			echo "fixing $${file}"; \
			cat .header.src > ${HEADER_TMP_FILE}; \
			sed -E '/^#{99}:/,/^#{99}:/d' $${file} >> ${HEADER_TMP_FILE}; \
			cat ${HEADER_TMP_FILE} > $${file}; \
		fi \
	done
	@rm -f ${HEADER_TMP_FILE}

dist: # Generate distributable files.
	@cat .header.dist > dist/all.sh
	@tail -n +9 -q ${SRC_FILES} >> dist/all.sh