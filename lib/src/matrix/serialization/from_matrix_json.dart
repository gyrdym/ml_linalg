import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/common/dtype_serializer/from_dtype_json.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_json_keys.dart';

/// Restores a matrix instance from given [json]
Matrix? fromMatrixJson(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }

  final matrixSource = json[matrixDataJsonKey] as List<dynamic>?;

  if (matrixSource == null) {
    throw Exception('Provided json is missing `$matrixDataJsonKey` field');
  }

  final double2dList = matrixSource
      .map((dynamic row) => (row as List<dynamic>)
          .map((dynamic element) => double.parse(element.toString()))
          .toList(growable: false))
      .toList(growable: false);

  final encodedDType = json[matrixDTypeJsonKey] as String?;

  if (encodedDType == null) {
    throw Exception('Provided json is missing `$matrixDTypeJsonKey` field');
  }

  final dType = fromDTypeJson(encodedDType);

  return Matrix.fromList(double2dList, dtype: dType!);
}
