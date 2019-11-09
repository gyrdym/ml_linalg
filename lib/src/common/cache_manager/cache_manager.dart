abstract class CacheManager {
  T retrieve<T>(String cachedValueName, T calculateIfAbsent());
  void clearCache();
}
