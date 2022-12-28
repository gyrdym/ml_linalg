import 'dart:typed_data';

import 'package:ml_linalg/dtype.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';
import '../../../helpers.dart';

void matrixIteratorTestGroupFactory(
        DType dtype,
        Iterator<Iterable<double>> Function(
                Float32List data, int rowCount, int colCount)
            createIterator,
        List<double> Function(List<double> data) createSource) =>
    group(dtypeToMatrixIteratorTestTitle[dtype], () {
      // 3x3 matrix
      final data = Float32List.fromList(
          [1.0, 2.0, 3.0, 10.0, 22.0, 31.0, 8.3, 3.4, 34.5]);

      test(
          'should throw an error if one accesses `current` property before '
          '`moveNext` call', () {
        final iterator = createIterator(data, 3, 3);

        expect(() => iterator.current, throwsA(isA()));
      });

      test(
          'should return the next value on every `moveNext` method call (9 '
          'elements, 3 columns)', () {
        final iterator = createIterator(data, 3, 3)..moveNext();

        expect(iterator.current, iterableAlmostEqualTo([1.0, 2.0, 3.0]));

        iterator.moveNext();
        expect(iterator.current, iterableAlmostEqualTo([10.0, 22.0, 31.0]));

        iterator.moveNext();
        expect(iterator.current, iterableAlmostEqualTo([8.3, 3.4, 34.5]));
      });

      test(
          'should contain the last successful value in `current` field if '
          '`moveNext` returns `false`', () {
        final iterator = createIterator(data, 3, 3)
          ..moveNext()
          ..moveNext()
          ..moveNext()
          ..moveNext();

        expect(iterator.current, iterableAlmostEqualTo([8.3, 3.4, 34.5]));
      });

      test(
          'should return the next value on every `moveNext` method call (9 '
          'elements, 2 columns)', () {
        final iterator = createIterator(data, 5, 2)..moveNext();

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

      test(
          'should return the next value on every `moveNext` method call (9 '
          'elements, 9 columns)', () {
        final iterator = createIterator(data, 1, 9)..moveNext();
        expect(
            iterator.current,
            iterableAlmostEqualTo(
                [1.0, 2.0, 3.0, 10.0, 22.0, 31.0, 8.3, 3.4, 34.5]));
      });

      test(
          'should return a proper boolean indicator after each `moveNext` '
          'call', () {
        final iterator = createIterator(data, 3, 3);

        expect(iterator.moveNext(), isTrue);
        expect(iterator.moveNext(), isTrue);
        expect(iterator.moveNext(), isTrue);
        expect(iterator.moveNext(), isFalse);
        expect(iterator.moveNext(), isFalse);
        expect(iterator.moveNext(), isFalse);
      });
    });
