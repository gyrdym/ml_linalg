import 'dart:core';
import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/common/float32_list_helper/float32_list_helper_factory.dart';
import 'package:ml_linalg/src/common/typed_list_helper/typed_list_helper_factory.dart';
import 'package:ml_linalg/src/vector/base_vector.dart';
import 'package:ml_linalg/src/vector/float32/simd_helper/float32x4_helper_factory.dart';

/// Vector with SIMD (single instruction, multiple data) architecture support
///
/// An entity, that extends this class, may have potentially infinite length
/// (in terms of vector algebra - number of dimensions). Vector components are
/// contained in a special typed data structure, that allow to perform vector
/// operations extremely fast due to hardware assisted computations.
///
/// Let's assume some considerations:
///
/// - High performance of vector operations is provided by SIMD types of Dart
/// language
///
/// - Each SIMD-typed value is a "cell", that contains several floating point
/// values (2 or 4).
///
/// - Sequence of SIMD-values forms a "computation lane", where computations
/// are performed with each floating point element simultaneously (in parallel)
class Float32Vector extends BaseVector<Float32x4, Float32x4List> {
  /// Creates a vector from collection
  Float32Vector.fromList(List<double> source, {
    TypedListHelperFactory typedListHelperFactory =
      const Float32ListHelperFactory(),
    Float32x4HelperFactory simdHelperFactory = const Float32x4HelperFactory(),
  }) : super.fromList(
      source,
      bytesPerElement,
      bucketSize,
      typedListHelperFactory.create(),
      simdHelperFactory.create(),
  );

  /// Creates a vector from SIMD-typed (Float32x4, Float64x2) list
  Float32Vector.fromSimdList(Float32x4List source, int origLength, {
    TypedListHelperFactory typedListHelperFactory =
      const Float32ListHelperFactory(),
    Float32x4HelperFactory simdHelperFactory = const Float32x4HelperFactory(),
  }) : super.fromSimdList(
    source,
    origLength,
    bytesPerElement,
    bucketSize,
    typedListHelperFactory.create(),
    simdHelperFactory.create(),
  );

  /// Creates a SIMD-vector with length equals [length] and fills all elements
  /// of created vector with a [value]
  Float32Vector.filled(int length, double value, {
    bool isMutable = false,
    TypedListHelperFactory typedListHelperFactory =
      const Float32ListHelperFactory(),
    Float32x4HelperFactory simdHelperFactory = const Float32x4HelperFactory(),
  }) : super.filled(
    length,
    value,
    bytesPerElement,
    bucketSize,
    typedListHelperFactory.create(),
    simdHelperFactory.create(),
  );

  /// Creates a SIMD-vector with length equals [length] and fills all elements
  /// of created vector with a zero
  Float32Vector.zero(int length, {
    bool isMutable = false,
    TypedListHelperFactory typedListFactoryFactory =
      const Float32ListHelperFactory(),
    Float32x4HelperFactory simdHelperFactory = const Float32x4HelperFactory(),
  }) : super.zero(
    length,
    bytesPerElement,
    bucketSize,
    typedListFactoryFactory.create(),
    simdHelperFactory.create(),
  );

  /// Creates a SIMD-vector with length equals [length] and fills all elements
  /// of created vector with a random value
  Float32Vector.randomFilled(int length, {
    int seed,
    bool isMutable = false,
    TypedListHelperFactory typedListFactoryFactory =
      const Float32ListHelperFactory(),
    Float32x4HelperFactory simdHelperFactory = const Float32x4HelperFactory(),
  }) : super.randomFilled(
    length,
    seed,
    bytesPerElement,
    bucketSize,
    typedListFactoryFactory.create(),
    simdHelperFactory.create(),
  );

  static const bucketSize = 4;
  static const bytesPerElement = Float32List.bytesPerElement;

  @override
  final DType dtype = DType.float32;
}
