
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
```bash
conan remote list
```
`conancenter: https://center.conan.io [Verify SSL: True, Enabled: True]`

Fixed by adding:
`--build=missing`
to my `conan install …`

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
