class CholeskyNonSquareMatrixException implements Exception {
  CholeskyNonSquareMatrixException(int rowsCount, int columnsCount)
      : message =
            'You are trying to decompose non square matrix, the matrix\' dimension is (${rowsCount}x$columnsCount). Only square matrices can be decomposed.';

  final String message;

  @override
  String toString() => message;
}
