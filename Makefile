CC          := cc
MKDIR       := mkdir -p
MV          := mv -f
RM          := rm -f
SED         := sed

# TODO: search tree for modules?
MODULES     := \
	src/drivers/kbd \
	src/drivers/vga \
	src/kernel \
	src/mm \
	src/test/kernel \
	src/test/mm \

INCLUDES    := src/inc

BINROOT     := bin/
OBJROOT     := obj/
LIBROOT     := lib/
SRCROOT     := src/

MOD_MK      := Module.mk

_SOURCES    :=
_BINARIES   :=
_LIBRARIES  :=

DEPENDS      = $(subst .o,.d,$(_OBJECTS))
SRC_DIR      = $(patsubst %/$(MOD_MK),%,$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
BIN_DIR      = $(subst $(SRCROOT),$(BINROOT),$(SRC_DIR))
LIB_DIR      = $(subst $(SRCROOT),$(LIBROOT),$(SRC_DIR))
OBJ_DIR      = $(subst $(SRCROOT),$(OBJROOT),$(SRC_DIR))


CFLAGS += $(addprefix -I,$(INCLUDES))

# $(call get-obj-name, source-list)
get-obj-name = $(subst $(SRCROOT),$(OBJROOT),$(subst .c,.o,$(filter %.c,$1)))

define make-exe	# exe-path, source-list, [link-libs]
  _BINARIES += $1
  _SOURCES += $(addprefix $(SRC_DIR)/,$2)
  $1: $(call get-obj-name,$(addprefix $(SRC_DIR)/,$2)) $3
	$(CC) -o $$@ $$^
endef

define make-lib # lib-name, source-list
  _LIBRARIES += $(addprefix $(LIB_DIR)/,$1)
  _SOURCES += $(addprefix $(SRC_DIR)/,$2)
  $(addprefix $(LIB_DIR)/,$1): $(call get-obj-name,$(addprefix $(SRC_DIR)/,$2))
	$(AR) rcs $$@ $$^
endef

define make-obj # obj-name, source-list
  _OBJECTS += $1
  $1: $2
	$(CC) $(CFLAGS) -c -MD -MF $$(@:.o=.d) -o $$@ $$<
endef

all:

vpath %.h $(INCLUDES)
include $(addsuffix /$(MOD_MK),$(MODULES))

.SECONDARY: $(_OBJECTS)
.PHONY: all dirs clean nuke debug-make

all: dirs $(_LIBRARIES) $(_BINARIES)

dirs:
	$(MKDIR) $(dir $(_OBJECTS) $(_LIBRARIES) $(_BINARIES))

clean:
	$(RM) $(_BINARIES) $(_LIBRARIES) $(_OBJECTS) $(DEPENDS)

nuke:
	$(RM) -r $(BINROOT) $(LIBROOT) $(OBJROOT)

debug-make:
	@echo 'INCLUDES = $(INCLUDES)'
	@echo '_SOURCES = $(_SOURCES)'
	@echo '_LIBRARIES = $(_LIBRARIES)'
	@echo '_BINARIES = $(_BINARIES)'
	@echo '_OBJECTS = $(_OBJECTS)'
	@echo 'DEPENDS = $(DEPENDS)'

# generate object file rules
$(foreach _src, $(_SOURCES), $(eval $(call make-obj, $(call get-obj-name, $(_src)), $(_src))))

-include $(DEPENDS)
