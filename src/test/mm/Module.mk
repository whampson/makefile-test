TARGET      := mm_test
SOURCES     := test2.c
LINKLIBS    := mm.lib

$(eval $(call make-exe, $(TARGET), $(SOURCES), $(LINKLIBS)))
