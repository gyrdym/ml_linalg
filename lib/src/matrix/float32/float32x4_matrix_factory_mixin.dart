import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/matrix/float32/float32x4_matrix.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_factory.dart';
import 'package:ml_linalg/vector.dart';

abstract class Float32x4MatrixFactoryMixin implements MLMatrixFactory {
  @override
  MLMatrix createMatrixFrom(Iterable<Iterable<double>> source) =>
      Float32x4Matrix.from(source);

  @override
  MLMatrix createMatrixFromFlattened(Iterable<double> source, int rowsNum, int columnsNum) =>
      Float32x4Matrix.flattened(source, rowsNum, columnsNum);

  @override
  MLMatrix createMatrixFromRows(Iterable<MLVector> source) =>
      Float32x4Matrix.rows(source);

  @override
  MLMatrix createMatrixFromColumns(Iterable<MLVector> source) =>
      Float32x4Matrix.columns(source);
}