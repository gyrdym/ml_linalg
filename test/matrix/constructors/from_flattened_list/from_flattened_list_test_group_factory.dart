import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixFromFlattenedListConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('fromFlattenedList constructor', () {
        test(
            'should create an instance from a flattened collection, 2x3 matrix',
            () {
          final actual = Matrix.fromFlattenedList(
              [1.0, 2.0, 3.0, 4.0, 5.0, 6.0], 2, 3,
              dtype: dtype);

          final expected = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
          ];

          expect(actual.rowCount, 2);
          expect(actual.columnCount, 3);
          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test(
            'should create an instance from a flattened collection. 2x3 matrix, collection length is 2x3+1',
            () {
          final actual = Matrix.fromFlattenedList(
              [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0], 2, 3,
              dtype: dtype);

          final expected = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
          ];

          expect(actual.rowCount, 2);
          expect(actual.columnCount, 3);
          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test(
            'should create an instance from a flattened collection, 1x3 matrix',
            () {
          final actual =
              Matrix.fromFlattenedList([1.0, 2.0, 3.0], 1, 3, dtype: dtype);

          final expected = [
            [1.0, 2.0, 3.0],
          ];

          expect(actual.rowCount, 1);
          expect(actual.columnCount, 3);
          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test(
            'should create an instance from a flattened collection, 1x5 matrix',
            () {
          final actual = Matrix.fromFlattenedList(
              [1.0, 2.0, 3.0, 4.0, 5.0], 1, 5,
              dtype: dtype);

          final expected = [
            [1.0, 2.0, 3.0, 4.0, 5.0],
          ];

          expect(actual.rowCount, 1);
          expect(actual.columnCount, 5);
          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test(
            'should create an instance from a flattened collection, 1x5 matrix, collection length is 1x5+2',
            () {
          final actual = Matrix.fromFlattenedList(
              [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0], 1, 5,
              dtype: dtype);

          final expected = [
            [1.0, 2.0, 3.0, 4.0, 5.0],
          ];

          expect(actual.rowCount, 1);
          expect(actual.columnCount, 5);
          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test(
            'should create an instance from a flattened collection, 5x2 matrix',
            () {
          final actual = Matrix.fromFlattenedList(
              [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0], 5, 2,
              dtype: dtype);

          final expected = [
            [1.0, 2.0],
            [3.0, 4.0],
            [5.0, 6.0],
            [7.0, 8.0],
            [9.0, 10.0],
          ];

          expect(actual.rowCount, 5);
          expect(actual.columnCount, 2);
          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test(
            'should create an instance from a flattened collection, 5x2 matrix, collection length is 5x2+3',
            () {
          final actual = Matrix.fromFlattenedList([
            1.0,
            2.0,
            3.0,
            4.0,
            5.0,
            6.0,
            7.0,
            8.0,
            9.0,
            10.0,
            11.0,
            12.0,
            13.0
          ], 5, 2, dtype: dtype);

          final expected = [
            [1.0, 2.0],
            [3.0, 4.0],
            [5.0, 6.0],
            [7.0, 8.0],
            [9.0, 10.0],
          ];

          expect(actual.rowCount, 5);
          expect(actual.columnCount, 2);
          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test('should create an instance based on an empty list', () {
          final actual = Matrix.fromFlattenedList([], 0, 0, dtype: dtype);
          final expected = <double>[];

          expect(actual.rowCount, 0);
          expect(actual.columnCount, 0);
          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test(
            'should throw an error if one tries to create a matrix from '
            'flattened collection with improper dimension', () {
          expect(
              () => Matrix.fromFlattenedList([1.0, 2.0, 3.0, 4.0, 5.0], 2, 3,
                  dtype: dtype),
              throwsException);
        });
      });
    });
