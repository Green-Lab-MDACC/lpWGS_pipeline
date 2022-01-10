# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /risapps/rhel7/cmake/3.16.2-gcc-7.1.0/bin/cmake

# The command to remove a file.
RM = /risapps/rhel7/cmake/3.16.2-gcc-7.1.0/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils

# Include any dependencies generated for this target.
include src/util/CMakeFiles/segToGc.dir/depend.make

# Include the progress variables for this target.
include src/util/CMakeFiles/segToGc.dir/progress.make

# Include the compile flags for this target's objects.
include src/util/CMakeFiles/segToGc.dir/flags.make

src/util/CMakeFiles/segToGc.dir/seg/segToGc.cpp.o: src/util/CMakeFiles/segToGc.dir/flags.make
src/util/CMakeFiles/segToGc.dir/seg/segToGc.cpp.o: src/util/seg/segToGc.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/util/CMakeFiles/segToGc.dir/seg/segToGc.cpp.o"
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util && /risapps/rhel7/gcc/7.1.0/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/segToGc.dir/seg/segToGc.cpp.o -c /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util/seg/segToGc.cpp

src/util/CMakeFiles/segToGc.dir/seg/segToGc.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/segToGc.dir/seg/segToGc.cpp.i"
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util && /risapps/rhel7/gcc/7.1.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util/seg/segToGc.cpp > CMakeFiles/segToGc.dir/seg/segToGc.cpp.i

src/util/CMakeFiles/segToGc.dir/seg/segToGc.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/segToGc.dir/seg/segToGc.cpp.s"
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util && /risapps/rhel7/gcc/7.1.0/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util/seg/segToGc.cpp -o CMakeFiles/segToGc.dir/seg/segToGc.cpp.s

# Object files for target segToGc
segToGc_OBJECTS = \
"CMakeFiles/segToGc.dir/seg/segToGc.cpp.o"

# External object files for target segToGc
segToGc_EXTERNAL_OBJECTS =

util/seg/segToGc: src/util/CMakeFiles/segToGc.dir/seg/segToGc.cpp.o
util/seg/segToGc: src/util/CMakeFiles/segToGc.dir/build.make
util/seg/segToGc: lib/libfastahack.a
util/seg/segToGc: lib/libsplit.a
util/seg/segToGc: src/util/CMakeFiles/segToGc.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../util/seg/segToGc"
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/segToGc.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/util/CMakeFiles/segToGc.dir/build: util/seg/segToGc

.PHONY : src/util/CMakeFiles/segToGc.dir/build

src/util/CMakeFiles/segToGc.dir/clean:
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util && $(CMAKE_COMMAND) -P CMakeFiles/segToGc.dir/cmake_clean.cmake
.PHONY : src/util/CMakeFiles/segToGc.dir/clean

src/util/CMakeFiles/segToGc.dir/depend:
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util/CMakeFiles/segToGc.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/util/CMakeFiles/segToGc.dir/depend
