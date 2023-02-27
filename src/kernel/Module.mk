SOURCES := \
	init.c \
	kmain.c

$(eval $(call make-lib, libkernel.a, $(SOURCES)))
