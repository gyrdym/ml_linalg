import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/src/vector/common/simd_helper.dart';

class Float32x4Helper implements SimdHelper<Float32x4, Float32x4List> {
  @override
  Float32x4 createFilled(double value) => Float32x4.splat(value);

  @override
  Float32x4 sum(Float32x4 a, Float32x4 b) => a + b;

  @override
  Float32x4 sub(Float32x4 a, Float32x4 b) => a - b;

  @override
  Float32x4 mul(Float32x4 a, Float32x4 b) => a * b;

  @override
  Float32x4 scale(Float32x4 a, double scalar) => a.scale(scalar);

  @override
  Float32x4 div(Float32x4 a, Float32x4 b) => a / b;

  @override
  Float32x4 abs(Float32x4 a) => a.abs();

  @override
  bool areValuesEqual(Float32x4 a, Float32x4 b) =>
    a.equal(b).signMask == 15;

  @override
  double sumLanes(Float32x4 a) =>
      (a.x.isNaN ? 0.0 : a.x) +
      (a.y.isNaN ? 0.0 : a.y) +
      (a.z.isNaN ? 0.0 : a.z) +
      (a.w.isNaN ? 0.0 : a.w);

  @override
  Float32x4List createList(int length) => Float32x4List(length);

  @override
  Float32x4List createListFrom(List<Float32x4> source) =>
      Float32x4List.fromList(source);

  @override
  Float32x4 selectMax(Float32x4 a, Float32x4 b) => a.max(b);

  @override
  double getMaxLane(Float32x4 a) =>
      math.max(math.max(a.x, a.y), math.max(a.z, a.w));

  @override
  Float32x4 selectMin(Float32x4 a, Float32x4 b) => a.min(b);

  @override
  double getMinLane(Float32x4 a) =>
      math.min(math.min(a.x, a.y), math.min(a.z, a.w));

  @override
  List<double> simdValueToList(Float32x4 a) => <double>[a.x, a.y, a.z, a.w];

  @override
  Float32x4List getBufferAsSimdList(ByteBuffer buffer) =>
      buffer.asFloat32x4List();
}
