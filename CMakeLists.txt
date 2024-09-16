cmake_minimum_required(VERSION 3.20)
cmake_policy(SET CMP0091 NEW)
project(pynest2d)

find_package(nest2d REQUIRED)
find_package(Python REQUIRED)

find_package(standardprojectsettings REQUIRED)
find_package(sipbuildtool REQUIRED)

add_library(pynest2d INTERFACE)
use_threads(pynest2d)

target_link_libraries(pynest2d INTERFACE nest2d::nest2d cpython::cpython)
add_sip_module(pynest2d)
install_sip_module(pynest2d)

