
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


### useful tools
Not required
```
brew install git-cola
```
