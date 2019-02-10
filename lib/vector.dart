import 'dart:typed_data';

import 'package:ml_linalg/src/vector/float32x4/float32x4_vector.dart';

import 'norm.dart';

/// An algebraic vector (ordered set of elements).
abstract class MLVector implements Iterable<double> {
  /// Creates a vector from a collection [source]. It converts the collection of [double]-type elements into a
  /// collection of [Float32x4] elements. If [isMutable] is true, one can alter the vector, for example, via `[]=`
  /// operator
  factory MLVector.from(Iterable<double> source, {bool isMutable, Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Vector.from(source, isMutable: isMutable);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a vector of length, equal to [length], filled with [value]. If [isMutable] is true, one can alter the
  /// vector, for example, via `[]=` operator
  factory MLVector.filled(int length, double value, {bool isMutable, Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Vector.filled(length, value, isMutable: isMutable);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a vector of length, equal to [length], filled with zeroes. If [isMutable] is true, one can alter the
  /// vector, for example, via `[]=` operator
  factory MLVector.zero(int length, {bool isMutable, Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Vector.zero(length, isMutable: isMutable);
      default:
        throw UnimplementedError();
    }
  }

  /// Creates a vector of length, equal to [length], filled with random values, generated from randomizer with seed,
  /// equal to [seed]. If [isMutable] is true, one can alter the vector, for example, via `[]=` operator
  factory MLVector.randomFilled(int length, {int seed, bool isMutable, Type dtype = Float32x4}) {
    switch (dtype) {
      case Float32x4:
        return Float32x4Vector.randomFilled(length, seed: seed, isMutable: isMutable);
      default:
        throw UnimplementedError();
    }
  }

  /// Can someone mutate the vector e.g. via []= operator
  bool get isMutable;

  /// Indexed access to a vector's element
  double operator [](int index);

  /// Assigns a value via indexed access
  void operator []=(int index, double value);

  /// Vector addition (element-wise operation)
  MLVector operator +(Object value);

  /// Vector subtraction (element-wise operation)
  MLVector operator -(Object value);

  /// Vector multiplication (element-wise operation)
  MLVector operator *(Object value);

  /// Element-wise division
  MLVector operator /(Object value);

  /// Creates a new [MLVector] containing elements of this [MLVector] raised to the integer [power]
  MLVector toIntegerPower(int power);

  /// Returns a vector with absolute value of each vector element
  MLVector abs();

  /// Returns a dot (inner) product of [this] and [vector]
  double dot(MLVector vector);

  /// Returns a distance between [this] and [vector] with vector norm type considering
  double distanceTo(MLVector vector, [Norm norm = Norm.euclidean]);

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

  /// Returns a vector composed of elements which are located on the passed indexes
  MLVector query(Iterable<int> indexes);

  /// Returns a vector composed of unique vector's elements
  MLVector unique();

  MLVector fastMap<E>(E mapper(E element, int offsetStartIdx, int offsetEndIdx));

  /// Cuts out a part of the vector
  MLVector subvector(int start, [int end]);
}