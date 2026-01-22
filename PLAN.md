# Foreign Function Interface (FFI) Expansion Plan

This document outlines the plan to create additional examples demonstrating the Foreign Function Interface (FFI) capabilities of the Wolfram Language.

## Objective
To provide a comprehensive set of examples covering intermediate to advanced FFI concepts, bridging the gap between simple scalar passing and complex real-world interoperability.

## Proposed Examples

### 1. Matrix Operations (`matrix_helpers`)
**Concept**: Efficiently passing and processing 2D arrays (matrices).
**Description**:
- Implement a C function `matrix_vector_multiply` that performs Matrix-Vector multiplication.
- Implement a C function `transpose_matrix` that transposes a matrix in-place.
- **Key Learning**: Handling contiguous memory (flattened arrays) representing 2D structures, using `RawArray` or `NumericArray` in WL to pass pointers directly for high performance.
**Files**:
- `matrix_helpers/matrix_lib.c`
- `matrix_helpers/MatrixOps.wl`

### 2. Error Handling & Pointers (`safe_math`)
**Concept**: robust error handling independent of side-effects (printing).
**Description**:
- Implement `safe_divide` which takes two `double` inputs and a `double*` for the result, returning an integer status code (0 for success, 1 for error).
- **Key Learning**: Passing pointers for "out" parameters, interpreting return codes in WL to generate `Message` or `Failure` objects, avoiding crashes from C arithmetic exceptions.
**Files**:
- `safe_math/safe_math.c`
- `safe_math/SafeMath.wl`

### 3. Asynchronous Callbacks (`callback_demo`)
**Concept**: Calling Wolfram Language functions from C (callbacks).
**Description**:
- Implement a C function `apply_callback` that iterates over an integer array and applies a function pointer to each element.
- The C function signature: `void apply_callback(int* data, size_t len, int (*func)(int))`.
- **Key Learning**: Using `ForeignCallback` in WL to create a callback entry point, passing this callback to C, and handling the bi-directional control flow.
**Files**:
- `callback_demo/callback_lib.c`
- `callback_demo/CallbackTest.wl`

### 4. Struct Management & Opaque Pointers (`image_processor`)
**Concept**: Managing C-side state using opaque pointers ('handles').
**Description**:
- Define a C struct `ImageBuffer` (width, height, pixel_data).
- Implement `create_image(w, h)`, `set_pixel(img, x, y, val)`, `get_pixel(img, x, y)`, and `destroy_image(img)`.
- **Key Learning**: Working with "Objects" in C exposed as `OpaqueRawPointer` in WL. Implementing a "Managed Object" pattern in WL (using `CreateManagedObject` or purely manual `delete` calls) to prevent memory leaks.
**Files**:
- `image_processor/image_lib.c`
- `image_processor/ImageTest.wl`

## Implementation Steps

1.  **Setup**: Ensure the C compiler (Clang/GCC) is available and configured.
2.  **Implementation**:
    - For each example, create the directory.
    - Write the C code (`.c` file).
    - Write the WL script (`.wl` file) to compile/load the library and test the functions.
3.  **Compilation Helper**: Create a reusable `build.sh` or a WL compilation helper function to streamline building the dynamic libraries (`.dylib` on macOS) for each example.
4.  **Verification**: Run each `.wl` script to verify output is as expected.

## Schedule
- **Phase 1**: `matrix_helpers` and `safe_math`.
- **Phase 2**: `callback_demo` and `image_processor`.
