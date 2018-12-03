import 'dart:typed_data';

import 'package:ml_linalg/src/vector/data_store.dart';

class Float32x4DataStoreMixin implements DataStore<Float32x4List, Float32x4> {
  @override
  Float32x4List data;

  @override
  int length;

  @override
  List<double> toList({bool growable = false}) => data.buffer.asFloat32List(0, length);
}
