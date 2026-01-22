(* Define the path to the library *)
libPath = FileNameJoin[{DirectoryName[$InputFileName], "basic_examples.dylib"}];

(* Load the functions *)
addIntegers = ForeignFunctionLoad[libPath, "add_integers", {"CInt", "CInt"} -> "CInt"];
multiplyDoubles = ForeignFunctionLoad[libPath, "multiply_doubles", {"CDouble", "CDouble"} -> "CDouble"];
getStringLength = ForeignFunctionLoad[libPath, "get_string_length", {"OpaqueRawPointer"} -> "CInt"];
reverseStringPtr = ForeignFunctionLoad[libPath, "reverse_string", {"OpaqueRawPointer"} -> "OpaqueRawPointer"];
freeString = ForeignFunctionLoad[libPath, "free_string", {"OpaqueRawPointer"} -> "Void"];
pointDistance = ForeignFunctionLoad[libPath, "point_distance", {{"CDouble", "CDouble"}, {"CDouble", "CDouble"}} -> "CDouble"];
printHello = ForeignFunctionLoad[libPath, "print_hello", {} -> "Void"];

(* Test simple functions *)
Print["add_integers[10, 20] = ", addIntegers[10, 20]];
Print["multiply_doubles[2.5, 4.0] = ", multiplyDoubles[2.5, 4.0]];
Print["get_string_length[\"Wolfram Language\"] = ", getStringLength["Wolfram Language"]];

(* Test struct passing *)
p1 = {0.0, 0.0};
p2 = {3.0, 4.0};
Print["point_distance[", p1, ", ", p2, "] = ", pointDistance[p1, p2]];

(* Test reverse_string *)
inputStr = "Antigravity";
ptr = reverseStringPtr[inputStr];
If[ptr =!= $Failed && Head[ptr] === OpaqueRawPointer,
  (* Manage the memory so it is automatically freed when no longer used *)
  managedPtr = CreateManagedObject[ptr, freeString];
  
  address = First[ptr];
  typedPtr = RawPointer[address, "UnsignedInteger8"];
  reversedStr = RawMemoryImport[typedPtr, "String"];
  Print["reverse_string[\"", inputStr, "\"] = ", reversedStr];
  (* No need to call freeString[ptr] manually *)
,
  Print["Failed to reverse string."];
];

Print["Calling print_hello:"];
printHello[];
