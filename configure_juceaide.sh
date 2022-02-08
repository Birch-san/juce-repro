#!/usr/bin/env bash
set -eo pipefail

cd JUCE

# build juceaide (we will *not* cross-compile this for Windows; we build natively for the build machine)
exec cmake -B build -DCMAKE_INSTALL_PREFIX="/linux_native"