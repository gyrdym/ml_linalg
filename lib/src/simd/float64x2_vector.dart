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
class Float64x2Vector extends SIMDVector<Float64x2List, Float64List, Float64x2> {
  @override
  int get _bucketSize => 2;

  /// Creates a [Float64x2Vector] with both empty simd and typed inner lists
  Float64x2Vector(int length) : super(length);

  /// Creates a [Float64x2Vector] vector from collection
  Float64x2Vector.from(Iterable<double> source) : super.from(source);

  /// Creates a [Float64x2Vector] vector from [Float64x2List] list
  Float64x2Vector.fromSIMDList(Float64x2List source, [int origLength]) : super.fromSIMDList(source, origLength);

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
  Float64List _createTypedList(int length) => new Float64List(length);

  @override
  Float64List _createTypedListFromList(List<double> list) => new Float64List.fromList(list);

  @override
  Float64x2Vector _createVectorFromSIMDList(Float64x2List list, int length) => new Float64x2Vector
      .fromSIMDList(list, length);

  @override
  Float64x2Vector _createVectorFromList(List<double> source) => new Float64x2Vector.from(source);

  @override
  Float64x2 _createSIMDFilled(double value) => new Float64x2.splat(value);

  @override
  Float64x2 _createSIMDFromSimpleList(List<double> list) {
    final x = list.length > 0 ? list[0] ?? 0.0 : 0.0;
    final y = list.length > 1 ? list[1] ?? 0.0 : 0.0;
    return new Float64x2(x, y);
  }

  @override
  Float64x2 _SIMDProduct(Float64x2 a, Float64x2 b) => a * b;

  @override
  Float64x2 _SIMDSum(Float64x2 a, Float64x2 b) => a + b;

  @override
  Float64x2 _SIMDAbs(Float64x2 a) => a.abs();

  @override
  double _singleSIMDSum(Float64x2 a) => (a.x.isNaN ? 0.0 : a.x) + (a.y.isNaN ? 0.0 : a.y);

  @override
  double _getScalarByOffsetIndex(Float64x2 value, int offset) {
    switch (offset) {
      case 0:
        return value.x;
      case 1:
        return value.y;
      default:
        throw new RangeError('wrong offset');
    }
  }

  @override
  Float64x2 _selectMax(Float64x2 a, Float64x2 b) => a.max(b);

  @override
  double _getMaxLane(Float64x2 a) => math.max(a.x, a.y);

  @override
  Float64x2 _selectMin(Float64x2 a, Float64x2 b) => a.min(b);

  @override
  double _getMinLane(Float64x2 a) => math.min(a.x, a.y);

  @override
  List<double> _SIMDToList(Float64x2 a) => [a.x, a.y];
}
