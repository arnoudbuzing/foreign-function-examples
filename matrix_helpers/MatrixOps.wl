(* 
  MatrixOps.wl
  Demonstrates passing RawArrays (C Arrays) to Foreign Functions for high performance.
*)

(* Path to the library *)
currentDir = DirectoryName[$InputFileName];
libPath = FileNameJoin[{currentDir, "matrix_lib.dylib"}];

(* Check if library exists *)
If[!FileExistsQ[libPath],
  Print["Library not found at: ", libPath];
  Print["Please run build.sh first."];
  Exit[];
];

(* 
  1. Matrix-Vector Multiplication 
  void matrix_vector_multiply(double *A, double *x, double *y, int rows, int cols)
*)
matrixVectorMultiply = ForeignFunctionLoad[
  libPath, 
  "matrix_vector_multiply", 
  {"OpaqueRawPointer", "OpaqueRawPointer", "OpaqueRawPointer", "CInt", "CInt"} -> "Void"
];

(* Helper to convert Wolfram Arrays to C-compatible RawPointer *)
(* Requires 'KeepAlive' if the pointer is used asynchronously, but here we are synchronous *)

RunMatrixMultExample[] := Module[{rows = 3, cols = 4, A, x, Aptr, xptr, yptr, resultY},
  Print["\n=== Running Matrix-Vector Multiplication Example ==="];
  
  (* Define data *)
  A = Flatten[{{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}}];
  x = {1, 0, 1, 0};
  
  (* Export data to C memory (Creates a copy!) *)
  Aptr = RawMemoryExport[A, "Real64"];
  xptr = RawMemoryExport[x, "Real64"];
  
  (* Allocate output buffer manually *)
  yptr = RawMemoryAllocate["Real64", rows];

  Print["Matrix A: ", A];
  Print["Vector x: ", x];
  
  (* Call C function *)
  matrixVectorMultiply[Aptr, xptr, yptr, rows, cols];
  
  (* Import result from C memory *)
  resultY = RawMemoryImport[yptr, {"List", rows}];
  
  Print["Result y = A.x: ", resultY];
  
  (* Verification in WL *)
  Print["Verification: ", Partition[A, cols] . x];
];

(* 
  2. Square Matrix Transpose (in-place)
  int transpose_square_matrix(double *M, int n)
*)
transposeSquareMatrix = ForeignFunctionLoad[
  libPath,
  "transpose_square_matrix",
  {"OpaqueRawPointer", "CInt"} -> "CInt"
];

RunTransposeExample[] := Module[{n = 3, M, Mptr, resultM, ret},
  Print["\n=== Running Square Matrix Transpose Example ==="];
  
  M = NumericArray[Flatten[{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}], "Real64"];
  
  (* Export to C memory *)
  Mptr = RawMemoryExport[M];
  
  Print["Original Matrix (Flattened): ", Normal[M]];
  Print["Formatted: ", Partition[Normal[M], n]];
  
  (* Call C function *)
  ret = transposeSquareMatrix[Mptr, n];
  Print["Transpose function returned: ", ret];
  
  (* Import result back *)
  resultM = RawMemoryImport[Mptr, {"List", n * n}];
  
  Print["Transposed Matrix (Flattened): ", resultM];
  Print["Formatted: ", Partition[resultM, n]];
  
  Print["Verification: ", Flatten[Transpose[Partition[Normal[M], n]]]];
];

(* Run the examples *)
RunMatrixMultExample[];
RunTransposeExample[];
