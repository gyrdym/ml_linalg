import 'package:linalg/src/matrix/range.dart';
import 'package:linalg/src/vector/vector.dart';

abstract class Matrix<E, T extends Vector<E>> {
  int get rowsNum;
  int get columnsNum;
  Iterable<double> operator [](int index);
  Matrix<E, T> submatrix(Range rowsRange, Range columnsRange);
  T getColumnVector(int index);
  T getRowVector(int index);
}
