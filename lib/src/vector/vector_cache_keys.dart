import 'package:ml_linalg/norm.dart';

const hashKey = 'hash';
const sqrtKey = 'sqrt';
const absKey = 'abs';
const sumKey = 'sum';
const meanKey = 'mean';
const euclideanNormKey = 'euclidean_norm';
const manhattanNormKey = 'manhattan_norm';
const maxKey = 'max';
const minKey = 'min';
const uniqueKey = 'unique';
const euclideanNormalizeKey = 'euclidean_normalize';
const manhattanNormalizeKey = 'manhattan_normalize';
const rescaleKey = 'rescale';

final vectorCacheKeys = Set<String>.from(<String>[
  hashKey,
  sqrtKey,
  absKey,
  sumKey,
  meanKey,
  euclideanNormKey,
  manhattanNormKey,
  maxKey,
  minKey,
  uniqueKey,
  euclideanNormalizeKey,
  manhattanNormalizeKey,
  rescaleKey,
]);

String getCacheKeyForNormByNormType(Norm normType) {
  switch (normType) {
    case Norm.euclidean:
      return euclideanNormKey;

    case Norm.manhattan:
      return manhattanNormKey;

    default:
      throw UnsupportedError('Unsupported norm type `$normType`');
  }
}

String getCacheKeyForNormalizeByNormType(Norm normType) {
  switch (normType) {
    case Norm.euclidean:
      return euclideanNormalizeKey;

    case Norm.manhattan:
      return manhattanNormalizeKey;

    default:
      throw UnsupportedError('Unsupported norm type `$normType`');
  }
}
