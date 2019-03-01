import 'dart:typed_data';

import 'package:ml_linalg/src/vector/float32x4/float32x4_vector.dart';
import 'package:ml_linalg/src/vector/vector_factory.dart';
import 'package:ml_linalg/vector.dart';

mixin Float32x4VectorFactoryMixin
    implements VectorFactory<Float32x4, Float32x4List> {
  @override
  Vector createVectorFrom(Iterable<double> source, [bool mutable = false]) =>
      Float32x4Vector.from(source, isMutable: mutable);

  @override
  Vector createVectorFromSIMDList(Float32x4List source,
          [int length, bool mutable = false]) =>
      Float32x4Vector.fromSIMDList(source,
          origLength: length, isMutable: mutable);
}
