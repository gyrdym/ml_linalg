abstract class CacheManager {
  T retrieveValue<T>(String cachedValueName, T calculateIfAbsent(), {
    bool skipCaching,
  });

  void clearCache();
}
