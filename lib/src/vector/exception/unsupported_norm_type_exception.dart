class UnsupportedNormType implements Exception {
  UnsupportedNormType(dynamic norm) : _message = 'Unsupported norm type: $norm';

  final String _message;

  @override
  String toString() => _message;
}
