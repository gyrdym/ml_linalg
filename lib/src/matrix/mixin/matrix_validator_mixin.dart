import 'package:ml_linalg/matrix.dart';

mixin MatrixValidatorMixin {
  void checkShape(Matrix first, Matrix second,
      {String errorMessage = 'Cannot perform the operation'}) {
    if (first.rowCount != second.rowCount ||
        first.colCount != second.colCount) {
      throw Exception('$errorMessage: matrices have different shapes - '
          '(${first.rowCount} x ${first.colCount}) and '
          '(${second.rowCount} x ${second.colCount})');
    }
  }

  void checkColumnsAndRowsNumber(Matrix first, Matrix second,
      {String errorMessage = 'Cannot perform the operation'}) {
    if (first.colCount != second.rowCount) {
      throw Exception(
          '$errorMessage: column number (${first.colCount}) of the first '
          'matrix is not equal to row number (${second.rowCount}) of the '
          'second matrix');
    }
  }
}
