import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/src/common/distance_type_serializer/distance_type_encoded_values.dart';
import 'package:ml_linalg/src/common/distance_type_serializer/ditance_type_to_json.dart';
import 'package:test/test.dart';

void main() {
  group('distanceTypeToJson', () {
    test('should encode cosine distance', () {
      expect(
          distanceTypeToJson(Distance.cosine), cosineDistanceTypeEncodedValue);
    });

    test('should encode Euclidean distance', () {
      expect(distanceTypeToJson(Distance.euclidean),
          euclideanDistanceTypeEncodedValue);
    });

    test('should encode hamming distance', () {
      expect(distanceTypeToJson(Distance.hamming),
          hammingDistanceTypeEncodedValue);
    });

    test('should encode Manhattan distance', () {
      expect(distanceTypeToJson(Distance.manhattan),
          manhattanDistanceTypeEncodedValue);
    });
  });
}
