import 'dart:typed_data';

import 'package:ml_linalg/src/vector/float32/float32x4_vector.dart';
import 'package:ml_linalg/src/vector/ml_vector_factory.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_linalg/vector_type.dart';

abstract class Float32x4VectorFactoryMixin implements MLVectorFactory<Float32x4List, Float32x4> {
  @override
  MLVector<Float32x4> createVectorFrom(Iterable<double> source, [MLVectorType type = MLVectorType.column]) =>
      Float32x4VectorInternal.from(source, type);

  @override
  MLVector<Float32x4> createVectorFromSIMDList(Float32x4List source, [int length,
    MLVectorType type = MLVectorType.column]) => Float32x4VectorInternal.fromSIMDList(source, length, type);
}
