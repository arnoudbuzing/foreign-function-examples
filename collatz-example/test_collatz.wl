(* Define the path to the library *)
libPath = FileNameJoin[{DirectoryName[$InputFileName], "collatz.dylib"}];

(* Load the functions *)
collatz = ForeignFunctionLoad[libPath, "collatz", {"Integer64"} -> "Integer64"];
collatzSequenceForeign = ForeignFunctionLoad[libPath, "collatz_sequence", {"Integer64", "RawPointer"::["OpaqueRawPointer"]} -> "Integer64"];
collatzFree = ForeignFunctionLoad[libPath, "collatz_free", {"OpaqueRawPointer"} -> "Void"];

(* Efficient sequence computation *)
CollatzSequence[n_Integer] := Module[{ptrToPtr, len, dataPtr, result},
    If[n <= 0, Return[{}]];
    
    (* Allocate a small buffer to receive the data address from C *)
    ptrToPtr = RawMemoryAllocate["OpaqueRawPointer", 1];
    
    (* Call C function: it allocates the array and returns its length *)
    len = collatzSequenceForeign[n, ptrToPtr];
    
    If[len < 0, Return[$Failed]];
    
    (* Retrieve the C-allocated pointer from the buffer *)
    dataPtr = RawMemoryRead[ptrToPtr];
    
    (* Manage the memory *)
    managedDataPtr = CreateManagedObject[dataPtr, collatzFree];
    
    (* Convert and import the data *)
    result = RawMemoryImport[RawPointer[First[dataPtr], "Integer64"], {"List", len}];
    
    (* No need to manually free *)

    
    result
]

(* --- Tests --- *)

Print["collatz[5] = ", collatz[5]];
Print["collatz[18] = ", collatz[18]];

Print["CollatzSequence[5] = ", CollatzSequence[5]];
Print["CollatzSequence[18] = ", CollatzSequence[18]];

(* Verification *)
If[CollatzSequence[5] === {5, 16, 8, 4, 2, 1},
    Print["\nSuccess: All tests passed!"],
    Print["\nFailure: Some tests failed."]
];
