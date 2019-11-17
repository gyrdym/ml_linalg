import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_factory.dart';
import 'package:ml_linalg/src/common/cache_manager/cache_manager_impl.dart';

class CacheManagerFactoryImpl implements CacheManagerFactory {
  const CacheManagerFactoryImpl();

  @override
  CacheManager create(Set<String> keys) => CacheManagerImpl(keys);
}
