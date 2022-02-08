#!/usr/bin/env bash
set -eo pipefail

cd JUCE/examples/CMake/AudioPlugin
# uncomment find_package line
sed -i '/^# find_package(JUCE/ s/# //' CMakeLists.txt

# I've disabled assertions because of an unrelated issue (compiling asm on Clang):
#   https://github.com/juce-framework/JUCE/issues/986
VERBOSE=1 exec cmake -Bbuild \
-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
-DCMAKE_PREFIX_PATH="/linux_native" \
-DCMAKE_INSTALL_PREFIX="/$MINGW_REPO" \
-DCMAKE_CXX_FLAGS='-DJUCE_DISABLE_ASSERTIONS' \
-DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" \
-DCMAKE_BUILD_TYPE=Debug