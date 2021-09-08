import os
import pathlib

from conans import ConanFile, tools
from conan.tools.cmake import CMakeToolchain, CMakeDeps, CMake


class pynest2dConan(ConanFile):
    name = "pynest2d"
    version = "4.11.0"
    license = "LGPL-3.0"
    author = "Ultimaker B.V."
    url = "https://github.com/Ultimaker/pynest2d"
    description = "Python bindings for libnest2d"
    topics = ("conan", "cura", "prusaslicer", "nesting", "c++", "bin packaging", "python", "sip")
    settings = "os", "compiler", "build_type", "arch"
    revision_mode = "scm"
    build_policy = "missing"
    exports = "LICENSE"
    options = {
        "shared": [True, False],
        "fPIC": [True, False]
    }
    default_options = {
        "shared": True,
        "fPIC": True
    }
    scm = {
        "type": "git",
        "subfolder": ".",
        "url": "auto",
        "revision": "auto"
    }

    def configure(self):
        if self.options.shared or self.settings.compiler == "Visual Studio":
            del self.options.fPIC
        self.options["SIP"].shared = self.options.shared
        self.options["libnest2d"].geometries = "clipper"
        self.options["libnest2d"].optimizer = "nlopt"
        self.options["libnest2d"].threading = "std"
        self.options["libnest2d"].shared = self.options.shared

    def build_requirements(self):
        self.build_requires("cmake/[>=3.16.2]")

    def requirements(self):
        self.requires("SIP/[>=4.19.24]@riverbankcomputing/testing")
        self.requires("Python/3.8.10@python/testing")
        self.requires(f"libnest2d/4.11.0@ultimaker/testing")

    def validate(self):
        if self.settings.compiler.get_safe("cppstd"):
            tools.check_min_cppstd(self, 17)

    def generate(self):
        cmake = CMakeDeps(self)
        cmake.generate()

        tc = CMakeToolchain(self)

        # FIXME: This shouldn't be necessary (maybe a bug in Conan????)
        if self.settings.compiler == "Visual Studio":
            tc.blocks["generic_system"].values["generator_platform"] = None
            tc.blocks["generic_system"].values["toolset"] = None

        tc.variables["ALLOW_IN_SOURCE_BUILD"] = True
        tc.variables["SIP_MODULE_SITE_PATH"] = "site-packages"
        tc.variables["Python_VERSION"] = self.deps_cpp_info["Python"].version
        tc.generate()

    _cmake = None

    def configure_cmake(self):
        if self._cmake:
            return self._cmake
        self._cmake = CMake(self)
        self._cmake.configure()
        return self._cmake

    def build(self):
        cmake = self.configure_cmake()
        cmake.build()

    def package(self):
        cmake = self.configure_cmake()
        cmake.install()
        self.copy("*", src = os.path.join("package", "site-packages"), dst = "site-packages")
        self.copy("*.pyi", src = ".", dst = "site-packages")

    def package_info(self):
        if self.in_local_cache:
            self.runenv_info.prepend_path("PYTHONPATH", os.path.join(self.package_folder, "site-packages"))
        else:
            self.runenv_info.prepend_path("PYTHONPATH",   os.path.join(str(pathlib.Path(__file__).parent.absolute())),
                                          f"cmake-build{self.settings.build_type}".lower())
