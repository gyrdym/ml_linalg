import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixMinTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('min method', () {
        test('should find its min value', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final actual = matrix.min();
          final expected = -3.0;

          expect(actual, equals(expected));
          expect(matrix.dtype, equals(dtype));
        });

        test('should find the matrix min value, 2x5 matrix', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0, 7.0],
            [5.0, 6.0, 7.0, 8.0, 13.5],
          ], dtype: dtype);

          final actual = matrix.min();
          final expected = 1;

          expect(actual, equals(expected));
        });

        test('should find the matrix min value, 1x5 matrix', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0, 7.0],
          ], dtype: dtype);

          final actual = matrix.min();
          final expected = 1;

          expect(actual, equals(expected));
        });

        test('should find the matrix min value, 5x1 matrix', () {
          final matrix = Matrix.fromList([
            [1.0],
            [2.0],
            [-3.0],
            [4.0],
            [7.0],
          ], dtype: dtype);

          final actual = matrix.min();
          final expected = -3;

          expect(actual, equals(expected));
        });

        test(
            'should find the matrix min value, 1x5 matrix, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([
            1.0,
            2.0,
            3.0,
            4.0,
            -7.0,
          ], 1, 5, dtype: dtype);

          final actual = matrix.min();
          final expected = -7;

          expect(actual, equals(expected));
        });

        test(
            'should find the matrix min value, 1x9 matrix, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList(
              [1, 2, 3, 4, 2344.9999, -2, -1000, -10000, 2345, 7, 10], 1, 9,
              dtype: dtype);

          final actual = matrix.min();
          final expected = -10000;

          expect(actual, equals(expected));
        });

        test(
            'should find the matrix min value, 1x1 matrix, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([10000], 1, 1, dtype: dtype);

          final actual = matrix.min();
          final expected = 10000;

          expect(actual, equals(expected));
        });

        test(
            'should find the matrix min value, 1x2 matrix, fromFlattenedList constructor, the matrix has negative infinite value',
            () {
          final matrix = Matrix.fromFlattenedList(
              [-double.infinity, -1e10], 1, 2,
              dtype: dtype);

          final actual = matrix.min();
          final expected = -double.infinity;

          expect(actual, equals(expected));
        });
      });
    });
