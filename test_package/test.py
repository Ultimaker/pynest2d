from platform import system

if system() == "Windows":
    from os import add_dll_directory
    from pathlib import Path
    add_dll_directory(str(Path(__file__).parent))

import pynest2d

print("SIP_VERSION" in dir(pynest2d))