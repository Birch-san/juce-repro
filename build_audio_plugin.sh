#!/usr/bin/env bash
set -eo pipefail

cd JUCE/examples/CMake/AudioPlugin

exec cmake --build build --target AudioPluginExample_Standalone