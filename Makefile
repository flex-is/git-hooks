.PHONY: dist

dist: # Generate distributable files.
	@cat dist/.header > dist/all.sh
	@find src -type f -name "*.sh" | sort | xargs tail -n +7 -q >> dist/all.sh