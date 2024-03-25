# install things. install requiremetns. preparation (of the environment)

sudo apt install default-jdk
java -version

# Install conan (via pipx)
sudo apt-get install pipx
pipx ensurepath
pipx install conan
conan  # test
