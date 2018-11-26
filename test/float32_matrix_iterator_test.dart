import 'dart:typed_data';

import 'package:linalg/src/matrix/float32_matrix_iterator.dart';
import 'package:test/test.dart';

import 'helpers/float_iterable_almost_equal_to.dart';

ByteData createByteData(Float32List source) => ByteData.view(source.buffer, 0, source.length);

void main() {
  group('Float32MatrixIterator', () {
    // 3x3 matrix
    final source = Float32List.fromList([
      1.0, 2.0, 3.0,
      10.0, 22.0, 31.0,
      8.3, 3.4, 34.5
    ]);

    test('should be created properly', () {
      final data = createByteData(source);
      final iterator = Float32MatrixIterator(data, 3);
      expect(iterator.current, isNull);
    });

    test('should return the next value on every `moveNext` method call (9 elements, 3 columns)', () {
      final data = createByteData(source);
      final iterator = Float32MatrixIterator(data, 3)
        ..moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([1.0, 2.0, 3.0]));

      iterator.moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([10.0, 22.0, 31.0]));

      iterator.moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([8.3, 3.4, 34.5]));

      iterator.moveNext();
      expect(iterator.current, isNull);
    });

    test('should return the next value on every `moveNext` method call (9 elements, 2 columns)', () {
      final data = createByteData(source);
      final iterator = Float32MatrixIterator(data, 2)
        ..moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([1.0, 2.0]));

      iterator.moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([3.0, 10.0]));

      iterator.moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([22.0, 31.0]));

      iterator.moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([8.3, 3.4]));

      iterator.moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([34.5]));

      iterator.moveNext();
      expect(iterator.current, isNull);
    });

    test('should return the next value on every `moveNext` method call (9 elements, 9 columns)', () {
      final data = createByteData(source);
      final iterator = Float32MatrixIterator(data, 9)
        ..moveNext();
      expect(iterator.current, floatIterableAlmostEqualTo([1.0, 2.0, 3.0, 10.0, 22.0, 31.0, 8.3, 3.4, 34.5]));

      iterator.moveNext();
      expect(iterator.current, isNull);
    });

    test('should return a proper boolean indicator after each `moveNext` call', () {
      final data = createByteData(source);
      final iterator = Float32MatrixIterator(data, 3);

      expect(iterator.moveNext(), isTrue);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.moveNext(), isFalse);
      expect(iterator.moveNext(), isFalse);
      expect(iterator.moveNext(), isFalse);
    });
  });
}
