import 'dart:typed_data';

import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/vector/float32/float32_vector.dart';
import 'package:xrange/zrange.dart';

import 'norm.dart';

/// An algebraic vector (ordered set of elements).
abstract class Vector implements Iterable<double> {
  /// Creates a vector from a collection [source].
  ///
  /// It converts the collection of [double]-type elements into a collection of
  /// [Float32x4] elements.
  factory Vector.fromList(List<double> source, {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Vector.fromList(source);
      default:
        throw UnimplementedError();
    }
  }

  factory Vector.fromSimdList(List source, int actualLength,
      {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Vector.fromSimdList(source as Float32x4List,
            actualLength);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a vector of length equal to [length], filled with [value].
  factory Vector.filled(int length, double value,
      {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Vector.filled(length, value);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a vector of length equal to [length], filled with zeroes.
  factory Vector.zero(int length, {DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Vector.zero(length);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a vector of length, equal to [length], filled with random values,
  /// which are bound by interval from [min] (inclusive) tp [max] (exclusive).
  /// If [min] greater than [max] when [min] becomes [max]
  /// generated from randomizer with seed, equal to [seed].
  factory Vector.randomFilled(int length,
      {int seed, double min = 0, double max = 1, DType dtype = DType.float32}) {
    switch (dtype) {
      case DType.float32:
        return Float32Vector.randomFilled(length, seed: seed,
            max: max, min: min);
      default:
        throw UnimplementedError();
    }
  }

  DType get dtype;

  /// Returns an element by its position in the vector
  double operator [](int index);

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

  /// Returns a new vector with absolute value of each vector element
  Vector abs();

  /// Returns a dot (inner) product of [this] and [vector]
  double dot(Vector vector);

  /// Returns a distance between [this] and [vector]
  double distanceTo(Vector vector, {
    Distance distance = Distance.euclidean,
  });

  /// Returns cosine of the angle between [this] and [other] vector
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

  /// Returns a new vector composed of elements which are located on the passed
  /// indexes
  Vector query(Iterable<int> indexes);

  /// Returns a new vector composed of the vector's unique elements
  Vector unique();

  /// Returns a new vector with normalized values of [this] vector
  Vector normalize([Norm norm = Norm.euclidean]);

  /// Returns rescaled (min-max normed) version of this vector
  Vector rescale();

  Vector fastMap<E>(E mapper(E element));

  /// Returns a new vector formed by a specific part of [this] vector using
  /// integer range
  Vector subvectorByRange(ZRange range);

  /// Returns a new vector formed by a specific part of [this] vector
  Vector subvector(int start, [int end]);
}
