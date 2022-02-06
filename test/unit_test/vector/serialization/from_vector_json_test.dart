import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/from_vector_json.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_encoded_values.dart';
import 'package:ml_linalg/src/vector/vector_json_keys.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

void main() {
  group('fromVectorJson', () {
    final data = [10, 20, 33, 55.5, 56.3, 32];

    test('should handle null value', () {
      expect(fromVectorJson(null), isNull);
    });

    test('should decode float32 vector', () {
      expect(
          fromVectorJson({
            vectorDataJsonKey: data,
            vectorDTypeJsonKey: dTypeFloat32EncodedValue,
          }),
          Vector.fromList(data, dtype: DType.float32));
    });

    test('should decode empty float32 vector', () {
      expect(
          fromVectorJson({
            vectorDataJsonKey: [],
            vectorDTypeJsonKey: dTypeFloat32EncodedValue,
          }),
          Vector.fromList([], dtype: DType.float32));
    });

    test('should decode float64 vector', () {
      expect(
          fromVectorJson({
            vectorDataJsonKey: data,
            vectorDTypeJsonKey: dTypeFloat64EncodedValue,
          }),
          Vector.fromList(data, dtype: DType.float64));
    });

    test('should decode empty float64 vector', () {
      expect(
          fromVectorJson({
            vectorDataJsonKey: [],
            vectorDTypeJsonKey: dTypeFloat64EncodedValue,
          }),
          Vector.fromList([], dtype: DType.float64));
    });

    test('should throw error if it is impossible to decode dtype field', () {
      expect(
          () => fromVectorJson({
                vectorDataJsonKey: [],
                vectorDTypeJsonKey: 'some_strange_string'
              }),
          throwsUnsupportedError);
    });
  });
}
