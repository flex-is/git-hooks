MERGE = awk 'FNR==1{print ""}1'
DIST_ALL = dist/all.sh

.PHONY: it

it: # Generate distributable files.
	${MERGE} src/msg.sh > ${DIST_ALL}
	${MERGE} src/git.sh >> ${DIST_ALL}
	${MERGE} src/php/*.sh >> ${DIST_ALL}
