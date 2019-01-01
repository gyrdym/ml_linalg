import 'dart:typed_data';

import 'package:ml_linalg/src/vector/float32/float32x4_vector.dart';
import 'package:ml_linalg/vector.dart';

/// A vector, whose elements type is [Float32x4]
abstract class Float32x4Vector implements MLVector<Float32x4> {
  /// Creates a vector from a collection [source]. It converts the collection of [double]-type elements into a
  /// collection of [Float32x4] elements. If [isMutable] is true, one can alter the vector, for example, via `[]=`
  /// operator
  factory Float32x4Vector.from(Iterable<double> source, {bool isMutable}) = Float32x4VectorInternal.from;

  /// Creates a vector of length, equal to [length], filled with [value]. If [isMutable] is true, one can alter the
  /// vector, for example, via `[]=` operator
  factory Float32x4Vector.filled(int length, double value, {bool isMutable}) = Float32x4VectorInternal.filled;

  /// Creates a vector of length, equal to [length], filled with zeroes. If [isMutable] is true, one can alter the
  /// vector, for example, via `[]=` operator
  factory Float32x4Vector.zero(int length, {bool isMutable}) = Float32x4VectorInternal.zero;

  /// Creates a vector of length, equal to [length], filled with random values, generated from randomizer with seed,
  /// equal to [seed]. If [isMutable] is true, one can alter the vector, for example, via `[]=` operator
  factory Float32x4Vector.randomFilled(int length, {int seed, bool isMutable}) = Float32x4VectorInternal.randomFilled;
}
