import 'dart:core';
import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/common/float32_list_helper/float32_list_helper.dart';
import 'package:ml_linalg/src/matrix/base_matrix.dart';
import 'package:ml_linalg/src/matrix/common/data_manager/data_manager_impl.dart';
import 'package:ml_linalg/vector.dart';

class Float32Matrix extends BaseMatrix {
  Float32Matrix.from(List<List<double>> source) :
        super(DataManagerImpl.from(
          source,
          Float32List.bytesPerElement,
          DType.float32,
          Float32ListHelper()));

  Float32Matrix.columns(List<Vector> source) :
        super(DataManagerImpl.fromColumns(
          source,
          Float32List.bytesPerElement,
          DType.float32,
          Float32ListHelper()));

  Float32Matrix.rows(List<Vector> source) :
        super(DataManagerImpl.fromRows(
          source,
          Float32List.bytesPerElement,
          DType.float32,
          Float32ListHelper()));

  Float32Matrix.flattened(List<double> source, int rowsNum,
      int columnsNum) :
        super(DataManagerImpl.fromFlattened(
          source,
          rowsNum,
          columnsNum,
          Float32List.bytesPerElement,
          DType.float32,
          Float32ListHelper()));

  @override
  final DType dtype = DType.float32;
}