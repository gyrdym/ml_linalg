import 'package:ml_linalg/matrix.dart';

mixin MatrixValidatorMixin {
  void checkShape(Matrix first, Matrix second,
      {String errorMessage = 'Cannot perform the operation'}) {
    if (first.rowCount != second.rowCount ||
        first.columnCount != second.columnCount) {
      throw Exception('$errorMessage: matrices have different shapes - '
          '(${first.rowCount} x ${first.columnCount}) and '
          '(${second.rowCount} x ${second.columnCount})');
    }
  }

  void checkColumnsAndRowsNumber(Matrix first, Matrix second,
      {String errorMessage = 'Cannot perform the operation'}) {
    if (first.columnCount != second.rowCount) {
      throw Exception(
          '$errorMessage: column number (${first.columnCount}) of the first '
          'matrix is not equal to row number (${second.rowCount}) of the '
          'second matrix');
    }
  }
}
