TARGET  := mm.lib
SOURCES := mm.c

$(eval $(call make-lib, $(TARGET), $(SOURCES)))
