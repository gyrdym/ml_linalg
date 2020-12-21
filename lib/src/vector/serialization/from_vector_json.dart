import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_encoded_values.dart';
import 'package:ml_linalg/src/vector/vector_json_keys.dart';

/// Restores a vector instance from the given [json]
Vector fromVectorJson(Map<String, dynamic> json) {
  if (json == null) {
    return null;
  }

  final source = (json[vectorDataJsonKey] as List)
      .map((dynamic value) => double.parse(value.toString()))
      .toList(growable: false);

  switch(json[vectorDTypeJsonKey] as String) {
    case dTypeFloat32EncodedValue:
      return Vector.fromList(source, dtype: DType.float32);

    case dTypeFloat64EncodedValue:
      return Vector.fromList(source, dtype: DType.float64);

    default:
      throw UnsupportedError('Unknown dtype encoded value - '
          '${json[vectorDTypeJsonKey]}');
  }
}
