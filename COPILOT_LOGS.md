# GitHub Copilot Logs for CSAD Lab 1

## Etap 1: "Hello World"

### File: main.cpp

**Zapyt:**
Generate a minimal C++ program that prints "Hello World" to the console.


**Zhenerovanyi kod:**
```cpp
#include <iostream>

int main() {
    std::cout << "Hello World" << std::endl;
    return 0;
}
```
## Etap 2: CMakeLists.txt
### File: CMakeLists.txt
**Zapyt**:

Generate a minimal CMakeLists.txt file for a C++ project named "hello" that uses main.cpp as its source file. Set the minimum required CMake version to 3.10 and the C++ standard to C++17.
**Zhenerovanyi kod**:
 ```cmake 
cmake_minimum_required(VERSION 3.10)

project(hello)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_executable(hello main.cpp)
```
## Etap 3: Unit Testing (Google Test)

### File: math_operations.h

**Zapyt:**
In math_operations.h, define a C++ function prototype 'int add(int a, int b);' and include necessary guards.
**Zhenerovanyi kod:**
```cpp
#ifndef MATH_OPERATIONS_H
#define MATH_OPERATIONS_H

// Function prototype for addition
int add(int a, int b);

#endif // MATH_OPERATIONS_H

### File: math_operations.cpp

**Zapyt:**
Implement the function 'int add(int a, int b)' from math_operations.h in math_operations.cpp to simply return the sum of a and b.
**Zhenerovanyi kod:**
```cpp
#include "math_operations.h"

int add(int a, int b) {
    return a + b;
}
### File: tests/unit_tests.cpp

**Zapyt:**
In unit_tests.cpp, generate a Google Test unit test case named 'BasicAddition' for the function 'int add(int a, int b)' from math_operations.h. Ensure it tests positive and negative numbers.
**Zhenerovanyi kod:**
```cpp
#include <gtest/gtest.h>
#include "math_operations.h"

TEST(BasicAddition, HandlesPositiveNumbers) {
    EXPECT_EQ(add(2, 3), 5);
    EXPECT_EQ(add(10, 20), 30);
}

TEST(BasicAddition, HandlesNegativeNumbers) {
    EXPECT_EQ(add(-2, -3), -5);
    EXPECT_EQ(add(-10, 5), -5);
    EXPECT_EQ(add(7, -4), 3);
}
### File: CMakeLists.txt (Final Update)

**Zapyt:**
Modify the existing CMakeLists.txt to fetch and link the Google Test framework using FetchContent.
**Zhenerovanyi kod:**
```cpp
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
