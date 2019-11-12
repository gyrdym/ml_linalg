import 'package:injector/injector.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory_impl.dart';
import 'package:ml_linalg/src/di/injector.dart';
import 'package:ml_linalg/src/vector/simd_helper/simd_helper_factory.dart';
import 'package:ml_linalg/src/vector/simd_helper/simd_helper_factory_impl.dart';

Injector get dependencies => injector ??= Injector()
  ..registerSingleton<CacheManagerFactory>(
          (_) => const CacheManagerFactoryImpl())

  ..registerSingleton<SimdHelperFactory>(
          (_) => const SimdHelperFactoryImpl());
