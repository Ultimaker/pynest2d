# Copyright (c) 2020 Ultimaker B.V.
# pynest2d is released under the terms of the LGPLv3 or higher.

project(pynest2d)
cmake_minimum_required(VERSION 3.6)  # Lowest version it's been tested with.

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Requirements.
find_package(PythonInterp 3.5 REQUIRED)  # Dependency of SIP.
find_package(PythonLibs 3.5 REQUIRED)  # Dependency of SIP.
find_package(SIP REQUIRED)  # To create Python bindings.
find_package(Libnest2D REQUIRED)  # The library we're creating bindings for.

# Some build options.
set(CMAKE_CXX_STANDARD 11)
if(APPLE AND CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
endif()
if(UNIX)
    # Want to be able to move symbols from the Clipper library.
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
endif()
if(NOT DEFINED LIB_SUFFIX)
    set(LIB_SUFFIX "")
endif()

# Building and linking.
set(SIP_EXTRA_FILES_DEPEND
    src/BottomLeftConfig.sip
    src/Box.sip
    src/Circle.sip
    src/DJDHeuristicConfig.sip
    src/Item.sip
    src/ItemGroup.sip
    src/NfpConfig.sip
    src/Point.sip
    src/Rectangle.sip
    src/String.sip
)

set(SIP_EXTRA_OPTIONS -g)  # Always release the GIL before calling C++ methods.
include_directories(src/ ${SIP_INCLUDE_DIRS})
add_sip_python_module(pynest2d src/Pynest2D.sip Libnest2D::libnest2d_headeronly)
