
# Use inside:
#   bash ~/gpu-experimentations/provisioning_scripts/mlir_env/mlir_env.bash $HOME/neopiler/toolkit/llvm
export PATH="$PATH:$B"

export WHERE="/home/ephemssss/neopiler"

set -ue


# which llvm to use?

# export LLVM_DIR="/usr/lib/llvm-14"
export LLVM_DIR="/usr/lib/llvm-18"

export PATH="$LLVM_DIR/bin:$PATH"
# export LD_LIBRARY_PATH="$LLVM_DIR/lib:$LD_LIBRARY_PATH"
# export CPLUS_INCLUDE_PATH="$LLVM_DIR/include:$CPLUS_INCLUDE_PATH"

# LLVM_DIR → Used by CMake to find LLVM.
# LLVM_CONFIG → Used to specify a specific llvm-config path.
# LD_LIBRARY_PATH → Used to load the correct LLVM shared libraries

# How it works:
#
#    llvm-config --libdir
#          /mlir/llvm-project/build/lib
#
#    ldd: prints shared object dependencies
#    $LD_LIBRARY_PATH : Where the "dynamic linker" should look for shared libraries (.so files) before using the default system locations.
#

LLVMLIBDIR=$(llvm-config --libdir)
echo "$LLVMLIBDIR == $LLVM_DIR/lib"
LLVMINCDIR=$(llvm-config --includedir)

if [ -z "${LD_LIBRARY_PATH:-}" ]; then
    export LD_LIBRARY_PATH="$LLVMLIBDIR"
else
    export LD_LIBRARY_PATH="$LLVMLIBDIR:$LD_LIBRARY_PATH"
fi

set -x

clang++ -std=c++20 -g -o warmup1 \
    "$WHERE/toolkit/llvm/warmup/warmup1.cpp" \
    `llvm-config --cxxflags --ldflags --system-libs --libs core clangFrontend clangParse clangSema`

# now run ./warmup1

# ???:

# lli toolkit/llvm/example/example-fragment-1.ll
