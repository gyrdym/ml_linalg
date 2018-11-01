# linalg

Linear algebra with Dart.

Currently, the library presents just vectors and vector operations.

All vector operations are supported by SIMD ([single instruction, multiple data](https://en.wikipedia.org/wiki/SIMD)) 
computation architecture, so this library  presents two high performance SIMD vector classes: `Float32x4Vector` and 
`Float64x2Vector`. Operations in the first one are performed in four "threads" and in the second one - in two "threads". 
This kind of concurrency is reached by special 128-bit processor registers, which are used directly by program code.  

At the present moment most common vector operations are implemented:

- Vector addition:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1 + vector2;
  print(result.toList()); // [3.0, 5.0, 7.0, 9.0, 11.0]
````

- Vector subtraction:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([4.0, 5.0, 6.0, 7.0, 8.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 2.0, 3.0, 2.0]);
  final result = vector1 - vector2;
  print(result.toList()); // [2.0, 2.0, 4.0, 4.0, 6.0]
````

- Vector multiplication:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1 * vector2;
  print(result.toList()); // [2.0, 6.0, 12.0, 20.0, 30.0]
````

- Vector division (actually, it is not a legit math operation with vectors, but it's useful in some cases):
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([6.0, 12.0, 24.0, 48.0, 96.0]);
  final vector2 = Float32x4VectorFactory.from([3.0, 4.0, 6.0, 8.0, 12.0]);
  final result = vector1 / vector2;
  print(result.toList()); // [2.0, 3.0, 4.0, 6.0, 8.0]
````

- Euclidean norm:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm();
  print(result); // sqrt(2^2 + 3^2 + 4^2 + 5^2 + 6^2) = sqrt(90) ~~ 9.48
````

- Manhattan norm:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm(Norm.manhattan);
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0
````

- Mean value:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.mean();
  print(result); // (2 + 3 + 4 + 5 + 6) / 5 = 4.0
````

- Sum of all vector elements:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.sum();
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0 (equivalent to Manhattan norm)
````

- Dot product of two vectors
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.dot(vector2);
  print(result); // 1.0 * 2.0 + 2.0 * 3.0 + 3.0 * 4.0 + 4.0 * 5.0 + 5.0 * 6.0 = 70.0
````

- Addition of a vector and a scalar:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1.scalarAdd(scalar);
  print(result.toList()); // [6.0, 7.0, 8.0, 9.0, 10.0]
````

- Subtraction of a scalar value from a vector:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1.scalarSub(scalar);
  print(result.toList()); // [-4.0, -3.0, -2.0, -1.0, 0.0]
````

- Multiplication of a scalar value and a vector:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1.scalarMul(scalar);
  print(result.toList()); // [5.0, 10.0, 15.0, 20.0, 25.0]
````

- Division of a vector by a scalar value:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([25.0, 50.0, 75.0, 100.0, 125.0]);
  final scalar = 5.0;
  final result = vector1.scalarDiv(scalar);
  print(result.toList()); // [5.0, 10.0, 15.0, 20.0, 25.0]
````

- Euclidean distance between two vectors:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2);
  print(result); // ~~2.23
````

- Manhattan distance between two vectors:
````Dart
  import 'package:linalg/vector.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2, Norm.MANHATTAN);
  print(result); // 5.0
````
