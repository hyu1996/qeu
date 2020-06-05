# qeu
Functionality for compare two values.<br>
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

# Note
The Javascript backend has not yet fully supported types such as `"uint64" "int64" "float64"`, so that comparing two larger values will produce erroneous results.
```javascript
console.log(9999999999999999) // actually shows 10000000000000000
```
