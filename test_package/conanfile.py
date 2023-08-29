import shutil
from io import StringIO
from pathlib import Path

from conan import ConanFile
from conan.tools.env import VirtualRunEnv
from conan.tools.build import can_run
from conan.errors import ConanException
from conan.tools.files import copy


class PyNest2DTestConan(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "VirtualRunEnv"
    test_type = "explicit"

    def requirements(self):
        self.requires(self.tested_reference_str)

    def generate(self):
        venv = VirtualRunEnv(self)
        venv.generate()

        cpp_info = self.dependencies[self.tested_reference_str].cpp_info
        copy(self, "*.pyd", src = cpp_info.libdirs[0], dst =self.build_folder)

        for dep in self.dependencies.values():
            for bin_dir in dep.cpp_info.bindirs:
                copy(self, "*.dll", src = bin_dir, dst = self.build_folder)

    def build(self):
        if can_run(self):
            shutil.copy(Path(self.source_folder).joinpath("test.py"), Path(self.build_folder).joinpath("test.py"))

    def test(self):
        if can_run(self):
            test_buf = StringIO()
            self.run(f"python test.py", env = "conanrun", output = test_buf)
            if "True" not in test_buf.getvalue():
                raise ConanException("pynest2d wasn't build correctly!")
