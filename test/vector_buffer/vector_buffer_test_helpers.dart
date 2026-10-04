import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';

Vector vectorWithPaddedTail(
  List<num> values, {
  required DType dtype,
  required double paddingValue,
}) {
  if (dtype == DType.float32) {
    const bucketSize =
        Float32x4List.bytesPerElement ~/ Float32List.bytesPerElement;
    final storage = Float32List(
      ((values.length + bucketSize - 1) ~/ bucketSize) * bucketSize,
    );
    storage.setRange(0, values.length, values.map((value) => value.toDouble()));
    for (var i = values.length; i < storage.length; i++) {
      storage[i] = paddingValue;
    }

    return Vector.fromSimdList(
      storage.buffer.asFloat32x4List(),
      values.length,
      dtype: dtype,
    );
  }

  const bucketSize =
      Float64x2List.bytesPerElement ~/ Float64List.bytesPerElement;
  final storage = Float64List(
    ((values.length + bucketSize - 1) ~/ bucketSize) * bucketSize,
  );
  storage.setRange(0, values.length, values.map((value) => value.toDouble()));
  for (var i = values.length; i < storage.length; i++) {
    storage[i] = paddingValue;
  }

  return Vector.fromSimdList(
    storage.buffer.asFloat64x2List(),
    values.length,
    dtype: dtype,
  );
}
