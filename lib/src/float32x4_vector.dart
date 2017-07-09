part of 'typed_vector.dart';

/// A vector with SIMD (single instruction, multiple data) architecture support
///
/// This vector may has potentially infinite length (in terms of vector algebra - number of
/// dimensions). Vector components are contained in [Float32x4List] data structure, that allow to perform vector operations
/// extremely fast due to hardware assisted computations.
///
/// Let's assume some considerations:
/// - High performance of vector operations is provided by SIMD types of dart language
/// - Each SIMD-typed value is a "cell", that contains (in case of [Float32x4Vector]) four 32-digit floating point values.
/// Type of this values is [Float32x4]
/// - Sequence of SIMD-values forms a "computation lane", where computations are performed on an each floating point element
/// simultaneously (in parallel, in this case - in four threads)
class Float32x4Vector extends _SIMDVector<Float32x4Vector, Float32x4List, Float32List, Float32x4> {
  @override
  int get _laneLength => 4;

  /// Creates a [Float32x4Vector] vector from collection
  Float32x4Vector.from(Iterable<double> source) : super.from(source);

  /// Creates a [Float32x4Vector] vector from [Float32x4List] list
  Float32x4Vector.fromSIMDList(Float32x4List source, [int origLength]) : super.fromSIMDList(source, origLength);

  /// Creates a [Float32x4Vector] vector with length equals [length] and fills all elements of created vector with a [value]
  Float32x4Vector.filled(int length, double value) : super.filled(length, value);

  /// Creates a [Float32x4Vector] vector with length equals [length] and fills all elements of created vector with a zero
  Float32x4Vector.zero(int length) : super.zero(length);

  /// Creates a [Float32x4Vector] vector with length equals [length] and fills all elements of created vector with a random value
  Float32x4Vector.randomFilled(int length, {int seed}) : super.randomFilled(length, seed: seed);

  // Factory methods implementation:

  @override
  Float32x4List _createSIMDList(int length) => new Float32x4List(length);

  @override
  Float32x4List _createSIMDListFrom(List list) => new Float32x4List.fromList(list);

  @override
  Float32List _createTypedListFrom(List<double> list) => new Float32List.fromList(list);

  @override
  Float32x4Vector _createVectorFromTypedList(Float32x4List list, int length) => new Float32x4Vector
      .fromSIMDList(list, length);

  @override
  Float32x4 _createSIMDValueFilled(double value) => new Float32x4.splat(value);

  @override
  Float32x4 _createSIMDValueFromList(List<double> list) {
    double x = list[0] ?? 0.0;
    double y = list[1] ?? 0.0;
    double z = list[2] ?? 0.0;
    double w = list[3] ?? 0.0;

    return new Float32x4(x, y, z, w);
  }

  @override
  Float32x4 _SIMDValuesProduct(Float32x4 a, Float32x4 b) => a * b;

  @override
  Float32x4 _SIMDValuesSum(Float32x4 a, Float32x4 b) => a + b;

  @override
  Float32x4 _SIMDValueAbs(Float32x4 a) => a.abs();

  @override
  double _SIMDValueSum(Float32x4 a) => a.x + a.y + a.z + a.w;

  @override
  List<double> _SIMDValueToList(Float32x4 a) => [a.x, a.y, a.z, a.w];

  @override
  List<double> _getPartOfSIMDValueAsList(Float32x4 a, int lanesCount) {
    switch (lanesCount) {
      case 1:
        return [a.x];
      case 2:
        return [a.x, a.y];
      case 3:
        return [a.x, a.y, a.z];
      default:
        return [a.x, a.y, a.z, a.w];
    }
  }
}
