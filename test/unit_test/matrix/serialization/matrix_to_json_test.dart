import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/common/dtype_serializer/dtype_encoded_values.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_json_keys.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_to_json.dart';
import 'package:test/test.dart';

void main() {
  group('matrixToJson', () {
    final source = <List<double>>[
      [1, -900, 3000, 12, 9],
      [0, 0, 123000, 7, 100009],
    ];
    final emptySource = <List<double>>[];

    final float32Matrix = Matrix.fromList(source, dtype: DType.float32);
    final float64Matrix = Matrix.fromList(source, dtype: DType.float64);
    final float32EmptyMatrix =
        Matrix.fromList(emptySource, dtype: DType.float32);

    test('should serialize float32 matrix', () {
      final encoded = matrixToJson(float32Matrix);
      expect(encoded, {
        matrixDTypeJsonKey: dTypeFloat32EncodedValue,
        matrixDataJsonKey: source,
      });
    });

    test('should serialize float64 matrix', () {
      final encoded = matrixToJson(float64Matrix);
      expect(encoded, {
        matrixDTypeJsonKey: dTypeFloat64EncodedValue,
        matrixDataJsonKey: source,
      });
    });

    test('should serialize empty matrix', () {
      final encoded = matrixToJson(float32EmptyMatrix);
      expect(encoded, {
        matrixDTypeJsonKey: dTypeFloat32EncodedValue,
        matrixDataJsonKey: emptySource,
      });
    });

    test('should handle null value', () {
      final encoded = matrixToJson(null);
      expect(encoded, isNull);
    });
  });
}
