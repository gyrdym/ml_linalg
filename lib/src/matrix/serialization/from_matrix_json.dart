import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/src/common/dtype_serializer/from_dtype_json.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_json_keys.dart';

Matrix fromMatrixJson(Map<String, dynamic> json) {
  final list = json[matrixDataJsonKey] as List<List<double>>;

  if (list == null) {
    throw Exception('Provided json is missing `$matrixDataJsonKey` field');
  }

  final encodedDType = json[matrixDTypeJsonKey] as String;

  if (encodedDType == null) {
    throw Exception('Provided json is missing `$matrixDTypeJsonKey` field');
  }

  final dType = fromDTypeJson(encodedDType);

  return Matrix.fromList(list, dtype: dType);
}
