import 'package:ml_linalg/src/common/hash/mix_hash.dart';
import 'package:test/test.dart';

void main() {
  group('mixHash', () {
    test('should be deterministic', () {
      expect(mixHash(1, 2), mixHash(1, 2));
    });

    test('should stay within the 31-bit mask', () {
      final hash = mixHash(0x1fffffff, 0x1fffffff);

      expect(hash, lessThanOrEqualTo(0x1fffffff));
      expect(hash, greaterThanOrEqualTo(0));
    });

    test('should change when the mixed value changes', () {
      expect(mixHash(10, 1), isNot(mixHash(10, 2)));
    });

    test('should change when the seed hash changes', () {
      expect(mixHash(1, 10), isNot(mixHash(2, 10)));
    });

    test('should avalanche a one-bit input change across the result', () {
      final left = mixHash(0, 1);
      final right = mixHash(0, 2);
      final xor = left ^ right;
      var changedBits = 0;

      for (var bit = 0; bit < 31; bit++) {
        if ((xor & (1 << bit)) != 0) {
          changedBits++;
        }
      }

      expect(changedBits, greaterThan(1));
    });
  });
}
