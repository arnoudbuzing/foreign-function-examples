cmake_minimum_required(VERSION 3.10)
project(matrix_examples C)

add_library(matrix_examples SHARED matrix_examples.c)

set_target_properties(matrix_examples PROPERTIES
    PREFIX ""
    IMPORT_PREFIX ""
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)
