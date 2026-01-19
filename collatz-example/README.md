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

## Wolfram Language Integration

The integration uses the `ForeignFunctionLoad` system. A key feature of this example is the `CollatzSequence` function in `test_collatz.wl`, which:
1.  Provides an `OpaqueRawPointer` to C to receive a memory address.
2.  Calls the C function to perform the calculation and allocation.
3.  Uses `RawMemoryImport` with a typed `RawPointer` to convert the raw C data into a native Wolfram Language `List`.
4.  Calls `collatz_free` in C to ensure no memory leaks occur.

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
