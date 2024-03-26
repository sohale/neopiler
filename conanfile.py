"""
[requires]
poco/1.10.1

[generators]
cmake
"""

from conan import ConanFile

# fails: Deprecated in Conan 2?
# from conan import CMake

#from conans import CMake
#from conans import ConanFile
#from conans import ConanFile, CMake

# Cool stuff available in Conan 2
from conan.tools.cmake import CMake  # constructor
from conan.tools.cmake import cmake_layout  # function


class Neopiler(ConanFile):

   name = " NeoPiler"
   version = "0.1"

   settings = "os", "compiler", "build_type", "arch"

   requires = "antlr4/4.13.1", "antlr4-cppruntime/4.13.1"


   # Conan 1
   # generators = "cmake", "txt"
   # See various generators: https://docs.conan.io/1/reference/generators.html
   #    "cmake":
   #    "cmake_find_package": This generator is suitable for CMake-based projects
   #    "txt": generic: produces conanbuildinfo.txt for human use (paths, flags, etc)
   #    "gcc": manually / preexisting build using gcc
   #    "CMakeToolchain": ? See https://docs.conan.io/2/reference/tools/cmake/cmaketoolchain.html#conan-tools-cmaketoolchain
   #    Multiple: You can use multiple to generate multiple files
   #    Alternatives: Meson (for simplicity and speed), CMake, SCons, Ninja (via Cmake), "cmake_find_package" (the cmake for ninja), Make (can call macke commands in `build()`), etc
   #    Not supported: Bazel (not supported in Conan out of the box),



   # Conan 2
   generators = "CMakeToolchain"


   # Binary configuration
   options = {
    "fPIC": [True, False],
    "shared": [True, False],
   }

   default_options = {

      "antlr4/*:shared": True,
      "antlr4-cppruntime/*:shared": True,

      "fPIC": True,
      "shared": False,
   }

   def layout(self):
      # for sub-projects
      # See https://github.com/conan-io/examples2/blob/main/examples/conanfile/layout/multiple_subprojects/bye/conanfile.py
      # self.folders.root = ".."
      # self.folders.subproject = "bye"

      # cmake_layout(self, src_folder="src")
      # self.folders.source = "src"
      # cmake_layout(self)
      cmake_layout(self, src_folder="src")

      # https://github.com/conan-io/examples2/blob/main/examples/conanfile/layout/third_party_libraries/conanfile.py

   # Conan 2
   # Sources are located in the same place as this recipe, copy them to the recipe
   # exports_sources = "CMakeLists.txt", "src/*", "include/*"

   def generate(self):
      tc = CMakeToolchain(self)
      tc.generate()
   # eq. to : generators = "CMakeToolchain" (?)
   # def generate(self):
   #     tc = CMakeToolchain(self)
   #     tc.variables["MYVAR"] = "MYVAR_VALUE"
   #     tc.preprocessor_definitions["MYDEFINE"] = "MYDEF_VALUE"
   #     tc.generate()

   # not sure if used in Conan 2
   def configure(self):
      print("In Conan 2 too? Yes. Confirmed")
      if self.settings.compiler == "clang":
         # Compiler flags?
         self.settings.compiler.version = "16"
         #  warning: "Libc++ only supports Clang 16 and later" ( /usr/include/c++/v1/__config:48:8 )
         self.settings.compiler.libcxx = "libc++"
         self.settings.compiler.cppstd = "20"

         print('@self.settings.compiler', self.settings.compiler, repr(self.settings.compiler))
      elif self.settings.compiler == "gcc":
        raise NotImplementedError("GCC is discouraged here. Let's use Clang for now")
      else:
        raise NotImplementedError("Unsupported compiler, we use Clang here")

      assert self.settings.os == "Linux", "Only Linux is supported for now"
      assert self.settings.build_type == "Debug", "Only Debug is supported for now"
      # assert self.settings.arch == "x86_64", "Only x86_64 is supported"


   #def imports(self):
   #   pass

   # Same in 1,2
   def build(self):
      cmake = CMake(self, generator="Ninja")
      # `#DEFINE` definitions:
      cmake.definitions["CMAKE_CXX_STANDARD"] = "20"  # Necessary for cmake
      cmake.configure()
      cmake.build()
      # self.run(os.path.join(self.cpp.build.bindir, "bye"))


"""

   def package(self):
      cmake = CMake(self)
      ßcmake.install()

   def package_info(self):

      # self.cpp_info.libs = ["hello"]

      self.cpp_info.components["algorithms"].libs = ["algorithms"]
      self.cpp_info.components["algorithms"].set_property("cmake_target_name", "algorithms")

      self.cpp_info.components["network"].libs = ["network"]
      self.cpp_info.components["network"].set_property("cmake_target_name", "network")

      self.cpp_info.components["ai"].libs = ["ai"]
      self.cpp_info.components["ai"].requires = ["algorithms"]
      self.cpp_info.components["ai"].set_property("cmake_target_name", "ai")

      self.cpp_info.components["rendering"].libs = ["rendering"]
      self.cpp_info.components["rendering"].requires = ["algorithms"]
      self.cpp_info.components["rendering"].set_property("cmake_target_name", "rendering")
"""

""" From various sources


* https://github.com/conan-io/examples2/blob/main/examples/conanfile/package_info/components/conanfile.py

"""


"""
Usage:
1. create profile
2. conan install . --output-folder=build --build=missing
"""
