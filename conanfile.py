"""
[requires]
poco/1.10.1

[generators]
cmake
"""

from conan import ConanFile

# fails:
from conan import CMake

#from conans import CMake
#from conans import ConanFile
#from conans import ConanFile, CMake

class Neopiler(ConanFile):

   name = " NeoPiler"
   version = "0.1"

   settings = "os", "compiler", "build_type", "arch"

   requires = "antlr4/4.13.1", "antlr4-cppruntime/4.13.1"

   # generators = "cmake", "gcc", "txt"  # todo: make it clang
   generators = "cmake", "txt"
   # See various generators: https://docs.conan.io/1/reference/generators.html
   #    "cmake":
   #    "cmake_find_package": This generator is suitable for CMake-based projects
   #    "txt": generic: produces conanbuildinfo.txt for human use (paths, flags, etc)
   #    "gcc": manually / preexisting build using gcc
   #    "CMakeToolchain": ? See https://docs.conan.io/2/reference/tools/cmake/cmaketoolchain.html#conan-tools-cmaketoolchain
   #    Multiple: You can use multiple to generate multiple files
   #    Alternatives: Meson (for simplicity and speed), CMake, SCons, Ninja (via Cmake), "cmake_find_package" (the cmake for ninja), Make (can call macke commands in `build()`), etc
   #    Not supported: Bazel (not supported in Conan out of the box),


   options = {"fPIC": [True, False]}

   default_options = {

      "antlr4:shared": True,
      "antlr4-cppruntime:shared": True,

      "fPIC": True,
   }

   # eq. to : generators = "CMakeToolchain" (?)
   # def generate(self):
   #     tc = CMakeToolchain(self)
   #     tc.variables["MYVAR"] = "MYVAR_VALUE"
   #     tc.preprocessor_definitions["MYDEFINE"] = "MYDEF_VALUE"
   #     tc.generate()

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


   #def imports(self):
   #   pass

   def build(self):
      cmake = CMake(self, generator="Ninja")
      # `#DEFINE` definitions:
      cmake.definitions["CMAKE_CXX_STANDARD"] = "20"  # Necessary for cmake
      cmake.configure()
      cmake.build()
