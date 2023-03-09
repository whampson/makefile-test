# TODO: search tree for modules?
export MODULES  := \
	drivers/kbd \
	drivers/vga \
	kernel \
	mm \
	test/kernel \
	test/mm \

export ROOT     := $(CURDIR)
export BINROOT  := bin
export LIBROOT  := lib
export OBJROOT  := obj
export SRCROOT  := src

export INCLUDES := inc
export CFLAGS   :=
export DEFINES  :=

export CC       := cc
export MKDIR    := mkdir -p
export MV       := mv -f
export RM       := rm -f

# Current module directory.
# DO NOT call from this Makefile!! Ok to use in define.
export MODDIR    = $(patsubst %/$(_MODFILE),%,$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

# =================================================================================================

_MODFILE    := Module.mk
_SOURCES    :=
_OBJECTS    :=
_BINARIES   :=
_LIBRARIES  :=

_MODULES     = $(addprefix $(SRCROOT)/,$(MODULES))
_INCLUDES    = $(addprefix $(SRCROOT)/,$(INCLUDES))
_DEPENDS     = $(subst .o,.d,$(_OBJECTS))

# $(call get-obj-name, source-list)
get-obj-name = $(subst $(SRCROOT)/,$(OBJROOT)/,$(subst .c,.o,$(filter %.c,$1)))

define make-exe	# exe-path, source-list, [link-libs]
  _BINARIES += $(addprefix $(BINROOT)/,$1)
  _SOURCES += $(addprefix $(MODDIR)/,$2)
  $(addprefix $(BINROOT)/,$1): $(call get-obj-name,$(addprefix $(MODDIR)/,$2))
	$(CC) -o $$@ $$^ $(addprefix $(LIBROOT)/,$3)
endef

define make-lib # lib-name, source-list
  _LIBRARIES += $(addprefix $(LIBROOT)/,$1)
  _SOURCES += $(addprefix $(MODDIR)/,$2)
  $(addprefix $(LIBROOT)/,$1): $(call get-obj-name,$(addprefix $(MODDIR)/,$2))
	$(AR) rcs $$@ $$^
endef

define make-obj # obj-name, source-list
  _OBJECTS += $1
  $1: $2
	$(CC) -o $$@ $(CFLAGS) $(addprefix -D,$(DEFINES)) $(addprefix -I,$(_INCLUDES)) -c -MD -MF $$(@:.o=.d) $$<
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
	$(RM) -r $(BINROOT) $(LIBROOT) $(OBJROOT)

debug-make:
	@echo 'MODULES       = $(MODULES)'
	@echo 'INCLUDES      = $(INCLUDES)'
	@echo 'CFLAGS        = $(CFLAGS)'
	@echo 'DEFINES       = $(DEFINES)'
	@echo 'CC            = $(CC)'
	@echo 'MKDIR         = $(MKDIR)'
	@echo 'MV            = $(MV)'
	@echo 'RM            = $(RM)'
	@echo '--------------------------------------------------------------------------------'
	@echo 'ROOT          = $(ROOT)'
	@echo 'BINROOT       = $(BINROOT)'
	@echo 'LIBROOT       = $(LIBROOT)'
	@echo 'OBJROOT       = $(OBJROOT)'
	@echo 'SRCROOT       = $(SRCROOT)'
	@echo 'MAKEFILE_LIST = $(MAKEFILE_LIST)'
	@echo '_MODULES      = $(_MODULES)'
	@echo '_BINARIES     = $(_BINARIES)'
	@echo '_LIBRARIES    = $(_LIBRARIES)'
	@echo '_SOURCES      = $(_SOURCES)'
	@echo '_INCLUDES     = $(_INCLUDES)'
	@echo '_OBJECTS      = $(_OBJECTS)'
	@echo '_DEPENDS      = $(_DEPENDS)'

# generate object file rules
$(foreach _src, $(_SOURCES), $(eval $(call make-obj, $(call get-obj-name, $(_src)), $(_src))))

-include $(_DEPENDS)
