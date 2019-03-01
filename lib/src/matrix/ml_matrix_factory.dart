import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLMatrixFactory {
  MLMatrix createMatrixFrom(Iterable<Iterable<double>> source);
  MLMatrix createMatrixFromFlattened(
      Iterable<double> source, int rowsNum, int columnsNum);
  MLMatrix createMatrixFromRows(Iterable<Vector> source);
  MLMatrix createMatrixFromColumns(Iterable<Vector> source);
}
