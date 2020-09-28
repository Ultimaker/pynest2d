# Copyright (c) 2020 Ultimaker B.V.
# pynest2d is released under the terms of the LGPLv3 or higher.

# This script finds libnest2d on your computer.
#
# The output of this script is the following variables:
# - LIBNEST2D_INCLUDE_DIR: The include directory for libnest2d.
# - LIBNEST2D_LIBRARY: The path to the libnest2d library.

find_package(PkgConfig)  # To easily find files on your computer.

# First try with packageconfig to get a beginning of an idea where to search.
pkg_check_modules(PC_LIBNEST2D QUIET libnest2d)

find_path(LIBNEST2D_INCLUDE_DIR NAMES libnest2d/libnest2d.hpp HINTS
    ${PC_LIBNEST2D_INCLUDE_DIRS}
    ${PC_LIBNEST2D_INCLUDE_DIRS}/libnest2d
    ${CMAKE_PREFIX_PATH}/include/
    ${CMAKE_PREFIX_PATH}/include/libnest2d
    /opt/local/include/
    /opt/local/include/libnest2d/
    /usr/local/include/
    /usr/local/include/libnest2d/
    /usr/include
    /usr/include/libnest2d/
)

set(_libnest2d_library_names "")
foreach(_suffix ${CMAKE_FIND_LIBRARY_SUFFIXES})
    list(APPEND _libnest2d_library_names libnest2d_clipper_nlopt${_suffix})
endforeach()

find_library(LIBNEST2D_LIBRARY NAMES ${_libnest2d_library_names} HINTS
    ${PC_LIBNEST2D_LIBRARY_DIRS}
    ${CMAKE_PREFIX_PATH}/lib/
    ${CMAKE_PREFIX_PATH}/lib/libnest2d/
    /opt/local/lib/
    /opt/local/lib/libnest2d/
    /usr/local/lib/
    /usr/local/lib/libnest2d/
    /usr/lib/
    /usr/lib/libnest2d/
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LIBNEST2D DEFAULT_MSG
    LIBNEST2D_LIBRARY LIBNEST2D_INCLUDE_DIR)

