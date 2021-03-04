import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory_impl.dart';
import 'package:ml_linalg/src/matrix/matrix_factory.dart';
import 'package:ml_linalg/src/matrix/matrix_factory_impl.dart';

MatrixFactory createMatrixFactory() {
  const cacheManagerFactory = CacheManagerFactoryImpl();

  return MatrixFactoryImpl(cacheManagerFactory);
}
