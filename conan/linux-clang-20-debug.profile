[settings]

os=Linux
arch=x86_64
compiler=clang

# Adjust this to your installed Clang version
compiler.version=17

# libstdc++11  Or libc++
# This was the culprit!!
# compiler.libcxx=libc++

compiler.cppstd=20
build_type=Debug
