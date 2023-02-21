source-to-object = $(subst .c,.o,$(filter %.c,$1))

subdirectory = $(patsubst %/Module.mk,%,\
	$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

define make-library
  libraries += $1
  sources   += $2

  $1: $(call source-to-object,$2)
	$(AR) rcs $$@ $$^
endef

# define make-program
#   programs += $1
#   sources  += $2

#   $1: $(call source-to-object,$2) $(libraries)
# 	$(CC) -o $$@ $$^
# endef

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


all:

include $(addsuffix /Module.mk,$(modules))

.PHONY: all
all: $(programs)

.PHONY: libs
libs: $(libraries)

.PHONY: clean
clean:
	$(RM) $(objects) $(depends) $(programs) $(libraries)

ifneq ($(MAKECMDGOALS),clean)
  include $(depends)
endif

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.d: %.c
	$(CC) $(CFLAGS) -M $< | \
	$(SED) 's,\($(notdir $*)\.o\) *:,$(dir $@)\1 $@: ,' > $@.tmp
	$(MV) $@.tmp $@
