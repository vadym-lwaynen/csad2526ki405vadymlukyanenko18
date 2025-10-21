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
