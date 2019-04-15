import 'dart:typed_data';

import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/src/vector/float32x4/float32x4_vector.dart';

import 'norm.dart';

/// An algebraic vector (ordered set of elements).
abstract class Vector implements Iterable<double> {
  /// Creates a vector from a collection [source].
  ///
  /// It converts the collection of [double]-type elements into a collection of
  /// [Float32x4] elements. If [isMutable] is true, one can alter the vector,
  /// for example, via `[]=` operator
  factory Vector.from(Iterable<double> source,
      {bool isMutable, Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Vector.from(source, isMutable: isMutable);
      default:
        throw UnimplementedError();
    }
  }

  factory Vector.fromSimdList(List source, int actualLength,
      {bool isMutable, Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Vector.fromSimdList(source as Float32x4List,
            actualLength, isMutable: isMutable);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a vector of length, equal to [length], filled with [value].
  ///
  /// If [isMutable] is true, one can alter the vector, for example, via `[]=`
  /// operator
  factory Vector.filled(int length, double value,
      {bool isMutable, Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Vector.filled(length, value, isMutable: isMutable);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a vector of length, equal to [length], filled with zeroes.
  ///
  /// If [isMutable] is true, one can alter the vector, for example, via `[]=`
  /// operator
  factory Vector.zero(int length, {bool isMutable, Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Vector.zero(length, isMutable: isMutable);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a vector of length, equal to [length], filled with random values,
  /// generated from randomizer with seed, equal to [seed].
  ///
  /// If [isMutable] is true, one can alter the vector, for example, via `[]=`
  /// operator
  factory Vector.randomFilled(int length,
      {int seed, bool isMutable, Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Vector.randomFilled(length, seed: seed,
            isMutable: isMutable);
      default:
        throw UnimplementedError();
    }
  }

  Type get dtype;

  /// Can someone mutate the vector, e.g. via []= operator, or not
  bool get isMutable;

  /// Indexed access to a vector's element
  double operator [](int index);

  /// Assigns a value via indexed access
  void operator []=(int index, double value);

  /// Vector addition (element-wise operation)
  Vector operator +(Object value);

  /// Vector subtraction (element-wise operation)
  Vector operator -(Object value);

  /// Vector multiplication (element-wise operation)
  Vector operator *(Object value);

  /// Element-wise division
  Vector operator /(Object value);

  /// Creates a new [Vector] containing elements of this [Vector] raised to
  /// the integer [power]
  Vector toIntegerPower(int power);

  /// Returns a vector with absolute value of each vector element
  Vector abs();

  /// Returns a dot (inner) product of [this] and [vector]
  double dot(Vector vector);

  /// Returns a distance between [this] and [vector]
  double distanceTo(Vector vector, {
    Distance distance = Distance.euclidean,
  });

  /// Returns cosine of the angle between [this] and [other]
  double getCosine(Vector other);

  /// Returns a mean value of [this] vector
  double mean();

  /// Calculates vector norm (magnitude)
  double norm([Norm norm = Norm.euclidean]);

  /// Returns sum of all elements
  double sum();

  /// Returns maximum element
  double max();

  /// Returns maximum element
  double min();

  /// Returns a vector composed of elements which are located on the passed
  /// indexes
  Vector query(Iterable<int> indexes);

  /// Returns a vector composed of unique vector's elements
  Vector unique();

  /// Returns normalized version of this vector
  Vector normalize([Norm norm = Norm.euclidean]);

  /// Returns rescaled (min-max normed) version of this vector
  Vector rescale();

  Vector fastMap<E>(
      E mapper(E element, int offsetStartIdx, int offsetEndIdx));

  /// Cuts out a part of the vector
  Vector subvector(int start, [int end]);
}
