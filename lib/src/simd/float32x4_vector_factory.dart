import 'dart:typed_data';

import 'package:linalg/src/simd/float32x4_vector.dart';
import 'package:linalg/src/vector.dart';

abstract class Float32x4VectorFactory {
  static Vector<Float32x4> create(int length) =>
      Float32x4Vector(length);

  static Vector<Float32x4> from(Iterable<double> source) =>
      Float32x4Vector.from(source);

  static Vector<Float32x4> filled(int length, double value) =>
      Float32x4Vector.filled(length, value);

  static Vector<Float32x4> zero(int length) =>
      Float32x4Vector.zero(length);
}
