class QRDecompositionNonSquareMatrixException implements Exception {
  QRDecompositionNonSquareMatrixException(int rowsCount, int columnsCount)
      : message =
            'QR decomposition: You are trying to decompose non square matrix, the matrix\' dimension is (${rowsCount}x$columnsCount). Only square matrices can be decomposed.';

  final String message;

  @override
  String toString() => message;
}
