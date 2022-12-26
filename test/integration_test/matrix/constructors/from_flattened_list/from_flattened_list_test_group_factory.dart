import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

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

          expect(actual.rowsNum, 2);
          expect(actual.columnsNum, 3);
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

          expect(actual.rowsNum, 2);
          expect(actual.columnsNum, 3);
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

          expect(actual.rowsNum, 1);
          expect(actual.columnsNum, 3);
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

          expect(actual.rowsNum, 1);
          expect(actual.columnsNum, 5);
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

          expect(actual.rowsNum, 1);
          expect(actual.columnsNum, 5);
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

          expect(actual.rowsNum, 5);
          expect(actual.columnsNum, 2);
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

          expect(actual.rowsNum, 5);
          expect(actual.columnsNum, 2);
          expect(actual, equals(expected));
          expect(actual.dtype, dtype);
        });

        test(
            'should create an instance from a flattened collection, the instance can perform correct arithmetic operations',
            () {
          final matrix = Matrix.fromFlattenedList([
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
          final actual1 = matrix + 1;
          final actual2 = matrix - 2;
          final actual3 = matrix * 3;

          final expected1 = [
            [2.0, 3.0],
            [4.0, 5.0],
            [6.0, 7.0],
            [8.0, 9.0],
            [10.0, 11.0],
          ];
          final expected2 = [
            [-1.0, 0.0],
            [1.0, 2.0],
            [3.0, 4.0],
            [5.0, 6.0],
            [7.0, 8.0],
          ];
          final expected3 = [
            [3.0, 6.0],
            [9.0, 12.0],
            [15.0, 18.0],
            [21.0, 24.0],
            [27.0, 30.0],
          ];

          expect(actual1, equals(expected1));
          expect(actual2, equals(expected2));
          expect(actual3, equals(expected3));
          expect(matrix.dtype, dtype);
        });

        test('should create an instance based on an empty list', () {
          final actual = Matrix.fromFlattenedList([], 0, 0, dtype: dtype);
          final expected = <double>[];

          expect(actual.rowsNum, 0);
          expect(actual.columnsNum, 0);
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
