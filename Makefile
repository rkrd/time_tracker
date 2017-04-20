FILES := $(wildcard *)
METAS := Makefile README.md
SOURCES := $(filter-out $(METAS),$(FILES))
BINFILES := $(patsubst %, $(HOME)/bin/%, $(SOURCES))

install: $(BINFILES)

$(BINFILES) : $(addprefix $(HOME)/bin/,%) : $(PWD)/%
	ln -s $< $@

.PHONY: uninstall
uninstall:
	@for f in $(BINFILES); do if [ -h $$f ]; then rm -i $$f; fi; done
