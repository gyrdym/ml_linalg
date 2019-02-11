import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/matrix/ml_matrix_validatior.dart';

abstract class MLMatrixValidatorMixin<E> implements MLMatrixValidator {
  @override
  void checkDimensions(MLMatrix first, MLMatrix second,
      {String errorTitle = 'Cannot perform the operation'}) {
    if (first.rowsNum != second.rowsNum ||
        first.columnsNum != second.columnsNum) {
      throw Exception('${errorTitle}: the matrices have different dimensions - '
          '(${first.rowsNum} x ${first.columnsNum}) and (${second.rowsNum} x ${second.columnsNum})');
    }
  }

  @override
  void checkColumnsAndRowsNumber(MLMatrix first, MLMatrix second,
      {String errorTitle = 'Cannot perform the operation'}) {
    if (first.columnsNum != second.rowsNum) {
      throw Exception(
          '$errorTitle: column number (${first.columnsNum}) of the first matrix is not equal to row '
          'number (${second.rowsNum}) of the second matrix');
    }
  }
}
