import 'dart:collection';
import 'dart:core';
import 'dart:typed_data';

import 'package:ml_linalg/src/vector/base_vector.dart';
import 'package:ml_linalg/src/vector/common/typed_list_factory_factory.dart';
import 'package:ml_linalg/src/vector/float32x4/helper/helper_factory.dart';
import 'package:ml_linalg/src/vector/float32x4/typed_list_factory/typed_list_factory_factory.dart';

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
class Float32x4Vector extends BaseVector<Float32x4, Float32x4List>
    with IterableMixin<double> {

  /// Creates a vector from collection
  Float32x4Vector.from(Iterable<double> source, {
    bool isMutable = false,
    TypedListFactoryFactory typedListFactoryFactory =
    const Float32ListFactoryFactory(),
    Float32x4HelperFactory simdHelperFactory = const Float32x4HelperFactory(),
  }) : super.from(
      source,
      4,
      isMutable,
      typedListFactoryFactory.create(),
      simdHelperFactory.create(),
  );

  /// Creates a vector from SIMD-typed (Float32x4, Float64x2) list
  Float32x4Vector.fromSimdList(Float32x4List source, int origLength, {
    bool isMutable = false,
    TypedListFactoryFactory typedListFactoryFactory =
    const Float32ListFactoryFactory(),
    Float32x4HelperFactory simdHelperFactory = const Float32x4HelperFactory(),
  }) : super.fromSimdList(
    origLength,
    4,
    isMutable,
    typedListFactoryFactory.create(),
    simdHelperFactory.create(),
    () => Float32x4List.fromList(source.sublist(0, origLength)),
  );

  /// Creates a SIMD-vector with length equals [length] and fills all elements
  /// of created vector with a [value]
  Float32x4Vector.filled(int length, double value, {
    bool isMutable = false,
    TypedListFactoryFactory typedListFactoryFactory =
    const Float32ListFactoryFactory(),
    Float32x4HelperFactory simdHelperFactory = const Float32x4HelperFactory(),
  }) : super.filled(
    length,
    value,
    4,
    isMutable,
    typedListFactoryFactory.create(),
    simdHelperFactory.create(),
  );

  /// Creates a SIMD-vector with length equals [length] and fills all elements
  /// of created vector with a zero
  Float32x4Vector.zero(int length, {
    bool isMutable = false,
    TypedListFactoryFactory typedListFactoryFactory =
    const Float32ListFactoryFactory(),
    Float32x4HelperFactory simdHelperFactory = const Float32x4HelperFactory(),
  }) : super.zero(
    length,
    4,
    isMutable,
    typedListFactoryFactory.create(),
    simdHelperFactory.create(),
  );

  /// Creates a SIMD-vector with length equals [length] and fills all elements
  /// of created vector with a random value
  Float32x4Vector.randomFilled(int length, {
    int seed,
    bool isMutable = false,
    TypedListFactoryFactory typedListFactoryFactory =
    const Float32ListFactoryFactory(),
    Float32x4HelperFactory simdHelperFactory = const Float32x4HelperFactory(),
  }) : super.randomFilled(
    length,
    seed,
    4,
    isMutable,
    typedListFactoryFactory.create(),
    simdHelperFactory.create(),
  );
}
