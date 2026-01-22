(* 
  matrix.wl
  Demonstrates passing RawArrays (C Arrays) to Foreign Functions for high performance.
*)

(* Path to the library *)
currentDir = DirectoryName[$InputFileName];
libPath = FileNameJoin[{currentDir, "matrix.dylib"}];

(* Check if library exists *)
If[!FileExistsQ[libPath],
  Print["Library not found at: ", libPath];
  Print["Please build the project using CMake."];
  Exit[];
];

(* 
  1. Matrix-Vector Multiplication 
  void matrix_vector_multiply(double *A, double *x, double *y, int rows, int cols)
*)
matrixVectorMultiplyForeign = ForeignFunctionLoad[
  libPath, 
  "matrix_vector_multiply", 
  {"OpaqueRawPointer", "OpaqueRawPointer", "OpaqueRawPointer", "CInt", "CInt"} -> "Void"
];

(* WL Wrapper for Matrix-Vector Multiplication *)
MatrixVectorMultiply[A_List, x_List] := Module[{rows, cols, Aptr, xptr, yptr, resultY},
  rows = Length[A];
  cols = Length[A[[1]]];
  
  (* Flatten A for C *)
  Aflat = Flatten[A];
  
  (* Export data to C memory (Creates a copy!) *)
  Aptr = RawMemoryExport[Aflat, "Real64"];
  xptr = RawMemoryExport[x, "Real64"];
  
  (* Allocate output buffer manually *)
  yptr = RawMemoryAllocate["Real64", rows];

  (* Call C function *)
  matrixVectorMultiplyForeign[Aptr, xptr, yptr, rows, cols];
  
  (* Import result from C memory *)
  resultY = RawMemoryImport[yptr, {"List", rows}];
  
  resultY
];

(* 
  2. Square Matrix Transpose (in-place)
  int transpose_square_matrix(double *M, int n)
*)
transposeSquareMatrixForeign = ForeignFunctionLoad[
  libPath,
  "transpose_square_matrix",
  {"OpaqueRawPointer", "CInt"} -> "CInt"
];

(* WL Wrapper for In-Place Transpose *)
(* Note: In WL we typically don't modify in-place, so this wrapper takes a list,
   copies it to C, modifies the copy, and returns the new list. *)
TransposeSquareMatrix[M_List] := Module[{n, Mflat, Mptr, resultM, ret},
  n = Length[M];
  Mflat = Flatten[M];
  
  (* Export to C memory *)
  Mptr = RawMemoryExport[Mflat, "Real64"];
  
  (* Call C function *)
  ret = transposeSquareMatrixForeign[Mptr, n];
  
  (* Import result back *)
  resultM = RawMemoryImport[Mptr, {"List", n * n}];
  
  (* Partition back into matrix *)
  Partition[resultM, n]
];
