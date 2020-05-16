import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_json_keys.dart';

Map<String, dynamic> matrixToJson(Matrix matrix) => <String, dynamic>{
  dTypeJsonKey: matrix.dtype,
  dataJsonKey: matrix.toList(),
};
