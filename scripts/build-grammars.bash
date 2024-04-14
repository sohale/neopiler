#!/usr/bin/env bash
# Run from Docker

# builds base (standard: std1) grammars

# toolkit <-> std1 <-> built-in <-> public repo
# also: to pull


# export JBIN=/home/myuser/.conan2/p/openj8b5e1658a4707/p/bin
# export AJAR=/home/myuser/.conan2/p/antlr15795d040a28f/p/res/antlr-complete.jar

# Search for and find them
# Dynamically find the Java executable path
export JBIN=$(dirname $(find /home/myuser/.conan2 -name java -type f ))

# Dynamically find the ANTLR jar file
export AJAR=$(find /home/myuser/.conan2 -name "antlr-*complete.jar" )


# Count the number of results
count1=$(echo "$JBIN" | grep -c '^')
if [ "$count1" -ne 1 ]; then
    echo "Error: Expected exactly one Java binary, found $count1."
    echo ">>>>$JBIN<<<<"
    echo "exiting"
    exit 1
fi
count2=$(echo "$AJAR" | grep -c '^')
if [ "$count2" -ne 1 ]; then
    echo "Error: Expected exactly one Java binary, found $count2."
    echo ">>>>$AJAR<<<<"
    echo "exiting"
    exit 1
fi


# export CLASSPATH=".:$AJAR:$CLASSPATH"

set -exu

$JBIN/java -jar $AJAR    -Dlanguage=Cpp   -o ./antlr_output_dir ./toolkit/cxx/CString.g4

$JBIN/java -jar $AJAR    -Dlanguage=Cpp   -o ./antlr_output_dir ./toolkit/neopiler/Neopiler.g4
