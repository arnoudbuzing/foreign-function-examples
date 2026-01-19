# Collatz Sequence FFI Example

This example demonstrates how to use the Wolfram Language **Foreign Function Interface (FFI)** to call C code for computing the Collatz sequence. It highlights different memory management strategies, including manual allocation in C and importing raw memory into Wolfram Language.

## Project Structure

- `collatz.c`: C source code containing the mathematical logic and memory management functions.
- `collatz.dylib`: The compiled dynamic library (macOS).
- `test_collatz.wl`: Wolfram Language script to load the library and execute tests.

## Mathematical Overview

The Collatz conjecture involves a sequence defined as follows:
- If $n$ is even: $n_{i+1} = n_i / 2$
- If $n$ is odd: $n_{i+1} = 3n_i + 1$
- The sequence ends when it reaches 1.

## C Functions

The library exports the following functions:

1.  `int64_t collatz(int64_t n)`: Computes a single step of the sequence.
2.  `int64_t collatz_length(int64_t n)`: Computes the total length of the sequence for a given $n$.
3.  `void collatz_fill(int64_t n, int64_t* out)`: Fills a caller-provided buffer with the sequence.
4.  `int64_t collatz_sequence(int64_t n, int64_t** out_data)`: 
    - **Highly Efficient**: Computes the sequence in a **single pass**.
    - Internal use of `malloc` and `realloc` to resize the buffer as needed.
    - Returns the length and provides the memory address via a pointer-to-pointer.
5.  `void collatz_free(int64_t* data)`: Frees memory allocated by `collatz_sequence`.

## Compilation

To compile the C code into a dynamic library on macOS:

```bash
gcc -shared -fPIC -o collatz.dylib collatz.c
```

## Wolfram Language Functions

The `test_collatz.wl` script defines high-level functions that wrap the underlying C library.

### `CollatzSequence[n_Integer]`

Computes the full Collatz sequence starting from `n` using the highly efficient single-pass C implementation.

- **Arguments**: 
  - `n`: A positive integer (must be greater than 0).
- **Returns**: 
  - A `List` of integers representing the complete sequence ending in 1.
  - Returns `{}` if `n` is less than or equal to 0.
  - Returns `$Failed` if C memory allocation fails.
- **Implementation Detail**: 
  - It uses a pointer-to-pointer (`"RawPointer"::["OpaqueRawPointer"]`) to receive a dynamically allocated memory address from the C `collatz_sequence` function.
  - It converts the result into a native Wolfram `List` using `RawMemoryImport`.
  - It automatically releases the C-allocated memory using `collatz_free`.

## Wolfram Language Integration

### Running the Example

You can run the provided test script using `wolframscript`:

```bash
wolframscript -file test_collatz.wl
```

### Manual Usage in Wolfram Kernel

```wolfram
libPath = "./collatz.dylib";
collatz = ForeignFunctionLoad[libPath, "collatz", {"Integer64"} -> "Integer64"];
collatz[5] (* Returns 16 *)
```

## Memory Management Note

This project demonstrates **Managed Memory** vs **Manual Memory**:
- For simple buffers, `RawMemoryAllocate` in Wolfram Language is preferred as it is garbage-collected.
- For dynamic data whose size is unknown until computed in C (like the Collatz sequence), manual allocation in C combined with an explicit `free` call (or `CreateManagedObject`) is more efficient.
