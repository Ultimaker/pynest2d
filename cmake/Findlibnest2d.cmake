# Copyright (c) 2020 Ultimaker B.V.
# pynest2d is released under the terms of the LGPLv3 or higher.

# This script finds libnest2d on your computer.
#
# The output of this script is the following variables:
# - LIBNEST2D_INCLUDE_DIR: The include directory for libnest2d.

find_package(PkgConfig)  # To easily find files on your computer.

# First try with packageconfig to get a beginning of an idea where to search.
pkg_check_modules(PC_LIBNEST2D QUIET libnest2d)

find_path(LIBNEST2D_INCLUDE_DIR NAMES libnest2d/libnest2d.hpp HINTS ${PC_LIBNEST2D_INCLUDE_DIRS})
find_library(LIBNEST2D_LIBRARY NAMES libnest2d_clipper_nlopt PATHS ${PC_LIBNEST2D_LIBRARY_DIRS})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LIBNEST2D DEFAULT_MSG
    LIBNEST2D_LIBRARY LIBNEST2D_INCLUDE_DIR)

