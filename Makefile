.PHONY: it

it: # Generate distributable files.
	find ./src/ -name '*.sh' -exec awk -F: 'FNR==1{print ""}1' {} > ./dist/all.sh \;
