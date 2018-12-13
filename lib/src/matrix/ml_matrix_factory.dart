import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLMatrixFactory<E> {
  MLMatrix<E> createMatrixFrom(Iterable<Iterable<double>> source);
  MLMatrix<E> createMatrixFromFlattened(Iterable<double> source, int rowsNum, int columnsNum);
  MLMatrix<E> createMatrixFromRows(Iterable<MLVector<E>> source);
  MLMatrix<E> createMatrixFromColumns(Iterable<MLVector<E>> source);
}