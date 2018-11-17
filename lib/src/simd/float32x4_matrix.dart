import 'dart:typed_data';

import 'package:linalg/src/matrix.dart';

class Float32x4Matrix implements Matrix {
  final int rows;
  final int columns;

  ByteData _data;

  Float32x4Matrix.from(List<List<double>> source) : rows = source.length, columns = source.first.length {
    _data = ByteData(rows * columns);
    for (int i = 0; i < source.length; i++) {
      for (int j = 0; j < source[i].length; j++) {
        _data.setFloat32(_data.lengthInBytes, source[i][j]);
      }
    }
  }

}
