import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ml_linalg/src/common/simd_helper/simd_helper.dart';

class Float32x4Helper implements SimdHelper<Float32x4> {
  const Float32x4Helper();

  @override
  bool areLanesEqual(Float32x4 a, Float32x4 b) => a.equal(b).signMask == 15;

  @override
  double sumLanes(Float32x4 a) =>
      (a.x.isNaN ? 0.0 : a.x) +
      (a.y.isNaN ? 0.0 : a.y) +
      (a.z.isNaN ? 0.0 : a.z) +
      (a.w.isNaN ? 0.0 : a.w);

  @override
  double multLanes(Float32x4 a) => a.x * a.y * a.z * a.w;

  @override
  double sumLanesForHash(Float32x4 a) =>
      (a.x.isNaN || a.x.isInfinite ? 0.0 : a.x) +
      (a.y.isNaN || a.y.isInfinite ? 0.0 : a.y) +
      (a.z.isNaN || a.z.isInfinite ? 0.0 : a.z) +
      (a.w.isNaN || a.w.isInfinite ? 0.0 : a.w);

  @override
  double getMaxLane(Float32x4 a) =>
      math.max(math.max(a.x, a.y), math.max(a.z, a.w));

  @override
  double getMinLane(Float32x4 a) =>
      math.min(math.min(a.x, a.y), math.min(a.z, a.w));

  @override
  List<double> simdValueToList(Float32x4 a, [int limit = 4]) {
    if (limit >= 4) {
      return [a.x, a.y, a.z, a.w];
    }

    if (limit == 3) {
      return [a.x, a.y, a.z];
    }

    if (limit == 2) {
      return [a.x, a.y];
    }

    return [a.x];
  }

  @override
  Float32x4 pow(Float32x4 a, num exponent) => Float32x4(
        math.pow(a.x, exponent).toDouble(),
        math.pow(a.y, exponent).toDouble(),
        math.pow(a.z, exponent).toDouble(),
        math.pow(a.w, exponent).toDouble(),
      );
}
