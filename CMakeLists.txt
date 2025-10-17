cmake_minimum_required(VERSION 3.10)
project(MyProject)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Define source files for the main application
set(SOURCES
    main.cpp
    math_operations.cpp
)

# Create the main executable
add_executable(MyApp ${SOURCES})

# Define source files for unit tests
set(TEST_SOURCES
    tests/unit_tests.cpp
    math_operations.cpp  # Include math_operations.cpp for linking
)

# Enable testing
enable_testing()

# Add test executable
add_executable(UnitTests ${TEST_SOURCES})

# Link test executable with necessary libraries (e.g., gtest)
find_package(GTest REQUIRED)
target_link_libraries(UnitTests GTest::gtest_main)

# Add test to CTest
add_test(NAME RunUnitTests COMMAND UnitTests)
