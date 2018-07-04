part of 'simd_vector.dart';

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
class Float64x2Vector extends _SIMDVector<Float64x2List, Float64List, Float64x2> {
  @override
  int get _bucketSize => 2;

  /// Creates a [Float64x2Vector] with both empty simd and typed inner lists
  Float64x2Vector(int length) : super(length);

  /// Creates a [Float64x2Vector] with both preset simd and typed inner lists
  Float64x2Vector._preset(Float64x2List simdList, Float64List typedList) : super.preset(simdList, typedList);

  /// Creates a [Float64x2Vector] vector from collection
  Float64x2Vector.from(Iterable<double> source) : super.from(source);

  /// Creates a [Float64x2Vector] vector from [Float64x2List] list
  Float64x2Vector.fromTypedList(Float64x2List source, [int origLength]) : super.fromSIMDList(source, origLength);

  /// Creates a [Float64x2Vector] vector with length equals [length] and fills all elements of created vector with a zero
  Float64x2Vector.filled(int length, double value) : super.filled(length, value);

  /// Creates a [Float64x2Vector] vector with length equals [length] and fills all elements of created vector with a zero
  Float64x2Vector.zero(int length) : super.zero(length);

  /// Creates a [Float64x2Vector] vector with length equals [length] and fills all elements of created vector with a random value
  Float64x2Vector.randomFilled(int length, {int seed}) : super.randomFilled(length, seed: seed);

  // Factory methods implementation:

  @override
  Float64x2List _createSIMDList(int length) => new Float64x2List(length);

  @override
  Float64x2List _createSIMDListFrom(List list) => new Float64x2List.fromList(list);

  @override
  Float64List _createTypedList(int length) => new Float64List(length);

  @override
  Float64List _createTypedListFromList(List<double> list) => new Float64List.fromList(list);

  @override
  Float64x2Vector _createVectorFromSIMDList(Float64x2List list, int length) => new Float64x2Vector
      .fromTypedList(list, length);

  @override
  Float64x2Vector _createVectorWithPresetData(Float64x2List simd, Float64List typed) =>
      new Float64x2Vector._preset(simd, typed);

  @override
  Float64x2Vector _createVectorFromList(List<double> source) => new Float64x2Vector.from(source);

  @override
  Float64x2 _createSIMDValueFilled(double value) => new Float64x2.splat(value);

  @override
  Float64x2 _createSIMDValueFromSimpleList(List<double> list) {
    double x = list[0] ?? 0.0;
    double y = list[1] ?? 0.0;

    return new Float64x2(x, y);
  }

  @override
  Float64x2 _SIMDValuesProduct(Float64x2 a, Float64x2 b) => a * b;

  @override
  Float64x2 _SIMDValuesSum(Float64x2 a, Float64x2 b) => a + b;

  @override
  Float64x2 _SIMDValueAbs(Float64x2 a) => a.abs();

  @override
  double _SIMDValueSum(Float64x2 a) => a.x + a.y;

  @override
  List<double> _SIMDValueToList(Float64x2 a) => [a.x, a.y];
}
