# Copyright (c) 2022 Ultimaker B.V.
# pynest2d is released under the terms of the LGPLv3 or higher.

project(pynest2d)
cmake_minimum_required(VERSION 3.20)  # Lowest version it's been tested with.
include(cmake/StandardProjectSettings.cmake)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

if(NOT DEFINED Python_VERSION)
    set(Python_VERSION
            3.10
            CACHE STRING "Python Version" FORCE)
    message(STATUS "Setting Python version to ${Python_VERSION}. Set Python_VERSION if you want to compile against an other version.")
endif()
if(APPLE)
    set(Python_FIND_FRAMEWORK NEVER)
endif()
find_package(cpython ${Python_VERSION} QUIET COMPONENTS Interpreter Development)
if(NOT TARGET cpython::cpython)
    find_package(Python ${Python_VERSION} EXACT REQUIRED COMPONENTS Interpreter Development)
else()
    add_library(Python::Python ALIAS cpython::python)
    set(Python_SITEARCH "${CMAKE_INSTALL_PREFIX}/lib/python${Python_VERSION}/site-packages")
    set(Python_EXECUTABLE ${cpython_PACKAGE_FOLDER_RELEASE}/bin/python3)
    set(ENV{PYTHONPATH} ${Python_SITEARCH})
endif()
message(STATUS "Linking and building ${project_name} against Python ${Python_VERSION}")

find_package(SIP REQUIRED 6.5.0)

find_package(Libnest2D REQUIRED)  # The library we're creating bindings for.

add_library(pynest2d INTERFACE)
set_project_standards(pynest2d)
use_threads(pynest2d)
set_rpath(TARGETS
            pynest2d
          PATHS
            "$<$<PLATFORM_ID:Linux>:usr/bin>"
            "$<$<PLATFORM_ID:Linux>:usr/bin/lib>"
            "$<$<PLATFORM_ID:Darwin>:../lib>"
            "$<$<PLATFORM_ID:Darwin>:../Resources/lib>"
            "../../"  # In distributions of Cura, the libnest2d dependency is 2 directories up from where pynest2d gets installed.
          RELATIVE)

target_include_directories(pynest2d
        INTERFACE
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src/>
        )

find_package(Threads)
find_package(clipper)
find_package(NLopt)
find_package(Boost)
target_link_libraries(pynest2d INTERFACE Libnest2D::libnest2d Python::Python Threads::Threads clipper::clipper NLopt::nlopt boost::boost)

add_sip_module(pynest2d)
if(Python_SITELIB_LOCAL)
    install_sip_module(pynest2d ${Python_SITELIB_LOCAL})
else()
    install_sip_module(pynest2d)
endif()
