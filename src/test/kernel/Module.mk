TARGET  := kernel_test         # relative to $(BINDIR) or bin/
SOURCES := test.c              # relative to $(MODDIR) or src/test/mm/
LIBS    := mm.lib kernel.lib   # relative to $(LIBDIR) or lib/

$(eval $(call make-exe, $(TARGET), $(SOURCES), $(LIBS)))
