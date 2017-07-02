part of 'typed_vector.dart';

class Float32x4Vector extends _SIMDVector<Float32x4Vector, Float32x4List, Float32List> {
  @override
  final int _laneLength = 4;

  Float32x4Vector(int length) : super(length);

  Float32x4Vector.from(Iterable<double> source) : super.from(source);

  Float32x4Vector.fromTypedList(Float32x4List source, [int origLength]) : super.fromTypedList(source, origLength);

  Float32x4Vector.filled(int length, double value) : super.filled(length, value);

  Float32x4Vector.zero(int length) : super.zero(length);

  Float32x4Vector.randomFilled(int length, {int seed}) : super.randomFilled(length, seed: seed);

  Float32x4List _createSIMDList(int length) => new Float32x4List(length);

  Float32x4List _createSIMDListFrom(List list) => new Float32x4List.fromList(list);

  Float32List _createTypedListFrom(List<double> list) => new Float32List.fromList(list);

  Float32x4Vector _createVectorFromTypedList(Float32x4List list, int length) => new Float32x4Vector
      .fromTypedList(list, length);
}
