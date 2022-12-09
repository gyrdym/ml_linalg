abstract class CacheManager {
  T get<T>(
    String key,
    T Function() calculateIfAbsent, {
    bool skipCaching,
  });

  void clear();
}
