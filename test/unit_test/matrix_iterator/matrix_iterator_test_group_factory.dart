import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_almost_equal_to.dart';
import 'package:test/test.dart';

import '../../dtype_to_title.dart';

void matrixIteratorTestGroupFactory(DType dtype,
    Iterator<Iterable<double>> createIterator(ByteData data, int rowsNum,
        int colsNum),
    List<double> createSource(List<double> data)) =>

    group(dtypeToMatrixIteratorTestTitle[dtype], () {
      ByteData createByteData(List<double> source) =>
          ByteData.view((source as TypedData).buffer, 0, source.length);

      // 3x3 matrix
      final source =
        createSource([1.0, 2.0, 3.0, 10.0, 22.0, 31.0, 8.3, 3.4, 34.5]);

      test('should initilize with `current` property equals `null`', () {
        final data = createByteData(source);
        final iterator = createIterator(data, 3, 3);

        expect(iterator.current, isNull);
      });

      test('should return the next value on every `moveNext` method call (9 '
          'elements, 3 columns)', () {
        final data = createByteData(source);

        final iterator = createIterator(data, 3, 3)
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
        final iterator = createIterator(data, 5, 2)
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
        final iterator = createIterator(data, 1, 9)
          ..moveNext();
        expect(
            iterator.current,
            iterableAlmostEqualTo(
                [1.0, 2.0, 3.0, 10.0, 22.0, 31.0, 8.3, 3.4, 34.5]));

        iterator.moveNext();

        expect(iterator.current, isNull);
      });

      test('should return a proper boolean indicator after each `moveNext` '
          'call', () {
            final data = createByteData(source);
            final iterator = createIterator(data, 3, 3);

            expect(iterator.moveNext(), isTrue);
            expect(iterator.moveNext(), isTrue);
            expect(iterator.moveNext(), isTrue);
            expect(iterator.moveNext(), isFalse);
            expect(iterator.moveNext(), isFalse);
            expect(iterator.moveNext(), isFalse);
          });
    });
