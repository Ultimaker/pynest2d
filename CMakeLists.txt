# Copyright (c) 2020 Ultimaker B.V.
# pynest2d is released under the terms of the LGPLv3 or higher.

project(pynest2d)
cmake_minimum_required(VERSION 3.18)  # Lowest version it's been tested with.

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT DEFINED Python_VERSION)
    set(Python_VERSION
            3.10
            CACHE STRING "Python Version" FORCE)
    message(STATUS "Setting Python version to ${Python_VERSION}. Set Python_VERSION if you want to compile against an other version.")
endif()
if(APPLE)
    set(Python_FIND_FRAMEWORK NEVER)
endif()
find_package(Python ${Python_VERSION} EXACT REQUIRED COMPONENTS Interpreter Development)
message(STATUS "Linking and building ${project_name} against Python ${Python_VERSION}")

find_package(SIP REQUIRED 6.5.0)

find_package(libnest2d REQUIRED)  # The library we're creating bindings for.

add_library(pynest2d INTERFACE)

target_include_directories(pynest2d
        INTERFACE
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src/>
        )

# Use C++17 Standard
message(STATUS "Setting C++17 support with extensions off and standard required")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
target_compile_features(pynest2d INTERFACE cxx_std_17)

if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    if (APPLE)
        message(STATUS "Compiling ${project_name} against libc++")
        target_compile_options(pynest2d INTERFACE "-stdlib=libc++")
    endif()
endif()

find_package(Threads)
find_package(clipper)
target_link_libraries(pynest2d INTERFACE libnest2d::libnest2d Python::Python Threads::Threads clipper::clipper)

add_sip_module(pynest2d)
install_sip_module(pynest2d)