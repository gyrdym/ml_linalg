import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/matrix/float32x4/float32x4_matrix.dart';
import 'package:ml_linalg/src/matrix/matrix_factory.dart';
import 'package:ml_linalg/vector.dart';

abstract class Float32x4MatrixFactoryMixin implements MatrixFactory {
  @override
  Matrix createMatrixFrom(Iterable<Iterable<double>> source) =>
      Float32x4Matrix.from(source);

  @override
  Matrix createMatrixFromFlattened(
          Iterable<double> source, int rowsNum, int columnsNum) =>
      Float32x4Matrix.flattened(source, rowsNum, columnsNum);

  @override
  Matrix createMatrixFromRows(Iterable<Vector> source) =>
      Float32x4Matrix.rows(source);

  @override
  Matrix createMatrixFromColumns(Iterable<Vector> source) =>
      Float32x4Matrix.columns(source);
}
