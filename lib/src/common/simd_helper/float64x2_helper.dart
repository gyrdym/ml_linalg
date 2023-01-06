import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/src/common/simd_helper/simd_helper.dart';

class Float64x2Helper implements SimdHelper<Float64x2> {
  const Float64x2Helper();

  @override
  bool areLanesEqual(Float64x2 a, Float64x2 b) => a.x == b.x && a.y == b.y;

  @override
  double sumLanes(Float64x2 a) =>
      (a.x.isNaN ? 0.0 : a.x) + (a.y.isNaN ? 0.0 : a.y);

  @override
  double sumLanesForHash(Float64x2 a) =>
      (a.x.isNaN || a.x.isInfinite ? 0.0 : a.x) +
      (a.y.isNaN || a.y.isInfinite ? 0.0 : a.y);

  @override
  double multLanes(Float64x2 a) => a.x * a.y;

  @override
  double getMaxLane(Float64x2 a) => math.max(a.x, a.y);

  @override
  double getMinLane(Float64x2 a) => math.min(a.x, a.y);

  @override
  List<double> simdValueToList(Float64x2 a, [int limit = 2]) {
    if (limit >= 2) {
      return [a.x, a.y];
    }

    return [a.x];
  }

  @override
  Float64x2 pow(Float64x2 a, num exponent) => Float64x2(
        math.pow(a.x, exponent).toDouble(),
        math.pow(a.y, exponent).toDouble(),
      );
}
