#!/usr/bin/env bash
set -eo pipefail

cd JUCE/examples/CMake/AudioPlugin
# uncomment find_package line
sed -i '/^# find_package(JUCE/ s/# //' CMakeLists.txt

LINKER_FLAGS="/xwin/sdk/lib/um/x86_64/UIAutomationCore.lib"

# I've disabled assertions because of an unrelated issue (compiling asm on Clang):
#   https://github.com/juce-framework/JUCE/issues/986
VERBOSE=1 exec cmake -Bbuild \
-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
-DCMAKE_PREFIX_PATH="/linux_native" \
-DCMAKE_EXE_LINKER_FLAGS="$LINKER_FLAGS" \
-DCMAKE_MODULE_LINKER_FLAGS="$LINKER_FLAGS" \
-DCMAKE_INSTALL_PREFIX="/clang64" \
-DCMAKE_CXX_FLAGS="-I/xwin/sdk/include/um -I/xwin/sdk/include/shared -DWIN32_LEAN_AND_MEAN -D_AMD64_ -fms-extensions" \
-DCMAKE_TOOLCHAIN_FILE="/x86_64_toolchain.cmake" \
-DCMAKE_BUILD_TYPE=Debug