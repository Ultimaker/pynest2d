# Copyright (c) 2020 Ultimaker B.V.
# pynest2d is released under the terms of the LGPLv3 or higher.

project(pynest2d)
cmake_minimum_required(VERSION 3.6)  # Lowest version it's been tested with.

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Requirements.
find_package(PythonInterp 3.5 REQUIRED)  # Dependency of SIP.
find_package(PythonLibs 3.5 REQUIRED)  # Dependency of SIP.
find_package(SIP REQUIRED)  # To create Python bindings.
find_package(libnest2d REQUIRED)  # The library we're creating bindings for.
find_package(Clipper REQUIRED)  # Dependency of libnest2d.
find_package(NLopt REQUIRED)  # Dependency of libnest2d.
find_package(Boost REQUIRED)  # Dependency of libnest2d.
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DLIBNEST2D_GEOMETRIES_clipper -DLIBNEST2D_OPTIMIZERS_nlopt -DLIBNEST2D_THREADING_std")  # Tell libnest2d to use Clipper and NLopt, and standard threads.

# Some build options.
set(CMAKE_CXX_STANDARD 11)
if(APPLE AND CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
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
include_directories(src/ ${SIP_INCLUDE_DIRS} ${Python3_INCLUDE_DIRS} ${CLIPPER_INCLUDE_DIRS} ${NLopt_INCLUDE_DIRS} ${LIBNEST2D_INCLUDE_DIRS})
add_sip_python_module(pynest2d src/Pynest2D.sip ${CLIPPER_LIBRARIES} ${NLopt_LIBRARIES})
