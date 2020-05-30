# qeu
Functionality for compare two values.  
Supports comparison between signed and unsigned integers.

# Examples
```nim
import qeu

assert less(1, 2)
assert less(-1, 2u32)
assert greater(2u32, -1)
assert greater(2.0, -1)

assert lessEqual(1, 1)
assert lessEqual(-1, 1u32)
assert greaterEqual(1, 1)
assert greaterEqual(1.1, 1u32)

assert equal(3, 3)

# three-way comparison
assert equal(Ordering.Less, compare(0, 1))
assert compare(cast[uint32](-1), -1) == Ordering.Greater
```
