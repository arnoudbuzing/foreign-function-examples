#!/bin/bash
# Simple build script for macOS

gcc -shared -o matrix_lib.dylib matrix_lib.c -fPIC
echo "Build complete: matrix_lib.dylib"
