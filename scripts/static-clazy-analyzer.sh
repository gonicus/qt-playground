#!/usr/bin/env bash
set -e

pushd .

rm -rf build; mkdir build; cd build

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++  
export CLAZY_IGNORE_DIRS="(.*qmltyperegistrations.*|.*/tests/.*|.*/\\.rcc/.*)"
export CLAZY_CHECKS="level0,level1,qt6-header-fixes,no-no-module-include,no-lambda-unique-connection"

cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DENABLE_WARNING_IS_ERROR=OFF -DENABLE_CLAZY=ON ..
cmake --build . --parallel $(nproc --all) 2>&1 | tee /tmp/build.log

popd

scripts/process-clazy-output.py --token $API_TOKEN /tmp/build.log
