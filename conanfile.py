import os

from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake
from conan.tools import files
from conan import ConanFile
from conans import tools
from conans.errors import ConanException

required_conan_version = ">=1.46.2"


class PyNest2DConan(ConanFile):
    name = "pynest2d"
    license = "LGPL-3.0"
    author = "Ultimaker B.V."
    url = "https://github.com/Ultimaker/pynest2d"
    description = "Python bindings for libnest2d"
    topics = ("conan", "cura", "prusaslicer", "nesting", "c++", "bin packaging", "python", "sip")
    settings = "os", "compiler", "build_type", "arch"
    revision_mode = "scm"
    exports = "LICENSE*"

    python_requires = "umbase/0.1.1@ultimaker/testing", "sipbuildtool/0.1@ultimaker/testing"
    python_requires_extend = "umbase.UMBaseConanfile"

    options = {
        "shared": [True, False],
        "fPIC": [True, False]
    }
    default_options = {
        "shared": True,
        "fPIC": True,
    }
    scm = {
        "type": "git",
        "subfolder": ".",
        "url": "auto",
        "revision": "auto"
    }

    def requirements(self):
        for req in self._um_data(self.version)["requirements"]:
            self.requires(req)

    def config_options(self):
        if self.options.shared and self.settings.compiler == "Visual Studio":
            del self.options.fPIC

    def configure(self):
        self.options["libnest2d"].shared = self.options.shared

    def validate(self):
        if self.settings.compiler.get_safe("cppstd"):
            tools.check_min_cppstd(self, 17)

    def generate(self):
        cmake = CMakeDeps(self)
        cmake.generate()

        sip = self.python_requires["sipbuildtool"].module.SipBuildTool(self)
        sip.configure(python_interpreter = self.deps_user_info["cpython"].python)
        sip.generate("pynest2d", sip_dir = "src")

        tc = CMakeToolchain(self)

        if self.settings.compiler == "Visual Studio":
            tc.blocks["generic_system"].values["generator_platform"] = None
            tc.blocks["generic_system"].values["toolset"] = None

        tc.variables["Python_EXECUTABLE"] = self.deps_user_info["cpython"].python
        tc.variables["Python_USE_STATIC_LIBS"] = not self.options["cpython"].shared
        tc.variables["Python_ROOT_DIR"] = self.deps_cpp_info["cpython"].rootpath
        tc.variables["Python_FIND_FRAMEWORK"] = "NEVER"
        tc.variables["Python_FIND_REGISTRY"] = "NEVER"
        tc.variables["Python_FIND_IMPLEMENTATIONS"] = "CPython"
        tc.variables["Python_FIND_STRATEGY"] = "LOCATION"

        if self.options.shared and self.settings.os == "Windows":
            tc.variables["Python_SITELIB_LOCAL"] = self.cpp.build.bindirs[0]
        else:
            tc.variables["Python_SITELIB_LOCAL"] = self.cpp.build.libdirs[0]

        tc.generate()

    def layout(self):
        self.folders.source = "."
        try:
            build_type = str(self.settings.build_type)
        except ConanException:
            raise ConanException("'build_type' setting not defined, it is necessary for cmake_layout()")
        self.folders.build = f"cmake-build-{build_type.lower()}"
        self.folders.generators = os.path.join(self.folders.build, "conan")

        self.cpp.build.bindirs = ["."]
        self.cpp.build.libdirs = [".", os.path.join("pynest2d", "pynest2d")]

        self.cpp.package.libdirs = ["site-packages"]

        if self.settings.os in ["Linux", "FreeBSD", "Macos"]:
            self.cpp.package.system_libs = ["pthread"]

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        packager = files.AutoPackager(self)
        packager.patterns.build.lib = ["*.so", "*.so.*", "*.a", "*.lib", "*.dylib", "*.pyd", "*.pyi"]
        packager.run()

        files.rmdir(self, os.path.join(self.package_folder, self.cpp.package.libdirs[0], "CMakeFiles"))
        files.rmdir(self, os.path.join(self.package_folder, self.cpp.package.libdirs[0], "pynest2d"))

    def package_info(self):
        if self.in_local_cache:
            self.runenv_info.append_path("PYTHONPATH", self.cpp_info.libdirs[0])
        else:
            self.runenv_info.append_path("PYTHONPATH", self.build_folder)
