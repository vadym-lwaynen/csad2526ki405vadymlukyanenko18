cmake_minimum_required(VERSION 3.10)
project(MyProject)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Define source files for main application
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

# Define source files for unit tests
set(TEST_SOURCES
    tests/unit_tests.cpp
    math_operations.cpp
)

# Add test executable
add_executable(UnitTests ${TEST_SOURCES})

# Include GoogleTest headers explicitly
target_include_directories(UnitTests PRIVATE
    ${googletest_SOURCE_DIR}/googletest/include
    ${googletest_SOURCE_DIR}/googlemock/include
)

# Link with GoogleTest
target_link_libraries(UnitTests
    gtest
    gtest_main
)

# Register the test
add_test(NAME RunUnitTests COMMAND UnitTests)
