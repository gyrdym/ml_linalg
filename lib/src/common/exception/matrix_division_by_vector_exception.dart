class MatrixDivisionByVectorException implements Exception {
  MatrixDivisionByVectorException(int rowsCount, int columnsCount, int vectorLength) :
        message = 'Cannot divide matrix of shape $rowsCount x $columnsCount matrix by a '
            'vector of length equals ${vectorLength}';

  final String message;

  @override
  String toString() => message;
}
