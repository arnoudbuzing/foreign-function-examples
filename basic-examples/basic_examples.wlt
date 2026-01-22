(* Load the library and definitions *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "basic_examples.wl"}]];

(* Helper for reverse string logic *)
ReverseString[inputStr_String] := Module[{ptr, managedPtr, address, typedPtr, reversedStr},
    ptr = reverseStringPtr[inputStr];
    If[ptr =!= $Failed && Head[ptr] === OpaqueRawPointer,
        managedPtr = CreateManagedObject[ptr, freeString];
        address = First[ptr];
        typedPtr = RawPointer[address, "UnsignedInteger8"];
        reversedStr = RawMemoryImport[typedPtr, "String"];
        reversedStr
    ,
        $Failed
    ]
]

(* Run Tests *)
report = TestReport[{
    VerificationTest[
        addIntegers[10, 20],
        30,
        TestID -> "AddIntegers"
    ],
    VerificationTest[
        multiplyDoubles[2.5, 4.0],
        10.0,
        TestID -> "MultiplyDoubles"
    ],
    VerificationTest[
        getStringLength["Wolfram Language"],
        16,
        TestID -> "StringLength"
    ],
    VerificationTest[
        pointDistance[{0.0, 0.0}, {3.0, 4.0}],
        5.0,
        TestID -> "PointDistance"
    ],
    VerificationTest[
        ReverseString["Antigravity"],
        "ytivargitnA",
        TestID -> "ReverseString"
    ],
    VerificationTest[
        printHello[];
        True,
        True, (* Just verifying it doesn't crash *)
        TestID -> "PrintHello"
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
