import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/matrix/iterator/float32_matrix_iterator.dart';

import 'matrix_iterator_test_group_factory.dart';

void main() {
  matrixIteratorTestGroupFactory(
    DType.float32,
    (data, rowsNum, colsNum) => Float32MatrixIterator(data, rowsNum, colsNum),
    (data) => Float32List.fromList(data),
  );
}
