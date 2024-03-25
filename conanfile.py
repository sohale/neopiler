"""
[requires]
poco/1.10.1

[generators]
cmake
"""

from conans import ConanFile, CMake

class Neopiler(ConanFile):

   name = " NeoPiler"
   version = "0.1"

   settings = "os", "compiler", "build_type", "arch"

   requires = "antlr4/4.13.1", "antlr4-cppruntime/4.13.1"

   # generators = "cmake", "gcc", "txt"  # todo: make it clang
   generators = "cmake"

   default_options = {"antlr4:shared": True, "antlr4-cppruntime:shared": True}


   def imports(self):
      pass

   def build(self):
      cmake = CMake(self)
      cmake.configure()
      cmake.build()
