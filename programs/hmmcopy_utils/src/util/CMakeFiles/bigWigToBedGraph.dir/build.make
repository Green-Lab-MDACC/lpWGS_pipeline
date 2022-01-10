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
include src/util/CMakeFiles/bigWigToBedGraph.dir/depend.make

# Include the progress variables for this target.
include src/util/CMakeFiles/bigWigToBedGraph.dir/progress.make

# Include the compile flags for this target's objects.
include src/util/CMakeFiles/bigWigToBedGraph.dir/flags.make

src/util/CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.o: src/util/CMakeFiles/bigWigToBedGraph.dir/flags.make
src/util/CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.o: src/util/bigwig/bigWigToBedGraph.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object src/util/CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.o"
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util && /risapps/rhel7/gcc/7.1.0/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.o   -c /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util/bigwig/bigWigToBedGraph.c

src/util/CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.i"
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util && /risapps/rhel7/gcc/7.1.0/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util/bigwig/bigWigToBedGraph.c > CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.i

src/util/CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.s"
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util && /risapps/rhel7/gcc/7.1.0/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util/bigwig/bigWigToBedGraph.c -o CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.s

# Object files for target bigWigToBedGraph
bigWigToBedGraph_OBJECTS = \
"CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.o"

# External object files for target bigWigToBedGraph
bigWigToBedGraph_EXTERNAL_OBJECTS =

util/bigwig/bigWigToBedGraph: src/util/CMakeFiles/bigWigToBedGraph.dir/bigwig/bigWigToBedGraph.c.o
util/bigwig/bigWigToBedGraph: src/util/CMakeFiles/bigWigToBedGraph.dir/build.make
util/bigwig/bigWigToBedGraph: lib/libkent.a
util/bigwig/bigWigToBedGraph: src/util/CMakeFiles/bigWigToBedGraph.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable ../../util/bigwig/bigWigToBedGraph"
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/bigWigToBedGraph.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/util/CMakeFiles/bigWigToBedGraph.dir/build: util/bigwig/bigWigToBedGraph

.PHONY : src/util/CMakeFiles/bigWigToBedGraph.dir/build

src/util/CMakeFiles/bigWigToBedGraph.dir/clean:
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util && $(CMAKE_COMMAND) -P CMakeFiles/bigWigToBedGraph.dir/cmake_clean.cmake
.PHONY : src/util/CMakeFiles/bigWigToBedGraph.dir/clean

src/util/CMakeFiles/bigWigToBedGraph.dir/depend:
	cd /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util /rsrch3/home/lym_myl_rsch/bnsugg/lpWGS_pipeline/programs/hmmcopy_utils/src/util/CMakeFiles/bigWigToBedGraph.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/util/CMakeFiles/bigWigToBedGraph.dir/depend

