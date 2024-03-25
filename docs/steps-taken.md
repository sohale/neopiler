
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
