cmake_minimum_required(VERSION 3.10)

project(hello)
cmake_minimum_required(VERSION 3.14)
project(MyProject)

# Enable testing
enable_testing()

# Add FetchContent module
include(FetchContent)

# Fetch GoogleTest
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/heads/main.zip
)

# Make GoogleTest available
FetchContent_MakeAvailable(googletest)

# Add your source files
add_library(math_operations math_operations.cpp)

# Add test executable
add_executable(unit_tests unit_tests.cpp)

# Link test executable with GoogleTest and your library
target_link_libraries(unit_tests
  PRIVATE
    math_operations
    gtest_main
)

# Discover and register tests
include(GoogleTest)
gtest_discover_tests(unit_tests)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_executable(hello main.cpp)
