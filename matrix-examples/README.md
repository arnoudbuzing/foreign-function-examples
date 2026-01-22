# Matrix Operations FFI Example

This example demonstrates how to efficiently pass numerical array data between the Wolfram Language and C using the Foreign Function Interface (FFI).

## Concepts Covered

1.  **Passing Arrays as Pointers**: Accessing the underlying data portion of a `NumericArray` or `RawArray` to pass to C functions expecting `double*`.
2.  **In-Place Modification**: Modifying data within a Wolfram Language-managed memory buffer directly from C.
3.  **Memory Management**: using `RawMemoryExport` to create C-compatible views of data and `RawMemoryImport` to retrieve results.

## Files

*   `matrix.c`: The C library implementing matrix-vector multiplication and in-place matrix transposition.
*   `matrix.wl`: The Wolfram Language script that loads the library (defining `MatrixVectorMultiply` and `TransposeSquareMatrix`).
*   `matrix.wlt`: The verification tests for the matrix operations.

## How to Run

1.  **Build the Library**:
    Open a terminal in the root directory and run:
    ```bash
    cmake -B build -S .
    cmake --build build
    ```
    ```
    ```
    This will generate `matrix.dylib`.

2.  **Run the Wolfram Language Script**:
    You can run the script using `wolframscript`:
    ```bash
    ```bash
    wolframscript -f matrix.wlt
    ```
    Or open `matrix.wl` in a Notebook interface to use the functions.

## Key Code Snippets

### Exporting Data to C
To pass a WL array to C, we first ensure it is a `NumericArray` of the correct type (e.g., "Real64"), then export it to get a raw pointer:

```mathematica
(* Create a NumericArray with explicit type *)
M = NumericArray[Flatten[{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}], "Real64"];

(* Get a pointer to the data *)
Mptr = RawMemoryExport[M];
```

### Importing Data from C
After the C function has modified the data (or filled an output buffer), we import it back into WL:

```mathematica
(* Import n*n elements as a List *)
resultList = RawMemoryImport[Mptr, {"List", n * n}];
```

## Function Reference

### `matrixVectorMultiply`
Computes `y = A . x` where `A` is a matrix and `x` and `y` are vectors.

**Signature:**
```mathematica
matrixVectorMultiply[Aptr, xptr, yptr, rows, cols]
```

**Arguments:**
*   `Aptr`: `OpaqueRawPointer` to the flattened input matrix data (rows * cols elements).
*   `xptr`: `OpaqueRawPointer` to the input vector data (cols elements).
*   `yptr`: `OpaqueRawPointer` to the output buffer (rows elements). **Must be allocated by caller**.
*   `rows`: Integer, number of rows in A.
*   `cols`: Integer, number of columns in A.

**Return:** `Void` (Output is written to `yptr`).

### `transposeSquareMatrix`
Transposes a square matrix in-place.

**Signature:**
```mathematica
status = transposeSquareMatrix[Mptr, n]
```

**Arguments:**
*   `Mptr`: `OpaqueRawPointer` to the flattened square matrix data.
*   `n`: Integer, the dimension of the matrix (n x n).

**Return:** `CInt` (Returns `n` on success, or error code). The data at `Mptr` is modified directly.
