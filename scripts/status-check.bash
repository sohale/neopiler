# Required foundation programs

# Pattern by Sosi, CC / © 2014

git --version
ssh -T git@github.com  # check remote access for git. If failed: source ~/gpu-experimentations/provisioning_scripts/refresh-ssh-agent.bash_source
# Checks if docker is installed, with correct permissions
docker run --rm hello-world

java -version
go version
conan --version
# Does it also check whether Conan install is done? no.

# optional
pipx --version
pipx list  # should contain conan. eg. package conan 2.2.2, installed using Python 3.10.12
# Note: venvs are in /home/ephemssss/.local/pipx/venvs (it says)


act
act --list
# act --help
ls -1 ./install/act >/dev/null || echo "ERROR: no ./install/act "  # not necessarily here. Only check if it exists
# also: act  antlr4-cpp-runtime-4.13.1-source.zip  go1.22.1.linux-amd64.tar.gz

antlr4

# check wasted space, resources
docker images
docker ps -a

set -ex

# important
conan profile list

--profile=myprofile
