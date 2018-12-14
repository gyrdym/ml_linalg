import 'dart:typed_data';

import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/matrix/float32/float32x4_matrix.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_factory.dart';
import 'package:ml_linalg/vector.dart';

abstract class Float32x4MatrixFactoryMixin implements MLMatrixFactory<Float32x4> {
  @override
  MLMatrix<Float32x4> createMatrixFrom(Iterable<Iterable<double>> source) =>
      Float32x4MatrixInternal.from(source);

  @override
  MLMatrix<Float32x4> createMatrixFromFlattened(Iterable<double> source, int rowsNum, int columnsNum) =>
      Float32x4MatrixInternal.flattened(source, rowsNum, columnsNum);

  @override
  MLMatrix<Float32x4> createMatrixFromRows(Iterable<MLVector<Float32x4>> source) =>
      Float32x4MatrixInternal.rows(source);

  @override
  MLMatrix<Float32x4> createMatrixFromColumns(Iterable<MLVector<Float32x4>> source) =>
      Float32x4MatrixInternal.columns(source);
}