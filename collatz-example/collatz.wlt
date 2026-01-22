(* Load the library and definitions *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "collatz.wl"}]];

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
