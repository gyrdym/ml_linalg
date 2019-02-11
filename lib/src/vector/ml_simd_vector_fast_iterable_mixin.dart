import 'dart:math' as math;

import 'package:ml_linalg/src/vector/ml_simd_operations_helper.dart';
import 'package:ml_linalg/src/vector/ml_vector_data_store.dart';
import 'package:ml_linalg/src/vector/ml_vector_factory.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLSimdVectorFastIterableMixin<E, S extends List<E>>
    implements
        MLVectorFactory<E, S>,
        MLVectorDataStore<E, S>,
        MLSimdOperationsHelper<E, S>,
        MLVector {
  @override
  MLVector fastMap<T>(
      T mapper(T element, int offsetStartIdx, int offsetEndIdx)) {
    final list = createSIMDList(data.length) as List<T>;
    for (int i = 0; i < data.length; i++) {
      final offsetStart = i * bucketSize;
      final offsetEnd = offsetStart + bucketSize - 1;
      list[i] =
          mapper(data[i] as T, offsetStart, math.min(offsetEnd, length - 1));
    }
    return createVectorFromSIMDList(list as S, length);
  }
}
