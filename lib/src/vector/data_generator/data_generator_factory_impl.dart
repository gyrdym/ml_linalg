import 'package:ml_linalg/src/vector/common/simd_helper.dart';
import 'package:ml_linalg/src/vector/data_generator/data_generator.dart';
import 'package:ml_linalg/src/vector/data_generator/data_generator_factory.dart';
import 'package:ml_linalg/src/vector/data_generator/data_generator_impl.dart';

class DataGeneratorFactoryImpl implements DataGeneratorFactory {
  const DataGeneratorFactoryImpl();

  @override
  DataGenerator<E, S> create<E, S extends List<E>>(List<double> source,
      int bucketSize, SimdHelper<E, S> simdHelper) =>
      DataGeneratorImpl<E, S>(source, bucketSize, simdHelper);
}
