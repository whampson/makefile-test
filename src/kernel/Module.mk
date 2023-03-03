SOURCES := \
	init.c \
	kmain.c

TARGET := libkernel.a


$(eval $(call make-lib, $(TARGET), $(SOURCES)))

# LINKLIBS := vga kbd mm kernel
# C_DEFINES += MAIN

# $(eval $(call make-exe, kernel, $(SOURCES), $(LINK)))
