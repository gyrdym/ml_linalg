import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_encoded_values.dart';
import 'package:ml_linalg/src/vector/vector_json_keys.dart';

Vector fromVectorJson(Map<String, dynamic> json) {
  final source = json[vectorDataJsonKey] as List<double>;

  switch(json[vectorDTypeJsonKey] as String) {
    case dTypeFloat32EncodedValue:
      return Vector.fromList(source, dtype: DType.float32);

    case dTypeFloat64EncodedValue:
      return Vector.fromList(source, dtype: DType.float32);

    default:
      throw UnsupportedError('Unknown dtype encoded value - '
          '${json[vectorDTypeJsonKey]}');
  }
}
