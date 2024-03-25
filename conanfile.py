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

   default_options = {
      "antlr4:shared": True,
      "antlr4-cppruntime:shared": True,
   }

   def configure(self):
      if self.settings.compiler == "clang":
         # Compiler flags?
         self.settings.compiler.version = "12"
         self.settings.compiler.libcxx = "libc++"
         self.settings.compiler.cppstd = "20"
      else:
        raise NotImplementedError("Unsupported compiler, we use Clang here")

      # assert self.settings.os == "Linux", "Only Linux is supported"
      # assert self.settings.build_type == "Debug", "Only Debug is supported"
      # assert self.settings.arch == "x86_64", "Only x86_64 is supported"


   def imports(self):
      pass

   def build(self):
      cmake = CMake(self)
      # `#DEFINE` definitions:
      cmake.definitions["CMAKE_CXX_STANDARD"] = "20"  # Necessary for cmake
      cmake.configure()
      cmake.build()
