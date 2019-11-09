import 'package:ml_linalg/src/common/cache_manager/cache_manager.dart';

class CacheManagerImpl implements CacheManager {
  CacheManagerImpl(this._isCacheDisabled);

  final _cache = <String, dynamic>{};
  final bool _isCacheDisabled;

  @override
  T retrieve<T>(String cachedValueName, T Function() calculateIfAbsent) {
    var value = _cache[cachedValueName] as T;

    if (value == null) {
      value = calculateIfAbsent();

      if (!_isCacheDisabled) {
        value = value;
      }
    }

    return value;
  }

  @override
  void clearCache() => _cache.clear();
}
