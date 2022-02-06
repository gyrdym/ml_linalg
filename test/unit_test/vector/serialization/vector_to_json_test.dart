import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_encoded_values.dart';
import 'package:ml_linalg/src/vector/serialization/vector_to_json.dart';
import 'package:ml_linalg/src/vector/vector_json_keys.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

void main() {
  group('vectorToJson', () {
    final data = [1, 2, 3, 0.5, -100.5, 0.0];

    test('should handle null value', () {
      expect(vectorToJson(null), isNull);
    });

    test('should encode float32 vector', () {
      expect(
        vectorToJson(Vector.fromList(data, dtype: DType.float32)),
        {
          vectorDTypeJsonKey: dTypeFloat32EncodedValue,
          vectorDataJsonKey: data,
        },
      );
    });

    test('should encode empty float32 vector', () {
      expect(
        vectorToJson(Vector.empty(dtype: DType.float32)),
        {
          vectorDTypeJsonKey: dTypeFloat32EncodedValue,
          vectorDataJsonKey: [],
        },
      );
    });

    test('should encode float64 vector', () {
      expect(
        vectorToJson(Vector.fromList(data, dtype: DType.float64)),
        {
          vectorDTypeJsonKey: dTypeFloat64EncodedValue,
          vectorDataJsonKey: data,
        },
      );
    });

    test('should encode empty float64 vector', () {
      expect(
        vectorToJson(Vector.empty(dtype: DType.float64)),
        {
          vectorDTypeJsonKey: dTypeFloat64EncodedValue,
          vectorDataJsonKey: [],
        },
      );
    });
  });
}
