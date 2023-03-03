SOURCES     := kbd.c
TARGET      := drivers/libkbd.a

$(eval $(call make-lib, $(TARGET), $(SOURCES)))
