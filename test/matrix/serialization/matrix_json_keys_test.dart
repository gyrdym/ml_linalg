import 'package:ml_linalg/src/matrix/serialization/matrix_json_keys.dart';
import 'package:test/test.dart';

void main() {
  group('Matrix json keys', () {
    test('should contain a proper key for dtype field', () {
      expect(matrixDTypeJsonKey, 'DT');
    });

    test('should contain a proper key for data field', () {
      expect(matrixDataJsonKey, 'D');
    });
  });
}
