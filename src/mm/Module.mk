TARGET  := mm/mm.lib
SOURCES := mm.c

$(eval $(call make-lib,$(TARGET),$(SOURCES)))
