import 'dart:collection';
import 'dart:core';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/src/vector/float32/float32_helper_mixin.dart';
import 'package:ml_linalg/src/vector/float32/float32x4_data_store_mixin.dart';
import 'package:ml_linalg/src/vector/float32/float32x4_helper_mixin.dart';
import 'package:ml_linalg/src/vector/float32/float32x4_vector_factory_mixin.dart';
import 'package:ml_linalg/src/vector/ml_vector_mixin.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_linalg/vector_type.dart';

/// Vector with SIMD (single instruction, multiple data) architecture support
///
/// An entity, that extends this class, may have potentially infinite length (in terms of vector algebra - number of
/// dimensions). Vector components are contained in a special typed data structure, that allow to perform vector operations
/// extremely fast due to hardware assisted computations.
///
/// Let's assume some considerations:
/// - High performance of vector operations is provided by SIMD types of Dart language
/// - Each SIMD-typed value is a "cell", that contains several floating point values (2 or 4).
/// - Sequence of SIMD-values forms a "computation lane", where computations are performed with each floating point element
/// simultaneously (in parallel)
class Float32x4VectorInternal extends Object with
    IterableMixin<double>,
    Float32HelperMixin,
    Float32x4HelperMixin,
    Float32x4VectorFactoryMixin,
    MLVectorMixin<Float32x4, Float32List, Float32x4List>,
    Float32x4DataStoreMixin implements MLVector<Float32x4> {

  @override
  final MLVectorType type;

  /// Creates a vector with both empty simd and typed inner lists
  Float32x4VectorInternal(int length, [this.type = MLVectorType.column]) {
    this.length = length;
    data = createSIMDList(length);
  }

  /// Creates a vector from collection
  Float32x4VectorInternal.from(Iterable<double> source, [this.type = MLVectorType.column]) {
    length = source.length;
    final List<double> _source = source is List ? source : source.toList(growable: false);
    data = convertCollectionToSIMDList(_source);
  }

  /// Creates a vector from SIMD-typed (Float32x4, Float64x2) list
  Float32x4VectorInternal.fromSIMDList(Float32x4List source, [int origLength, this.type = MLVectorType.column]) {
    length = origLength ?? source.length * bucketSize;
    data = Float32x4List.fromList(source.sublist(0, source.length));
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a [value]
  Float32x4VectorInternal.filled(int length, double value, [this.type = MLVectorType.column]) {
    this.length = length;
    final source = List<double>.filled(length, value);
    data = convertCollectionToSIMDList(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a zero
  Float32x4VectorInternal.zero(int length, [this.type = MLVectorType.column]) {
    this.length = length;
    final source = List<double>.filled(length, 0.0);
    data = convertCollectionToSIMDList(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a random value
  Float32x4VectorInternal.randomFilled(int length, {int seed, this.type = MLVectorType.column}) {
    this.length = length;
    final random = math.Random(seed);
    final source = List<double>.generate(length, (_) => random.nextDouble());
    data = convertCollectionToSIMDList(source);
  }
}
