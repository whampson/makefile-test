TARGET  := mm_test
SOURCES := test2.c
LINKLIBS:= mm/mm.lib
LNKFLAGS:= -m32

$(eval $(call make-exe,$(TARGET),$(SOURCES),$(LINKLIBS),,$(LNKFLAGS)))
