import 'package:linalg/src/matrix/range.dart';
import 'package:linalg/src/vector/vector.dart';

abstract class Matrix<E, T extends Vector<E>> {
  int get rowsNum;
  int get columnsNum;
  Matrix<E, T> operator *(Object value);
  Iterable<double> operator [](int index);
//  Matrix<E, T> transpose();
  Matrix<E, T> submatrix({Range rows, Range columns});
  T getColumnVector(int index);
  T getRowVector(int index);
  T reduceColumns(T combiner(T combine, T vector), {T initValue});
  T reduceRows(T combiner(T combine, T vector), {T initValue});
}
