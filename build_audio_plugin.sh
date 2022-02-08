#!/usr/bin/env bash
set -eo pipefail

cd JUCE/examples/CMake/AudioPlugin

# will encounter link failure in juce_VST3_Wrapper.cpp
exec cmake --build build --target AudioPluginExample_VST3