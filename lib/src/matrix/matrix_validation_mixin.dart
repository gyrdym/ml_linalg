import 'package:linalg/matrix.dart';
import 'package:linalg/vector.dart';

abstract class MatrixValidationMixin<E, T extends Vector<E>> {
  void checkDimensions(Matrix<E, T> first, Matrix<E, T> second,
      {String errorTitle = 'Cannot perform the operation'}) {
    if (first.rowsNum != second.rowsNum || first.columnsNum != second.columnsNum) {
      throw Exception('${errorTitle}: the matrices have different dimensions - '
          '(${first.rowsNum} x ${first.columnsNum}) and (${second.rowsNum} x ${second.columnsNum})');
    }
  }

  void checkColumnsAndRowsNumber(Matrix<E, T> first, Matrix<E, T> second,
      {String errorTitle = 'Cannot perform the operation'}) {
    if (first.columnsNum != second.rowsNum) {
      throw Exception('$errorTitle: column number (${first.columnsNum}) of the first matrix is not equal to row '
          'number (${second.rowsNum}) of the second matrix');
    }
  }
}
