import 'package:ml_linalg/distance.dart';
import 'package:ml_linalg/src/common/distance_type_serializer/distance_type_encoded_values.dart';

Distance fromDistanceTypeJson(String encodedValue) {
  switch (encodedValue) {
    case cosineDistanceTypeEncodedValue:
      return Distance.cosine;

    case euclideanDistanceTypeEncodedValue:
      return Distance.euclidean;

    case hammingDistanceTypeEncodedValue:
      return Distance.hamming;

    case manhattanDistanceTypeEncodedValue:
      return Distance.manhattan;

    default:
      throw UnsupportedError('Unsupported distance type encoded value '
          '$encodedValue');
  }
}
