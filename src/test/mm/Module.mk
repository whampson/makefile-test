EXE         := bin/mm_test
LINKLIBS    := mm
SOURCES     := test2.c

$(eval $(call make-exe, $(EXE), $(SOURCES), $(LINKLIBS)))
