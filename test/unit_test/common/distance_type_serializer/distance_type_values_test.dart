import 'package:ml_linalg/src/common/distance_type_serializer/distance_type_encoded_values.dart';
import 'package:test/test.dart';

void main() {
  group('Distance type encoded values', () {
    test('should have a proper value for cosine distance', () {
      expect(cosineDistanceTypeEncodedValue, 'C');
    });

    test('should have a proper value for Euclidean distance', () {
      expect(euclideanDistanceTypeEncodedValue, 'E');
    });

    test('should have a proper value for hamming distance', () {
      expect(hammingDistanceTypeEncodedValue, 'H');
    });

    test('should have a proper value for Manhattan distance', () {
      expect(manhattanDistanceTypeEncodedValue, 'M');
    });
  });
}
