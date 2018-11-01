import 'dart:typed_data';

import 'package:linalg/src/simd/float32x4_helper.dart';
import 'package:linalg/src/simd/simd_vector.dart';

class Float32x4VectorFactory {
  static const _helper = Float32x4Helper();

  /// Creates a with both empty simd and typed inner lists
  static SIMDVector<Float32x4List, Float32List, Float32x4> empty(int length) =>
      SIMDVector<Float32x4List, Float32List, Float32x4>(length, _helper);

  /// Creates a vector from collection
  static SIMDVector<Float32x4List, Float32List, Float32x4> from(Iterable<double> source) =>
      SIMDVector<Float32x4List, Float32List, Float32x4>.from(source, _helper);

  /// Creates a vector from [Float32x4List] list
  static SIMDVector<Float32x4List, Float32List, Float32x4> fromSIMDList(Float32x4List source, [int origLength]) =>
      SIMDVector<Float32x4List, Float32List, Float32x4>.fromSIMDList(source, _helper, origLength);

  /// Creates a vector with length equals [length] and fills all elements of created vector with a [value]
  static SIMDVector<Float32x4List, Float32List, Float32x4> filled(int length, double value) =>
      SIMDVector<Float32x4List, Float32List, Float32x4>.filled(length, value, _helper);

  /// Creates a vector with length equals [length] and fills all elements of created vector with a zero
  static SIMDVector<Float32x4List, Float32List, Float32x4> zero(int length) =>
      SIMDVector<Float32x4List, Float32List, Float32x4>.zero(length, _helper);

  /// Creates a vector with length equals [length] and fills all elements of created vector with a random value
  static SIMDVector<Float32x4List, Float32List, Float32x4> randomFilled(int length, {int seed}) =>
      SIMDVector<Float32x4List, Float32List, Float32x4>.randomFilled(length, _helper, seed: seed);
}
