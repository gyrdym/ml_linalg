# dart_simd_vector
Algebraic vector with SIMD support and a potentially infinite length

At the present moment were implemented most common vector operations such as:

- Vector addition:

```Dart
import 'package:dart_simd_vector/vector.dart';

Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
Float32x4Vector vector2 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);

print((vector1 + vector2).asList());
```
