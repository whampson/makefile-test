# $(call source-to-object, source-file-list)
source-to-object = $(subst src/,$(OBJDIR)/,$(subst .c,.o,$(filter %.c,$1)))

# $(subdirectory)
# TODO: this needs to be reworked to omit .d files
subdirectory = $(patsubst %/Module.mk,%,\
	$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

# $(call make-library, library-name, source-file-list)
define make-library
  libraries += $1
  sources   += $2
  $1: $(call source-to-object,$2)
	$(AR) rcs $$@ $$^
endef

# $(call make-program, program-name, source-file-list)
define make-program
  programs  += $1
  sources   += $2
  $1: $(call source-to-object,$2) $(libraries)
	$(CC) -o $$@ $$^
endef

modules   := src/kernel src/mm src/test
programs  :=
libraries :=
sources   :=

OBJDIR = obj
LIBDIR = lib

objects = $(call source-to-object,$(sources))
depends = $(subst .o,.d,$(objects))

includes := src/inc
CFLAGS += $(addprefix -I,$(includes))

vpath %.h $(includes)

MV  := mv -f
RM  := rm -f
SED := sed
CC := cc

all:

include $(addsuffix /Module.mk,$(modules))

.SECONDARY: $(objects)
.PHONY: all libs clean debug-make

all: libs $(programs)

libs: $(libraries)

clean:
	$(RM) $(objects) $(depends) $(programs) $(libraries)

define make-object
  $2: $1
	mkdir -p $(dir $2)
	$(CC) $(CFLAGS) -c -MD -MF $(2:.o=.d) -o $2 $1
endef


$(foreach _src, $(sources), $(eval $(call make-object,$(_src),$(call source-to-object,$(_src)))))

# # append
# #    Makefile $(addsuffix /Module.mk,$(modules))
# # to detect changes made to Makefile and .mk files
# $(OBJDIR)/%.o: %.c
# 	mkdir -p $(dir $@)
# 	$(CC) $(CFLAGS) -c -MD -MF $(@:.o=.d) -o $@ $<

debug-make:
	@echo 'OBJDIR = $(OBJDIR)'
	@echo 'sources = $(sources)'
	@echo 'objects = $(objects)'
	@echo 'depends = $(depends)'

-include $(depends)
