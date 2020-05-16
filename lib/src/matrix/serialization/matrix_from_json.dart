import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/src/common/dtype_serializer/from_dtype_json.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_json_keys.dart';

Matrix fromMatrixJson(Map<String, dynamic> json) {
  final list = json[dataJsonKey] as List<List<double>>;

  if (list == null) {
    throw Exception('Provided json is missing `$dataJsonKey` field');
  }

  final encodedDType = json[dTypeJsonKey] as String;

  if (encodedDType == null) {
    throw Exception('Provided json is missing `$dTypeJsonKey` field');
  }

  final dType = fromDTypeJson(encodedDType);

  return Matrix.fromList(list, dtype: dType);
}
