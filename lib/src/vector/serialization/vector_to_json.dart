import 'package:ml_linalg/dtype_to_json.dart';
import 'package:ml_linalg/src/vector/vector_json_keys.dart';
import 'package:ml_linalg/vector.dart';

/// Returns a json-serializable map for the [vector]
Map<String, dynamic> vectorToJson(Vector vector) {
  if (vector == null) {
    return null;
  }

  final encodedDType = dTypeToJson(vector.dtype);
  final encodedData = vector.toList(growable: false);

  return <String, dynamic>{
    vectorDTypeJsonKey: encodedDType,
    vectorDataJsonKey: encodedData,
  };
}
