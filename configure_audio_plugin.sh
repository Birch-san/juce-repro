#!/usr/bin/env bash
set -eo pipefail

cd JUCE/examples/CMake/AudioPlugin
# uncomment find_package line
sed -i '/^# find_package(JUCE/ s/# //' CMakeLists.txt

VERBOSE=1 exec cmake -Bbuild \
-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
-DCMAKE_PREFIX_PATH="/linux_native" \
-DCMAKE_TOOLCHAIN_FILE="/${XARCH}_toolchain.cmake" \
-DCMAKE_BUILD_TYPE=Debug