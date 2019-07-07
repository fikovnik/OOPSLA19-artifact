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

%.feather.gz:
	curl --progress-bar -O $(BASE_URL)/$@

%.feather: %.feather.gz
	gunzip -f --keep $<

.PHONY: all clean fetch

all: fetch

clean:
	-rm -f $(REMOTE) $(LOCAL)

fetch: $(LOCAL)
