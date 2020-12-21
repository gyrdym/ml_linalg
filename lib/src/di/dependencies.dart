import 'package:injector/injector.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory_impl.dart';
import 'package:ml_linalg/src/di/injector.dart';
import 'package:ml_linalg/src/matrix/matrix_factory.dart';
import 'package:ml_linalg/src/matrix/matrix_factory_impl.dart';
import 'package:ml_linalg/src/matrix/serialization/from_matrix_json.dart';
import 'package:ml_linalg/src/matrix/serialization/from_matrix_json_impl.dart';
import 'package:ml_linalg/src/matrix/serialization/matrix_to_json.dart';

Injector get dependencies => injector ??= Injector()
  ..registerSingleton<CacheManagerFactory>(
          () => const CacheManagerFactoryImpl())

  ..registerSingleton<MatrixFactory>(() {
    final cacheManagerFactory = injector.get<CacheManagerFactory>();

    return MatrixFactoryImpl(cacheManagerFactory);
  })

  ..registerDependency<FromMatrixJsonFn>(() => fromMatrixJson)

  ..registerDependency<MatrixToJsonFn>(() => matrixToJson);
