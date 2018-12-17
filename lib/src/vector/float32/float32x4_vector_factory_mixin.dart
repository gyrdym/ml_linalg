import 'dart:typed_data';

import 'package:ml_linalg/src/vector/float32/float32x4_vector.dart';
import 'package:ml_linalg/src/vector/ml_vector_factory.dart';
import 'package:ml_linalg/vector.dart';

abstract class Float32x4VectorFactoryMixin implements MLVectorFactory<Float32x4List, Float32x4> {
  @override
  MLVector<Float32x4> createVectorFrom(Iterable<double> source, [bool mutable = false]) =>
      Float32x4VectorInternal.from(source, isMutable: mutable);

  @override
  MLVector<Float32x4> createVectorFromSIMDList(Float32x4List source, [int length, bool mutable = false]) =>
      Float32x4VectorInternal.fromSIMDList(source, origLength: length, isMutable: mutable);
}
