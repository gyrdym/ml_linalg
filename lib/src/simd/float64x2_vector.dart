import 'dart:typed_data';

import 'package:linalg/src/simd/float64x2_helper.dart';
import 'package:linalg/src/simd/simd_vector.dart';

/// Vector with SIMD (single instruction, multiple data) architecture support
///
/// This vector may have potentially infinite length (in terms of vector algebra - number of
/// dimensions). Vector components are contained in [Float64x2List] data structure, that allow to perform vector operations
/// extremely fast due to hardware assisted computations.
///
/// Let's assume some considerations:
/// - High performance of vector operations is provided by SIMD types of dart language
/// - Each SIMD-typed value is a "cell", that contains (in case of [Float64x2Vector]) two 64-digit floating point values.
/// Type of these values is [Float64x2]
/// - Sequence of SIMD-values forms a "computation lane", where computations are performed with each floating point element
/// simultaneously (in parallel, in this case - in two threads)
class Float64x2Vector extends SIMDVector<Float64x2List, Float64List, Float64x2> {
  /// Creates a [Float64x2Vector] with both empty simd and typed inner lists
  Float64x2Vector(int length) : super(length, Float64x2Helper());

  /// Creates a [Float64x2Vector] vector from collection
  Float64x2Vector.from(Iterable<double> source) : super.from(source, Float64x2Helper());

  /// Creates a [Float64x2Vector] vector from [Float64x2List] list
  Float64x2Vector.fromSIMDList(Float64x2List source, [int origLength])
      : super.fromSIMDList(source, Float64x2Helper(), origLength);

  /// Creates a [Float64x2Vector] vector with length equals [length] and fills all elements of created vector with a zero
  Float64x2Vector.filled(int length, double value) : super.filled(length, value, Float64x2Helper());

  /// Creates a [Float64x2Vector] vector with length equals [length] and fills all elements of created vector with a zero
  Float64x2Vector.zero(int length) : super.zero(length, Float64x2Helper());

  /// Creates a [Float64x2Vector] vector with length equals [length] and fills all elements of created vector with a random value
  Float64x2Vector.randomFilled(int length, {int seed}) : super.randomFilled(length, Float64x2Helper(), seed: seed);
}
