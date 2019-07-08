BASE_URL := "http://prl1.ele.fit.cvut.cz:8149/github"

REMOTE := corpus-stage1.feather.gz \
  corpus-stage3.feather.gz \
  implicits-exceptions.feather.gz \
  implicit-callsites.feather.gz \
  implicit-callsites-problems.feather.gz \
  implicit-declarations.feather.gz \
  implicit-declarations-problems.feather.gz \
  implicit-conversions.feather.gz \
  implicit-conversions-problems.feather.gz \
  implicit-parameters.feather.gz \
  implicit-parameters-problems.feather.gz

LOCAL := ${REMOTE:feather.gz=feather}

SCRIPTS_DIR := ../../scala-implicits-analysis/scripts

%.feather.gz:
	curl --progress-bar -O $(BASE_URL)/$@

%.feather: %.feather.gz
	gunzip -f --keep $<

.PHONY: all clean fetch

all: fetch report

clean:
	-rm -f $(REMOTE) $(LOCAL)

fetch: $(LOCAL)

%.html:
	Rscript -e "rmarkdown::render('$(SCRIPTS_DIR)/analysis/${@:html=Rmd}', output_dir='$(CURDIR)', params=list(base_dir='$(CURDIR)', lib_dir='../inc'))"

report: $(LOCAL) stage1-analysis.html stage3-analysis.html implicits-analysis.html
