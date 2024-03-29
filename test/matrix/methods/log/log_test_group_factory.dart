import 'dart:math' as math;

import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';
import '../../../helpers.dart';

void matrixLogTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('log method', () {
        test(
            'should take a natural log of every matrix element and return '
            'new matrix', () {
          final matrix = Matrix.fromList([
            [1, 2, 3, 4],
            [5, 6, 7, 8],
          ], dtype: dtype);
          final result = matrix.log();

          expect(
              result,
              iterable2dAlmostEqualTo([
                [math.log(1), math.log(2), math.log(3), math.log(4)],
                [math.log(5), math.log(6), math.log(7), math.log(8)],
              ], 1e-3));
          expect(result.dtype, dtype);
        });

        test('should handle a matrix created from columns', () {
          final matrix = Matrix.fromColumns([
            Vector.fromList([1, 2, 3, 4], dtype: dtype),
            Vector.fromList([5, 6, 7, 8], dtype: dtype),
          ], dtype: dtype);
          final result = matrix.log();

          expect(
              result,
              iterable2dAlmostEqualTo([
                [math.log(1), math.log(5)],
                [math.log(2), math.log(6)],
                [math.log(3), math.log(7)],
                [math.log(4), math.log(8)],
              ], 1e-3));
          expect(result.dtype, dtype);
        });

        test(
            'should take a natural log of every matrix element and return '
            'new matrix, 9x1 matrix, fromFlattenedList constructor', () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
          ], 9, 1, dtype: dtype);
          final result = matrix.log();

          expect(
              result,
              iterable2dAlmostEqualTo([
                [math.log(1)],
                [math.log(2)],
                [math.log(3)],
                [math.log(4)],
                [math.log(5)],
                [math.log(6)],
                [math.log(7)],
                [math.log(8)],
                [math.log(9)],
              ], 1e-3));
          expect(result.dtype, dtype);
          expect(result, isNot(same(matrix)));
        });

        test(
            'should take a natural log of every matrix element and return '
            'new matrix, 1x9 matrix, fromFlattenedList constructor', () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
          ], 1, 9, dtype: dtype);
          final result = matrix.log();

          expect(
              result,
              iterable2dAlmostEqualTo([
                [
                  math.log(1),
                  math.log(2),
                  math.log(3),
                  math.log(4),
                  math.log(5),
                  math.log(6),
                  math.log(7),
                  math.log(8),
                  math.log(9)
                ],
              ], 1e-3));
          expect(result.dtype, dtype);
          expect(result, isNot(same(matrix)));
        });

        test('should handle empty matrix', () {
          final matrix = Matrix.fromList([], dtype: dtype);
          final result = matrix.log();

          expect(result, <double>[]);
          expect(result.dtype, dtype);
        });
      });
    });
