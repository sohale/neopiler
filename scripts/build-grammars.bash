#!/usr/bin/env bash

# builds base (standard: std1) grammars

# toolkit <-> std1 <-> built-in <-> public repo
# also: to pull

export JBIN=/home/myuser/.conan2/p/openj8b5e1658a4707/p/bin
export AJAR=/home/myuser/.conan2/p/antlr15795d040a28f/p/res/antlr-complete.jar

# export CLASSPATH=".:$AJAR:$CLASSPATH"


$JBIN/java -jar $AJAR    -Dlanguage=Cpp   -o ./antlr_output_dir ./toolkit/cxx/CString.g4

$JBIN/java -jar $AJAR    -Dlanguage=Cpp   -o ./antlr_output_dir ./toolkit/neopiler/Neopiler.g4
