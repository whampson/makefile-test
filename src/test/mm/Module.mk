EXE         := bin/mm_test
LINKLIBS    := lib/mm/libmm.a
SOURCES     := test2.c

$(eval $(call make-exe, $(EXE), $(SOURCES), $(LINKLIBS)))
