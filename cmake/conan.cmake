if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
    file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/0.18.0/conan.cmake"
            "${CMAKE_BINARY_DIR}/conan.cmake"
            EXPECTED_HASH SHA256=65fc3508c91bf201f5472d28b21259e02b6f975a2917be457412ab7a87906c1e
            TLS_VERIFY ON)
endif()
include(${CMAKE_BINARY_DIR}/conan.cmake)

# === Project specific ===

conan_config_install(ITEM https://github.com/ultimaker/conan-config.git TYPE git VERIFY_SSL True)
conan_check(VERSION 1.46.0 REQUIRED)

conan_cmake_run(
        BASIC_SETUP
        CONANFILE
            conanfile.txt
        GENERATORS
            VirtualRunEnv
            VirtualBuildEnv
            CMakeDeps
            CMakeToolchain
            json
        PROFILE
            cura_release.jinja
        BUILD
            missing
        )

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE AND EXISTS "${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
    include(${CMAKE_BINARY_DIR}/conan_toolchain.cmake)
    set(CMAKE_TOOLCHAIN_FILE ${CMAKE_BINARY_DIR}/conan_toolchain.cmake)
endif()