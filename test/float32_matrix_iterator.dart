import 'dart:typed_data';

import 'package:linalg/src/simd/matrix/float32/float32_matrix_iterator.dart';
import 'package:test/test.dart';

ByteData createByteData(Float32List source) => ByteData.view(source.buffer, 0, source.length);

Matcher floatIterableAlmostEqualTo(Iterable<double> expected, [double precision = 1e-3]) =>
    pairwiseCompare<double, double>(expected, (expectedVal, actualVal) => (expectedVal - actualVal) <= precision, '');

void main() {
  group('Float32MatrixIterator', () {
    test('should be created properly', () {
      // 3x3 matrix
      final source = Float32List.fromList([
        1.0, 2.0, 3.0,
        10.0, 22.0, 31.0,
        8.3, 3.4, 34.5
      ]);
      bool isActive;
      final data = createByteData(source);
      final iterator = Float32MatrixIterator(data, 3);

      isActive = iterator.moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([1.0, 2.0, 3.0]));
      expect(isActive, isTrue);

      isActive = iterator.moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([10.0, 22.0, 31.0]));
      expect(isActive, isTrue);

      isActive = iterator.moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([8.3, 3.4, 34.5]));
      expect(isActive, isTrue);

      isActive = iterator.moveNext();
      expect(iterator.current, isNull);
      expect(isActive, isFalse);
    });
  });
}
