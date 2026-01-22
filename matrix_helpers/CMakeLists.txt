cmake_minimum_required(VERSION 3.10)
project(matrix_helpers C)

add_library(matrix_lib SHARED matrix_lib.c)

# Set output directory to current source directory for compatibility with existing scripts
set_target_properties(matrix_lib PROPERTIES
    PREFIX ""
    IMPORT_PREFIX ""
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)
