cmake_minimum_required(VERSION 3.20)
project(pynest2d)
cmake_policy(SET CMP0091 NEW)

find_package(Python REQUIRED)
find_package(nest2d REQUIRED)

find_package(standardprojectsettings REQUIRED)
find_package(sipbuildtool REQUIRED)

add_library(pynest2d INTERFACE)
use_threads(pynest2d)

target_link_libraries(pynest2d INTERFACE nest2d::nest2d cpython::cpython)
add_sip_module(pynest2d)
install_sip_module(pynest2d)

# Ensure the linking to libnest2d will not be discarded by GCC
target_link_libraries(sip_pynest2d PUBLIC
    $<$<CXX_COMPILER_ID:GNU,Clang>:-Wl,--no-as-needed>
    -lnest2d
    $<$<CXX_COMPILER_ID:GNU,Clang>:-Wl,--as-needed>
)
