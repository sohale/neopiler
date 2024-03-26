
git, apt upgrade etc

#### Install ANTLR 4
Install Antlr4: core (java) & target (C++)
wget https://www.antlr.org/download/antlr4-cpp-runtime-4.13.1-source.zip
actual (unfolded, observed; outcome; g-truth): 4.13.1

Start with: https://github.com/antlr/antlr4/tree/master

```bash
sudo apt install default-jdk
java -version
```

Outcome: `openjdk version "11.0.22" 2024-01-16. OpenJDK Runtime Environment (build 11.0.22+7-post-Ubuntu-0ubuntu222.04.1). OpenJDK 64-Bit Server VM (build 11.0.22+7-post-Ubuntu-0ubuntu222.04.1, mixed mode, sharing)`


#### Set up Conan
According to: https://docs.conan.io/2/installation.html
```bash
# pip install conan  # but no. instead:


sudo apt-get install pipx
pipx ensurepath
# restart terminal here (?)
pipx install conan
conan  # test
```

Wrote the conanfile.py

Still an error:
```bash
conan install .
```
```
ERROR: The default build profile '/home/ephemssss/.conan2/profiles/default' doesn't exist.
You need to create a default profile (type 'conan profile detect' command)
or specify your own profile with '--profile:build=<myprofile>'
```


#### Act
Run actions locally: `act`
Use: https://github.com/nektos/act to install on Linux.

Ok, let's make github acitons, and run it locally:
https://github.com/nektos/act
(previous: 6 June 2023)
```bash
# Install Go tools 1.20+, see below
go version
cd install
git clone git@github.com:nektos/act.git
cd act
make test
make install
```
The `make isntall` will need access to '/usr/local/bin/act'. You can, instead of `sudo`ing it,
```bash
sudo touch /usr/local/bin/act
sudo chown  $USER:$USER /usr/local/bin/act
make install
```
The `make test` fails. Not sure, it might need Docker, which requires certain permissions.
```bash
sudo usermod -aG docker $USER

```

#### Install Golang
Installing *go* (Golang) for "Act":
Based on: https://golang.org/doc/install

1. From https://go.dev/dl/ extract the URL, then:
2. do
```bash
cd install
wget https://go.dev/dl/go1.22.1.linux-amd64.tar.gz
rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version
```
Outcome: `go version go1.22.1 linux/amd64`

3. Add go to PATH permanently. Add this to your ~/.bashrc:
```bash
source .../scripts/bashrc.bash.source
```

4. (optional step): Then, use managed install: https://go.dev/doc/manage-install



### useful tools
Not required
```
brew install git-cola
```

#### (optional) Terraform
todo: also terraform.


#### Conan: cont.
OK now conan is intalled, and I also have a conanfile.py. But It needs to create a profile.
```
conan profile detect
```
Output:
```txt
detect_api: Found gcc 11
detect_api: gcc>=5, using the major as version
detect_api: gcc C++ standard library: libstdc++11
```
then
```txt
Detected profile:
[settings]
arch=x86_64
build_type=Release
compiler=gcc
compiler.cppstd=gnu17
compiler.libcxx=libstdc++11
compiler.version=11
os=Linux
```

Create & see profiles:
```
conan profile detect

??conan profile list default --detec

conan profile list
conan profile show
conan profile path default
```

and finally: (not that I have my conan profile: "default")
```
conan install .
```
which shows but follows with some errors (not shown)
```txt
======== Input profiles ========
Profile host:
[settings]
arch=x86_64
build_type=Release
compiler=gcc
compiler.cppstd=gnu17
compiler.libcxx=libstdc++11
compiler.version=11
os=Linux

Profile build:
[settings]
arch=x86_64
build_type=Release
compiler=gcc
compiler.cppstd=gnu17
compiler.libcxx=libstdc++11
compiler.version=11
os=Linux
```

Create a conan profile. (See ...)

By this? (only once. diff)
```bash
conan profile detect --force
conan profile path default
```

Then:
Sorry, it seems I need my separate venv
```bash
python3 -m venv install/venv-neopiler
source ./install/venv-neopiler/bin/activate
pip install conan
```

# Conan 2.0
Ok, it seems my sample conanfile s were from Conan 1. But I am (and should be) using Conan 2.


conan install . --output-folder=build --build=missing

What is `CMAKE_TOOLCHAIN_FILE`?
```
$ cmake .. -G "..." -DCMAKE_TOOLCHAIN_FILE="conan_toolchain.cmake"
$ cmake --build . --config Release
```

Apparently you need to look into:
git clone https://github.com/conan-io/examples2.git

ok, let's see


todo: Conan in subfolder
https://github.com/conan-io/examples2/blob/main/examples/conanfile/layout/conanfile_in_subfolder/conan/conanfile.py


ok. import CMake is deprecated in Conan 2

now `conan install .` works. Almost.

