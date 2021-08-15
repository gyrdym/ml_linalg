class SquareMatrixDivisionByVectorException implements Exception {
  SquareMatrixDivisionByVectorException(int rowsCount, int columnsCount)
      : message = 'Division by a vector is ambiguous for squared matrices, '
            'the matrix\'s shape is ($rowsCount) by ($columnsCount)';

  final String message;

  @override
  String toString() => message;
}
