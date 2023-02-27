SOURCES     := kbd.c

$(eval $(call make-lib, libkbd.a, $(SOURCES), $(LINKLIBS)))
