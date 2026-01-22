cmake_minimum_required(VERSION 3.10)
project(my_ffi C)

add_library(my_ffi_lib SHARED my_ffi_lib.c)

set_target_properties(my_ffi_lib PROPERTIES
    PREFIX ""
    IMPORT_PREFIX ""
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)
