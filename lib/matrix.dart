import 'package:ml_linalg/range.dart';
import 'package:ml_linalg/vector.dart';

abstract class MLMatrix<E> {
  int get rowsNum;
  int get columnsNum;
  Iterable<double> operator [](int index);
  MLMatrix<E> operator +(Object value);
  MLMatrix<E> operator -(Object value);
  MLMatrix<E> operator *(Object value);
  MLMatrix<E> transpose();
  MLMatrix<E> submatrix({Range rows, Range columns});
  MLMatrix<E> pick({Iterable<Range> rowRanges, Iterable<Range> columnRanges});
  MLVector<E> getColumnVector(int index, {bool tryCache = true});
  MLVector<E> getRowVector(int index, {bool tryCache = true});
  MLVector<E> reduceColumns(MLVector<E> combiner(MLVector<E> combine, MLVector<E> vector), {MLVector<E> initValue});
  MLVector<E> reduceRows(MLVector<E> combiner(MLVector<E> combine, MLVector<E> vector), {MLVector<E> initValue});
  MLMatrix<E> vectorizedMap(E mapper(E columnElement));
  MLVector<E> toVector({bool mutable = false});
}
