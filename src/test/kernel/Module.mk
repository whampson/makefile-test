TARGET      := bin/kernel_test
SOURCES     := test.c
LINKLIBS    := \
	$(LIB_ROOT)/mm.lib \
	$(LIB_ROOT)/kernel.lib \

$(eval $(call make-exe, $(TARGET), $(SOURCES), $(LINKLIBS)))
