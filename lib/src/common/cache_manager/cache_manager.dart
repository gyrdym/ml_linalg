abstract class CacheManager {
  T retrieveValue<T>(String key, T Function() calculateIfAbsent, {
    bool skipCaching,
  });

  void clearCache();
}
