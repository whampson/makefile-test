CC          := cc
MKDIR       := mkdir -p
MV          := mv -f
RM          := rm -f
SED         := sed

INCLUDES    := src/inc
MODULES     := \
	src/kernel \
	src/mm \
	src/test \
	src/test2 \

ALL_SOURCES :=
BIN_TARGETS :=
LIB_TARGETS :=

BINROOT     := bin/
OBJROOT     := obj/
LIBROOT     := lib/
SRCROOT     := src/

MODMAKE     := Module.mk

DEPENDS = $(subst .o,.d,$(OBJECTS))

# $(call source-to-object, source-file-list)
source-to-object = $(subst $(SRCROOT),$(OBJROOT),$(subst .c,.o,$(filter %.c,$1)))

# $(MODDIR)
# TODO: this needs to be reworked to omit .d files
MODDIR = $(patsubst %/$(MODMAKE),%,$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
OBJDIR = $(subst $(SRCROOT),$(OBJROOT),$(MODDIR))
LIBDIR = $(subst $(SRCROOT),$(LIBROOT),$(MODDIR))

CFLAGS += $(addprefix -I,$(INCLUDES))

# $(call make-program, program-name, source-file-list)
define make-program
  BIN_TARGETS += $(TARGET)
  ALL_SOURCES += $(addprefix $(MODDIR)/,$(SOURCES))
  $(TARGET): $(call source-to-object,$(addprefix $(MODDIR)/,$(SOURCES))) $(TARGETLIBS)
	$(CC) -o $$@ $$^
endef

# $(call make-library)
define make-library
  LIB_TARGETS += $(addprefix $(LIBDIR)/,$(TARGET))
  ALL_SOURCES += $(addprefix $(MODDIR)/,$(SOURCES))
  $(addprefix $(LIBDIR)/,$(TARGET)): $(call source-to-object,$(addprefix $(MODDIR)/,$(SOURCES)))
	$(AR) rcs $$@ $$^
endef

# $(call make-object, object-name, source-name)
define make-object
  OBJECTS += $1
  $1: $2
	$(CC) $(CFLAGS) -c -MD -MF $$(@:.o=.d) -o $$@ $$<
endef

all:

vpath %.h $(INCLUDES)
include $(addsuffix /$(MODMAKE),$(MODULES))

.SECONDARY: $(OBJECTS)
.PHONY: all dirs clean nuke debug-make

all: dirs $(LIB_TARGETS) $(BIN_TARGETS)

dirs:
	$(MKDIR) $(dir $(OBJECTS) $(LIB_TARGETS) $(BIN_TARGETS))

clean:
	$(RM) $(BIN_TARGETS) $(LIB_TARGETS) $(OBJECTS) $(DEPENDS)

nuke:
	$(RM) -r $(BINROOT) $(LIBROOT) $(OBJROOT)

debug-make:
	@echo 'ALL_SOURCES = $(ALL_SOURCES)'
	@echo 'LIB_TARGETS = $(LIB_TARGETS)'
	@echo 'BIN_TARGETS = $(BIN_TARGETS)'
	@echo 'INCLUDES = $(INCLUDES)'
	@echo 'OBJECTS = $(OBJECTS)'
	@echo 'DEPENDS = $(DEPENDS)'

# generate object file rules
$(foreach _src, $(ALL_SOURCES), $(eval $(call make-object,$(call source-to-object,$(_src)),$(_src))))

-include $(DEPENDS)
