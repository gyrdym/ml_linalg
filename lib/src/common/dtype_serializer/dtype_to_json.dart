import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_encoded_values.dart';

/// Encodes [dtype] to a json-serializable value
String? dTypeToJson(DType? dtype) {
  switch (dtype) {
    case DType.float32:
      return dTypeFloat32EncodedValue;

    case DType.float64:
      return dTypeFloat64EncodedValue;

    default:
      return null;
  }
}
