# Copyright (c) 2021 Ultimaker B.V.
# pynest2d is released under the terms of the LGPLv3 or higher.

project(pynest2d)
cmake_minimum_required(VERSION 3.13)

include(cmake/StandardProjectSettings.cmake)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

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

find_package(SIP REQUIRED)
set(SIP_EXTRA_OPTIONS -y pynest2d.pyi -o -g -n PyQt5.sip)  # Always release the GIL before calling C++ methods. -n PyQt5.sip is required to not get the PyCapsule error
add_sip_python_module(pynest2d src/Pynest2D.sip)

set_project_standards(python_module_pynest2d)
set_project_warnings(python_module_pynest2d)

use_python(python_module_pynest2d Interpreter Development)
find_package(libnest2d REQUIRED)  # The library we're creating bindings for.

target_link_libraries(python_module_pynest2d PUBLIC libnest2d::libnest2d SIP::SIP)

target_compile_definitions(python_module_pynest2d
        PRIVATE
            LIBNEST2D_GEOMETRIES_clipper
            LIBNEST2D_OPTIMIZERS_nlopt
            LIBNEST2D_THREADING_std
        )

target_include_directories(python_module_pynest2d
        PRIVATE
            $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src>
            $<INSTALL_INTERFACE:src>
        )