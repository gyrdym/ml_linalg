import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';

class CacheManagerImpl implements CacheManager {
  final _cache = <String, dynamic>{};

  @override
  T retrieve<T>(String cachedValueName, T Function() calculateIfAbsent, {
    bool skipCaching = false,
  }) {
    var value = _cache[cachedValueName] as T;

    if (value == null) {
      value = calculateIfAbsent();

      if (!skipCaching) {
        _cache[cachedValueName] = value;
      }
    }

    return value;
  }

  @override
  void clearCache() => _cache.clear();
}
