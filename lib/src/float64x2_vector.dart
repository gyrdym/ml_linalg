part of 'typed_vector.dart';

/// A vector with SIMD (single instruction, multiple data) architecture support
///
/// This vector may has potentially infinite length (in terms of vector algebra - number of
/// dimensions). Vector components are contained in [Float64x2List] data structure, that allow to perform vector operations
/// extremely fast due to hardware assisted computations.
///
/// Let's assume some considerations:
/// - High performance of vector operations is provided by SIMD types of dart language
/// - Each SIMD-typed value is a "cell", that contains (in case of [Float64x2Vector]) two 64-digit floating point values.
/// Type of this values is [Float64x2]
/// - Sequence of SIMD-values forms a "computation lane", where computations are performed on an each floating point element
/// simultaneously (in parallel, in this case - in two threads)
class Float64x2Vector extends SIMDVector<Float64x2Vector, Float64x2List, Float64List, Float64x2> {
  @override
  int get _laneLength => 2;

  Float64x2Vector(int length) : super(length);

  Float64x2Vector.from(Iterable<double> source) : super.from(source);

  Float64x2Vector.fromTypedList(Float64x2List source, [int origLength]) : super.fromSIMDList(source, origLength);

  Float64x2Vector.filled(int length, double value) : super.filled(length, value);

  Float64x2Vector.zero(int length) : super.zero(length);

  Float64x2Vector.randomFilled(int length, {int seed}) : super.randomFilled(length, seed: seed);

  Float64x2List _createSIMDList(int length) => new Float64x2List(length);

  Float64x2List _createSIMDListFrom(List list) => new Float64x2List.fromList(list);

  Float64List _createTypedListFrom(List<double> list) => new Float64List.fromList(list);

  Float64x2Vector _createVectorFromTypedList(Float64x2List list, int length) => new Float64x2Vector
      .fromTypedList(list, length);

  Float64x2 _createSIMDValueFilled(double value) => new Float64x2.splat(value);

  Float64x2 _createSIMDValueFromList(List<double> list) {
    double x = list[0] ?? 0.0;
    double y = list[1] ?? 0.0;

    return new Float64x2(x, y);
  }

  Float64x2 _SIMDValuesProduct(Float64x2 a, Float64x2 b) => a * b;

  Float64x2 _SIMDValuesSum(Float64x2 a, Float64x2 b) => a + b;

  Float64x2 _SIMDValueAbs(Float64x2 a) => a.abs();

  double _SIMDValueSum(Float64x2 a) => a.x + a.y;

  List<double> _SIMDValueToList(Float64x2 a) => [a.x, a.y];

  List<double> _getPartOfSIMDValueAsList(Float64x2 a, int lanesCount) {
    switch (lanesCount) {
      case 1:
        return [a.x];
      default:
        return [a.x, a.y];
    }
  }
}
