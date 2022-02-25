# Copyright (c) 2022 Ultimaker B.V.
# pynest2d is released under the terms of the LGPLv3 or higher.

# This script finds libnest2d on your computer.
#
# The output of this script is the following variables:
# - LIBNEST2D_INCLUDE_DIR: The include directory for libnest2d.

find_package(PkgConfig)  # To easily find files on your computer.

# First try with packageconfig to get a beginning of an idea where to search.
pkg_check_modules(PC_LIBNEST2D QUIET libnest2d)

if(NOT TARGET libnest2d::libnest2d)
    add_library(libnest2d::libnest2d INTERFACE IMPORTED)
endif()

find_path(libnest2d_INCLUDE_DIRS NAMES libnest2d/libnest2d.hpp HINTS
    ${libnest2d_PACKAGE_FOLDER}/include
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
set_property(TARGET libnest2d::libnest2d
        PROPERTY INTERFACE_INCLUDE_DIRECTORIES
        ${libnest2d_INCLUDE_DIRS} APPEND)

find_library(libnest2d_LIBRARIES_TARGETS NAMES libnest2d_clipper_nlopt
        HINTS
        ${libnest2d_PACKAGE_FOLDER}/lib
        ${PC_LIBNEST2D_LIBDIR}
        ${PC_LIBNEST2D_LIBRARY_DIRS}
        ${CMAKE_PREFIX_PATH}/lib/
        ${CMAKE_PREFIX_PATH}/lib/libnest2d
        /opt/local/lib/
        /opt/local/lib/libnest2d/
        /usr/local/lib/
        /usr/local/lib/libnest2d/
        /usr/lib
        /usr/lib/libnest2d/
        )
set_property(TARGET libnest2d::libnest2d
        PROPERTY INTERFACE_LINK_LIBRARIES
        ${libnest2d_LIBRARIES_TARGETS} APPEND)

set(libnest2d_COMPILE_DEFINITIONS
        "LIBNEST2D_GEOMETRIES_clipper"
        "LIBNEST2D_OPTIMIZERS_nlopt"
        "LIBNEST2D_THREADING_std")
set_property(TARGET libnest2d::libnest2d
        PROPERTY INTERFACE_COMPILE_DEFINITIONS
        ${libnest2d_COMPILE_DEFINITIONS} APPEND)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(libnest2d DEFAULT_MSG
        libnest2d_INCLUDE_DIRS)
