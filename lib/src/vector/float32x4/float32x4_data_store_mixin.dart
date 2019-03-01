import 'dart:typed_data';

import 'package:ml_linalg/src/vector/ml_vector_data_store.dart';

mixin Float32x4DataStoreMixin
    implements VectorDataStore<Float32x4, Float32x4List> {
  @override
  Float32x4List data;

  @override
  int length;

  @override
  List<double> toList({bool growable = false}) =>
      data.buffer.asFloat32List(0, length);
}
