import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

abstract class MatrixFactory {
  Matrix createMatrixFrom(Iterable<Iterable<double>> source);
  Matrix createMatrixFromFlattened(
      Iterable<double> source, int rowsNum, int columnsNum);
  Matrix createMatrixFromRows(Iterable<Vector> source);
  Matrix createMatrixFromColumns(Iterable<Vector> source);
}
