TARGET  := drivers/vga.lib
SOURCES := vga.c

$(eval $(call make-lib, $(TARGET), $(SOURCES)))
