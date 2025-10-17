cmake_minimum_required(VERSION 3.10)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
project(MyProject)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Define source files for main application (corrected paths)
set(SOURCES
    main.cpp
    math_operations.cpp
)

add_executable(MyApp ${SOURCES})

# Enable testing
enable_testing()

# Include FetchContent module
include(FetchContent)

# Fetch GoogleTest
FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/heads/main.zip
)

# Make available
FetchContent_MakeAvailable(googletest)

# Define source files for unit tests (corrected paths)
set(TEST_SOURCES
    tests/unit_tests.cpp
    math_operations.cpp
)

# Add test executable
add_executable(UnitTests ${TEST_SOURCES})

# FINAL FIX: Include directories for GTest and local headers
target_include_directories(UnitTests PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${googletest_SOURCE_DIR}/googletest/include
    ${googletest_SOURCE_DIR}/googlemock/include
)

target_link_libraries(UnitTests PRIVATE
    gtest_main
    GTest::gtest
)

# Register the test
add_test(NAME RunUnitTests COMMAND UnitTests)
