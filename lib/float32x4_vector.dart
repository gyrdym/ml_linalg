import 'dart:typed_data';

import 'package:ml_linalg/src/vector/float32/float32x4_vector.dart';
import 'package:ml_linalg/vector.dart';

abstract class Float32x4Vector implements MLVector<Float32x4> {
  factory Float32x4Vector.from(Iterable<double> source, {bool isMutable}) = Float32x4VectorInternal.from;
  factory Float32x4Vector.filled(int length, double value, {bool isMutable}) = Float32x4VectorInternal.filled;
  factory Float32x4Vector.zero(int length, {bool isMutable}) = Float32x4VectorInternal.zero;
  factory Float32x4Vector.randomFilled(int length, {int seed, bool isMutable}) = Float32x4VectorInternal.randomFilled;
}
