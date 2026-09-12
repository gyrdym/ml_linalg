import 'package:ml_linalg/src/common/hash/finalize_hash.dart';
import 'package:test/test.dart';

void main() {
  group('finalizeHash', () {
    test('should be deterministic', () {
      expect(finalizeHash(123), finalizeHash(123));
    });

    test('should stay within the 31-bit mask', () {
      final hash = finalizeHash(0x1fffffff);

      expect(hash, lessThanOrEqualTo(0x1fffffff));
      expect(hash, greaterThanOrEqualTo(0));
    });

    test('should change when the input hash changes', () {
      expect(finalizeHash(1), isNot(finalizeHash(2)));
    });

    test('should avalanche a one-bit input change across the result', () {
      final left = finalizeHash(1);
      final right = finalizeHash(2);
      final xor = left ^ right;
      var changedBits = 0;

      for (var bit = 0; bit < 31; bit++) {
        if ((xor & (1 << bit)) != 0) {
          changedBits++;
        }
      }

      expect(changedBits, greaterThan(1));
    });

    test('should map zero to a stable non-negative value', () {
      final hash = finalizeHash(0);

      expect(hash, greaterThanOrEqualTo(0));
      expect(hash, lessThanOrEqualTo(0x1fffffff));
    });
  });
}
