import 'package:ml_linalg/src/common/cache_manager/cache_manager_impl.dart';
import 'package:test/test.dart';

void main() {
  group('CacheManagerImpl', () {
    final cacheKey = 'key_1';
    final cacheKeys = <String>{cacheKey};

    test('should calculate value if it is absent in the cache', () {
      final manager = CacheManagerImpl(cacheKeys);
      var calledTimes = 0;

      final value = manager.retrieveValue(cacheKey, () {
        calledTimes++;
        return 'value';
      });

      expect(calledTimes, 1);
      expect(value, 'value');
    });

    test('should return value from cache if it was calculated once', () {
      final manager = CacheManagerImpl(cacheKeys);
      final value = {'key': 'value'};
      var calledTimes = 0;

      final calculateIfAbsentFn = () {
        calledTimes++;
        return value;
      };

      final cachedValue1 = manager.retrieveValue(cacheKey, calculateIfAbsentFn);
      final cachedValue2 = manager.retrieveValue(cacheKey, calculateIfAbsentFn);
      final cachedValue3 = manager.retrieveValue(cacheKey, calculateIfAbsentFn);

      expect(calledTimes, 1);
      expect(cachedValue1, value);
      expect(cachedValue2, same(cachedValue1));
      expect(cachedValue3, same(cachedValue2));
    });

    test('should throw error if non existent key was accessed', () {
      final manager = CacheManagerImpl(cacheKeys);

      expect(() => manager.retrieveValue('non_existent_key', () => 'val'),
          throwsException);
    });
  });
}
