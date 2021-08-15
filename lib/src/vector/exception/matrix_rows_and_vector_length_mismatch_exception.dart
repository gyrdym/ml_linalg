class MatrixRowsAndVectorLengthMismatchException implements Exception {
  MatrixRowsAndVectorLengthMismatchException(int rowsCount, int length)
      : _message =
            'Matrix row count and vector length mismatch, vector length: $length, '
                'matrix row count: $rowsCount';

  final String _message;

  @override
  String toString() => _message;
}
