# Directory tree tracking

ifeq ($(PROJECT_ROOT),$(CURDIR))
  IN_PROJECT_ROOT = 1
endif
ifeq ($(SOURCE_ROOT),$(CURDIR))
  IN_SOURCE_ROOT = 1
endif

ifdef IN_PROJECT_ROOT
  export TREE := $(subst $(PROJECT_ROOT),,$(CURDIR))
else
  export TREE := $(subst $(SOURCE_ROOT),,$(CURDIR))
endif
