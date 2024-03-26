#!/bin/bash

# the-build.bash

set -ex

# conan install . --output-folder=build --build=missing

conan install . --output-folder=build --profile=./conan/linux-clang-20-debug.profile \
   --build=missing
