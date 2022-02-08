#!/usr/bin/env bash
set -eo pipefail

cd JUCE

exec cmake --build build --target install