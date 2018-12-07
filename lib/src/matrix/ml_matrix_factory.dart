import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLMatrixFactory<E> {
  MLMatrix<E> matrixFrom(Iterable<Iterable<double>> source);
  MLMatrix<E> matrixFlattened(Iterable<double> source, int rowsNum, int columnsNum);
  MLMatrix<E> matrixRows(Iterable<MLVector<E>> source);
  MLMatrix<E> matrixColumns(Iterable<MLVector<E>> source);
}