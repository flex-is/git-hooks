.PHONY: dist

dist: # Generate distributable files.
	@> dist/all.sh
	@awk 'FNR==1{print ""}1' $$(find src -type f | sort) >> dist/all.sh
