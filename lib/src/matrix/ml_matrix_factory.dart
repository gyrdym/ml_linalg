import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLMatrixFactory<E> {
  MLMatrix<E> fromIterable(Iterable<Iterable<double>> source);
  MLMatrix<E> fromFlattenedIterable(Iterable<double> source, int rowsNum, int columnsNum);
  MLMatrix<E> fromRows(Iterable<MLVector<E>> source);
  MLMatrix<E> fromColumns(Iterable<MLVector<E>> source);
}