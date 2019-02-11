import 'dart:collection';
import 'dart:core';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/src/vector/common/float32_list_factory_mixin.dart';
import 'package:ml_linalg/src/vector/float32x4/float32x4_data_store_mixin.dart';
import 'package:ml_linalg/src/vector/float32x4/float32x4_operations_mixin.dart';
import 'package:ml_linalg/src/vector/float32x4/float32x4_vector_factory_mixin.dart';
import 'package:ml_linalg/src/vector/ml_simd_vector_fast_iterable_mixin.dart';
import 'package:ml_linalg/src/vector/ml_simd_vector_operations_mixin.dart';
import 'package:ml_linalg/vector.dart';

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
class Float32x4Vector extends Object
    with
        IterableMixin<double>,
        Float32ListFactoryMixin,
        Float32x4OperationsMixin,
        Float32x4VectorFactoryMixin,
        Float32x4DataStoreMixin,
        MLSimdVectorFastIterableMixin<Float32x4, Float32x4List>,
        MLSimdVectorOperationsMixin<Float32x4, Float32x4List>
    implements MLVector {
  @override
  final bool isMutable;

  /// Creates a vector from collection
  Float32x4Vector.from(Iterable<double> source, {this.isMutable = false}) {
    length = source.length;
    final List<double> _source =
        source is List ? source : source.toList(growable: false);
    data = convertCollectionToSIMDList(_source);
  }

  /// Creates a vector from SIMD-typed (Float32x4, Float64x2) list
  Float32x4Vector.fromSIMDList(Float32x4List source,
      {int origLength, this.isMutable = false}) {
    length = origLength ?? source.length * bucketSize;
    data = Float32x4List.fromList(source.sublist(0, source.length));
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a [value]
  Float32x4Vector.filled(int length, double value, {this.isMutable = false}) {
    this.length = length;
    final source = List<double>.filled(length, value);
    data = convertCollectionToSIMDList(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a zero
  Float32x4Vector.zero(int length, {this.isMutable = false}) {
    this.length = length;
    final source = List<double>.filled(length, 0.0);
    data = convertCollectionToSIMDList(source);
  }

  /// Creates a SIMD-vector with length equals [length] and fills all elements of created vector with a random value
  Float32x4Vector.randomFilled(int length, {int seed, this.isMutable = false}) {
    this.length = length;
    final random = math.Random(seed);
    final source = List<double>.generate(length, (_) => random.nextDouble());
    data = convertCollectionToSIMDList(source);
  }
}
