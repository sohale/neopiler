# Required foundation programs

# Pattern by Sosi, CC / © 2014

git --version
ssh -T git@github.com  # check remote access for git. If failed: source ~/gpu-experimentations/provisioning_scripts/refresh-ssh-agent.bash_source
# Checks if docker is installed, with correct permissions
docker run --rm hello-world

java -version
go version
conan

# pipx
# go version

act
ls -1 ./install/act  # not necessarily here
# also: act  antlr4-cpp-runtime-4.13.1-source.zip  go1.22.1.linux-amd64.tar.gz

antlr4

# check wasted space, resources
docker images
docker ps -a
