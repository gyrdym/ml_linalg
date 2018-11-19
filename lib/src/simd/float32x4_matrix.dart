import 'dart:core';
import 'dart:typed_data';

import 'package:linalg/src/matrix.dart';
import 'package:linalg/src/simd/matrix_iterable_mixin.dart';

class Float32x4Matrix extends Object with MatrixIterableMixin implements Matrix, Iterable<Iterable<double>> {
  @override
  final int rows;

  @override
  final int columns;

  ByteData _data;

  Float32x4Matrix.from(List<List<double>> source) : rows = source.length, columns = source.first.length {
    _data = ByteData(rows * columns);
    for (int i = 0; i < source.length; i++) {
      for (int j = 0; j < source[i].length; j++) {
        _data.setFloat32(_data.lengthInBytes * Float32List.bytesPerElement, source[i][j]);
      }
    }
  }

  @override
  Iterable<double> operator [](int index) {
    // TODO: implement []
  }
}
