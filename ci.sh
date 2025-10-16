#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Step 1: Create the build directory
mkdir -p build

# Step 2: Enter the build directory
cd build

# Step 3: Configure the project
cmake ..

# Step 4: Build the project
cmake --build .

# Step 5: Run all CTest unit tests
ctest --output-on-failure
