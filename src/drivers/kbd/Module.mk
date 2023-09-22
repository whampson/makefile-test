TARGET  := drivers/kbd.lib
SOURCES := kbd.c

$(eval $(call make-lib,$(TARGET),$(SOURCES)))
