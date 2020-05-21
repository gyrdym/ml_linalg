import 'package:ml_linalg/dtype_to_json.dart';
import 'package:ml_linalg/src/vector/vector_json_keys.dart';
import 'package:ml_linalg/vector.dart';

Map<String, dynamic> vectorToJson(Vector vector) {
  final encodedDType = dTypeToJson(vector.dtype);
  final encodedData = vector.toList(growable: false);

  return <String, dynamic>{
    vectorDTypeJsonKey: encodedDType,
    vectorDataJsonKey: encodedData,
  };
}
