import 'package:ml_linalg/range.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLMatrix<E, T extends MLVector<E>> {
  int get rowsNum;
  int get columnsNum;
  Iterable<double> operator [](int index);
  MLMatrix<E, T> operator +(Object value);
  MLMatrix<E, T> operator -(Object value);
  MLMatrix<E, T> operator *(Object value);
  MLMatrix<E, T> transpose();
  MLMatrix<E, T> submatrix({Range rows, Range columns});
  T getColumnVector(int index);
  T getRowVector(int index);
  T reduceColumns(T combiner(T combine, T vector), {T initValue});
  T reduceRows(T combiner(T combine, T vector), {T initValue});
  MLMatrix<E, T> mapColumns(E mapper(E columnElement));
  MLMatrix<E, T> mapRows(E mapper(E rowElement));
}
