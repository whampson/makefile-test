# TODO: search tree for modules?
export MODULES  := \
	drivers/kbd \
	drivers/vga \
	kernel \
	mm \
	test/kernel \
	test/mm \

export BIN_ROOT         := bin
export OBJROOT          := obj
export SOURCE_ROOT      := src

export DEFAULT_INCLUDES := inc
export DEFAULT_CFLAGS   :=
export DEFAULT_DEFINES  :=

export CC               := cc
export MKDIR            := mkdir -p
export MV               := mv -f
export RM               := rm -f

# Current module directory.
# DO NOT call from this Makefile!! Ok to use in define.
export MODULE = $(patsubst %/$(_MODFILE),%,$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

# =================================================================================================

_MODFILE    := Module.mk
_OBJECTS    :=
_BINARIES   :=
_LIBRARIES  :=

_MODULES     = $(addprefix $(SOURCE_ROOT)/,$(MODULES))
_INCLUDES    = $(addprefix $(SOURCE_ROOT)/,$(DEFAULT_INCLUDES))
_DEPENDS     = $(subst .o,.d,$(_OBJECTS))

# $(call make-exe, exe-path, source-list, [link-libs], [cflags], [linkflags])
define make-exe
  _BINARIES += $(addprefix $(BIN_ROOT)/,$1)
  $(foreach _src,$(addprefix $(MODULE)/,$2),$(eval $(call make-obj,$(call get-obj-path,$(_src)),$(_src),$4)))
  $(addprefix $(BIN_ROOT)/,$1): $(call get-obj-path,$(addprefix $(MODULE)/,$2))
	$(CC) $5 -o $$@ $$^ $(addprefix $(OBJROOT)/,$3)
endef

# $(call make-lib, lib-name, source-list)
define make-lib
  _LIBRARIES += $(addprefix $(OBJROOT)/,$1)
  $(foreach _src,$(addprefix $(MODULE)/,$2),$(eval $(call make-obj,$(call get-obj-path,$(_src)),$(_src),$4)))
  $(addprefix $(OBJROOT)/,$1): $(call get-obj-path,$(addprefix $(MODULE)/,$2))
	$(AR) rcs $$@ $$^
endef


# $(call get-obj-path, source-list)
define get-obj-path
  $(subst $(SOURCE_ROOT)/,$(OBJROOT)/,$(subst .c,.o,$(filter %.c,$1)))
endef

# $(call make-obj, obj-path, source-list, [cflags])
define make-obj
  _OBJECTS += $1
  $1: $2
	$(CC) -o $$@ $(DEFAULT_CFLAGS) $(addprefix -D,$(DEFAULT_DEFINES)) $(addprefix -I,$(_INCLUDES)) $3 -c -MD -MF $$(@:.o=.d) $$<
endef

# uniq - https://stackoverflow.com/a/16151140
uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))

# =================================================================================================

.PHONY: all dirs clean nuke debug-make
.SECONDARY: $(_OBJECTS)

all:

vpath %.h $(_INCLUDES)
include $(addsuffix /$(_MODFILE), $(_MODULES))

all: dirs $(_LIBRARIES) $(_BINARIES)

dirs:
	$(MKDIR) $(call uniq, $(dir $(_OBJECTS) $(_LIBRARIES) $(_BINARIES)))

clean:
	$(RM) $(_BINARIES) $(_LIBRARIES) $(_OBJECTS) $(_DEPENDS)

nuke:
	$(RM) -r $(BIN_ROOT) $(OBJROOT) $(OBJROOT)

-include $(_DEPENDS)
