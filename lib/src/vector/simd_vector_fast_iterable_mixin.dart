import 'dart:math' as math;

import 'package:ml_linalg/src/vector/simd_operations_helper.dart';
import 'package:ml_linalg/src/vector/vector_data_store.dart';
import 'package:ml_linalg/vector.dart';

mixin SimdVectorFastIterableMixin<E, S extends List<E>>
    implements
        VectorDataStore<E, S>,
        SimdOperationsHelper<E, S>,
        Vector {
  @override
  Vector fastMap<T>(
      T mapper(T element, int offsetStartIdx, int offsetEndIdx)) {
    final list = createSIMDList(data.length) as List<T>;
    for (int i = 0; i < data.length; i++) {
      final offsetStart = i * bucketSize;
      final offsetEnd = offsetStart + bucketSize - 1;
      list[i] =
          mapper(data[i] as T, offsetStart, math.min(offsetEnd, length - 1));
    }
    return Vector.fromSimdList(list, actualLength: length,
        isMutable: false, dtype: dtype);
  }
}
