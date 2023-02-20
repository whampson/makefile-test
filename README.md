# Recursive Makefile Test
Yeah yeah, I know that [recursive Makefiles are "bad"](https://web.archive.org/web/20230117102559/https://aegis.sourceforge.net/auug97.pdf), but I wanted to play with them anyway.

## Overview
This repo simulates a _simple_ OS source tree. The Makefile system is designed to build individual modules into link libraries or executables, as dictated by the Makefile at that module's root. The Makefiles are sensitive to source and header file changes and will rebuild any modules that have changed. However, cross-module dependencies are not yet implemented (see [Pitfalls](#pitfalls)).

## Usage
First, you must source the environment script with `$ source scripts/env.sh`. This will define some global environment variables needed in order for the build system to work. Then you can build the tree with `$ make all` (or just `$ make`). You can also build individual modules by running `$ make` in that module's root directory.

The following variables may be defined in your Makefile:
- `DIRS` - subdirectories to be built as part of this module
- `SOURCES` - source files to be compiled as part of this module
- `TARGET` - the executable or link library to be built
- `TARGETTYPE` - the target type, either "executable" or "library"; TARGETs with the .lib suffix are assumed to be of type "library"
- `TARGETLIBS` - link libraries that this module depends on

It's rather easy to add more, like `C_DEFINES`, `INCLUDES`, etc. Experiment!

### A Simple Example
A basic Makefile looks like the following:
```Makefile
SOURCES = source.c
TARGET = program

include $(BUILD)/Common.mk
```

This will compile `./source.c` and into an executable program `$(BINDIR)/program`. `BINDIR` is currently defined as `bin/` from the project root. You must include `$(BUILD)/Common.mk` after defining your build parameters as this contains the meat of the build system.

The system works top-down, meaning it will only ever look at the current directory and child directories. Modules are not meant to be aware of source files that exist "above" them, although you can reference link libraries from anywhere in the tree (so long as they've been built, see [Pitfalls](#pitfalls)).

### A More Complex Example
Here's a more complex example using modules. In this example, the directory tree looks as follows:
```
./
+-build/        <-- build system stuff, not relevant for our example
+-src/
| +-Makefile
| +-program.c
| +-moduleA/
| | +-Makefile
| | \-modA.c
| \-moduleB/
|   +-Makefile
|   \-modB.c
\-Makefile
```

`./Makefile`:

This is the top-level Makefile. It's sole purpose is to call `$ make all` on `./src/Makefile`
```Makefile
DIRS = src

include $(BUILD)/Common.mk
```

`./src/Makefile`:

This will first build `./src/moduleA` and `./src/moduleB`, then link them into an executable `./bin/test/program.exe`.
```Makefile
DIRS = moduleA moduleB
SOURCES = program.c
TARGET = test/program
# TARGETTYPE assumed to be "executable"; gets placed in $(BINARY_ROOT)/$(TARGET)
TARGETLIBS = \
    $(OBJECT_ROOT)/moduleA/moduleA.lib \
    $(OBJECT_ROOT)/moduleA/moduleB.lib \

include $(BUILD)/Common.mk
```

`./src/moduleA/Makefile`:
```Makefile
SOURCES = modA.c
TARGET = moduleA.lib
# TARGETTYPE assumed to be "library" due to .lib extension; gets placed in $(OBJECT_ROOT)/$(TREE)/$(TARGET)

include $(BUILD)/Common.mk
```

`./src/moduleB/Makefile`:
```Makefile
SOURCES = modb.c
TARGET = moduleB.lib

include $(BUILD)/Common.mk
```

When built, we will end up with the following directory tree:
```
./
+-bin/
| \-test/
|   \-program.exe   <-- target binary
+-build/
+-obj/
| +-moduleA/
| | +-modA.o        <-- object file
| | +-modA.o.d      <-- dependency file for make
| | \-moduleA.lib   <-- target link library
| \-moduleB/
|   +-modB.o
|   +-modB.o.d
|   \-moduleB.lib
+-src/
| +-Makefile
| +-program.c
| +-moduleA/
| | +-Makefile
| | \-modA.c
| \-moduleB/
|   +-Makefile
|   \-modB.c
\-Makefile
```

As you can see, the `obj/` directory structure mirrors that of `src/`, making it easy to manage a module's object files.

### Common Goals
Several common goals are defined and callable from any Makefile. They are:
- `all` - the default goal; will build TARGET for the current module and any submodules (specified in DIRS)
- `clean` - will remove any object files, targets, and make dependency files within the current module and any submodules (specified in DIRS)
- `nuke` - will delete `$(OBJECT_ROOT)` and `$(BINARY_ROOT)` directories, typically `obj/` and `bin/` respectively
- `debug-make` - will print some Makefile variables for debugging the current module

The goals `all` and `clean` can be appended in your module to do additional work. To do so, use the double-colon syntax:

```Makefile
all::
    # insert custom rule here, like stripping your binary!

clean::
    # delete some other unwanted file
```

## Pitfalls
Module dependency tracking is not yet implemented. This means if module A depends on moduleB, and moduleB has changes and was rebuilt, moduleA will not be aware that moduleB changed and will not be rebuilt unless explicitly told to do so.
