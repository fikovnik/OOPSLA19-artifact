SCRIPTS_DIR := ../../scala-implicits-analysis/scripts

.PHONY: all build clean implicits console

all: implicits

clean:
	sbt clean
	-rm -fr *.csv
	-rm -fr _analysis_
	-rm -fr _ivy_

build:
	[ -d _ivy_ ] || mkdir _ivy_
	[ -L _ivy_/local ] || ln -s $(GLOBAL_IVY_DIR)/local _ivy_/local
	[ -L _ivy_/cache ] || ln -s $(GLOBAL_IVY_DIR)/cache _ivy_/cache
	GIT_DISCOVERY_ACROSS_FILESYSTEM=1 sbt -ivy _ivy_ metadata semanticdb
	amm $(SCRIPTS_DIR)/merge-semanticdbs.sc

implicits: build
	amm $(SCRIPTS_DIR)/extract-implicits.sc
	amm $(SCRIPTS_DIR)/export-implicits.sc _analysis_/implicits.bin

console: implicits
	amm -p $(SCRIPTS_DIR)/implicits-analysis-session.sc
