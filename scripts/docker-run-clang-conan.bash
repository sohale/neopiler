# The bash
docker run \
      --rm -it \
      --volume $(pwd):$(pwd) \
      --user $(id -u):$(id -g) \
      --workdir $(pwd) \
      --env REPOROOT=$(realpath .) \
      --env CC=/usr/bin/clang \
      --env CXX=/usr/bin/clang++ \
      \
   neopiler_clang17_with_conan2:latest \
      \
      env && echo && \
      sudo rm  -f /usr/bin/g++ /usr/bin/gcc && \
      ls -altH conan/linux-clang-20-debug.profile && \
      conan install . \
      --output-folder=build \
      --profile:build=./conan/linux-clang-20-debug.profile \
      --profile:host=./conan/linux-clang-20-debug.profile \
      --build=missing

exit
#      bash \
#         -c "source $(realpath .)/scripts/container-bashrc.source; /bin/bash"


#       conan profile detect && \
