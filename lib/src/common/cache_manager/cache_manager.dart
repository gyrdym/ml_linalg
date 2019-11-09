abstract class CacheManager {
  T retrieve<T>(String cachedValueName, T calculateIfAbsent(), {
    bool skipCaching,
  });

  void clearCache();
}
