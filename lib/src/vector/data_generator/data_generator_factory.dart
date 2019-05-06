import 'package:ml_linalg/src/vector/common/simd_helper.dart';
import 'package:ml_linalg/src/vector/data_generator/data_generator.dart';

abstract class DataGeneratorFactory {
  DataGenerator create<E, S extends List<E>>(List<double> source,
      int bucketSize, SimdHelper<E, S> simdHelper);
}
