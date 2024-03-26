#!/bin/bash

# the-build.bash

# direct build

set -ex

# conan install . --output-folder=build --build=missing

conan install . --output-folder=build --profile=./conan/linux-clang-20-debug.profile \
   --build=missing
