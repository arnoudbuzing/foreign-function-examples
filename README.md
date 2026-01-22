# Wolfram Language FFI Examples

This repository contains various examples demonstrating the Foreign Function Interface (FFI) capabilities of the Wolfram Language.

## Project Structure

- `matrix-examples/`: Examples of matrix and vector operations.
- `basic-examples/`: Basic FFI examples (scalar types, strings, simple structs).
- `collatz-example/`: Computing the Collatz sequence using C for performance.

## Build System (CMake)

The project uses a unified CMake build system to compile all C libraries.

### Prerequisites

- A C compiler (e.g., GCC, Clang)
- CMake 3.10 or higher

### Building All Examples

To build all the FFI libraries at once:

```bash
cmake -B build -S .
cmake --build build
```

This will generate the dynamic libraries (`.dylib` on macOS, `.so` on Linux, `.dll` on Windows) directly in each example's directory, where the corresponding `.wl` scripts expect to find them.



## Running the Examples

Each example directory contains one or more `.wl` (Wolfram Language) scripts. You can run them using `wolframscript`:

```bash
cd matrix-examples
wolframscript -f matrix.wlt
```

Alternatively, you can open the `.wl` files in the Wolfram Desktop/Mathematica interface.
