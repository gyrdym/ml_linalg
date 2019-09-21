import 'dart:typed_data';

import 'package:ml_linalg/src/common/float32_list_helper/float32_list_helper.dart';
import 'package:ml_linalg/src/matrix/common/matrix_iterator.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

ByteData createByteData(Float32List source) =>
    ByteData.view(source.buffer, 0, source.length);

void main() {
  group('MatrixIterator', () {
    // 3x3 matrix
    final source =
        Float32List.fromList([1.0, 2.0, 3.0, 10.0, 22.0, 31.0, 8.3, 3.4, 34.5]);

    test('should be created properly', () {
      final data = createByteData(source);
      final iterator = MatrixIterator(data, 3, 3, Float32ListHelper());
      expect(iterator.current, isNull);
    });

    test('should return the next value on every `moveNext` method call (9 '
        'elements, 3 columns)', () {
      final data = createByteData(source);
      final iterator = MatrixIterator(data, 3, 3, Float32ListHelper())
        ..moveNext();
      expect(iterator.current, iterableAlmostEqualTo([1.0, 2.0, 3.0]));

      iterator.moveNext();
      expect(iterator.current, iterableAlmostEqualTo([10.0, 22.0, 31.0]));

      iterator.moveNext();
      expect(iterator.current, iterableAlmostEqualTo([8.3, 3.4, 34.5]));

      iterator.moveNext();
      expect(iterator.current, isNull);
    });

    test('should return the next value on every `moveNext` method call (9 '
        'elements, 2 columns)', () {
      final data = createByteData(source);
      final iterator = MatrixIterator(data, 5, 2, Float32ListHelper())
        ..moveNext();
      expect(iterator.current, iterableAlmostEqualTo([1.0, 2.0]));

      iterator.moveNext();
      expect(iterator.current, iterableAlmostEqualTo([3.0, 10.0]));

      iterator.moveNext();
      expect(iterator.current, iterableAlmostEqualTo([22.0, 31.0]));

      iterator.moveNext();
      expect(iterator.current, iterableAlmostEqualTo([8.3, 3.4]));

      // ignore: unnecessary_lambdas
      expect(() => iterator.moveNext(), throwsRangeError);

      // ignore: unnecessary_lambdas
      expect(() => iterator.moveNext(), throwsRangeError);
    });

    test('should return the next value on every `moveNext` method call (9 '
        'elements, 9 columns)', () {
      final data = createByteData(source);
      final iterator = MatrixIterator(data, 1, 9, Float32ListHelper())
        ..moveNext();
      expect(
          iterator.current,
          iterableAlmostEqualTo(
              [1.0, 2.0, 3.0, 10.0, 22.0, 31.0, 8.3, 3.4, 34.5]));

      iterator.moveNext();
      expect(iterator.current, isNull);
    });

    test('should return a proper boolean indicator after each `moveNext` call',
        () {
      final data = createByteData(source);
      final iterator = MatrixIterator(data, 3, 3, Float32ListHelper());

      expect(iterator.moveNext(), isTrue);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.moveNext(), isTrue);
      expect(iterator.moveNext(), isFalse);
      expect(iterator.moveNext(), isFalse);
      expect(iterator.moveNext(), isFalse);
    });
  });
}
