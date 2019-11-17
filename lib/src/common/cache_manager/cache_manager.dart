abstract class CacheManager {
  T retrieveValue<T>(String key, T calculateIfAbsent(), {
    bool skipCaching,
  });

  void clearCache();
}
