# Makefile Variables
# -----------------------------------------------------------------------------
# DIRS :: list of subdirectories to build
# SOURCES :: list of source files to build
# INCLUDES :: include directories
# TARGET :: output file generated by compiling SOURCES and linking TARGETLIBS
# TARGETTYPE :: output file type, can be 'executable' or 'library'
# TARGETLIBS :: pre-built object libraries that TARGET depends on
# -----------------------------------------------------------------------------

# Makefile Goals
# -----------------------------------------------------------------------------
# all :: builds TARGET; runs 'all' goal on Makefiles in DIRS
# clean :: removes TARGET and intermediate object files; runs 'clean' goal on Makefiles in DIRS
# nuke :: removes bin/ and obj/ directories
# debug-make :: spit out Makefile variables for debugging
# -----------------------------------------------------------------------------

include $(BUILD)/Tree.mk

ifndef DIRS
  ifndef SOURCES
    $(error Missing DIRS or SOURCES.)
  endif
endif

INCLUDES = $(SOURCE_ROOT)/inc

OBJECTS = $(addprefix $(OBJDIR)/,$(SOURCES:.c=.o))
DEPENDS = $(OBJECTS:.o=.o.d)

OBJDIR := $(OBJECT_ROOT)$(TREE)
BINDIR := $(BINARY_ROOT)

MAKEFLAGS += --no-print-directory

ifndef TARGETTYPE
  TARGETTYPE = executable
  ifeq ($(suffix $(TARGET)),.lib)
    TARGETTYPE = library
  endif
endif

ifeq ($(TARGETTYPE),executable)
  TARGET := $(addprefix $(BINDIR)/,$(TARGET))
endif
ifeq ($(TARGETTYPE),library)
  TARGET := $(addprefix $(OBJDIR)/,$(TARGET))
endif

include $(BUILD)/Rules.mk

all:: $(TARGET)

-include $(DEPENDS)