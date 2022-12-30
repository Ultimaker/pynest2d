import shutil
from io import StringIO
from pathlib import Path

from conan import ConanFile
from conan.tools.env import VirtualRunEnv
from conan.tools.build import cross_building
from conan.errors import ConanException


class PyNest2DTestConan(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "VirtualRunEnv"

    def generate(self):
        venv = VirtualRunEnv(self)
        venv.generate()

    def build(self):
        if not cross_building(self):
            shutil.copy(Path(self.source_folder).joinpath("test.py"), Path(self.build_folder).joinpath("test.py"))

    def imports(self):
        if self.settings.os == "Windows" and not cross_building(self):
            self.copy("*.dll", dst=".", src="@bindirs")
            self.copy("*.pyd", dst=".", src="@libdirs")

    def test(self):
        if not cross_building(self, skip_x64_x86 = True):
            test_buf = StringIO()
            self.run(f"python test.py", env = "conanrun", output = test_buf)
            if "True" not in test_buf.getvalue():
                raise ConanException("pynest2d wasn't build correctly!")
