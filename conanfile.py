import os

from pathlib import Path
from os import path

from conan import ConanFile
from conan.errors import ConanInvalidConfiguration
from conan.tools.build import check_min_cppstd
from conan.tools.cmake import CMake, CMakeToolchain, cmake_layout
from conan.tools.env import VirtualBuildEnv
from conan.tools.files import copy, mkdir
from conan.tools.microsoft import check_min_vs, is_msvc, is_msvc_static_runtime
from conan.tools.scm import Version


required_conan_version = ">=1.56.0"


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
    generators = "CMakeDeps", "VirtualBuildEnv", "VirtualRunEnv"

    python_requires = "pyprojecttoolchain/[>=0.1.7]@ultimaker/stable", "sipbuildtool/[>=0.2.4]@ultimaker/stable"

    options = {
        "shared": [True, False],
        "fPIC": [True, False],
        "py_build_requires": ["ANY"],
        "py_build_backend": ["ANY"],
    }
    default_options = {
        "shared": True,
        "fPIC": True,
        "py_build_requires": '"sip >=6, <7", "setuptools>=40.8.0", "wheel"',
        "py_build_backend": "sipbuild.api",
    }

    def set_version(self):
        if not self.version:
            self.version = "5.3.0-alpha"

    @property
    def _min_cppstd(self):
        return 17

    @property
    def _compilers_minimum_version(self):
        return {
            "gcc": "9",
            "clang": "9",
            "apple-clang": "9",
            "msvc": "192",
            "visual_studio": "14",
        }

    def export_sources(self):
        copy(self, "CMakeLists.txt", self.recipe_folder, self.export_sources_folder)
        copy(self, "*", path.join(self.recipe_folder, "python"), path.join(self.export_sources_folder, "python"))

    def requirements(self):
        self.requires("nest2d/5.2.2")
        self.requires("cpython/3.10.4")

    def validate(self):
        if self.settings.compiler.cppstd:
            check_min_cppstd(self, self._min_cppstd)
        check_min_vs(self, 192)  # TODO: remove in Conan 2.0
        if not is_msvc(self):
            minimum_version = self._compilers_minimum_version.get(str(self.settings.compiler), False)
            if minimum_version and Version(self.settings.compiler.version) < minimum_version:
                raise ConanInvalidConfiguration(
                    f"{self.ref} requires C++{self._min_cppstd}, which your compiler does not support."
                )

    def build_requirements(self):
        self.test_requires("standardprojectsettings/[>=0.1.0]@ultimaker/stable")
        self.test_requires("sipbuildtool/[>=0.2.4]@ultimaker/stable")

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def configure(self):
        if self.options.shared:
            self.options.rm_safe("fPIC")
        self.options["cpython"].shared = True

    def generate(self):
        pp = self.python_requires["pyprojecttoolchain"].module.PyProjectToolchain(self)
        pp.blocks["tool_sip_project"].values["sip_files_dir"] = str(Path("python").as_posix())
        # mkdir(self, self.build_path)  # FIXME: bad, this should not be necessary
        pp.blocks.remove("extra_sources")
        pp.generate()

        tc = CMakeToolchain(self)
        if is_msvc(self):
            tc.variables["USE_MSVC_RUNTIME_LIBRARY_DLL"] = not is_msvc_static_runtime(self)
        tc.cache_variables["CMAKE_POLICY_DEFAULT_CMP0077"] = "NEW"
        tc.variables["Python_EXECUTABLE"] = self.deps_user_info["cpython"].python.replace("\\", "/")
        tc.variables["Python_USE_STATIC_LIBS"] = not self.options["cpython"].shared
        tc.variables["Python_ROOT_DIR"] = self.deps_cpp_info["cpython"].rootpath.replace("\\", "/")
        tc.variables["Python_FIND_FRAMEWORK"] = "NEVER"
        tc.variables["Python_FIND_REGISTRY"] = "NEVER"
        tc.variables["Python_FIND_IMPLEMENTATIONS"] = "CPython"
        tc.variables["Python_FIND_STRATEGY"] = "LOCATION"
        tc.variables["Python_SITEARCH"] = "site-packages"
        tc.generate()

        vb = VirtualBuildEnv(self)
        vb.generate(scope="build")

        # Generate the Source code from SIP
        sip = self.python_requires["sipbuildtool"].module.SipBuildTool(self)
        sip.configure()
        sip.build()

    def layout(self):
        cmake_layout(self)

        if self.settings.os in ["Linux", "FreeBSD", "Macos"]:
            self.cpp.package.system_libs = ["pthread"]

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        copy(self, pattern="LICENSE*", dst="licenses", src=self.source_folder)
        for ext in ("*.pyi", "*.so", "*.lib", "*.a", "*.pyd"):
            copy(self, ext, src = self.build_folder, dst = path.join(self.package_folder, "lib"), keep_path = False)

        for ext in ("*.dll", "*.so", "*.dylib"):
            copy(self, ext, src = self.build_folder, dst = path.join(self.package_folder, "bin"), keep_path = False)

    def package_info(self):
        self.cpp_info.libdirs = [ os.path.join(self.package_folder, "lib")]
        if self.in_local_cache:
            self.runenv_info.append_path("PYTHONPATH", os.path.join(self.package_folder, "lib"))
        else:
            self.runenv_info.append_path("PYTHONPATH", self.build_folder)
