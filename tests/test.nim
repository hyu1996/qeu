# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import qeu
import unittest

template checkOrdering[T, E](number1: T, number2: E, expected: Ordering) =

    check compare(number1, number2) == expected

    case compare(number1, number2):
    of Ordering.LESS:
        check (less(number1, number2))
        check (lessEqual(number1, number2))
        check (not greater(number1, number2))
        check (not greaterEqual(number1, number2))
        check (not equal(number1, number2))
    of Ordering.EQUAL:
        check (not less(number1, number2))
        check (lessEqual(number1, number2))
        check (not greater(number1, number2))
        check (greaterEqual(number1, number2))
        check (equal(number1, number2))
    of Ordering.GREATER:
        check (not less(number1, number2))
        check (not lessEqual(number1, number2))
        check (greater(number1, number2))
        check (greaterEqual(number1, number2))
        check (not equal(number1, number2))

test "cmp(s, s)":
  checkOrdering(1, 2, Ordering.Less)
  checkOrdering(1, -2, Ordering.Greater)
  checkOrdering(-1, 2, Ordering.Less)
  checkOrdering(-1, -2, Ordering.Greater)

  checkOrdering(2, 1, Ordering.Greater)
  checkOrdering(2, -1, Ordering.Greater)
  checkOrdering(-2, 1, Ordering.Less)
  checkOrdering(-2, -1, Ordering.Less)

test "cmp(u, u)":
  checkOrdering(1u32, 2u32, Ordering.Less)
  checkOrdering(1u32, cast[uint32](-2), Ordering.Less)
  checkOrdering(cast[uint32](-1), 2u32, Ordering.Greater)
  checkOrdering(cast[uint32](-1), cast[uint32](-2), Ordering.Greater)

  checkOrdering(2u32, 1u32, Ordering.Greater)
  checkOrdering(2u32, -1, Ordering.Greater)
  checkOrdering(cast[uint32](-2), 1u32, Ordering.Greater)
  checkOrdering(cast[uint32](-2), cast[uint32](-1), Ordering.Less)

test "cmp(u, s)":
  checkOrdering(1u32, 2, Ordering.Less)
  checkOrdering(1u32, -2, Ordering.Greater)
  checkOrdering(cast[uint32](-1), 2, Ordering.Greater)
  checkOrdering(cast[uint32](-1), -2, Ordering.Greater)

  checkOrdering(2u32, 1, Ordering.Greater)
  checkOrdering(2u32, -1, Ordering.Greater)
  checkOrdering(cast[uint32](-2), 1, Ordering.Greater)
  checkOrdering(cast[uint32](-2), -1, Ordering.Greater)

test "cmp(s, u)":
  checkOrdering(2, 1u32, Ordering.Greater)
  checkOrdering(-2, 1u32, Ordering.Less)
  checkOrdering(2, cast[uint32](-1), Ordering.Less)
  checkOrdering(-2, cast[uint32](-1), Ordering.Less)

  checkOrdering(1, 2u32, Ordering.Less)
  checkOrdering(-1, 2u32, Ordering.Less)
  checkOrdering(1, cast[uint32](-2), Ordering.Less)
  checkOrdering(-1, cast[uint32](-2), Ordering.Less)

test "cmp(f, u) cmp(f, s) cmp(f, f)":
  checkOrdering(1.10f32, 1u32, Ordering.Greater)
  checkOrdering(-12, -12.0f32, Ordering.Equal)
  checkOrdering(-12, -12.0001f32, Ordering.Greater)
  checkOrdering(-12.0001, -12.0f32, Ordering.Less)

  checkOrdering(-12.0001, -12, Ordering.Less)
  checkOrdering(-12.0001, -13, Ordering.Greater)

  checkOrdering(-12.0001, Ordering.Less, Ordering.Less)
  checkOrdering(Ordering.Greater, -12.0001, Ordering.Greater)

test "cmp zeros":
  checkOrdering(-0.0,  +0.0, Ordering.Equal)
  checkOrdering(-0,  +0.0, Ordering.Equal)
  checkOrdering(+0.0, -0,  Ordering.Equal)
  checkOrdering(+0,  -0.0, Ordering.Equal)
  checkOrdering(-0.0, +0,  Ordering.Equal)

  checkOrdering(0u32, 0i32, Ordering.Equal)
  checkOrdering(0u32, -0i32, Ordering.Equal)
  checkOrdering(0u16, 0i32, Ordering.Equal)
  checkOrdering(0u16, -0i32, Ordering.Equal)

  checkOrdering(0i32, 0u32, Ordering.Equal)
  checkOrdering(-0i32, 0u32, Ordering.Equal)
  checkOrdering(0i32, 0u16, Ordering.Equal)
  checkOrdering(-0i32, 0u16, Ordering.Equal)

test "cmp(e, e) cmp(e, u32) cmp(e, f)":
  type
    GeneralEnum = enum
      LowEqualTwo = 2
      HighEqualThree = 3

  checkOrdering(GeneralEnum.LowEqualTwo, GeneralEnum.HighEqualThree, Ordering.Less)
  checkOrdering(GeneralEnum.HighEqualThree, GeneralEnum.LowEqualTwo, Ordering.Greater)

  checkOrdering(GeneralEnum.LowEqualTwo, 1, Ordering.Greater)
  checkOrdering(GeneralEnum.HighEqualThree, 3, Ordering.Equal)
  checkOrdering(GeneralEnum.LowEqualTwo, 2, Ordering.Equal)

  checkOrdering(-1, GeneralEnum.LowEqualTwo, Ordering.Less)
  checkOrdering(GeneralEnum.HighEqualThree, -1, Ordering.Greater)

  checkOrdering(GeneralEnum.LowEqualTwo, 2u32, Ordering.Equal)
  checkOrdering(GeneralEnum.LowEqualTwo, 0u32, Ordering.Greater)
  checkOrdering(GeneralEnum.LowEqualTwo, cast[uint32](-1), Ordering.Less)

  checkOrdering(2.5, GeneralEnum.LowEqualTwo, Ordering.Greater)
  checkOrdering(-2.5, GeneralEnum.LowEqualTwo, Ordering.Less)
  checkOrdering(GeneralEnum.LowEqualTwo, 2.5, Ordering.Less)
  checkOrdering(GeneralEnum.LowEqualTwo, -2.5, Ordering.Greater)