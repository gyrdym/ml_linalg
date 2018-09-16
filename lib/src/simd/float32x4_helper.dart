import 'dart:math' as math;
import 'dart:typed_data';

import 'package:linalg/src/simd/float32x4_vector.dart';
import 'package:linalg/src/simd/simd_helper.dart';

class Float32x4Helper implements SIMDHelper<Float32x4List, Float32x4, Float32List> {

  final bucketSize = 4;

  Float32x4 createSIMDFilled(double value) => new Float32x4.splat(value);

  Float32x4 createSIMDFromSimpleList(List<double> list) {
    final x = list.length > 0 ? list[0] ?? 0.0 : 0.0;
    final y = list.length > 1 ? list[1] ?? 0.0 : 0.0;
    final z = list.length > 2 ? list[2] ?? 0.0 : 0.0;
    final w = list.length > 3 ? list[3] ?? 0.0 : 0.0;
    return new Float32x4(x, y, z, w);
  }

  Float32x4 SIMDSum(Float32x4 a, Float32x4 b) => a + b;

  Float32x4 SIMDSub(Float32x4 a, Float32x4 b) => a - b;

  Float32x4 SIMDMul(Float32x4 a, Float32x4 b) => a * b;

  Float32x4 SIMDDiv(Float32x4 a, Float32x4 b) => a / b;

  Float32x4 SIMDAbs(Float32x4 a) => a.abs();

  double singleSIMDSum(Float32x4 a) => (a.x.isNaN ? 0.0 : a.x) + (a.y.isNaN ? 0.0 : a.y) + (a.z.isNaN ? 0.0 : a.z) +
    (a.w.isNaN ? 0.0 : a.w);

  Float32x4List createSIMDList(int length) => new Float32x4List(length);

  Float32List createTypedList(int length) => new Float32List(length);

  Float32List createTypedListFromList(List<double> list) => new Float32List.fromList(list);

  Float32x4Vector createVectorFromSIMDList(Float32x4List list, int length) => new Float32x4Vector
      .fromSIMDList(list, length);

  Float32x4Vector createVectorFromList(List<double> source) => new Float32x4Vector.from(source);

  double getScalarByOffsetIndex(Float32x4 value, int offset) {
    switch (offset) {
      case 0:
        return value.x;
      case 1:
        return value.y;
      case 2:
        return value.z;
      case 3:
        return value.w;
      default:
        throw new RangeError('wrong offset');
    }
  }

  Float32x4 selectMax(Float32x4 a, Float32x4 b) => a.max(b);

  double getMaxLane(Float32x4 a) => math.max(math.max(a.x, a.y), math.max(a.z, a.w));

  Float32x4 selectMin(Float32x4 a, Float32x4 b) => a.min(b);

  double getMinLane(Float32x4 a) => math.min(math.min(a.x, a.y), math.min(a.z, a.w));

  List<double> SIMDToList(Float32x4 a) => <double>[a.x, a.y, a.z, a.w];
}
