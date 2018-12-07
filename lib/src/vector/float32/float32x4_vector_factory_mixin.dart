import 'dart:typed_data';

import 'package:ml_linalg/src/vector/float32/float32x4_vector.dart';
import 'package:ml_linalg/src/vector/ml_vector_factory.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_linalg/vector_type.dart';

abstract class Float32x4VectorFactoryMixin implements MLVectorFactory<Float32x4List, Float32x4> {
  @override
  MLVector<Float32x4> vectorFrom(Iterable<double> source, [MLVectorType type = MLVectorType.column]) =>
      Float32x4Vector.from(source);

  @override
  MLVector<Float32x4> vectorFromSIMDList(Float32x4List source, [int length, MLVectorType type = MLVectorType.column]) =>
      Float32x4Vector.fromSIMDList(source, length);
}
