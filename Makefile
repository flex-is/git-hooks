.PHONY: dist

dist: # Generate distributable files.
	@cat dist/.header > dist/all.sh
	@tail -n +7 -q $(find src -type f -name "*.sh" | sort) >> dist/all.sh
