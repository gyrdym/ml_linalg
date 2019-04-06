import 'dart:core';
import 'dart:typed_data';

import 'package:ml_linalg/src/matrix/byte_data_storage/float32_data_manager.dart';
import 'package:ml_linalg/src/matrix/base_matrix.dart';
import 'package:ml_linalg/vector.dart';

class Float32x4Matrix extends BaseMatrix {
  Float32x4Matrix.from(Iterable<Iterable<double>> source) :
        super(Float32DataManager.from(source));

  Float32x4Matrix.columns(Iterable<Vector> source) :
        super(Float32DataManager.fromColumns(source));

  Float32x4Matrix.rows(Iterable<Vector> source) :
        super(Float32DataManager.fromRows(source));

  Float32x4Matrix.flattened(Iterable<double> source, int rowsNum,
      int columnsNum) :
        super(Float32DataManager.fromFlattened(source, rowsNum, columnsNum));

  @override
  final Type dtype = Float32x4;
}
