[![Build Status](https://travis-ci.com/gyrdym/ml_linalg.svg?branch=master)](https://travis-ci.com/gyrdym/ml_linalg)
[![Coverage Status](https://coveralls.io/repos/github/gyrdym/ml_linalg/badge.svg)](https://coveralls.io/github/gyrdym/ml_linalg)
[![pub package](https://img.shields.io/pub/v/ml_linalg.svg)](https://pub.dartlang.org/packages/ml_linalg)
[![Gitter Chat](https://badges.gitter.im/gyrdym/gyrdym.svg)](https://gitter.im/gyrdym/)

**SIMD-based Linear algebra with Dart**

**Table of contents**

- [What is linear algebra](#linear-algebra)
- [What is SIMD](#what-is-simd)
- [Vectors](#vectors)
	- [A couple of words about the underlying architecture](#a-couple-of-words-about-the-underlying-architecture)
	- [Vector benchmarks](#vector-benchmarks)
	- [Vector operations](#vector-operations-examples)
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
- [Matrices](#matrices)
    - [Matrix operations](#matrix-operations-examples)
        - [Creation of diagonal matrix](#creation-of-diagonal-matrix)
        - [Creation of scalar matrix](#creation-of-scalar-matrix)
        - [Creation of identity matrix](#creation-of-identity-matrix)
        - [Creation of column matrix](#creation-of-column-matrix)
        - [Creation of row matrix](#creation-of-row-matrix)
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
        - [Getting max value of the matrix](#getting-max-value-of-the-matrix)
        - [Getting min value of the matrix](#getting-min-value-of-the-matrix)
        - [Matrix indexing and sampling](#matrix-indexing-and-sampling)
        - [Add new columns to a matrix](#add-new-columns-to-a-matrix)
- [Contacts](#contacts)

## Linear algebra

&nbsp;&nbsp;&nbsp;&nbsp;In a few words, linear algebra is a branch of mathematics that is working with vectors and 
matrices. 

&nbsp;&nbsp;&nbsp;&nbsp;Let's give a simple definition of Vector and Matrix. Vector is an ordered set of numbers, 
representing a point in the space where the vector is directed from the origin. Matrix is a collection of vectors, used to 
map vectors from one space to another.     

&nbsp;&nbsp;&nbsp;&nbsp;Vectors and matrices are extremely powerful tools, which can be used in real-life applications, such as machine 
learning algorithms. There are many implementations of these great mathematical entities in a plenty of programming 
languages, and as Dart offers developers good instrumentarium, e.g. highly optimized virtual machine and rich 
out-of-the-box library, Dart-based implementation of vectors and matrices has to be quite performant.

&nbsp;&nbsp;&nbsp;&nbsp;Among myriad of standard Dart tools there are SIMD data types. Namely support of SIMD computational architecture
served as a source of inspiration for creating this library.

## What is SIMD?

&nbsp;&nbsp;&nbsp;&nbsp;SIMD stands for `Single instruction, multiple data` - it is a computer architecture, that allows to perform uniform 
operations in parallel on huge amount of data. For instance, one has two arrays: 

- ![a = [10, 20, 30, 40]](https://latex.codecogs.com/gif.latex?a%20%3D%20%5B10%2C%2020%2C%2030%2C%2040%5D)
- ![b = [50, 60, 70, 80]](https://latex.codecogs.com/gif.latex?b%20%3D%20%5B50%2C%2060%2C%2070%2C%2080%5D)

and one needs to add these arrays element-wise. Using the regular architecture this operation could be done in this 
manner:

<p align="center">
    <img width="300" src="https://raw.github.com/gyrdym/ml_linalg/master/readme_resources/img/non_simd_array_sum.svg?sanitize=true">
</p>

&nbsp;&nbsp;&nbsp;&nbsp;We need to do 4 operations one by one in a row. Using SIMD architecture we may perform one mathematical 
operation on several operands in parallel, thus element-wise sum of two arrays will be done for just one step:

<p align="center">
    <img height="350" src="https://raw.github.com/gyrdym/ml_linalg/master/readme_resources/img/simd_array_sum.svg?sanitize=true"> 
</p>

## Vectors

### A couple of words about the underlying architecture
    
&nbsp;&nbsp;&nbsp;&nbsp;The library contains two high performant vector classes, based on [Float32x4](https://api.dartlang.org/stable/2.2.0/dart-typed_data/Float32x4-class.html) 
and [Float32x4](https://api.dartlang.org/stable/2.2.0/dart-typed_data/Float32x4-class.html) data types - 
[Float32x4Vector](https://github.com/gyrdym/linalg/blob/master/lib/src/vector/float32x4_vector.dart) and [Float64x2Vector](https://github.com/gyrdym/linalg/blob/master/lib/src/vector/float64x2_vector.dart)  

Most of element-wise operations in the first one are performed in four "threads" and in the second one - in two "threads".

&nbsp;&nbsp;&nbsp;&nbsp;Implementation of both classes is hidden from the library's users. You can create a 
`Float32x4Vector` or a `Float64x2Vector` instance via [Vector](https://github.com/gyrdym/ml_linalg/blob/master/lib/vector.dart) factory (see examples below).

&nbsp;&nbsp;&nbsp;&nbsp;The vectors are immutable - once created, the vector cannot be changed. All vector operations lead to 
creation of a new vector instance (of course, if an operation is supposed to return `Vector`).

&nbsp;&nbsp;&nbsp;&nbsp;Both classes implement `Iterable<double>` interface - so it's possible to use them as regular 
iterable collections.

&nbsp;&nbsp;&nbsp;&nbsp;It's possible to use vector instances as keys for `HashMap` and similar data structures 
and to look up a value by the vector-key, since the hash code is the same for equal vectors:

```dart
import 'package:ml_linalg/vector.dart';

final map = HashMap<Vector, bool>();

map[Vector.fromList([1, 2, 3, 4, 5])] = true;

print(map[Vector.fromList([1, 2, 3, 4, 5])]); // true
print(Vector.fromList([1, 2, 3, 4, 5]).hashCode == Vector.fromList([1, 2, 3, 4, 5]).hashCode); // true
```

### Vector benchmarks

To see the performance gain provided by the library's vector classes, one may visit `benchmark` directory: one may find 
there a baseline [benchamrk](https://github.com/gyrdym/ml_linalg/blob/master/benchmark/vector/baseline/regular_lists_addition.dart) - 
element-wise addition of two regular List instances and a [benchmark](https://github.com/gyrdym/ml_linalg/blob/master/benchmark/vector/float32/vector_operations/float32x4_vector_vector_addition.dart)
of a similar operation, but performed with two `Float32x4Vector` instances on the same amount of elements and compare 
the timings:

- Baseline benchmark (executed on Macbook Air mid 2017), 2 regular lists each with 10,000,000 elements:
<p align="center">
    <img height="350" src="https://raw.github.com/gyrdym/ml_linalg/matrix-speed-up/readme_resources/img/vector_baseline_benchmark_timing.png"> 
</p>

- Actual benchmark (executed on Macbook Air mid 2017), 2 vectors each with 10,000,000 elements:
<p align="center">
    <img height="350" src="https://raw.github.com/gyrdym/ml_linalg/matrix-speed-up/readme_resources/img/vector_actual_benchmark_timing.png"> 
</p>


### Vector operations examples

#### Vectors sum
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1 + vector2;
  print(result.toList()); // [3.0, 5.0, 7.0, 9.0, 11.0]
````

#### Vectors subtraction
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([4.0, 5.0, 6.0, 7.0, 8.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 2.0, 3.0, 2.0]);
  final result = vector1 - vector2;
  print(result.toList()); // [2.0, 2.0, 4.0, 4.0, 6.0]
````

#### Element wise vector by vector multiplication
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1 * vector2;
  print(result.toList()); // [2.0, 6.0, 12.0, 20.0, 30.0]
````

#### Element wise vector by vector division
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([6.0, 12.0, 24.0, 48.0, 96.0]);
  final vector2 = Vector.fromList([3.0, 4.0, 6.0, 8.0, 12.0]);
  final result = vector1 / vector2;
  print(result.toList()); // [2.0, 3.0, 4.0, 6.0, 8.0]
````

#### Euclidean norm
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm();
  print(result); // sqrt(2^2 + 3^2 + 4^2 + 5^2 + 6^2) = sqrt(90) ~~ 9.48
````

#### Manhattan norm
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm(Norm.manhattan);
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0
````

#### Mean value
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.mean();
  print(result); // (2 + 3 + 4 + 5 + 6) / 5 = 4.0
````

#### Sum of all vector elements
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.sum();
  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0 (equivalent to Manhattan norm)
````

#### Dot product of two vectors
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.dot(vector2);
  print(result); // 1.0 * 2.0 + 2.0 * 3.0 + 3.0 * 4.0 + 4.0 * 5.0 + 5.0 * 6.0 = 70.0
````

#### Sum of a vector and a scalar
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 + scalar;
  print(result.toList()); // [6.0, 7.0, 8.0, 9.0, 10.0]
````

#### Subtraction of a scalar from a vector
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 - scalar;
  print(result.toList()); // [-4.0, -3.0, -2.0, -1.0, 0.0]
````

#### Multiplication (scaling) of a vector by a scalar
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 * scalar;
  print(result.toList()); // [5.0, 10.0, 15.0, 20.0, 25.0]
````

#### Division (scaling) of a vector by a scalar value
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([25.0, 50.0, 75.0, 100.0, 125.0]);
  final scalar = 5.0;
  final result = vector1.scalarDiv(scalar);
  print(result.toList()); // [5.0, 10.0, 15.0, 20.0, 25.0]
````

#### Euclidean distance between two vectors
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2, distance: Distance.euclidean);
  print(result); // ~~2.23
````

#### Manhattan distance between two vectors
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2, distance: Distance.manhattan);
  print(result); // 5.0
````

#### Cosine distance between two vectors
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector1 = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.distanceTo(vector2, distance: Distance.cosine);
  print(result); // 0.00506
````

#### Vector normalization using Euclidean norm
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final result = vector.normalize(Norm.euclidean);
  print(result); // [0.134, 0.269, 0.404, 0.539, 0.674]
````

#### Vector normalization using Manhattan norm
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0]);
  final result = vector.normalize(Norm.manhattan);
  print(result); // [0.066, -0.133, 0.200, -0.266, 0.333]
````

#### Vector rescaling (min-max normalization)
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0, 0.0]);
  final result = vector.rescale();
  print(result); // [0.555, 0.222, 0.777, 0.0, 1.0, 0.444]
````

## Matrices

&nbsp;&nbsp;&nbsp;&nbsp;Along with SIMD vectors, the library presents SIMD-based Matrices. One can use the matrices via 
[Matrix factory](https://github.com/gyrdym/ml_linalg/blob/master/lib/matrix.dart). The matrices are immutable as well 
as vectors and also they implement `Iterable`, to be precise - `Iterable<Iterable<double>>` interface, thus it's possible 
to use them as a regular iterable collection.

### Matrix operations examples

#### Creation of diagonal matrix
````dart
import 'package:ml_linalg/matrix.dart';

final matrix = Matrix.diagonal([1, 2, 3, 4, 5]);

print(matrix);
````
  
The output:

```
Matrix 5 x 5:
(1.0, 0.0, 0.0, 0.0, 0.0)
(0.0, 2.0, 0.0, 0.0, 0.0)
(0.0, 0.0, 3.0, 0.0, 0.0)
(0.0, 0.0, 0.0, 4.0, 0.0)
(0.0, 0.0, 0.0, 0.0, 5.0)
```

#### Creation of scalar matrix
````dart
import 'package:ml_linalg/matrix.dart';

final matrix = Matrix.scalar(3, 5);

print(matrix);
````
  
The output:

```
Matrix 5 x 5:
(3.0, 0.0, 0.0, 0.0, 0.0)
(0.0, 3.0, 0.0, 0.0, 0.0)
(0.0, 0.0, 3.0, 0.0, 0.0)
(0.0, 0.0, 0.0, 3.0, 0.0)
(0.0, 0.0, 0.0, 0.0, 3.0)
```

#### Creation of identity matrix
````dart
import 'package:ml_linalg/matrix.dart';

final matrix = Matrix.identity(5);

print(matrix);
````
  
The output:

```
Matrix 5 x 5:
(1.0, 0.0, 0.0, 0.0, 0.0)
(0.0, 1.0, 0.0, 0.0, 0.0)
(0.0, 0.0, 1.0, 0.0, 0.0)
(0.0, 0.0, 0.0, 1.0, 0.0)
(0.0, 0.0, 0.0, 0.0, 1.0)
```

#### Creation of column matrix
````dart
final matrix = Matrix.column([1, 2, 3, 4, 5]);

print(matrix);
````

The output:

```
Matrix 5 x 1:
(1.0)
(2.0)
(3.0)
(4.0)
(5.0)
```

#### Creation of row matrix

````dart
final matrix = Matrix.row([1, 2, 3, 4, 5]);

print(matrix);
````

The output:

```
Matrix 1 x 5:
(1.0, 2.0, 3.0, 4.0, 5.0)
```

#### Sum of a matrix and another matrix
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

#### Sum of a matrix and a scalar
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

#### Multiplication of a matrix and a vector
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

#### Multiplication of a matrix and another matrix
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

#### Multiplication of a matrix and a scalar
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

#### Element wise matrices subtraction
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

#### Matrix transposition
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
 
#### Matrix row wise reduce
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
  ]); 
  final reduced = matrix.reduceRows((combine, row) => combine + row);
  print(reduced); // [6.0, 8.0, 10.0, 12.0]
````

#### Matrix column wise reduce
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

#### Matrix row wise map
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

#### Matrix column wise map
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

#### Getting max value of the matrix
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

#### Getting min value of the matrix
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

#### Matrix indexing and sampling
&nbsp;&nbsp;&nbsp;&nbsp;To access a certain row vector of the matrix one may use `[]` operator:

````Dart
import 'package:ml_linalg/linalg.dart';

final matrix = Matrix.fromList([
    [11.0, 12.0, 13.0, 14.0],
    [15.0, 16.0, 0.0, 18.0],
    [21.0, 22.0, -23.0, 24.0],
    [24.0, 32.0, 53.0, 74.0],
  ]);

final row = matrix[2];

print(row); // [21.0, 22.0, -23.0, 24.0]
```` 

&nbsp;&nbsp;&nbsp;&nbsp;The library's matrix interface offers `sample` method, that is supposed to return a new matrix, 
consisting of different segments of a source matrix. It's possible to build a new matrix from certain columns and 
vectors and they should not be necessarily subsequent.
 
&nbsp;&nbsp;&nbsp;&nbsp;For example, one needs to create a matrix from rows 1, 3, 5 and columns 1 and 3. To do so, 
it's needed to perform the following:

````Dart
import 'package:ml_linalg/linalg.dart';

final matrix = Matrix.fromList([
//| 1 |         | 3 |                
  [4.0,   8.0,   12.0,   16.0,  34.0], // 1 Range(0, 1)
  [20.0,  24.0,  28.0,   32.0,  23.0],
  [36.0,  .0,   -8.0,   -12.0,  12.0], // 3 Range(2, 3)
  [16.0,  1.0,  -18.0,   3.0,   11.0],
  [112.0, 10.0,  34.0,   2.0,   10.0], // 5 Range(4, 5)
]);
final result = matrix.sample(
  rowIndices: [0, 2, 4],
  columnIndices: [0, 2],
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
