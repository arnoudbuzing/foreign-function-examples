cmake_minimum_required(VERSION 3.10)
project(basic_examples C)

add_library(basic_examples SHARED basic_examples.c)

set_target_properties(basic_examples PROPERTIES
    PREFIX ""
    IMPORT_PREFIX ""
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)
