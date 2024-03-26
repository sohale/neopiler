
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

12. Only clang separates ABI from the rest: `libc++-dev` `libc++abi-dev` (see motivation for separating ABI in stdlib packaging)
13. They did a major refactoring (see it this way)

Compatibility:
* Compatibility with libstdc++ is *maintained* to ensure that Clang can be used in environments where libstdc++ is prevalent or required.


##### Binary-ness & link-ed-ness distinction
C++ standard library includes both header-only components and components that require linking.
Only the template and inline are as source. Otherwise, shipped as binary.

In other words,
* header-only components (templates, inline functions)
* components that require linking (compiled binary code, like the standard library's implementation of IO operations)

##### Packaging: apt-get artifacts
Artifacts:
* `libc++-dev`
* `libc++abi-dev`
These are `apt-get`--specific names.

Both for `libc++` (as opposed to `libstdc++11`).


Difference:
* `libc++-dev`: provides the "headers and development files" for libc++.
* `libc++abi-dev` : implements the low-level ABI

###### Package naming
* Minor notes on package naming:
   * gcc has a verion number `libstdc++-<version>-dev` (for GCC 9, it would be `libstdc++-9-dev`)
   * but Clang's does not have a verison name (see above).
   * (Also see C packages below; `libc6-dev`)
   * See below for `-dev` suffix
   * The Clang's compiler and stdlib development are "tightly integrated and versioned together as part of the LLVM project".
      * "are expected to be managed together rather than piecemeal"

* Non-Debian package managers (dnf, pacman, yum, zypper) use differnt package names: `glibc-devel` (gcc), `libcxx-devel`, `libcxxabi-devel` (clang), etc
   * Fedora and CentOS (Red Hat) use `yum` or `dnf`, Arch Linux uses `pacman`, openSUSE uses `zypper`.

* The package `build-essential` includes gcc, g++, make
   * What is the difference between gcc vs g++? you mentioned them in the same list (as alternatives?) I always get confused about g++, gcc, and other namings of the compiler binary for gcc C/C++/etc compiler(s).

* On suffix `-dev` in apt-get:
Is the `-dev` suffix for compiling software that "depends on the library"? or to develop the library itself? (Yes, verified). The development of library itself will not need `apt-get` packages.
Verified: "They are intended for developers building software that depends on these libraries, not for the development of the libraries themselves."

* Reminder: `dev` is specific to Clang
* Nice way to say it: Clang's approach to "standard library packaging"

###### Separate package for the ABI
* "an ABI layer": ABI as a layer added, for e.g. `libc++`.
   * The ABI layer is only between headers and binaries of the same?
   * Then why do we have them (as) separate packages?

* "ABI layers are crucial"
   * for ensuring binary compatibility across different versions of a library
   * or when interfacing with other components

Separate packages for ABI:
* to "update" or "configure" the ABI support "independently" from the main library development files.

ABI notes:
* name mangling (only C++)
* exception handling (only C++)
* ABI concerns "pre-compiled" binaries (ABI stability and compatibility)
* Separation of ABI is not common for C libraries.
   * C ABI issues are less complex
      * simpler compilation model of C
      * C's lack of features like name mangling.
* Contributing to ABI complexity:
   * Name Mangling (Name Decoration):
   * Exception Handling
   * Virtual Tables
      * Virtual Inheritance
      * dynamic binding
      * The layout of virtual tables (vtables)
      * dynamic binding can vary between compilers, affecting how method calls are resolved at runtime.
   * Templates and Template Instantiation
      * different Template instantiation strategies across compilers  & compiler verions
   * Inheritance and Object Layout

* interoperability
ABI (Application Binary Interface) is fundamentally about interoperability.

ABI compatibility across
* different compilers
* different compiler versions
* different  build configurations

separation of the compilation and linking phases is key.

for independent compilation of modules that,
"must" "later" be linked into a single executable or library.

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

* C packages:
Package name: `libc6-dev`
Name `glibc` (GNU C Library)

* Only Clang separates ABI from the rest: `libc++-dev` `libc++abi-dev`
* Clang and GCC can both use `glibc`
* The ABI-specific package (libc++abi-dev) is only about C++.

##### Commands
* `gcc` compile multiple languages covered by GCC
   * used when compiling C code.
   * ability to compile multiple languages (including C++).
   * Does not automatically includes the C++ standard library
   * You can use `-lstdc++`

* `g++` Specifically for C++.
   * automatically includes the C++ standard library
   * specifically, `libstdc++`

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


### stdlib for antlr
Back to the real world.

oh, see this:
warning: "Libc++ only supports Clang 16 and later"

while
clang --version

Ubuntu clang version 14.0.0-1ubuntu1.1
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin

https://clangd.llvm.org/installation.html

How to install latest clangd, and not take too long?
* ccache?
* dockerfile
* ready docker image


```bash

docker pull silkeh/clang
docker pull silkeh/clang:17

docker run --rm -it silkeh/clang bash
docker run --rm -it -v $(pwd):$(pwd) silkeh/clang bash

export ENVFILE=toolchain/scripts/clang-env-docker.env

docker run --rm -it -v $(pwd):$(pwd) --env-file "$ENVFILE" silkeh/clang:17 bash

docker run --rm -it \
      -v $(pwd):$(pwd) \
      --env-file "$ENVFILE" \
      --user $(id -u):$(id -g) \
   silkeh/clang:17 \
      bash


docker run --rm -it \
      --volume $(pwd):$(pwd) \
      --user $(id -u):$(id -g) \
      --workdir $(pwd) \
      --env REPOROOT=$(realpath .) \
   silkeh/clang:17 \
      bash

```


```bash
export ENVFILE=toolchain/scripts/clang-env-docker.env
touch $ENVFILE
export ENVRFILE=$(realpath $ENVFILE)
printenv | grep -E '^(HOME|PS1)=' > $ENVRFILE
echo "# End of host's environment variables" >> $ENVRFILE

```

Mapping user inside Docker:
Inside Docker container:
```bash
cat /etc/passwd
cat /etc/group
id -u
id -g
id
```


The user inside is: (by running command `id`):
```
uid=1000 gid=1000 groups=1000
```
Already mapping of the file using `--user $(id -u):$(id -g)` works:
```
-rw-r--r--  1 ephemssss ephemssss     0 Mar 26 16:57 file-created-in-container.txt
-rw-rw-r--  1 ephemssss ephemssss  1527 Mar 25 16:39 file-created-in-host.txt
```

Good pattern:
Use source ing inside the container.

Usage: docker run ... `bash -c "source /path/to/yourfile; exec bash"`

Why `exec`? Aha, inside bash, we want to rnu another bash, but reuse the process & PID.

A possible pattern:
--env CONTAINER_NAME=mycontainer

Notes:
* Specifically: `:17`
* Note: `--env-file`
* Use a `docker-compose.yml`
* I deally, RUN useradd -m myuser -u 1000 -g 1000


```bash

docker run --rm -it \
      --volume $(pwd):$(pwd) \
      --user $(id -u):$(id -g) \
      --workdir $(pwd) \
      --env REPOROOT=$(realpath .) \
   silkeh/clang:17 \
      bash \
      -c "source $(realpath .)/scripts/container-bashrc.source; exec bash"



docker run --rm -it \
      --volume $(pwd):$(pwd) \
      --user $(id -u):$(id -g) \
      --workdir $(pwd) \
      --env REPOROOT=$(realpath .) \
   silkeh/clang:17 \
      bash \
      -c "source $(realpath .)/scripts/container-bashrc.source; /bin/bash"


```

Oops, I will need Conan too, inside the container:

In search of a Clang 17 with Conan 2:
https://github.com/conan-io/conan-docker-tools
https://github.com/conan-io/conan-docker-tools/tree/master/modern
wow, containers for Jenkins too?

? https://github.com/conan-io/conan-docker-tools/blob/master/modern/clang/Dockerfile

Legacy Conan 1: (e.g. conanio/clang14-ubuntu16.04 (Clang 14) x86_64)
https://docs.conan.io/1/howtos/run_conan_in_docker.html#docker-conan

Conan? https://hub.docker.com/u/conanio

Search: https://hub.docker.com/search?q=conan%20clang

`chainguard/clang` :  zero CVE
   * (Build, ship and run secure software with Chainguard's low-to-zero CVE container images).
   * CVE: Common Vulnerabilities and Exposures

conan server ! docker image

#### Chainguard's image
Ok, Let's focus on "Chainguard"'s
```
docker pull cgr.dev/chainguard/clang:latest
docker pull chainguard/clang:latest
```

https://images.chainguard.dev/directory/image/clang/overview


```bash

docker run --rm -it \
      --volume $(pwd):$(pwd) \
      --user $(id -u):$(id -g) \
      --workdir $(pwd) \
      --env REPOROOT=$(realpath .) \
   chainguard/clang:latest \
      bash

```
cool: clang-15
The latest supported is 15.


Image's SBOM = ?

SBOM: https://images.chainguard.dev/directory/image/clang/sbom

Good to know:
libxml2


okok, let's create and build a dockerfile
```dockerfile
FROM silkeh/clang:latest
# FROM silkeh/clang:17

# The silkeh/clang image is based on debian:buster-slim

# RUN apt-get update && apt-get install -y bash

# not:    pip install --user pipx && \
# do I need " --user" also in apt-get install pipx ?
# no need: pipx ensurepath
#no need?    export PATH=$PATH:/root/.local/bin && \
# unable to locate pipx: apt-get install -y pipx
# ok, then update
# debconf: delaying package configuration, since apt-utils is not installed

RUN \
   apt-get update && \
   apt-get install -y pipx && \
   export PATH=$PATH:/root/.local/bin && \
   pipx install conan


# bash (not this, but the CVE one)
# realpath
# go (for act)
# act: no


#   # Build the Docker image
#   docker build -t neopiler_clang17_with_conan2 -f /home/ephemssss/neopiler/toolchain/dockering/conan_with_clang.Dockerfile .
#
#   # Run the Docker container
#   docker run -it neopiler_clang17_with_conan2

```

Successfully tagged neopiler_clang17_with_conan2:latest
!


```bash

docker run --rm -it \
      --volume $(pwd):$(pwd) \
      --user $(id -u):$(id -g) \
      --workdir $(pwd) \
      --env REPOROOT=$(realpath .) \
   neopiler_clang17_with_conan2:latest \
      bash \
      -c "source $(realpath .)/scripts/container-bashrc.source; /bin/bash"


```

but where is conan?
which conan
/home/ephemssss/.local/bin/conan

ls -alt /home/ephemssss/.local/bin/
total 24
drwxrwxr-x 2 ephemssss ephemssss 4096 Mar 25 20:39 .
lrwxrwxrwx 1 ephemssss ephemssss   49 Mar 25 20:39 conan -> /home/ephemssss/.local/pipx/venvs/conan/bin/conan
drwxrwxr-x 6 ephemssss ephemssss 4096 Mar 25 16:47 ..
-rwxrwxr-x 1 ephemssss ephemssss  206 Feb 27 21:59 cmake
-rwxrwxr-x 1 ephemssss ephemssss  206 Feb 27 21:59 cpack
-rwxrwxr-x 1 ephemssss ephemssss  206 Feb 27 21:59 ctest
-rwxrwxr-x 1 ephemssss ephemssss  206 Feb 27 21:59 ninja


oops:
bash: sudo: command not found

I need `ls /root`


Added sudo. A separate layer, will make it faster.
```Dockerfile
RUN \
   apt-get update && \
   apt-get install -y sudo && \
   apt-get install -y bash && \
   apt-get install -y apt-utils && \
```

sudo: you do not exist in the passwd database

I can use
```
   apt-get install -y apt-fast && \
```
But a conundrum:
Needs `apt-get update` before any ... I see!

At least, later ones will be fast. But cannot apt-fast before that.

In clang:17
Available: wget
Not available: curl

Alternative: manually install apt-fast
https://github.com/ilikenwf/apt-fast

OK, An image, only with`apt-get update`: absolutely nothing else
RUN apt-get update

Nevertheless, `E: Unable to locate package apt-fast`

ok, I need to add this too:
debconf: delaying package configuration, since apt-utils is not installed

OK, now conan command available: `/root/.local/bin/conan`

Note:
/home/ephemssss/.local/bin/conan -> /home/ephemssss/.local/pipx/venvs/conan/bin/conan


At what step of the docker it creates myuser?
It's OK, since the number is `1000`
`id`
uid=1000(myuser) gid=1000(myuser) groups=1000(myuser)


but:
`id root`
uid=0(root) gid=0(root) groups=0(root)


ok, now cleaning up:
```
docker ps -a | grep 'act-push-yml' | awk '{print $1}' | xargs docker rm


docker images | awk '{print $3}' |xargs docker rmi

```


To remove all unused images (not just dangling ones), you can use:
```
docker image prune -a
```

Difference between dangling and unused?!

docker container prune


Enalbed colour:
force_color_prompt=yes
color_prompt=yes

What?

./scripts/docker-run-clang-conan.bash
ERROR: The default build profile '/home/myuser/.conan2/profiles/default' doesn't exist.
You need to create a default profile (type 'conan profile detect' command)
or specify your own profile with '--profile:build=<myprofile>

So, which one: `--profile:build=` or `--profile=`?

--profile:host=myprofile --profile:build=myprofile


New approachL removed ANTLR for now.

A conflict
In Conan, the `CMakeToolchain` can be specified either in the generators attribute of your conanfile.py or instantiated and used within the generate() method, but not both simultaneously.

Generated aggregated env files: ['conanbuild.sh', 'conanrun.sh']


This was the culprit!!
```
compiler.libcxx=libc++
```

Clanup:
```bash
conan remove "*" -f

conan remove "antlr4-cppruntime/4.13.1" -f

conan remove "antlr4-cppruntime/4.13.1" -b -p -f

conan remove "antlr4-cppruntime/4.13.1" -b -p
```
-b option removes the build folder, -p removes the package folder, and -f forces the action without confirmation.

Oh no, it does not run that in the container!

OK done.

Now runnning ANTLR 4
```bash
export JBIN=/home/myuser/.conan2/p/openj8b5e1658a4707/p/bin
export AJAR=/home/myuser/.conan2/p/antlr15795d040a28f/p/res/antlr-complete.jar
export CLASSPATH=".:$AJAR:$CLASSPATH"
$JBIN/java -jar $AJAR
# verifies ANTLR is running: ANTLR Parser Generator  Version 4.13.1

$JBIN/java -jar $AJAR  -Dlanguage=C++ -o output_dir ./toolkit/cxx/cstring.antlr.g4
```

```
error(31):  ANTLR cannot generate C++ code as of version 4.13.1
error(8): cstring.antlr.g4:13:8: grammar name CppString and file name cstring.antlr.g4 differ
```
