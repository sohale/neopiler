"""
[requires]
poco/1.10.1

[generators]
cmake
"""

from conans import ConanFile, CMake

class Neopiler(ConanFile):
   settings = "os", "compiler", "build_type", "arch"

   requires = ""   # comma-separated list of requirements
   generators = "cmake", "gcc", "txt"  # todo: make it clang

   def imports(self):
      pass
