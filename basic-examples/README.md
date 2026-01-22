# Basic Examples

This directory contains a simple example of using Foreign Function Interface (FFI) in Wolfram Language to call C functions.

## Contents

- `basic_examples.c`: The C source code containing several functions to demonstrate different FFI capabilities (integers, doubles, strings, structs).
- `basic_examples.wlt`: A Wolfram Language script that tests the loaded C functions.
- `basic_examples.wl`: The Wolfram Language script to load the library and execute tests.
- `CMakeLists.txt`: CMake configuration file for building the shared library.

## Prerequisites

- C Compiler (GCC, Clang, etc.)
- CMake
- Wolfram Language (Mathematica, Wolfram Engine, etc.)

## Building the Library
 
 This project uses a unified CMake build system.
 
 1.  Navigate to the project root directory.
 2.  Run the build commands:
 
     ```bash
     cmake -B build -S .
     cmake --build build
     ```
 
     This will generate `basic_examples.dylib` (or `.so`/`.dll`) inside this directory (`basic-examples/`).

## Usage

You can load the code using `Get`:

```mathematica
Get["basic-examples/basic_examples.wl"]
```

## Functions

The following Wolfram Language functions are defined in `basic_examples.wl`:

- `AddIntegers[a_, b_]`: Adds two integers.
- `MultiplyDoubles[a_, b_]`: Multiplies two doubles.
- `GetStringLength[s_String]`: Returns the length of a string.
- `ReverseString[s_String]`: Returns a new string which is the reverse of the input. (Caller must free the result).
- `FreeString[s_String]`: Frees the string allocated by `ReverseString`.
- `PointDistance[p1_, p2_]`: Calculates the distance between two points (structs).
- `PrintHello[]`: Prints a message to stdout.
