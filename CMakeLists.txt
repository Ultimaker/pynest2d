# Copyright (c) 2022 Ultimaker B.V.
# pynest2d is released under the terms of the LGPLv3 or higher.

# For MSVC flags, will be ignored on non-Windows OS's
cmake_policy(SET CMP0091 NEW)

project(pynest2d)
cmake_minimum_required(VERSION 3.20)  # Lowest version it's been tested with.
include(cmake/StandardProjectSettings.cmake)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

find_package(cpython ${Python_VERSION} REQUIRED)
find_package(SIP REQUIRED 6.5.0)
find_package(libnest2d REQUIRED)

add_library(pynest2d INTERFACE)
use_threads(pynest2d)
set_project_warnings(pynest2d)

target_include_directories(pynest2d
        INTERFACE
            $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
            $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src/>
        )
target_link_libraries(pynest2d INTERFACE libnest2d::libnest2d cpython::cpython)

add_sip_module(pynest2d)
if(Python_SITELIB_LOCAL)
    install_sip_module(pynest2d ${Python_SITELIB_LOCAL})
else()
    install_sip_module(pynest2d)
endif()
