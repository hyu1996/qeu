type
  Ordering* {.pure.} = enum
    Less
    Greater
    Equal

type
  SymbolKind = enum
    SignedSymbol
    UnsignedSymbol

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
  
template castToBiggestNumber[T: Number](number: T, kind: SymbolKind): auto =
  when kind == SymbolKind.UnsignedSymbol:
    uint64(number)
  else:
    int64(number)

template compareTwoNumber[T: Number](number1: T, number2: T, kordering: Ordering): untyped =
  when kordering == Ordering.Less:
    number1 < number2
  elif kordering == Ordering.Greater:
    number1 > number2
  else:
    number1 == number2

template compareTwoNumber[T: Number, E: Number](number1: T, number2: E, ksymbol: SymbolKind, kordering: Ordering): untyped =

  when isFloatNumber(typeof(T)) or isFloatNumber(typeof(E)):
    compareTwoNumber(
      float64(number1), 
      float64(number2), kordering)
  else:
    compareTwoNumber(
      castToBiggestNumber(number1, ksymbol), 
      castToBiggestNumber(number2, ksymbol), kordering)

template compareTwoNumber[T: Number, E: Number](number1: T, number2: E, greater: typed, less: typed, compare: typed): untyped =

  when isUnsignedNumber(typeof(T)) and isUnsignedNumber(typeof(E)):
    compare(number1, number2, SymbolKind.UnsignedSymbol)
  elif isUnsignedNumber(typeof(T)):
    if number2 < cast[E](0):
      result = greater
    else:
      compare(number1, number2, SymbolKind.UnsignedSymbol)
  elif isUnsignedNumber(typeof(E)):
    if number1 < cast[T](0):
      result = less
    else:
      compare(number1, number2, SymbolKind.UnsignedSymbol)
  else:
    compare(number1, number2, SymbolKind.SignedSymbol)

proc less*[T: Number, E: Number](
  number1: T, number2: E): bool {.inline, noSideEffect.} = 

  template checkLess[T: Number, E: Number](number1: T, number2: E, kind: SymbolKind): untyped =
    result = compareTwoNumber(number1, number2, kind, Ordering.Less)
    
  compareTwoNumber(number1, number2, false, true, checkLess)

template greater*[T: Number, E: Number](
  number1: T, number2: E): bool = 
    less(number2, number1)

proc equal*[T: Number, E: Number](
  number1: T, number2: E): bool {.inline, noSideEffect.} = 

  template checkEqual[T: Number, E: Number](number1: T, number2: E, kind: SymbolKind): untyped =
    result = compareTwoNumber(number1, number2, kind, Ordering.Equal)
    
  compareTwoNumber(number1, number2, false, false, checkEqual)

template lessEqual*[T: Number, E: Number](
  number1: T, number2: E): bool = not greater(number1, number2)

template greaterEqual*[T: Number, E: Number](
  number1: T, number2: E): bool = not less(number1, number2)

proc compare*[T: Number, E: Number](
  number1: T, number2: E): Ordering {.inline, noSideEffect.} =

  template checkOrdering[T: Number, E: Number](number1: T, number2: E, ksymbol: SymbolKind): untyped =
    if compareTwoNumber(number1, number2, ksymbol, Ordering.Equal):
      result = Ordering.Equal
    elif compareTwoNumber(number1, number2, ksymbol, Ordering.Less):
      result = Ordering.Less
    else:
      result = Ordering.Greater

  compareTwoNumber(number1, number2, Ordering.Greater, Ordering.Less, checkOrdering)