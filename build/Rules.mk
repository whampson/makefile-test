# Goals and Rules
# TODO: proper dependency tracking for link libraries

.DEFAULT_GOAL: all
.PHONY: all nuke clean debug-make
.PRECIOUS: $(OBJDIR)/%.o

all::
	@mkdir -p $(OBJDIR)
	@for dir in $(DIRS); do \
		$(MAKE) -C $$dir all; \
	done

nuke:
	$(RM) -r $(OBJECT_ROOT)
	$(RM) -r $(BINARY_ROOT)

clean::
	@for dir in $(DIRS); do \
		$(MAKE) -C $$dir clean; \
	done
ifneq ($(OBJECTS),)
	$(RM) $(OBJECTS) $(DEPENDS)
endif
ifneq ($(TARGET),)
	$(RM) $(TARGET)
endif

$(TARGET): $(OBJECTS) $(TARGETLIBS)
ifeq ($(TARGETTYPE),executable)
	@mkdir -p $(dir $(TARGET))
	$(CC) -o $@ $^
endif

$(OBJDIR)/%.lib: $(OBJECTS)
	$(AR) rcs $@ $^

$(OBJDIR)/%.o: %.c
	$(CC) -o $@ $(addprefix -I,$(INCLUDES)) -c -MD -MF $(@:.o=.o.d) $<

debug-make:
	@echo '      CURDIR = $(CURDIR)'
	@echo 'PROJECT_ROOT = $(PROJECT_ROOT)'
	@echo ' SOURCE_ROOT = $(SOURCE_ROOT)'
	@echo ' OBJECT_ROOT = $(OBJECT_ROOT)'
	@echo ' BINARY_ROOT = $(BINARY_ROOT)'
	@echo '       BUILD = $(BUILD)'
	@echo '     SCRIPTS = $(SCRIPTS)'
	@echo '        TREE = $(TREE)'
	@echo '      OBJDIR = $(OBJDIR)'
	@echo '      BINDIR = $(BINDIR)'
	@echo '    INCLUDES = $(INCLUDES)'
	@echo '     SOURCES = $(SOURCES)'
	@echo '     OBJECTS = $(OBJECTS)'
	@echo '     DEPENDS = $(DEPENDS)'
	@echo '        DIRS = $(DIRS)'
	@echo '      TARGET = $(TARGET)'
	@echo '  TARGETTYPE = $(TARGETTYPE)'
	@echo '  TARGETLIBS = $(TARGETLIBS)'
	@echo '        MAKE = $(MAKE)'
	@echo '          CC = $(CC)'
	@echo '          AR = $(AR)'
	@echo '          RM = $(RM)'
