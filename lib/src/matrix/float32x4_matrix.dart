import 'dart:core';
import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/matrix/base_matrix.dart';
import 'package:ml_linalg/src/matrix/byte_data_helpers/float32_byte_data_helpers.dart';
import 'package:ml_linalg/src/matrix/data_manager/data_manager_impl.dart';
import 'package:ml_linalg/vector.dart';

class Float32x4Matrix extends BaseMatrix {
  Float32x4Matrix.from(List<List<double>> source) :
        super(DataManagerImpl.from(
          source,
          Float32List.bytesPerElement,
          DType.float32,
          bufferToFloat32List));

  Float32x4Matrix.columns(List<Vector> source) :
        super(DataManagerImpl.fromColumns(
          source,
          Float32List.bytesPerElement,
          DType.float32,
          bufferToFloat32List));

  Float32x4Matrix.rows(List<Vector> source) :
        super(DataManagerImpl.fromRows(
          source,
          Float32List.bytesPerElement,
          DType.float32,
          bufferToFloat32List));

  Float32x4Matrix.flattened(List<double> source, int rowsNum,
      int columnsNum) :
        super(DataManagerImpl.fromFlattened(
          source,
          rowsNum,
          columnsNum,
          Float32List.bytesPerElement,
          DType.float32,
          bufferToFloat32List));

  @override
  final DType dtype = DType.float32;
}
