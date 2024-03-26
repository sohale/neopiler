set -eux

cd "$REPOROOT"

docker build \
   -t neopiler_clang17_with_conan2 \
   -f /home/ephemssss/neopiler/toolchain/dockering/conan_with_clang.Dockerfile \
   .

