import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/src/common/distance_type_serializer/distance_type_encoded_values.dart';
import 'package:ml_linalg/src/common/distance_type_serializer/from_distance_type_json.dart';
import 'package:test/test.dart';

void main() {
  group('fromDistanceTypeJson', () {
    test('should decode cosine distance', () {
      expect(fromDistanceTypeJson(cosineDistanceTypeEncodedValue),
          Distance.cosine);
    });

    test('should decode Euclidean distance', () {
      expect(fromDistanceTypeJson(euclideanDistanceTypeEncodedValue),
          Distance.euclidean);
    });

    test('should decode hamming distance', () {
      expect(fromDistanceTypeJson(hammingDistanceTypeEncodedValue),
          Distance.hamming);
    });

    test('should decode Manhattan distance', () {
      expect(fromDistanceTypeJson(manhattanDistanceTypeEncodedValue),
          Distance.manhattan);
    });
  });
}
