import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_to_json.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_json_keys.dart';

Map<String, dynamic> matrixToJson(Matrix matrix) => <String, dynamic>{
  matrixDTypeJsonKey: dTypeToJson(matrix.dtype),
  matrixDataJsonKey: matrix.toList(),
};
