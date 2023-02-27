TARGET  := libkernel.a
SOURCES := \
	init.c \
	kmain.c

$(eval $(call make-library))
