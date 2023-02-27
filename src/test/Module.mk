TARGET     := bin/test
TARGETLIBS := lib/kernel/libkernel.a lib/mm/libmm.a
SOURCES    := test.c

$(eval $(call make-program))
