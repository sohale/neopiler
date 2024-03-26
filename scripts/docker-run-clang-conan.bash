docker run \
      --rm -it \
      --volume $(pwd):$(pwd) \
      --user $(id -u):$(id -g) \
      --workdir $(pwd) \
      --env REPOROOT=$(realpath .) \
   neopiler_clang17_with_conan2:latest \
      bash \
         -c "source $(realpath .)/scripts/container-bashrc.source; /bin/bash"
