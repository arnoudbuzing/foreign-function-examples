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


