import 'dart:typed_data';

import 'package:linalg/src/simd/float32x4_helper.dart';
import 'package:linalg/src/simd/simd_vector.dart';

/// Vector with SIMD (single instruction, multiple data) architecture support
///
/// This vector may have potentially infinite length (in terms of vector algebra - number of
/// dimensions). Vector components are contained in [Float32x4List] data structure, that allow to perform vector operations
/// extremely fast due to hardware assisted computations.
///
/// Let's assume some considerations:
/// - High performance of the vector operations is provided by SIMD types of Dart language
/// - Each SIMD-typed value is a "cell", that contains (in case of [Float32x4Vector]) four 32-digit floating point values.
/// Type of these values is [Float32x4]
/// - Sequence of SIMD-values forms a "computation lane", where computations are performed with each floating point element
/// simultaneously (in parallel, in this case - in four threads)
class Float32x4Vector extends SIMDVector<Float32x4List, Float32List, Float32x4> {

  /// Creates a [Float32x4Vector] with both empty simd and typed inner lists
  Float32x4Vector(int length) : super(length, new Float32x4Helper());

  /// Creates a [Float32x4Vector] vector from collection
  Float32x4Vector.from(Iterable<double> source) : super.from(source, new Float32x4Helper());

  /// Creates a [Float32x4Vector] vector from [Float32x4List] list
  Float32x4Vector.fromSIMDList(Float32x4List source, [int origLength])
      : super.fromSIMDList(source, new Float32x4Helper(), origLength);

  /// Creates a [Float32x4Vector] vector with length equals [length] and fills all elements of created vector with a [value]
  Float32x4Vector.filled(int length, double value) : super.filled(length, value, new Float32x4Helper());

  /// Creates a [Float32x4Vector] vector with length equals [length] and fills all elements of created vector with a zero
  Float32x4Vector.zero(int length) : super.zero(length, new Float32x4Helper());

  /// Creates a [Float32x4Vector] vector with length equals [length] and fills all elements of created vector with a random value
  Float32x4Vector.randomFilled(int length, {int seed}) : super.randomFilled(length, new Float32x4Helper(), seed: seed);
}
