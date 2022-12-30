import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory_impl.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_impl.dart';
import 'package:test/test.dart';

void main() {
  group('CacheManagerFactoryImpl', () {
    test('should create a CacheManagerImpl instance', () {
      final keys = <String>{'key_1', 'key_2', 'key_3'};

      final cacheManagerFactory = const CacheManagerFactoryImpl();
      final manager = cacheManagerFactory.create(keys);

      expect(manager, isA<CacheManagerImpl>());
    });
  });
}
