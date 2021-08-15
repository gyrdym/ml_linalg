class UnsupportedDistanceTypeException implements Exception {
  UnsupportedDistanceTypeException(dynamic distance)
      : _message = 'Unsupported distance type: $distance';

  final String _message;

  @override
  String toString() => _message;
}
