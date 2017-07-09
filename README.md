# dart_simd_vector
Algebraic vector with SIMD support and a potentially infinite length

At the present moment are implemented most common vector operations, such as:

- Vector addition:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  Float32x4Vector vector2 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  Float32x4Vector result = vector1 + vector2;
  print(result.asList()); // [3.0, 5.0, 7.0, 9.0, 11.0]
````

- Vector subtraction:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([4.0, 5.0, 6.0, 7.0, 8.0]);
  Float32x4Vector vector2 = new Float32x4Vector.from([2.0, 3.0, 2.0, 3.0, 2.0]);
  Float32x4Vector result = vector1 - vector2;
  print(result.asList()); // [2.0, 2.0, 4.0, 4.0, 6.0]
````

- Vector multiplication:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  Float32x4Vector vector2 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  Float32x4Vector result = vector1 * vector2;
  print(result.asList()); // [2.0, 6.0, 12.0, 20.0, 30.0]
````

- Vector division:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([6.0, 12.0, 24.0, 48.0, 96.0]);
  Float32x4Vector vector2 = new Float32x4Vector.from([3.0, 4.0, 6.0, 8.0, 12.0]);
  Float32x4Vector result = vector1 / vector2;
  print(result.asList()); // [2.0, 3.0, 4.0, 6.0, 8.0]
````

- Euclidean norm:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  double result = vector1.norm();
  print(result); // sqrt(2^2 + 3^2 + 4^2 + 5^2 + 6^2) = sqrt(90) ~~ 9.48
````

- Manhattan norm:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  double result = vector1.norm(Norm.MANHATTAN);
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0
````

- Mean value:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  double result = vector1.mean();
  print(result); // (2 + 3 + 4 + 5 + 6) / 5 = 4.0
````

- Sum of all vector elements:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  double result = vector1.sum();
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0 (equivalent to Manhattan norm)
````

- Dot product of two vectors
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  Float32x4Vector vector2 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  double result = vector1.dot(vector2);
  print(result); // 1.0 * 2.0 + 2.0 * 3.0 + 3.0 * 4.0 + 4.0 * 5.0 + 5.0 * 6.0 = 70.0
````

- Addition of a vector and a scalar:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  double scalar = 5.0;
  Float32x4Vector result = vector1.scalarAdd(scalar);
  print(result.asList()); // [6.0, 7.0, 8.0, 9.0, 10.0]
````

- Subtraction scalar value from a vector:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  double scalar = 5.0;
  Float32x4Vector result = vector1.scalarSub(scalar);
  print(result.asList()); // [-4.0, -3.0, -2.0, -1.0, 0.0]
````

- Multiplication of a scalar value and a vector:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  double scalar = 5.0;
  Float32x4Vector result = vector1.scalarMul(scalar);
  print(result.asList()); // [5.0, 10.0, 15.0, 20.0, 25.0]
````

- Division of a vector by a scalar value:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([25.0, 50.0, 75.0, 100.0, 125.0]);
  double scalar = 5.0;
  Float32x4Vector result = vector1.scalarDiv(scalar);
  print(result.asList()); // [5.0, 10.0, 15.0, 20.0, 25.0]
````

- Finding a Euclidean distance between two vectors:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  Float32x4Vector vector2 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  double result = vector1.distanceTo(vector2);
  print(result); // ~~2.23
````

- Finding a Manhattan distance between two vectors:
````Dart
  import 'package:dart_simd_vector/vector.dart';

  Float32x4Vector vector1 = new Float32x4Vector.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  Float32x4Vector vector2 = new Float32x4Vector.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  double result = vector1.distanceTo(vector2, Norm.MANHATTAN);
  print(result); // 5.0
````
