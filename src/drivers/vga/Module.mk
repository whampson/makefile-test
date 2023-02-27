SOURCES     := vga.c

$(eval $(call make-lib, libvga.a, $(SOURCES), $(LINKLIBS)))
