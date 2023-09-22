TARGET  := kernel_test
SOURCES := test.c
LINKLIBS:= mm/mm.lib kernel/kernel.lib
CFLAGS  := -Wpedantic
LNKFLAGS:= -Wpedantic -m32

$(eval $(call make-exe,$(TARGET),$(SOURCES),$(LINKLIBS),$(CFLAGS),$(LNKFLAGS)))
