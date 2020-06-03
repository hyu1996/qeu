type
  Ordering* {.pure.} = enum
    Less
    Greater
    Equal

type
  Number = SomeOrdinal | SomeInteger | SomeFloat

template isFloatNumber(S: typedesc): bool =
  S is float or
  S is float32 or
  S is float64

template isUnsignedNumber(N: typedesc): bool =
  N is uint8 or
  N is uint16 or
  N is uint32 or
  N is uint64 or
  N is uint

template compareTwoNumber[T: Number](number1: T, number2: T, ordering: Ordering): untyped =
  when ordering == Ordering.Less:
    number1 < number2
  elif ordering == Ordering.Greater:
    number1 > number2
  else:
    number1 == number2

template decideHowToCompare[T: Number, E: Number](number1: T, number2: E, greater: typed, less: typed, comparator: typed): untyped =

  when isFloatNumber(typeof(T)) or isFloatNumber(typeof(E)):
    comparator(float64(number1), float64(number2))
  elif isUnsignedNumber(typeof(T)) and isUnsignedNumber(typeof(E)):
    comparator(uint64(number1), uint64(number2))
  elif isUnsignedNumber(typeof(T)):
    if number2 < cast[E](0):
      result = greater
    else:
      comparator(uint64(number1), uint64(number2))
  elif isUnsignedNumber(typeof(E)):
    if number1 < cast[T](0):
      result = less
    else:
      comparator(uint64(number1), uint64(number2))
  else:
    comparator(int64(number1), int64(number2))

proc less*[T: Number, E: Number](
  number1: T, number2: E): bool {.inline, noSideEffect.} =

  template checkLess[T: Number, E: Number](number1: T, number2: E): untyped =
    result = compareTwoNumber(number1, number2, Ordering.Less)

  decideHowToCompare(number1, number2, false, true, checkLess)

template greater*[T: Number, E: Number](
  number1: T, number2: E): bool =
    less(number2, number1)

proc equal*[T: Number, E: Number](
  number1: T, number2: E): bool {.inline, noSideEffect.} =

  template checkEqual[T: Number, E: Number](number1: T, number2: E): untyped =
    result = compareTwoNumber(number1, number2, Ordering.Equal)

  decideHowToCompare(number1, number2, false, false, checkEqual)

template lessEqual*[T: Number, E: Number](
  number1: T, number2: E): bool = not greater(number1, number2)

template greaterEqual*[T: Number, E: Number](
  number1: T, number2: E): bool = not less(number1, number2)

proc compare*[T: Number, E: Number](
  number1: T, number2: E): Ordering {.inline, noSideEffect.} =

  template checkOrdering[T: Number, E: Number](number1: T, number2: E): untyped =
    if compareTwoNumber(number1, number2, Ordering.Equal):
      result = Ordering.Equal
    elif compareTwoNumber(number1, number2, Ordering.Less):
      result = Ordering.Less
    else:
      result = Ordering.Greater

  decideHowToCompare(number1, number2, Ordering.Greater, Ordering.Less, checkOrdering)