import 'dart:typed_data';

import 'package:ml_linalg/src/vector/float32x4/float32x4_vector.dart';
import 'package:ml_linalg/src/vector/ml_vector_factory.dart';
import 'package:ml_linalg/vector.dart';

abstract class Float32x4VectorFactoryMixin
    implements MLVectorFactory<Float32x4, Float32x4List> {
  @override
  MLVector createVectorFrom(Iterable<double> source, [bool mutable = false]) =>
      Float32x4Vector.from(source, isMutable: mutable);

  @override
  MLVector createVectorFromSIMDList(Float32x4List source,
          [int length, bool mutable = false]) =>
      Float32x4Vector.fromSIMDList(source,
          origLength: length, isMutable: mutable);
}
