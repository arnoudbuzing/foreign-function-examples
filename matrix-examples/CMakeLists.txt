cmake_minimum_required(VERSION 3.10)
project(matrix C)

add_library(matrix SHARED matrix.c)

set_target_properties(matrix PROPERTIES
    PREFIX ""
    IMPORT_PREFIX ""
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)
