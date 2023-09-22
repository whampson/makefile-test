TARGET  := kernel/kernel.lib
SOURCES := init.c kmain.c

$(eval $(call make-lib,$(TARGET),$(SOURCES)))
