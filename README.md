**Linear algebra with Dart**

**Table of contents**

{{TOC}}

### Vectors

#### A couple of words about the underlying vector architecture
All vector operations are supported by SIMD ([single instruction, multiple data](https://en.wikipedia.org/wiki/SIMD)) 
computation architecture, so this library presents a high performance SIMD vector class, based on [Float32x4](https://api.dartlang.org/stable/2.1.0/dart-typed_data/Float32x4-class.html) - [Float32x4Vector](https://github.com/gyrdym/linalg/blob/master/lib/src/vector/float32x4_vector.dart). 
However, you cannot use it directly in your project. To create an instance of the vector, just import [Float32xrVectorFactory](https://github.com/gyrdym/linalg/blob/master/lib/src/vector/float32x4_vector_factory.dart)
and instantiate a vector via the factory. Most of operations in the vector are performed in four "threads". This kind 
of concurrency is reached by special 128-bit processor registers, which are used directly by program code.  For better understanding of the topic please read the [article](https://www.dartlang.org/articles/dart-vm/simd).

#### Vector operations examples
At the present moment most common vector operations are implemented:

 ##### Vector addition
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1 + vector2;
  print(result.toList()); // [3.0, 5.0, 7.0, 9.0, 11.0]
````

 ##### Vector subtraction
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([4.0, 5.0, 6.0, 7.0, 8.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 2.0, 3.0, 2.0]);
  final result = vector1 - vector2;
  print(result.toList()); // [2.0, 2.0, 4.0, 4.0, 6.0]
````

 ##### Element wise vector by vector multiplication
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1 * vector2;
  print(result.toList()); // [2.0, 6.0, 12.0, 20.0, 30.0]
````

 ##### Element wise vector by vector division
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([6.0, 12.0, 24.0, 48.0, 96.0]);
  final vector2 = Float32x4VectorFactory.from([3.0, 4.0, 6.0, 8.0, 12.0]);
  final result = vector1 / vector2;
  print(result.toList()); // [2.0, 3.0, 4.0, 6.0, 8.0]
````

 ##### Euclidean norm
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm();
  print(result); // sqrt(2^2 + 3^2 + 4^2 + 5^2 + 6^2) = sqrt(90) ~~ 9.48
````

 ##### Manhattan norm
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm(Norm.manhattan);
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0
````

 ##### Mean value
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.mean();
  print(result); // (2 + 3 + 4 + 5 + 6) / 5 = 4.0
````

 ##### Sum of all vector elements
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.sum();
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0 (equivalent to Manhattan norm)
````

 ##### Dot product of two vectors
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.dot(vector2);
  print(result); // 1.0 * 2.0 + 2.0 * 3.0 + 3.0 * 4.0 + 4.0 * 5.0 + 5.0 * 6.0 = 70.0
````

 ##### Addition of a vector and a scalar
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 + scalar;
  print(result.toList()); // [6.0, 7.0, 8.0, 9.0, 10.0]
````

 ##### Subtraction of a scalar value from a vector
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 - scalar;
  print(result.toList()); // [-4.0, -3.0, -2.0, -1.0, 0.0]
````

 ##### Multiplication (scaling) of a vector by a scalar
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 * scalar;
  print(result.toList()); // [5.0, 10.0, 15.0, 20.0, 25.0]
````

 ##### Division (scaling) of a vector by a scalar value
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([25.0, 50.0, 75.0, 100.0, 125.0]);
  final scalar = 5.0;
  final result = vector1.scalarDiv(scalar);
  print(result.toList()); // [5.0, 10.0, 15.0, 20.0, 25.0]
````

 ##### Euclidean distance between two vectors
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2);
  print(result); // ~~2.23
````

 ##### Manhattan distance between two vectors
````Dart
  import 'package:linalg/linalg.dart';

  final vector1 = Float32x4VectorFactory.from([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Float32x4VectorFactory.from([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2, Norm.manhattan);
  print(result); // 5.0
````

### Matrices

Also, a class for matrix is available. It is based on Float32x4 and Float32x4Vector types.

#### Matrix operations examples

 ##### Multiplication of a matrix and a vector
````Dart
  import 'package:linalg/linalg.dart';

  final matrix = Float32x4Matrix.from([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
    [9.0, .0, -2.0, -3.0],
  ]);
  final vector = Float32x4Vector.from([2.0, 3.0, 4.0, 5.0]);
  final result = matrix * vector;
  print(result); 
  // a vector-column [
  //  [40],
  //  [96],
  //  [-5],
  //]
````

##### Multiplication of a matrix and another matrix
````Dart
  import 'package:linalg/linalg.dart';

  final matrix1 = Float32x4Matrix.from([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
    [9.0, .0, -2.0, -3.0],
  ]);
  final matrix2 = Float32x4Matrix.from([
    [1.0, 2.0],
    [5.0, 6.0],
    [9.0, .0],
    [-9.0, 1.0],
  ]);
  final result = matrix1 * matrix2;
  print(result);
  //[
  // [2.0, 18.0],
  // [26.0, 54.0],
  // [18.0, 15.0],
  //]
````

##### Matrix transposition
````Dart
  import 'package:linalg/linalg.dart';
  
  final matrix = Float32x4Matrix.from([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
    [9.0, .0, -2.0, -3.0],
  ]);
  final result = matrix.transpose();
  print(result);
  //[
  // [1.0, 5.0, 9.0],
  // [2.0, 6.0, .0],
  // [3.0, 7.0, -2.0],
  // [4.0, 8.0, -3.0],
  //]
````
 
##### Matrix row-wise reduce
````Dart
  import 'package:linalg/linalg.dart';

  final matrix = Float32x4MatrixFactory.from([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
  ]); 
  final reduced = matrix.reduceRows((combine, row) => combine + row);
  print(reduced); // [6.0, 8.0, 10.0, 12.0]
````

##### Matrix column-wise reduce
````Dart
  import 'package:linalg/linalg.dart';

  final matrix = Float32x4Matrix.from([
    [11.0, 12.0, 13.0, 14.0],
    [15.0, 16.0, 17.0, 18.0],
    [21.0, 22.0, 23.0, 24.0],
  ]);
  final result = matrix.reduceColumns((combine, vector) => combine + vector);
  print(result); // [50, 66, 90]
````

##### Submatrix (taking a lower dimension matrix of the current matrix)
````Dart
  import 'package:linalg/linalg.dart';

  final matrix = Float32x4Matrix.from([
    [11.0, 12.0, 13.0, 14.0],
    [15.0, 16.0, 17.0, 18.0],
    [21.0, 22.0, 23.0, 24.0],
    [24.0, 32.0, 53.0, 74.0],
  ]);
  final submatrix = matrix.submatrix(rows: Range(0, 2));
  print(submatrix);
  // [
  //  [11.0, 12.0, 13.0, 14.0],
  //  [15.0, 16.0, 17.0, 18.0],
  //];
````
