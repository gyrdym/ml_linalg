import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';

class CacheManagerImpl implements CacheManager {
  CacheManagerImpl(this._keys);

  final _cache = <String, dynamic>{};
  final Set<String> _keys;

  @override
  T retrieveValue<T>(String key, T Function() calculateIfAbsent, {
    bool skipCaching = false,
  }) {
    if (!_keys.contains(key)) {
      throw Exception('Cache key `$key` is not registered');
    }
    
    var value = _cache[key] as T;

    if (value == null) {
      value = calculateIfAbsent();

      if (!skipCaching) {
        _cache[key] = value;
      }
    }

    return value;
  }

  @override
  void clearCache() => _cache.clear();
}
