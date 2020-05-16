import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_encoded_values.dart';

DType fromDTypeJson(String json) {
  switch (json) {
    case dTypeFloat32EncodedValue:
      return DType.float32;

    case dTypeFloat64EncodedValue:
      return DType.float64;

    default:
      return null;
  }
}
