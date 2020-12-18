import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/src/common/distance_type_serializer/distance_type_encoded_values.dart';

String distanceTypeToJson(Distance distance) {
  switch (distance) {
    case Distance.cosine:
      return cosineDistanceTypeEncodedValue;

    case Distance.hamming:
      return hammingDistanceTypeEncodedValue;

    case Distance.euclidean:
      return euclideanDistanceTypeEncodedValue;

    case Distance.manhattan:
      return manhattanDistanceTypeEncodedValue;

    default:
      throw UnsupportedError('Unsupported distance type $distance');
  }
}
