
# Use inside:
#   bash ~/gpu-experimentations/provisioning_scripts/mlir_env/mlir_env.bash $HOME/neopiler/toolkit/llvm
export PATH="$PATH:$B"

export WHERE="/home/ephemssss/neopiler"

set -ux


# How it works:
#    llvm-config --libdir
#          /mlir/llvm-project/build/lib


export LD_LIBRARY_PATH=$(llvm-config --libdir):$LD_LIBRARY_PATH

clang++ -std=c++20 -g -o warmup1 \
    "$WHERE/toolkit/llvm/warmup/warmup1.cpp" \
    `llvm-config --cxxflags --ldflags --system-libs --libs core clangFrontend clangParse clangSema`

# now run ./warmup1

# ???:

# lli toolkit/llvm/example/example-fragment-1.ll
