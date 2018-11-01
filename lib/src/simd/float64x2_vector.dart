import 'dart:typed_data';

import 'package:linalg/src/simd/float64x2_helper.dart';
import 'package:linalg/src/simd/simd_vector.dart';

class Float64x2VectorFactory {
  static const _helper = Float64x2Helper();

  /// Creates a with both empty simd and typed inner lists
  static SIMDVector<Float64x2List, Float64List, Float64x2> empty(int length) =>
      SIMDVector<Float64x2List, Float64List, Float64x2>(length, _helper);

  /// Creates a vector from collection
  static SIMDVector<Float64x2List, Float64List, Float64x2> from(Iterable<double> source) =>
      SIMDVector<Float64x2List, Float64List, Float64x2>.from(source, _helper);

  /// Creates a vector from [Float64x2List] list
  static SIMDVector<Float64x2List, Float64List, Float64x2> fromSIMDList(Float64x2List source, [int origLength]) =>
      SIMDVector<Float64x2List, Float64List, Float64x2>.fromSIMDList(source, _helper, origLength);

  /// Creates a vector with length equals [length] and fills all elements of created vector with a [value]
  static SIMDVector<Float64x2List, Float64List, Float64x2> filled(int length, double value) =>
      SIMDVector<Float64x2List, Float64List, Float64x2>.filled(length, value, _helper);

  /// Creates a vector with length equals [length] and fills all elements of created vector with a zero
  static SIMDVector<Float64x2List, Float64List, Float64x2> zero(int length) =>
      SIMDVector<Float64x2List, Float64List, Float64x2>.zero(length, _helper);

  /// Creates a vector with length equals [length] and fills all elements of created vector with a random value
  static SIMDVector<Float64x2List, Float64List, Float64x2> randomFilled(int length, {int seed}) =>
      SIMDVector<Float64x2List, Float64List, Float64x2>.randomFilled(length, _helper, seed: seed);
}
