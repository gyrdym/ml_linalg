import 'package:ml_linalg/matrix.dart';

mixin MatrixShapeValidationMixin {
  void validateMatricesShapeEquality(Matrix first, Matrix second,
      {String errorMessage = 'Cannot perform the operation'}) {
    if (first.rowCount != second.rowCount ||
        first.columnCount != second.columnCount) {
      throw Exception('$errorMessage: matrices have different shapes - '
          '(${first.rowCount} x ${first.columnCount}) and '
          '(${second.rowCount} x ${second.columnCount})');
    }
  }

  void validateMatricesMultEligibility(Matrix first, Matrix second,
      {String errorMessage = 'Cannot perform the operation'}) {
    if (first.columnCount != second.rowCount) {
      throw Exception(
          '$errorMessage: the column count (${first.columnCount}) of the first '
          'matrix is not equal to the row count (${second.rowCount}) of the '
          'second matrix');
    }
  }
}
