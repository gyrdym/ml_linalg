import 'package:injector/injector.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory_impl.dart';
import 'package:ml_linalg/src/di/injector.dart';
import 'package:ml_linalg/src/matrix/matrix_factory.dart';
import 'package:ml_linalg/src/matrix/matrix_factory_impl.dart';

Injector get dependencies => injector ??= Injector()
  ..registerSingleton<CacheManagerFactory>(
          (_) => const CacheManagerFactoryImpl())

  ..registerSingleton<MatrixFactory>((injector) {
    final cacheManagerFactory = injector.getDependency<CacheManagerFactory>();
    return MatrixFactoryImpl(cacheManagerFactory);
  });
