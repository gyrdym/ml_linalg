import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_encoded_values.dart';
import 'package:ml_linalg/src/vector/serialization/from_vector_json.dart';
import 'package:ml_linalg/src/vector/vector_json_keys.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

void main() {
  group('fromVectorJson', () {
    final data = <double>[12, 23, 44.0, -1e10, 10007.888, -10, 0, 7];
    final float32Json = {
      vectorDTypeJsonKey: dTypeFloat32EncodedValue,
      vectorDataJsonKey: data,
    };
    final float64Json = {
      vectorDTypeJsonKey: dTypeFloat64EncodedValue,
      vectorDataJsonKey: data,
    };
    final unknownJson = {
      vectorDTypeJsonKey: 'some_unknown_dtype',
      vectorDataJsonKey: data,
    };

    test('should decode serialized float32 vector', () {
      final vector = fromVectorJson(float32Json);

      expect(vector, iterableAlmostEqualTo(data, 1e-3));
      expect(vector.dtype, DType.float32);
    });

    test('should decode serialized float64 vector', () {
      final vector = fromVectorJson(float64Json);

      expect(vector, iterableAlmostEqualTo(data, 1e-3));
      expect(vector.dtype, DType.float64);
    });

    test('should throw an error if unknown decoded value is passed', () {
      final actual = () => fromVectorJson(unknownJson);

      expect(actual, throwsUnsupportedError);
    });
  });
}
