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
Etap 2: CMakeLists.txt
File: CMakeLists.txt
Zapyt:

Generate a minimal CMakeLists.txt file for a C++ project named "hello" that uses main.cpp as its source file. Set the minimum required CMake version to 3.10 and the C++ standard to C++17.
Zhenerovanyi kod:

CMake

cmake_minimum_required(VERSION 3.10)

project(hello)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_executable(hello main.cpp)
