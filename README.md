[![Build Status](https://travis-ci.com/gyrdym/ml_linalg.svg?branch=master)](https://travis-ci.com/gyrdym/ml_linalg)
[![Coverage Status](https://coveralls.io/repos/github/gyrdym/ml_linalg/badge.svg)](https://coveralls.io/github/gyrdym/ml_linalg)
[![pub package](https://img.shields.io/pub/v/ml_linalg.svg)](https://pub.dartlang.org/packages/ml_linalg)
[![Gitter Chat](https://badges.gitter.im/gyrdym/gyrdym.svg)](https://gitter.im/gyrdym/)

**SIMD-based Linear algebra with Dart**

**Table of contents**

+ [Vectors](#vectors)
	- [A couple of words about the underlying vector architecture](#a-couple-of-words-about-the-underlying-vector-architecture)
	+ [Vector operations examples](#vector-operations-examples)
	    - [Vectors sum](#vectors-sum)
	    - [Vectors subtraction](#vectors-subtraction)
	    - [Element wise vector by vector multiplication](#element-wise-vector-by-vector-multiplication)
	    - [Element wise vector by vector division](#element-wise-vector-by-vector-division)
	    - [Euclidean norm](#euclidean-norm)
	    - [Manhattan norm](#manhattan-norm)
	    - [Mean value](#mean-value)
	    - [Sum of all vector elements](#sum-of-all-vector-elements)
	    - [Dot product](#dot-product-of-two-vectors)
	    - [Sum of a vector and a scalar](#sum-of-a-vector-and-a-scalar)
	    - [Subtraction of a scalar from a vector](#subtraction-of-a-scalar-from-a-vector)
	    - [Multiplication (scaling) of a vector by a scalar](#multiplication-scaling-of-a-vector-by-a-scalar)
	    - [Division (scaling) of a vector by a scalar value](#division-scaling-of-a-vector-by-a-scalar-value)
	    - [Euclidean distance between two vectors](#euclidean-distance-between-two-vectors)
	    - [Manhattan distance between two vectors](#manhattan-distance-between-two-vectors)
	    - [Cosine distance between two vectors](#cosine-distance-between-two-vectors)
	    - [Vector normalization (using Euclidean norm)](#vector-normalization-using-euclidean-norm)
	    - [Vector normalization (using Manhattan norm)](#vector-normalization-using-manhattan-norm)
	    - [Vector rescaling (min-max normalization)](#vector-rescaling-min-max-normalization)
        - [Fast map](#fast-map)
+ [Matrices](#matrices)
	+ [Matrix operations examples](#matrix-operations-examples)
        - [Sum of a matrix and another matrix](#sum-of-a-matrix-and-another-matrix)
        - [Sum of a matrix and a scalar](#sum-of-a-matrix-and-a-scalar)
        - [Multiplication of a matrix and a vector](#multiplication-of-a-matrix-and-a-vector)
        - [Multiplication of a matrix and another matrix](#multiplication-of-a-matrix-and-another-matrix)
        - [Multiplication of a matrix and a scalar](#multiplication-of-a-matrix-and-a-scalar)
        - [Element wise matrices subtraction](#element-wise-matrices-subtraction)
        - [Matrix transposition](#matrix-transposition)
        - [Matrix row wise reduce](#matrix-row-wise-reduce)
        - [Matrix column wise reduce](#matrix-column-wise-reduce)
        - [Matrix row wise map](#matrix-row-wise-map)
        - [Matrix column wise map](#matrix-column-wise-map)
        - [Submatrix](#submatrix-taking-a-lower-dimension-matrix-of-the-current-matrix)
        - [Getting max value of the matrix](#getting-max-value-of-the-matrix)
        - [Getting min value of the matrix](#getting-min-value-of-the-matrix)
        - [Matrix fast map](#matrix-fast-map)
        - [Matrix indexing](#matrix-indexing)
        - [Add new columns to a matrix](#add-new-columns-to-a-matrix)
+ [Contacts](#contacts)

### SIMD-based linear algebra

Vectors and matrices are extremely powerful tools, which can be applied not just in abstract sense, but also in 
real-life applications, such as machine learning algorithms. There are many implementations of such great mathematical 
entities in a plenty of programming languages, and as Dart offers developers good instrumentarium, e.g. highly optimized 
virtual machine and rich out-of-the-box library, Dart-based implementation of vectors and matrices has to be performant
and robust.

Among myriad of standard Dart library tools there is SIMD data types. Namely support of SIMD computational architecture
served as a source of inspiration for creating this library.

### What is SIMD?

SIMD extends as `Single instruction, multiple data` - it is a computer architecture, that allows to perform uniform 
operations in parallel on huge amount of data. For instance, one has two vectors, ![\vec{a} = [10, 20, 30, 40]](https://latex.codecogs.com/gif.latex?%5Cvec%7Ba%7D%20%3D%20%5C%5B10%2C%2020%2C%2030%2C%2040%5C%5D)
and ![\vec{b} = [5, 6, 7, 8]](https://latex.codecogs.com/gif.latex?%5Cvec%7Bb%7D%20%3D%20%5C%5B5%2C%206%2C%207%2C%208%5C%5D)

### Vectors

#### A couple of words about the underlying vector architecture
    
All vector operations are supported by SIMD ([single instruction, multiple data](https://en.wikipedia.org/wiki/SIMD)) 
computation architecture. Actually, the main purpose of the library - connect such a powerful computation way with 
the pure math. So, the library contains a high performance SIMD vector class, based on 
[Float32x4](https://api.dartlang.org/stable/2.1.0/dart-typed_data/Float32x4-class.html) - 
[Float32Vector](https://github.com/gyrdym/linalg/blob/master/lib/src/vector/float32/float32_vector.dart). 
Most of operations in the vector class are performed in four "threads". This kind of parallelism is reached by special 
128-bit processor registers, which are used directly by program code. It is also possible to implement [Float64x2](https://api.dartlang.org/stable/2.1.0/dart-typed_data/Float64x2-class.html)-based
version of vector using existing codebase, but so far there is no need to do so.
    The class [Float32Vector](https://github.com/gyrdym/linalg/blob/master/lib/src/vector/float32/float32_vector.dart) 
is hidden from the library's users. You can create a [Float32Vector](https://github.com/gyrdym/linalg/blob/master/lib/src/vector/float32x4/float32x4_vector.dart) 
instance via [Vector](https://github.com/gyrdym/ml_linalg/blob/master/lib/vector.dart) factory (see examples below).

The vector is absolutely immutable - there is no way to change once created instance. All vector operations lead to 
creation of a new vector instance (of course, if the operation is supposed to return `Vector`).

#### Vector operations examples
At the present moment most common vector operations are implemented:

##### Vectors sum
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1 + vector2;
  print(result.toList()); // [3.0, 5.0, 7.0, 9.0, 11.0]
````

##### Vectors subtraction
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([4.0, 5.0, 6.0, 7.0, 8.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 2.0, 3.0, 2.0]);
  final result = vector1 - vector2;
  print(result.toList()); // [2.0, 2.0, 4.0, 4.0, 6.0]
````

##### Element wise vector by vector multiplication
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1 * vector2;
  print(result.toList()); // [2.0, 6.0, 12.0, 20.0, 30.0]
````

##### Element wise vector by vector division
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([6.0, 12.0, 24.0, 48.0, 96.0]);
  final vector2 = Vector.fromList([3.0, 4.0, 6.0, 8.0, 12.0]);
  final result = vector1 / vector2;
  print(result.toList()); // [2.0, 3.0, 4.0, 6.0, 8.0]
````

##### Euclidean norm
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm();
  print(result); // sqrt(2^2 + 3^2 + 4^2 + 5^2 + 6^2) = sqrt(90) ~~ 9.48
````

##### Manhattan norm
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm(Norm.manhattan);
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0
````

##### Mean value
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.mean();
  print(result); // (2 + 3 + 4 + 5 + 6) / 5 = 4.0
````

##### Sum of all vector elements
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.sum();
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0 (equivalent to Manhattan norm)
````

##### Dot product of two vectors
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.dot(vector2);
  print(result); // 1.0 * 2.0 + 2.0 * 3.0 + 3.0 * 4.0 + 4.0 * 5.0 + 5.0 * 6.0 = 70.0
````

##### Sum of a vector and a scalar
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 + scalar;
  print(result.toList()); // [6.0, 7.0, 8.0, 9.0, 10.0]
````

##### Subtraction of a scalar from a vector
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 - scalar;
  print(result.toList()); // [-4.0, -3.0, -2.0, -1.0, 0.0]
````

##### Multiplication (scaling) of a vector by a scalar
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 * scalar;
  print(result.toList()); // [5.0, 10.0, 15.0, 20.0, 25.0]
````

##### Division (scaling) of a vector by a scalar value
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([25.0, 50.0, 75.0, 100.0, 125.0]);
  final scalar = 5.0;
  final result = vector1.scalarDiv(scalar);
  print(result.toList()); // [5.0, 10.0, 15.0, 20.0, 25.0]
````

##### Euclidean distance between two vectors
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2, distance: Distance.euclidean);
  print(result); // ~~2.23
````

##### Manhattan distance between two vectors
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2, distance: Distance.manhattan);
  print(result); // 5.0
````

##### Cosine distance between two vectors
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2, distance: Distance.cosine);
  print(result); // 0.00506
````

##### Vector normalization using Euclidean norm
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final result = vector.normalize(Norm.euclidean);
  print(result); // [0.134, 0.269, 0.404, 0.539, 0.674]
````

##### Vector normalization using Manhattan norm
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0]);
  final result = vector.normalize(Norm.manhattan);
  print(result); // [0.066, -0.133, 0.200, -0.266, 0.333]
````

##### Vector rescaling (min-max normalization)
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0, 0.0]);
  final result = vector.rescale();
  print(result); // [0.555, 0.222, 0.777, 0.0, 1.0, 0.444]
````

##### Fast map

Performs mapping from one vector to another in efficient way (using simd computations)

````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final result = vector.fastMap<Float32x4>((Float32x4 element) => element.scale(2.0));
  print(result); // [2.0, 4.0, 6.0, 8.0, 10.0]
````

### Matrices

Also, a class for matrix is available. It is based on Float32x4 and Float32Vector types. `Matrix` is immutable as well 
as `Vector`.

#### Matrix operations examples

##### Sum of a matrix and another matrix
````Dart
import 'package:ml_linalg/linalg.dart';

final matrix1 = Matrix.fromList([
  [1.0, 2.0, 3.0, 4.0],
  [5.0, 6.0, 7.0, 8.0],
  [9.0, .0, -2.0, -3.0],
]);
final matrix2 = Matrix.fromList([
  [10.0, 20.0, 30.0, 40.0],
  [-5.0, 16.0, 2.0, 18.0],
  [2.0, -1.0, -2.0, -7.0],
]);
print(matrix1 + matrix2);
// [
//  [11.0, 22.0, 33.0, 44.0],
//  [0.0, 22.0, 9.0, 26.0],
//  [11.0, -1.0, -4.0, -10.0],
// ];
````

##### Sum of a matrix and a scalar
````Dart
import 'package:ml_linalg/linalg.dart';

final matrix = Matrix.fromList([
  [1.0, 2.0, 3.0, 4.0],
  [5.0, 6.0, 7.0, 8.0],
  [9.0, .0, -2.0, -3.0],
]);
print(matrix + 7);
//  [
//    [8.0, 9.0, 10.0, 11.0],
//    [12.0, 13.0, 14.0, 15.0],
//    [16.0, 7.0, 5.0, 4.0],
//  ];
````

##### Multiplication of a matrix and a vector
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
    [9.0, .0, -2.0, -3.0],
  ]);
  final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0]);
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
  import 'package:ml_linalg/linalg.dart';

  final matrix1 = Matrix.fromList([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
    [9.0, .0, -2.0, -3.0],
  ]);
  final matrix2 = Matrix.fromList([
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

##### Multiplication of a matrix and a scalar
````Dart
import 'package:ml_linalg/linalg.dart';

final matrix = Matrix.fromList([
  [1.0, 2.0, 3.0, 4.0],
  [5.0, 6.0, 7.0, 8.0],
  [9.0, .0, -2.0, -3.0],
]);
print(matrix * 3);
// [
//   [3.0, 6.0, 9.0, 12.0],
//   [15.0, 18.0, 21.0, 24.0],
//   [27.0, .0, -6.0, -9.0],
// ];
````

##### Element wise matrices subtraction
````Dart
import 'package:ml_linalg/linalg.dart';

final matrix1 = Matrix.fromList([
  [1.0, 2.0, 3.0, 4.0],
  [5.0, 6.0, 7.0, 8.0],
  [9.0, .0, -2.0, -3.0],
]);
final matrix2 = Matrix.fromList([
  [10.0, 20.0, 30.0, 40.0],
  [-5.0, 16.0, 2.0, 18.0],
  [2.0, -1.0, -2.0, -7.0],
]);
print(matrix1 - matrix2);
// [
//   [-9.0, -18.0, -27.0, -36.0],
//   [10.0, -10.0, 5.0, -10.0],
//   [7.0, 1.0, .0, 4.0],
// ];
````

##### Matrix transposition
````Dart
  import 'package:ml_linalg/linalg.dart';
  
  final matrix = Matrix.fromList([
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
 
##### Matrix row wise reduce
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
  ]); 
  final reduced = matrix.reduceRows((combine, row) => combine + row);
  print(reduced); // [6.0, 8.0, 10.0, 12.0]
````

##### Matrix column wise reduce
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [11.0, 12.0, 13.0, 14.0],
    [15.0, 16.0, 17.0, 18.0],
    [21.0, 22.0, 23.0, 24.0],
  ]);
  final result = matrix.reduceColumns((combine, vector) => combine + vector);
  print(result); // [50, 66, 90]
````

##### Matrix row wise map
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
  ]); 
  final modifier = Vector.filled(4, 2.0);
  final newMatrix = matrix.rowsMap((row) => row + modifier);
  print(newMatrix); 
  // [
  //  [3.0, 4.0, 5.0, 6.0],
  //  [7.0, 8.0, 9.0, 10.0],
  // ]
````

##### Matrix column wise map
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
  ]); 
  final modifier = Vector.filled(2, 2.0);
  final newMatrix = matrix.columnsMap((column) => column + modifier);
  print(newMatrix); 
  // [
  //  [3.0, 4.0, 5.0, 6.0],
  //  [7.0, 8.0, 9.0, 10.0],
  // ]
````

##### Submatrix (taking a lower dimension matrix of the current matrix)
````Dart
  import 'package:ml_linalg/linalg.dart';
  import 'package:xrange/zrange.dart';

  final matrix = Matrix.fromList([
    [11.0, 12.0, 13.0, 14.0],
    [15.0, 16.0, 17.0, 18.0],
    [21.0, 22.0, 23.0, 24.0],
    [24.0, 32.0, 53.0, 74.0],
  ]);
  final submatrix = matrix.submatrix(rows: ZRange.closedOpen(0, 2));
  print(submatrix);
  // [
  //  [11.0, 12.0, 13.0, 14.0],
  //  [15.0, 16.0, 17.0, 18.0],
  //];
````

##### Getting max value of the matrix
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [11.0, 12.0, 13.0, 14.0],
    [15.0, 16.0, 17.0, 18.0],
    [21.0, 22.0, 23.0, 24.0],
    [24.0, 32.0, 53.0, 74.0],
  ]);
  final maxValue = matrix.max();
  print(maxValue);
  // 74.0
````

##### Getting min value of the matrix
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [11.0, 12.0, 13.0, 14.0],
    [15.0, 16.0, 0.0, 18.0],
    [21.0, 22.0, -23.0, 24.0],
    [24.0, 32.0, 53.0, 74.0],
  ]);
  final minValue = matrix.min();
  print(minValue);
  // -23.0
````

#### Matrix fast map

Performs mapping from one matrix to another in efficient way (using simd computations)

````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [11.0, 12.0, 13.0, 14.0],
    [15.0, 16.0, 0.0, 18.0],
    [21.0, 22.0, -23.0, 24.0],
    [24.0, 32.0, 53.0, 74.0],
  ], dtype: DType.float32);
  final newMatrix = matrix.fastMap<Float32x4>((Float32x4 val) => val.scale(3.0));
  print(minValue);
  // [
  //   [33.0, 36.0, 39.0, 42.0],
  //   [45.0, 48.0, 0.0, 54.0],
  //   [63.0, 66.0, -69.0, 72.0],
  //   [72.0, 96.0, 159.0, 222.0],
  // ]
````

#### Matrix indexing
The library's matrix interface offers `pick` method, that supposes to return a new matrix, consisting of different 
segments of a source matrix (like in Pandas dataframe in Python, e.g. `loc` method). It's possible to build a new 
matrix from certain columns and vectors and they should not be necessarily subsequent: for example, it is needed to
create a matrix from rows 1, 3, 5 and columns 1 and 3. To do so, it's needed to access the matrix this way:
````Dart
import 'package:ml_linalg/linalg.dart';
import 'package:xrange/zrange.dart';

final matrix = Matrix.fromList([
//| 1 |         | 3 |                
  [4.0,   8.0,   12.0,   16.0,  34.0], // 1 Range(0, 1)
  [20.0,  24.0,  28.0,   32.0,  23.0],
  [36.0,  .0,   -8.0,   -12.0,  12.0], // 3 Range(2, 3)
  [16.0,  1.0,  -18.0,   3.0,   11.0],
  [112.0, 10.0,  34.0,   2.0,   10.0], // 5 Range(4, 5)
]);
final result = matrix.pick(
  rowRanges: [ZRange.closedOpen(0, 1), ZRange.closedOpen(2, 3), ZRange.closedOpen(4, 5)],
  columnRanges: [ZRange.closedOpen(0, 1), ZRange.closedOpen(2, 3)],
);
print(result);
/*
  [4.0,   12.0],
  [36.0,  -8.0],
  [112.0, 34.0]
*/
````

#### Add new columns to a matrix
````dart
import 'package:ml_linalg/linalg.dart';

final matrix = Matrix.fromList([
  [11.0, 12.0, 13.0, 14.0],
  [15.0, 16.0, 0.0, 18.0],
  [21.0, 22.0, -23.0, 24.0],
  [24.0, 32.0, 53.0, 74.0],
], dtype: DType.float32);

final updatedMatrix = matrix.insertColumns(0, [
  Vector.fromList([1.0, 2.0, 3.0, 4.0]),
  Vector.fromList([-1.0, -2.0, -3.0, -4.0]),
]);

print(updatedMatrix);
// [
//  [1.0, -1.0, 11.0, 12.0, 13.0, 14.0],
//  [2.0, -2.0, 15.0, 16.0, 0.0, 18.0],
//  [3.0, -3.0, 21.0, 22.0, -23.0, 24.0],
//  [4.0, -4.0, 24.0, 32.0, 53.0, 74.0],
// ]

print(updatedMatrix == matrix); // false
````

### Contacts
If you have questions, feel free to write me on 
 - [Facebook](https://www.facebook.com/ilya.gyrdymov)
 - [Linkedin](https://www.linkedin.com/in/gyrdym/)
