# $(call source-to-object, source-file-list)
source-to-object = $(subst .c,.o,$(filter %.c,$1))

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
.PHONY: all libs clean

all: libs $(programs)

libs: $(libraries)

clean:
	$(RM) $(objects) $(depends) $(programs) $(libraries)

# append
#    Makefile $(addsuffix /Module.mk,$(modules))
# to detect changes made to Makefile and .mk files
%.o: %.c
	$(CC) $(CFLAGS) -c -MD -MF $(@:.o=.d) -o $@ $<

-include $(depends)
