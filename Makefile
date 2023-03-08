# TODO: search tree for modules?
export MODULES := \
	src/drivers/kbd \
	src/drivers/vga \
	src/kernel \
	src/mm \
	src/test/kernel \
	src/test/mm \

export INCLUDES    := src/inc
export CFLAGS      :=
export DEFINES     :=

export BIN_ROOT    := bin
export OBJ_ROOT    := obj
export LIB_ROOT    := lib
export SRC_ROOT    := src

export CC          := cc
export MKDIR       := mkdir -p
export MV          := mv -f
export RM          := rm -f

# Current module directory (source directory).
export MOD_DIR      = $(patsubst %/$(_MODFILE),%,$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

# =================================================================================================

_MODFILE    := Module.mk
_SOURCES    :=
_BINARIES   :=
_LIBRARIES  :=
_DEPENDS     = $(subst .o,.d,$(_OBJECTS))

# $(call get-obj-name, source-list)
get-obj-name = $(subst $(SRC_ROOT)/,$(OBJ_ROOT)/,$(subst .c,.o,$(filter %.c,$1)))

define make-exe	# exe-path, source-list, [link-libs]
  _BINARIES += $1
  _SOURCES += $(addprefix $(MOD_DIR)/,$2)
  $1: $(call get-obj-name,$(addprefix $(MOD_DIR)/,$2))
	$(CC) -o $$@ $$^ $3
endef

define make-lib # lib-name, source-list
  _LIBRARIES += $(addprefix $(LIB_ROOT)/,$1)
  _SOURCES += $(addprefix $(MOD_DIR)/,$2)
  $(addprefix $(LIB_ROOT)/,$1): $(call get-obj-name,$(addprefix $(MOD_DIR)/,$2))
	$(AR) rcs $$@ $$^
endef

define make-obj # obj-name, source-list
  _OBJECTS += $1
  $1: $2
	$(CC) -o $$@ $(CFLAGS) $(addprefix -D,$(DEFINES)) $(addprefix -I,$(INCLUDES)) -c -MD -MF $$(@:.o=.d) $$<
endef

# uniq - https://stackoverflow.com/a/16151140
uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))

# =================================================================================================

all:

vpath %.h $(INCLUDES)
include $(addsuffix /$(_MODFILE),$(MODULES))

.SECONDARY: $(_OBJECTS)
.PHONY: all dirs clean nuke debug-make

all: dirs $(_LIBRARIES) $(_BINARIES)

dirs:
	$(MKDIR) $(call uniq, $(dir $(_OBJECTS) $(_LIBRARIES) $(_BINARIES)))

clean:
	$(RM) $(_BINARIES) $(_LIBRARIES) $(_OBJECTS) $(_DEPENDS)

nuke:
	$(RM) -r $(BIN_ROOT) $(LIB_ROOT) $(OBJ_ROOT)

debug-make:
	@echo 'MODULES = $(MODULES)'
	@echo 'INCLUDES = $(INCLUDES)'
	@echo '_SOURCES = $(_SOURCES)'
	@echo '_LIBRARIES = $(_LIBRARIES)'
	@echo '_BINARIES = $(_BINARIES)'
	@echo '_OBJECTS = $(_OBJECTS)'
	@echo '_DEPENDS = $(_DEPENDS)'

# generate object file rules
$(foreach _src, $(_SOURCES), $(eval $(call make-obj, $(call get-obj-name, $(_src)), $(_src))))

-include $(_DEPENDS)
