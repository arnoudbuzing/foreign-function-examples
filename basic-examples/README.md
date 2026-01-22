# Basic Examples

This directory contains a simple example of using Foreign Function Interface (FFI) in Wolfram Language to call C functions.

## Contents

- `basic_examples.c`: The C source code containing several functions to demonstrate different FFI capabilities (integers, doubles, strings, structs).
- `test_ffi.wl`: A Wolfram Language script that tests the loaded C functions.
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

Once the library is built, you can run the Wolfram Language script to test the functions.

1.  Open the `test_ffi.wl` file in Wolfram Desktop or run it with `wolframscript`:

    ```bash
    wolframscript -f test_ffi.wl
    ```

## Functions

The C library exports the following functions:

- `int add_integers(int a, int b)`: Adds two integers.
- `double multiply_doubles(double a, double b)`: Multiplies two doubles.
- `int get_string_length(const char *s)`: Returns the length of a string.
- `char *reverse_string(const char *s)`: Returns a new string which is the reverse of the input. (Caller must free the result).
- `void free_string(char *s)`: Frees the string allocated by `reverse_string`.
- `double point_distance(Point p1, Point p2)`: Calculates the distance between two points (structs).
- `void print_hello()`: Prints a message to stdout.
