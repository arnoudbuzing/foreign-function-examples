cmake_minimum_required(VERSION 3.10)
project(collatz_example C)

add_library(collatz SHARED collatz.c)

set_target_properties(collatz PROPERTIES
    PREFIX ""
    IMPORT_PREFIX ""
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)
