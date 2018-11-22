import 'dart:typed_data';

import 'package:linalg/src/simd/data_store.dart';

class Float32x4DataStoreMixin implements DataStore<Float32x4List> {
  @override
  Float32x4List data;

  @override
  int length;

  @override
  List<double> toList({bool growable = false}) => data.buffer.asFloat32List(0, length);
}
