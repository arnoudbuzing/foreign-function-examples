(* Load the library and definitions *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "matrix.wl"}]];

(* Run Tests *)
report = TestReport[{
    VerificationTest[
        (* Definition: A 3x4 matrix *)
        A = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}};
        x = {1, 0, 1, 0};
        MatrixVectorMultiply[A, x],
        {4., 12., 20.},
        TestID -> "MatrixVectorMultiply"
    ],
    VerificationTest[
        (* Definition: A 3x3 matrix *)
        M = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
        TransposeSquareMatrix[M],
        {{1., 4., 7.}, {2., 5., 8.}, {3., 6., 9.}},
        TestID -> "TransposeSquareMatrix"
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
