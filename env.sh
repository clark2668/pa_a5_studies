#!/bin/bash

eval "$(/data/user/brianclark/phased_array/software/build/python_build/bin/conda shell.bash hook)" 

# define directories
export ARA_SETUP_DIR="/data/user/brianclark/phased_array/software/build"
export ARA_UTIL_INSTALL_DIR="${ARA_SETUP_DIR%/}/ara_build"
export ARA_DEPS_INSTALL_DIR="${ARA_SETUP_DIR%/}/misc_build"
export ARA_ROOT_DIR="${ARA_SETUP_DIR%/}/../source/AraRoot"

# get the LD_LIBRARY_PATH and PATHs right
export LD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$ARA_DEPS_INSTALL_DIR/lib:$LD_LIBRARY_PATH"
export DYLD_LIBRARY_PATH="$ARA_UTIL_INSTALL_DIR/lib:$ARA_DEPS_INSTALL_DIR/lib:$DYLD_LIBRARY_PATH"
export PATH="$ARA_UTIL_INSTALL_DIR/bin:$ARA_DEPS_INSTALL_DIR/bin:$PATH"

# activate root
. "${ARA_SETUP_DIR%/}/root_build/bin/thisroot.sh"

# make sure dependencies are where they are expected
export SQLITE_ROOT="$ARA_DEPS_INSTALL_DIR"
export GSL_ROOT="$ARA_DEPS_INSTALL_DIR"
export FFTWSYS="$ARA_DEPS_INSTALL_DIR"
export BOOST_ROOT="$ARA_DEPS_INSTALL_DIR/include"
export CMAKE_PREFIX_PATH="$ARA_DEPS_INSTALL_DIR"

# now PA stuff
export NUPHASE_INSTALL_DIR="/data/user/brianclark/phased_array/software/build/nuphase_build/"
export LD_LIBRARY_PATH=$NUPHASE_INSTALL_DIR/lib:$LD_LIBRARY_PATH

export PYTHONPATH=/home/brianclark/phased_array/PA_Analysis/src:$PYTHONPATH
