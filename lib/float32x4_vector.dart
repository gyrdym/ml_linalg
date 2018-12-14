import 'dart:typed_data';

import 'package:ml_linalg/src/vector/float32/float32x4_vector.dart';
import 'package:ml_linalg/vector.dart';

abstract class Float32x4Vector {
  static MLVector<Float32x4> create(int length) =>
      Float32x4VectorInternal(length);

  static MLVector<Float32x4> from(Iterable<double> source) =>
      Float32x4VectorInternal.from(source);

  static MLVector<Float32x4> filled(int length, double value) =>
      Float32x4VectorInternal.filled(length, value);

  static MLVector<Float32x4> zero(int length) =>
      Float32x4VectorInternal.zero(length);
}
