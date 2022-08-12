cmake_policy(SET CMP0091 NEW)
project(pynest2d)
cmake_minimum_required(VERSION 3.20)
include(cmake/StandardProjectSettings.cmake)
include(${CMAKE_BINARY_DIR}/cmake/SIPMacros.cmake)

find_package(cpython REQUIRED)
find_package(nest2d REQUIRED)

add_library(pynest2d INTERFACE)
use_threads(pynest2d)
set_project_warnings(pynest2d)

target_include_directories(pynest2d
        INTERFACE
            $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
            $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/python/>
        )
target_link_libraries(pynest2d INTERFACE nest2d::nest2d cpython::cpython)

add_sip_module(pynest2d)
if(DEFINED Python_SITELIB_LOCAL)
    install_sip_module(pynest2d ${Python_SITELIB_LOCAL})
else()
    install_sip_module(pynest2d)
endif()
