TARGET      := bin/mm_test
SOURCES     := test2.c
LINKLIBS    := \
	$(LIB_ROOT)/mm.lib \

$(eval $(call make-exe, $(TARGET), $(SOURCES), $(LINKLIBS)))
