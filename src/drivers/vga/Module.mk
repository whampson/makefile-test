SOURCES     := vga.c
TARGET      := drivers/libvga.a

$(eval $(call make-lib, $(TARGET), $(SOURCES)))
