import 'package:ml_linalg/norm.dart';

const vectorHashKey = 'hash';
const vectorSqrtKey = 'sqrt';
const vectorAbsKey = 'abs';
const vectorSumKey = 'sum';
const vectorProdKey = 'prod';
const vectorMeanKey = 'mean';
const vectorMedianKey = 'median';
const vectorExpKey = 'exp';
const vectorLogKey = 'log';
const vectorEuclideanNormKey = 'euclidean_norm';
const vectorManhattanNormKey = 'manhattan_norm';
const vectorMaxKey = 'max';
const vectorMinKey = 'min';
const vectorUniqueKey = 'unique';
const vectorEuclideanNormalizeKey = 'euclidean_normalize';
const vectorManhattanNormalizeKey = 'manhattan_normalize';
const vectorRescaleKey = 'rescale';

final vectorCacheKeys = <String>{
  vectorHashKey,
  vectorSqrtKey,
  vectorAbsKey,
  vectorSumKey,
  vectorProdKey,
  vectorMeanKey,
  vectorMedianKey,
  vectorExpKey,
  vectorLogKey,
  vectorEuclideanNormKey,
  vectorManhattanNormKey,
  vectorMaxKey,
  vectorMinKey,
  vectorUniqueKey,
  vectorEuclideanNormalizeKey,
  vectorManhattanNormalizeKey,
  vectorRescaleKey,
};

String getCacheKeyForNormByNormType(Norm normType) {
  switch (normType) {
    case Norm.euclidean:
      return vectorEuclideanNormKey;

    case Norm.manhattan:
      return vectorManhattanNormKey;

    default:
      throw UnsupportedError('Unsupported norm type `$normType`');
  }
}

String getCacheKeyForNormalizeByNormType(Norm normType) {
  switch (normType) {
    case Norm.euclidean:
      return vectorEuclideanNormalizeKey;

    case Norm.manhattan:
      return vectorManhattanNormalizeKey;

    default:
      throw UnsupportedError('Unsupported norm type `$normType`');
  }
}
