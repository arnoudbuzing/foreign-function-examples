(* Define the path to the library *)
libPath = FileNameJoin[{DirectoryName[$InputFileName], "collatz.dylib"}];

(* Load the functions *)
collatz = ForeignFunctionLoad[libPath, "collatz", {"Integer64"} -> "Integer64"];
collatzSequenceForeign = ForeignFunctionLoad[libPath, "collatz_sequence", {"Integer64", "RawPointer"::["OpaqueRawPointer"]} -> "Integer64"];
collatzFree = ForeignFunctionLoad[libPath, "collatz_free", {"OpaqueRawPointer"} -> "Void"];

(* Efficient sequence computation *)
CollatzSequence[n_Integer] := Module[{ptrToPtr, len, dataPtr, managedDataPtr, result},
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

(* Run Tests *)
report = TestReport[{
    VerificationTest[
        collatz[5],
        16,
        TestID -> "CollatzStep-5"
    ],
    VerificationTest[
        collatz[18],
        9,
        TestID -> "CollatzStep-18"
    ],
    VerificationTest[
        CollatzSequence[5],
        {5, 16, 8, 4, 2, 1},
        TestID -> "CollatzSeq-5"
    ],
    VerificationTest[
        CollatzSequence[18],
        {18, 9, 28, 14, 7, 22, 11, 34, 17, 52, 26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1},
        TestID -> "CollatzSeq-18"
    ]
}];

(* Print Summary *)
Print[""];
Print["Tests passed: ", report["TestsSucceededCount"]];
Print["Tests failed: ", report["TestsFailedCount"]];


If[report["TestsFailedCount"] > 0, 
    Print["Failed Tests:"];
    Scan[Print[#["TestID"]]&, Select[Values[report["TestResults"]], #["Outcome"] =!= "Success" &]];
    Exit[1]
];

Exit[0];
