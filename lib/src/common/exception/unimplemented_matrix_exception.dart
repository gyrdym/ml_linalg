import 'package:ml_linalg/dtype.dart';

class UnimplementedMatrixException implements Exception {
  UnimplementedMatrixException(DType type, {String operationName = ''})
      : _message = 'Matrix of type $type is not implemented';

  final String _message;

  @override
  String toString() => _message;
}
