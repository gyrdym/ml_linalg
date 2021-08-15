class VectorsLengthMismatchException implements Exception {
  VectorsLengthMismatchException(int firstLength, int secondLength)
      : _message = 'Vectors length must be equal, '
            'the first vector\'s length is $firstLength, '
            'the second vector\'s length is $secondLength';

  final String _message;

  @override
  String toString() => _message;
}
