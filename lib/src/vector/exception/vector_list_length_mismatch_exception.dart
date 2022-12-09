class VectorListLengthMismatchException implements Exception {
  VectorListLengthMismatchException(int vectorLength, int listLength)
      : _message = 'The vector\'s and list\'s length must be equal, '
            'the vector\'s length is $vectorLength, '
            'the list\'s length is $listLength';

  final String _message;

  @override
  String toString() => _message;
}
