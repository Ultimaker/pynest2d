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
    options = {
        "python_version": "ANY",
        "shared": [True, False],
        "fPIC": [True, False]
    }
    default_options = {
        "python_version": "system",
        "shared": True,
        "fPIC": True,
    }
    scm = {
        "type": "git",
        "subfolder": ".",
        "url": "auto",
        "revision": "auto"
    }

    @property
    def _conan_data_version(self):
        version = tools.Version(self.version)
        return f"{version.major}.{version.minor}.{version.patch}-{version.prerelease}"

    def build_requirements(self):
        self.tool_requires("ninja/[>=1.10.0]")
        self.tool_requires("cmake/[>=3.23.0]")

    def requirements(self):
        for req in self.conan_data["requirements"][self._conan_data_version]:
            self.requires(req)

    def system_requirements(self):
        pass  # Add Python here ???

    def config_options(self):
        if self.options.shared and self.settings.compiler == "Visual Studio":
            del self.options.fPIC
        if self.options.python_version == "system":
            from platform import python_version
            self.options.python_version = python_version()

    def configure(self):
        self.options["*"].shared = self.options.shared

    def validate(self):
        if self.settings.compiler.get_safe("cppstd"):
            tools.check_min_cppstd(self, 17)

    def generate(self):
        cmake = CMakeDeps(self)
        cmake.generate()

        tc = CMakeToolchain(self, generator = "Ninja")

        if self.settings.compiler == "Visual Studio":
            tc.blocks["generic_system"].values["generator_platform"] = None
            tc.blocks["generic_system"].values["toolset"] = None

        tc.variables["ALLOW_IN_SOURCE_BUILD"] = True
        tc.variables["Python_VERSION"] = self.options.python_version
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
        py_version = tools.Version(self.options.python_version)
        py_build_type = "d" if self.settings.build_type == "Debug" else ""
        self.cpp.package.system_libs = [f"Python{py_version.major}.{py_version.minor}{py_build_type}"]
        if self.settings.os in ["Linux", "FreeBSD", "Macos"]:
            self.cpp.package.system_libs.append("pthread")

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
        self.runenv_info.append_path("PYTHONPATH", self.cpp_info.libdirs[0])
