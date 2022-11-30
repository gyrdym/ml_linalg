class UnsupportedOperandTypeException implements Exception {
  UnsupportedOperandTypeException(Type operandType, {String operationName = ''})
      : _message =
            '${operationName.isNotEmpty ? '${operationName}, ' : ''}Unsupported operand type: $operandType';

  final String _message;

  @override
  String toString() => _message;
}
