# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.29

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = "C:/Program Files/cmake-3.29.2-windows-x86_64/bin/cmake.exe"

# The command to remove a file.
RM = "C:/Program Files/cmake-3.29.2-windows-x86_64/bin/cmake.exe" -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = D:/ScouseOS

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = D:/ScouseOS/build

# Utility rule file for ALL.

# Include any custom commands dependencies for this target.
include CMakeFiles/ALL.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/ALL.dir/progress.make

CMakeFiles/ALL: /out/boot.bin

/out/boot.bin: D:/ScouseOS/src/boot.asm
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=D:/ScouseOS/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Assembling "
	cd D:/ScouseOS && nasm D:/ScouseOS/src/boot.asm -f bin -o /out/boot.bin

ALL: /out/boot.bin
ALL: CMakeFiles/ALL
ALL: CMakeFiles/ALL.dir/build.make
.PHONY : ALL

# Rule to build all files generated by this target.
CMakeFiles/ALL.dir/build: ALL
.PHONY : CMakeFiles/ALL.dir/build

CMakeFiles/ALL.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/ALL.dir/cmake_clean.cmake
.PHONY : CMakeFiles/ALL.dir/clean

CMakeFiles/ALL.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" D:/ScouseOS D:/ScouseOS D:/ScouseOS/build D:/ScouseOS/build D:/ScouseOS/build/CMakeFiles/ALL.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/ALL.dir/depend