Next thing to solve:
```
ERROR: Error loading conanfile at '/home/ephemssss/neopiler/conanfile.py': Error while initializing options. The usage of package names `antlr4:shared` in options is deprecated, use a pattern like `antlr4/*:shared` instead
```
Simply added a `/*`

### Clang installation

Let's see: https://clang.llvm.org/get_started.html

Why profile file is not created?
why I cannot cfreate it locally?

Why Adjust my clang version?

`compiler.version=12`

#### On profiles
Comments should be on separate lines

Profile can be specific in cli arg `--profile`, see build.bash


#### cmake_layout issue:

What is it about?

What is the workflow?

Why does conanfile have a layout?
```
[layout]
cmake_layout
```
```
ERROR: Missing binary: antlr4-cppruntime/4.13.1:
ERROR: Missing prebuilt package for 'antlr4-cppruntime/4.13.1'. You can try:
```
It suggestes:
    - List all available packages using `conan list antlr4-cppruntime/4.13.1:* -r=remote`
    - Explain missing binaries: replace `conan install ...` with 'conan graph explain ...'
    - Try to build locally from sources using the `--build=antlr4-cppruntime/4.13.1` argument

 I suppose, also `--build=missing`


but:
```bash
conan list antlr4-cppruntime/4.13.1:* -r=remote
```
`ERROR: Remote 'remote' can't be found or is disabled`
```bash
conan install antlr4-cppruntime/4.13.1:*
```
`ERROR: Conanfile not found at /home/ephemssss/neopiler/antlr4-cppruntime/4.13.1:*`


Fixed by adding:
`--build=missing`
to my `conan install …`

Also useful: (not, no `*` or `@`)
```bash
conan search antlr4-cppruntime/4.13.1 -r conancenter
conan remote list
conan remote enable conancenter
```
Some outputs:
`conancenter: https://center.conan.io [Verify SSL: True, Enabled: True]`


Why remote is not accepted?
`conan list antlr4-cppruntime/4.13.1:* -r=remote`


This could be useful, but already fine:
```bash
sudo apt-get install clang
sudo apt-get reinstall clang
```

This was Missing: (fixed)
```bash
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
```

Note:
```bash
conan install . --output-folder=build --profile=./conan/linux-clang-20-debug.profile    --build=missing
```


Next issue: Standard libary is missing? `/usr/include/c++/v1/new:218:40: error: 'std' is not a class, namespace, or enumeration`

"Ensure that your compiler and standard library versions are compatible and correctly set up."

#### Standard library artifacts
Learning note: on libstdc, libc++

My notes on C/C++ standard library, its separation and multitude

##### Question:
```
A few (a myriad of) quesitions about libc++.

Four things: lib std c++, lib c++, lib c, lib std c
Two things: Clang , gcc.

Why do we have both `libstdc++11`  & `libc++` for clang?
Does it (11 or nont-11) depend on C++ version?
Could it be related to modules in C++20?
Is `libc++` for before, or after?
If I want to stick to C++20, which ones (of the two) do I need?
Why we have `libstdc++11` for C++11, and not before C++11?
Will `libstdc++11` work with C++20?
Why is it apt-get that has: `libc++-dev` and `libc++abi-dev`?
Why both?
Why are they separate as part of apt-get?
Is it independent from GCC vs clang?
but I think clang has its own stdlib?
Is stdlib a link-time thing? or header-only? or both?
Why is stdlib needed? doesn't linux itself provide the basis? (files, etc)
Why did they separate stdlib?
Is it just the `std::` of C++ and everything in it?
So it is not just C?

doesn't C itself need a standard library?
is C library perpendicular to C++'s?

Why is it `libc++-dev` and not libc++?
Why ABI in `libc++abi-dev`. isn't a non-ABI enough?
Why package manager (conanfile or its profile) needs to specify that? and why?
```

##### The two: Why separate std lib
`Why multiple & separate std lib: the two`

Standard libary can have multiple implementations. Otherwise, it is just a standard.

' ##### Why separating stdlib'
The separation of the standard library from compilers allows for flexibility and the continuous evolution of C++ support, independent of compiler updates.

"The separation of standard libraries allows for flexibility, portability, and the optimization of library implementations for specific compilers or platforms."

##### The two: Why multiple std libs
Implementations include GNU (part of GCC), and Clang's re-implentations of it.

The former can be used with Clang too, because clang is backward compatible. (but not recommended? Is it slower? Is it kept compatilble? or is it just compatible? Why did them reimplement it for LLVM? In fact I remember they said the way they were written was creating IR that were not suitable for LLVM's optimisations)

* `libstdc++` …: GNU implementation
* `libc++` : Specific to Clang/LLVM (lighter)

* Clang's `libc++`
* GCC's `libstdc++`

Specific artifacts:
* `libstdc++11`
* `libc++`

The `11` suffix does not mean any limitation to version. Both support latest versions of C++. Both evolved continuously.
‌Both can be used in C++20.

###### From user's point of view (what benefit from) re-implementinf
Clang with `libc++` versus Clang with `libstdc++`:
1. is "more naturally paired"
2. "designed for compatibility with Clang and LLVM"
3. "aims to be lighter"
4. "and more performant"
5. `libc++` "is designed to work with Clang" and not GCC. But `libstdc++` can be used with both.
6. Part of: they are "part of" clang and gcc, respectively.
7. "different implementations might be optimized for different compilers" or "systems"
8. "compatibility with your compiler"
   * "Ensure that your compiler and standard library versions are compatible and correctly set up."
9. compiler architecture: "each optimized for their respective compiler's architecture and performance characteristics."
10. Modularity: "Clang reimplemented the standard library (libc++) to optimize for LLVM's backend and to provide a modular, lightweight, and performance-oriented library."
   * modular
   * lightweight
   * performance-oriented library
11. motivated by the desire to create a library that leverages LLVM's strengths
   * including its optimizer and code generation capabilities.

Compatibility:
* Compatibility with libstdc++ is *maintained* to ensure that Clang can be used in environments where libstdc++ is prevalent or required.


##### Binary-ness & link-ed-ness distinction
C++ standard library includes both header-only components and components that require linking.
Only the template and inline are as source. Otherwise, shipped as binary.

In other words,
* header-only components (templates, inline functions)
* components that require linking (compiled binary code, like the standard library's implementation of IO operations)

##### apt-get artifacts
Artifacts:
* `libc++-dev`
* `libc++abi-dev`
These are `apt-get`--specific names.

Both for `libc++` (as opposed to `libstdc++11`).


Difference:
* `libc++-dev`: provides the "headers and development files" for libc++.
* `libc++abi-dev` : implements the low-level ABI

###### Suffix `-dev`

Is the `-dev` suffix for compiling software that "depends on the library"? or to develop the library itself? (Yes, verified). The development of library itself will not need `apt-get` packages.
Verified: "They are intended for developers building software that depends on these libraries, not for the development of the libraries themselves."

###### Separate package for the ABI
* "an ABI layer": ABI as a layer added, for e.g. `libc++`.
   * The ABI layer is only between headers and binaries of the same?
   * Then why do we have them (as) separate packages?

* "ABI layers are crucial"
   * for ensuring binary compatibility across different versions of a library
   * or when interfacing with other components

Separate packages for ABI:
* to "update" or "configure" the ABI support "independently" from the main library development files.


##### C vs C++ standard libraries:
* C++ standard library is compatible at level of interface (and ABI), but the implementation should be different to C (to verify). It seems there is partial (degrees of) ABI-compatibility.
* The C standard library packages and (product) names are different. (to verify) (look up the names)

* Are C and C++ ABI-level compatible?
   * (If backward-compatibility is conserved. How much?)
   * Maybe being ABI-compatible is meaningful in context of compiling (because we are compiling them, and we don't need to mix headers of one stdlib with binaries of another. But I am speculating this, and am not sure).

* So, we have ABI compatibility betwen C & C++?
    * data types
    * function calls
    * memory layouts

* The "degree of compatibility" can vary
   * hence, C vs C++ std lib s are not fully compatible (to verify)

* The **level** of compatibility: The "C" standard library (as opposed to C++'s) remains available "at the level of language" (compiling sources without changing the .hxx and .cxx source files)


* memory layouts = ? Why should they matter for ABI?

What if I miss that ABI package? ( `libc++abi-dev` )

##### Side notes:

Motivation of separating:
* Nice way to say: "standard library is separated from the compiler to allow for evolution and improvement of the library independent of the compiler"
* allows for different implementations
* "different implementations might be optimized for different compilers or systems"

##### On status of C++20 modules:
Damn, as of 26 March 2024 still suppor for modules are partially missing for both Clang and GCC:
* gcc 11 (partial)
* clang 8 (partial)

"standard c++ modules"? See https://clang.llvm.org/docs/StandardCPlusPlusModules.html#how-modules-speed-up-compilation

### Conan 2
* **Layout**: the directory structure of the project.
* `cmake_layout`: function that defines the layout. In terms of directories for source, build, and package.

* Workflow:
* Installation of Conan (and pulling the repo)
* Seed the **profile** (may be in home directory; not pushed?)
* The **Conan-File** execusion
   * Includes parametrising
* The **configure**
* The **layout** step
* The **generate** step
* The **configure** step
* The **build** step (compiles into binaries)
   * Includes "post-build" executables (e.g. for debugging/demonstrating)
   * Involves, CMake, which in turn, involves make, ninja, etc
* The **package** step
   * Copying binaries, header, etc
   * from the "build directory" to the "package directory"
   * assembling all the components into package
   * package project side
   * how to "produce" the package (as opposed to consume: see below)
   * creating the package content, vs "usage"
* The **package-info**
   * package consumer/user ('s project) side
   * how to "consume" the package
   * What info? library names, compile definitions, header (.hxx) files
   * "usage" versus "creating the package content" (in "package" as verb)

Other Conan2 concepts:
* requirements ?
* build of dependencies (from source, etc): The "transitivity" in package management (when there is a hierarchy of packages)
* compile definitions
* etc
