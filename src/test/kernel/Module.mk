EXE         := bin/kernel_test
LINKLIBS    := lib/kernel/libkernel.a lib/mm/libmm.a
SOURCES     := test.c

$(eval $(call make-exe, $(EXE), $(SOURCES), $(LINKLIBS)))
