class UnsupportedOperandTypeException implements Exception {
  UnsupportedOperandTypeException(Type operandType)
      : _message = 'Unsupported operand type: $operandType';

  final String _message;

  @override
  String toString() => _message;
}
