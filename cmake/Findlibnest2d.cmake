# Copyright (c) 2020 Ultimaker B.V.
# pynest2d is released under the terms of the LGPLv3 or higher.

# This script finds libnest2d on your computer.
#
# The output of this script is the following variables:
# - libnest2d_INCLUDE_DIR: The include directory for libnest2d.

find_package(PkgConfig)  # To easily find files on your computer.

# First try with packageconfig to get a beginning of an idea where to search.
pkg_check_modules(PC_LIBNEST2D QUIET libnest2d)

find_path(libnest2d_INCLUDE_DIRS NAMES libnest2d/libnest2d.hpp HINTS
    ${PC_libnest2d_INCLUDE_DIRS}
    ${PC_libnest2d_INCLUDE_DIRS}/libnest2d
    ${CMAKE_PREFIX_PATH}/include/
    ${CMAKE_PREFIX_PATH}/include/libnest2d
    /opt/local/include/
    /opt/local/include/libnest2d/
    /usr/local/include/
    /usr/local/include/libnest2d/
    /usr/include
    /usr/include/libnest2d/
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(libnest2d DEFAULT_MSG  libnest2d_INCLUDE_DIRS)

if(libnest2d_FOUND)
    add_library(libnest2d::libnest2d INTERFACE IMPORTED)
    set_target_properties(libnest2d::libnest2d PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
            "${libnest2d_INCLUDE_DIRS}")
endif()

mark_as_advanced(libnest2d_INCLUDE_DIRS)