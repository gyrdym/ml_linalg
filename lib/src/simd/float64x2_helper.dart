import 'dart:math' as math;
import 'dart:typed_data';

import 'package:linalg/src/simd/float64x2_vector.dart';
import 'package:linalg/src/simd/simd_helper.dart';

class Float64x2Helper implements SIMDHelper<Float64x2List, Float64x2, Float64List> {

  final bucketSize = 2;

  Float64x2 createSIMDFilled(double value) => new Float64x2.splat(value);

  Float64x2 createSIMDFromSimpleList(List<double> list) {
    final x = list.length > 0 ? list[0] ?? 0.0 : 0.0;
    final y = list.length > 1 ? list[1] ?? 0.0 : 0.0;
    return new Float64x2(x, y);
  }

  Float64x2 SIMDSum(Float64x2 a, Float64x2 b) => a + b;

  Float64x2 SIMDSub(Float64x2 a, Float64x2 b) => a - b;

  Float64x2 SIMDMul(Float64x2 a, Float64x2 b) => a * b;

  Float64x2 SIMDDiv(Float64x2 a, Float64x2 b) => a / b;

  Float64x2 SIMDAbs(Float64x2 a) => a.abs();

  double singleSIMDSum(Float64x2 a) => (a.x.isNaN ? 0.0 : a.x) + (a.y.isNaN ? 0.0 : a.y);

  Float64x2List createSIMDList(int length) => new Float64x2List(length);

  Float64List createTypedList(int length) => new Float64List(length);

  Float64List createTypedListFromList(List<double> list) => new Float64List.fromList(list);

  Float64x2Vector createVectorFromSIMDList(Float64x2List list, int length) => new Float64x2Vector
      .fromSIMDList(list, length);

  Float64x2Vector createVectorFromList(List<double> source) => new Float64x2Vector.from(source);

  double getScalarByOffsetIndex(Float64x2 value, int offset) {
    switch (offset) {
      case 0:
        return value.x;
      case 1:
        return value.y;
      default:
        throw new RangeError('wrong offset');
    }
  }

  Float64x2 selectMax(Float64x2 a, Float64x2 b) => a.max(b);

  double getMaxLane(Float64x2 a) => math.max(a.x, a.y);

  Float64x2 selectMin(Float64x2 a, Float64x2 b) => a.min(b);

  double getMinLane(Float64x2 a) => math.min(a.x, a.y);

  List<double> SIMDToList(Float64x2 a) => <double>[a.x, a.y];
}
