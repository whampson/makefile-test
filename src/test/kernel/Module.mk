EXE         := bin/kernel_test
LINKLIBS    := mm kernel
SOURCES     := test.c

$(eval $(call make-exe, $(EXE), $(SOURCES), $(LINKLIBS)))
