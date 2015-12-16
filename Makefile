PLUGIN_NAME = vivi
VITAL_MODULES = System.Filepath \
				Data.List \
				ConcurrentProcess

THEMIS = themis
VIMDOC = vimdoc
VINT = beco vint

.PHONY: all test doc lint clean
all: $(vitalize) $(doc) $(test) $(lint)

vitalize:
	vim -c "Vitalize . --name=$(PLUGIN_NAME) $(VITAL_MODULES)" -c q

test:
	$(THEMIS)

doc:
	$(VIMDOC) .

lint:
	find . -name "*.vim" | grep -v vital | xargs $(VINT)

clean:
	/bin/rm -rf autoload/vital*
