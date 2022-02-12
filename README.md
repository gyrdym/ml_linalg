[![Build Status](https://github.com/gyrdym/ml_linalg/workflows/CI%20pipeline/badge.svg)](https://github.com/gyrdym/ml_linalg/actions?query=branch%3Amaster+)
[![Coverage Status](https://coveralls.io/repos/github/gyrdym/ml_linalg/badge.svg)](https://coveralls.io/github/gyrdym/ml_linalg)
[![pub package](https://img.shields.io/pub/v/ml_linalg.svg)](https://pub.dartlang.org/packages/ml_linalg)
[![Gitter Chat](https://badges.gitter.im/gyrdym/gyrdym.svg)](https://gitter.im/gyrdym/)

**SIMD-based linear algebra and statistics for data science with Dart**

**Table of contents**

- [What is linear algebra](#linear-algebra)
- [What is SIMD](#what-is-simd)
- [Vectors](#vectors)
	- [A couple of words about the underlying architecture](#a-couple-of-words-about-the-underlying-architecture)
	- [Vector benchmarks](#vector-benchmarks)
	- [Vector operations](#vector-operations-examples)
        - [Vectors sum](#vectors-sum)
        - [Vectors subtraction](#vectors-subtraction)
        - [Element-wise vector by vector multiplication](#element-wise-vector-by-vector-multiplication)
        - [Element-wise vector by vector division](#element-wise-vector-by-vector-division)
        - [Euclidean norm](#euclidean-norm)
        - [Manhattan norm](#manhattan-norm)
        - [Mean value](#mean-value)
        - [Sum of all vector elements](#sum-of-all-vector-elements)
        - [Product of all vector elements](#product-of-all-vector-elements)
        - [Element-wise power](#element-wise-power)
        - [Element-wise exp](#element-wise-exp)
        - [Dot product](#dot-product-of-two-vectors)
        - [Sum of a vector and a scalar](#sum-of-a-vector-and-a-scalar)
        - [Subtraction of a scalar from a vector](#subtraction-of-a-scalar-from-a-vector)
        - [Multiplication of a vector by a scalar](#multiplication-of-a-vector-by-a-scalar)
        - [Division of a vector by a scalar](#division-of-a-vector-by-a-scalar)
        - [Euclidean distance between two vectors](#euclidean-distance-between-two-vectors)
        - [Manhattan distance between two vectors](#manhattan-distance-between-two-vectors)
        - [Cosine distance between two vectors](#cosine-distance-between-two-vectors)
        - [Vector normalization (using Euclidean norm)](#vector-normalization-using-euclidean-norm)
        - [Vector normalization (using Manhattan norm)](#vector-normalization-using-manhattan-norm)
        - [Vector rescaling (min-max normalization)](#vector-rescaling-min-max-normalization)
        - [Vector serialization](#vector-serialization)
        - [Vector mapping](#vector-mapping)
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
        - [Hadamard product (element-wise matrices multiplication)](#hadamard-product-element-wise-matrices-multiplication)
        - [Element-wise matrices subtraction](#element-wise-matrices-subtraction)
        - [Matrix transposition](#matrix-transposition)
        - [Matrix LU decomposition](#matrix-lu-decomposition)
        - [Matrix Cholesky decomposition](#matrix-cholesky-decomposition)
        - [Matrix LU inversion](#matrix-lu-inversion)
        - [Matrix Cholesky inversion](#matrix-cholesky-inversion)
        - [Triangular Matrix inversion, forward substitution](#triangular-matrix-inversion-forward-substitution)
        - [Triangular Matrix inversion, backward substitution](#triangular-matrix-inversion-backward-substitution)
        - [Matrix row-wise reduce](#matrix-row-wise-reduce)
        - [Matrix column-wise reduce](#matrix-column-wise-reduce)
        - [Matrix row-wise mapping](#matrix-row-wise-mapping)
        - [Matrix column-wise mapping](#matrix-column-wise-mapping)
        - [Matrix element-wise mapping](#matrix-element-wise-mapping)
        - [Getting max value of the matrix](#getting-max-value-of-the-matrix)
        - [Getting min value of the matrix](#getting-min-value-of-the-matrix)
        - [Matrix element-wise power](#matrix-element-wise-power)
        - [Matrix element-wise exp](#matrix-element-wise-exp)
        - [Sum of all matrix elements](#sum-of-all-matrix-elements)
        - [Product of all matrix elements](#product-of-all-matrix-elements)
        - [Matrix indexing and sampling](#matrix-indexing-and-sampling)
        - [Add new columns to a matrix](#add-new-columns-to-a-matrix)
        - [Matrix serialization/deserialization](#matrix-serializationdeserialization)
- [Contacts](#contacts)

## Linear algebra

&nbsp;&nbsp;&nbsp;&nbsp;In a few words, linear algebra is a branch of mathematics that works with vectors and 
matrices. 

&nbsp;&nbsp;&nbsp;&nbsp;Vectors and matrices are extremely powerful tools which can be used in real-life applications, 
such as machine learning algorithms. There are many implementations of these great mathematical entities in a plenty of 
programming languages, and as Dart offers developers good instrumentarium, e.g. highly optimized virtual machine and rich 
out-of-the-box library, Dart-based implementation of vectors and matrices has to be quite performant.

&nbsp;&nbsp;&nbsp;&nbsp;Among myriad of standard Dart tools there are SIMD data types. Namely support of SIMD 
computational architecture served as inspiration for creating this library.

## What is SIMD?

&nbsp;&nbsp;&nbsp;&nbsp;SIMD stands for `Single instruction, multiple data` - it's a computer architecture that allows 
to perform uniform mathematical operations in parallel on a list-like data structure. For instance, one has two arrays: 

```Dart
final a = [10, 20, 30, 40];
final b = [50, 60, 70, 80];
```

and one needs to add these arrays element-wise. Using the regular architecture this operation could be done in the following 
manner:

```Dart
final c = List(4);

c[0] = a[0] + b[0]; // operation 1
c[1] = a[1] + b[1]; // operation 2
c[2] = a[2] + b[2]; // operation 3
c[3] = a[3] + b[3]; // operation 4
```

&nbsp;&nbsp;&nbsp;&nbsp;As you may have noticed, we need to do 4 operations one by one in a row using regular 
computational approach. But with help of SIMD architecture we may do one arithmetic operation on several operands in 
parallel, thus element-wise sum of two arrays can be done for just one step:

<p align="center">
    <img height="350" src="https://raw.github.com/gyrdym/ml_linalg/master/readme_resources/img/simd_array_sum.svg?sanitize=true"> 
</p>

## Vectors

### A couple of words about the underlying architecture
    
&nbsp;&nbsp;&nbsp;&nbsp;The library contains two high performant vector classes based on [Float32x4](https://api.dartlang.org/stable/2.5.0/dart-typed_data/Float32x4-class.html) 
and [Float64x2](https://api.dartlang.org/stable/2.5.0/dart-typed_data/Float64x2-class.html) data types - 
[Float32x4Vector](https://github.com/gyrdym/linalg/blob/master/lib/src/vector/float32x4_vector.dart) and [Float64x2Vector](https://github.com/gyrdym/linalg/blob/master/lib/src/vector/float64x2_vector.gen.dart) (the second one is generated from the source code of the first vector's implementation)

&nbsp;&nbsp;&nbsp;&nbsp;Most of element-wise operations in the first one are performed in four "threads" and in the second one - in two "threads".

&nbsp;&nbsp;&nbsp;&nbsp;Implementation of both classes is hidden from the library's users. You can create a 
`Float32x4Vector` or a `Float64x2Vector` instance via [Vector](https://github.com/gyrdym/ml_linalg/blob/master/lib/vector.dart) factory (see examples below).

&nbsp;&nbsp;&nbsp;&nbsp;The vectors are immutable: once created, the vector cannot be changed. All the vector operations 
lead to creation of a new vector instance (of course, if the operation is supposed to return a `Vector`).

&nbsp;&nbsp;&nbsp;&nbsp;Both classes implement `Iterable<double>` interface, so it's possible to use them as regular 
iterable collections.

&nbsp;&nbsp;&nbsp;&nbsp;It's possible to use vector instances as keys for `HashMap` and similar data structures 
and to look up a value by the vector-key, since the hash code for equal vectors is the same:

```dart
import 'package:ml_linalg/vector.dart';

final map = HashMap<Vector, bool>();

map[Vector.fromList([1, 2, 3, 4, 5])] = true;

print(map[Vector.fromList([1, 2, 3, 4, 5])]); // true
print(Vector.fromList([1, 2, 3, 4, 5]).hashCode == Vector.fromList([1, 2, 3, 4, 5]).hashCode); // true
``` 

### Vector benchmarks

&nbsp;&nbsp;&nbsp;&nbsp;To see the performance benefits provided by the library's vector classes, one may visit `benchmark` directory: one may find 
there a baseline [benchmark](https://github.com/gyrdym/ml_linalg/blob/master/benchmark/vector/baseline/regular_lists_addition.dart) - 
element-wise summation of two regular List instances and a [benchmark](https://github.com/gyrdym/ml_linalg/blob/master/benchmark/vector/float32/vector_operations/float32x4_vector_vector_addition.dart)
of a similar operation, but performed on two `Float32x4Vector` instances on the same amount of elements and compare 
the timings:

- Baseline benchmark (executed on Macbook Air mid 2017), 2 regular lists each with 10,000,000 elements:
<p align="center">
    <img height="250" src="https://raw.github.com/gyrdym/ml_linalg/master/readme_resources/img/vector_baseline_benchmark_timing.png"> 
</p>

- Actual benchmark (executed on Macbook Air mid 2017), 2 vectors each with 10,000,000 elements:
<p align="center">
    <img height="250" src="https://raw.github.com/gyrdym/ml_linalg/master/readme_resources/img/vector_actual_benchmark_timing.png"> 
</p>

It took 15 seconds to create a new regular list by summing the elements of two lists, and 0.7 second to sum two vectors - 
the difference is significant.

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

  final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm();

  print(result); // sqrt(2^2 + 3^2 + 4^2 + 5^2 + 6^2) = sqrt(90) ~~ 9.48
````

#### Manhattan norm
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.norm(Norm.manhattan);

  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0
````

#### Mean value
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector1.mean();

  print(result); // (2 + 3 + 4 + 5 + 6) / 5 = 4.0
````

#### Sum of all vector elements
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector.sum();

  print(result); // 2 + 3 + 4 + 5 + 6 = 20.0
````

#### Product of all vector elements
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector.prod();

  print(result); // 2 * 3 * 4 * 5 * 6 = 720
````

#### Element-wise power
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector.pow(3);
  
  print(result); // [2 ^ 3 = 8.0, 3 ^ 3 = 27.0, 4 ^ 3 = 64.0, 5 ^3 = 125.0, 6 ^ 3 = 216.0]
````

#### Element-wise exp
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result = vector.exp();
  
  print(result); // [e ^ 2, e ^ 3, e ^ 4, e ^ 5, e ^ 6]
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

  final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector1 + scalar;

  print(result.toList()); // [6.0, 7.0, 8.0, 9.0, 10.0]
````

#### Subtraction of a scalar from a vector
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector - scalar;

  print(result.toList()); // [-4.0, -3.0, -2.0, -1.0, 0.0]
````

#### Multiplication of a vector by a scalar
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  final scalar = 5.0;
  final result = vector * scalar;

  print(result.toList()); // [5.0, 10.0, 15.0, 20.0, 25.0]
````

#### Division of a vector by a scalar
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([25.0, 50.0, 75.0, 100.0, 125.0]);
  final scalar = 5.0;
  final result = vector.scalarDiv(scalar);

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

#### Vector serialization
````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0, 0.0]);
  final serialized = vector.toJson();
  print(serialized); // it yields a serializable representation of the vector

  final restoredVector = Vector.fromJson(serialized);
  print(restoredVector); // [1.0, -2.0, 3.0, -4.0, 5.0, 0.0]
````

#### Vector mapping

````Dart
  import 'package:ml_linalg/linalg.dart';

  final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0, 0.0]);
  final mapped = vector.mapToVector((el) => el * 2);
  
  print(mapped); // [2.0, -4.0, 6.0, -8.0, 10.0, 0.0]
  print(mapped is Vector); // true
  print(identical(vector, mapped)); // false
````

## Matrices

&nbsp;&nbsp;&nbsp;&nbsp;Along with SIMD vectors, the library contains SIMD-based Matrices. One can use the matrices via 
[Matrix factory](https://github.com/gyrdym/ml_linalg/blob/master/lib/matrix.dart). The matrices are immutable as well 
as vectors and also they implement `Iterable` interface (to be more precise, `Iterable<Iterable<double>>`), thus it's 
possible to use them as a regular iterable collection.

Matrices are serializable, and that means that one can easily convert a Matrix instance to a json-serializable map 
via `toJson` method, see the examples below.

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

#### Hadamard product (element-wise matrices multiplication)
````Dart
import 'package:ml_linalg/linalg.dart';

final matrix1 = Matrix.fromList([
  [1.0, 2.0,  3.0,  4.0],
  [5.0, 6.0,  7.0,  8.0],
  [9.0, 0.0, -2.0, -3.0],
]);
final matrix2 = Matrix.fromList([
  [7.0,   1.0,  9.0,  2.0],
  [2.0,   4.0,  3.0, -8.0],
  [0.0, -10.0, -2.0, -3.0],
]);
print(matrix1.multiply(matrix2));
// [
//   [ 7.0,  2.0, 27.0,   8.0],
//   [10.0, 24.0, 21.0, -64.0],
//   [ 0.0,  0.0,  4.0,   9.0],
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

#### Matrix LU decomposition
```dart
  final matrix = Matrix.fromList([
    [4, 12, -16],
    [12, 37, -43],
    [-16, -43, 98],
  ], dtype: dtype);
  final decomposed = matrix.decompose(Decomposition.LU);
  
  print(decomposed.first * decomposed.last); // yields approximately the same matrix as the original one
```

#### Matrix Cholesky decomposition
```dart
  final matrix = Matrix.fromList([
    [4, 12, -16],
    [12, 37, -43],
    [-16, -43, 98],
  ], dtype: dtype);
  final decomposed = matrix.decompose(Decomposition.cholesky);
  
  print(decomposed.first * decomposed.last); // yields approximately the same matrix as the original one
```

*Keep in mind that Cholesky decomposition is applicable only for positive definite and symmetric matrices*

#### Matrix LU inversion

```dart
  final matrix = Matrix.fromList([
    [-16, -43, 98],
    [33, 12.4, 37],
    [12, -88.3, 4],
  ], dtype: dtype);
  final inverted = matrix.inverse(Inverse.LU);

  print(inverted * matrix);
  // The output (there can be some round-off errors):
  // [1, 0, 0],
  // [0, 1, 0],
  // [0, 0, 1],
```

#### Matrix Cholesky inversion

```dart
  final matrix = Matrix.fromList([
    [4, 12, -16],
    [12, 37, -43],
    [-16, -43, 98],
  ], dtype: dtype);
  final inverted = matrix.inverse(Inverse.cholesky);

  print(inverted * matrix);
  // The output (there can be some round-off errors):
  // [1, 0, 0],
  // [0, 1, 0],
  // [0, 0, 1],
```

*Keep in mind that since this kind of inversion is based on Cholesky decomposition, the inversion is applicable only for positive definite and symmetric matrices*

#### Triangular matrix inversion (forward substitution)

```dart
  final matrix = Matrix.fromList([
    [  4,   0,  0],
    [ 12,  37,  0],
    [-16, -43, 98],
  ], dtype: dtype);
  final inverted = matrix.inverse(Inverse.forwardSubstitution);

  print(inverted * matrix);
  // The output (there can be some round-off errors):
  // [1, 0, 0],
  // [0, 1, 0],
  // [0, 0, 1],
```

#### Triangular matrix inversion (backward substitution)

```dart
  final matrix = Matrix.fromList([
    [4, 12, -16],
    [0, 37, -43],
    [0,  0, -98],
  ], dtype: dtype);
  final inverted = matrix.inverse(Inverse.backwardSubstitution);

  print(inverted * matrix);
  // The output (there can be some round-off errors):
  // [1, 0, 0],
  // [0, 1, 0],
  // [0, 0, 1],
```
 
#### Matrix row-wise reduce
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
  ]); 
  final reduced = matrix.reduceRows((combine, row) => combine + row);
  print(reduced); // [6.0, 8.0, 10.0, 12.0]
````

#### Matrix column-wise reduce
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

#### Matrix row-wise mapping
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

#### Matrix column-wise mapping
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

#### Matrix element-wise mapping
````dart
import 'package:ml_linalg/linalg.dart';

final matrix = Matrix.fromList([
  [11.0, 12.0, 13.0, 14.0],
  [15.0, 16.0, 0.0, 18.0],
  [21.0, 22.0, -23.0, 24.0],
], dtype: DType.float32);
final result = matrix.mapElements((element) => element * 2);

print(result);
// [
//  [22.0, 24.0,  26.0, 28.0],
//  [30.0, 32.0,   0.0, 36.0],
//  [42.0, 44.0, -46.0, 48.0],
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

#### Matrix element-wise power
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0],
    [7.0, 8.0, 9.0],
  ]);
  final result = matrix.pow(3.0);
  
  print(result);
  // [1 ^ 3 = 1,   2 ^ 3 = 8,   3 ^ 3 = 27 ]
  // [4 ^ 3 = 64,  5 ^ 3 = 125, 6 ^ 3 = 216]
  // [7 ^ 3 = 343, 8 ^ 3 = 512, 9 ^ 3 = 729]
````

#### Matrix element-wise exp
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0],
    [7.0, 8.0, 9.0],
  ]);
  final result = matrix.exp();
  
  print(result);
  // [e ^ 1, e ^ 2, e ^ 3]
  // [e ^ 4, e ^ 5, e ^ 6]
  // [e ^ 7, e ^ 8, e ^ 9]
````

#### Sum of all matrix elements
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0],
    [7.0, 8.0, 9.0],
  ]);
  final result = matrix.sum();
  
  print(result); // 1.0 + 2.0 + 3.0 + 4.0 + 5.0 + 6.0 + 7.0 + 8.0 + 9.0
````

#### Product of all matrix elements
````Dart
  import 'package:ml_linalg/linalg.dart';

  final matrix = Matrix.fromList([
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0],
    [7.0, 8.0, 9.0],
  ]);
  final result = matrix.product();
  
  print(result); // 1.0 * 2.0 * 3.0 * 4.0 * 5.0 * 6.0 * 7.0 * 8.0 * 9.0
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

&nbsp;&nbsp;&nbsp;&nbsp;The library's matrix interface offers `sample` method that is supposed to return a new matrix, 
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

#### Matrix serialization/deserialization
&nbsp;&nbsp;&nbsp;&nbsp;To convert a matrix to a json-serializable map one may use `toJson` method:

````Dart
import 'package:ml_linalg/linalg.dart';

final matrix = Matrix.fromList([
    [11.0, 12.0, 13.0, 14.0],
    [15.0, 16.0, 0.0, 18.0],
    [21.0, 22.0, -23.0, 24.0],
    [24.0, 32.0, 53.0, 74.0],
  ]);

final serialized = matrix.toJson();
````

To restore a serialized matrix one may use `Matrix.fromJson` constructor:

````Dart
import 'package:ml_linalg/linalg.dart';

final matrix = Matrix.fromJson(serialized);
````

### Contacts
If you have questions, feel free to write me on 
 - [Twitter](https://twitter.com/ilgyrd)
 - [Facebook](https://www.facebook.com/ilya.gyrdymov)
 - [Linkedin](https://www.linkedin.com/in/gyrdym/)
