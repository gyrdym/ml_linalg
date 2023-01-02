import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/matrix_norm.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixNormTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('norm method', () {
        test('should find a frobenius norm', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, .0, -2.0, -3.0],
          ], dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 17.2626;

          expect(norm, closeTo(expected, 0.0001));
          expect(matrix.dtype, dtype);
        });

        test('should find a frobenius norm, 1x1 matrix', () {
          final matrix = Matrix.fromList([
            [5.0],
          ], dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 5;

          expect(norm, closeTo(expected, 0.0001));
          expect(matrix.dtype, dtype);
        });

        test('should find a frobenius norm, 1x3 matrix', () {
          final matrix = Matrix.fromList([
            [5, 6, 7],
          ], dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 10.488;

          expect(norm, closeTo(expected, 0.0001));
          expect(matrix.dtype, dtype);
        });

        test('should find a frobenius norm, 3x1 matrix', () {
          final matrix = Matrix.fromList([
            [5],
            [6],
            [7],
          ], dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 10.488;

          expect(norm, closeTo(expected, 0.0001));
          expect(matrix.dtype, dtype);
        });

        test('should find a frobenius norm, 2x2 matrix', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0],
            [5.0, 6.0],
          ], dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 8.124;

          expect(norm, closeTo(expected, 0.0001));
          expect(matrix.dtype, dtype);
        });

        test('should find a frobenius norm, 2x5 matrix', () {
          final matrix = Matrix.fromList([
            [1, 2, 3, 4, 5],
            [5, 6, 7, 8, 6],
          ], dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 16.2788;

          expect(norm, closeTo(expected, 0.0001));
          expect(matrix.dtype, dtype);
        });

        test(
            'should find a frobenius norm, 2x5 matrix, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            5,
            5,
            6,
            7,
            8,
            6,
          ], 2, 5, dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 16.2788;

          expect(norm, closeTo(expected, 0.0001));
          expect(matrix.dtype, dtype);
        });

        test('should find a frobenius norm, 5x2 matrix', () {
          final matrix = Matrix.fromList([
            [1, 2],
            [3, 4],
            [5, 5],
            [6, 7],
            [8, 6],
          ], dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 16.2788;

          expect(norm, closeTo(expected, 0.0001));
          expect(matrix.dtype, dtype);
        });

        test(
            'should find a frobenius norm, 5x2 matrix, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            5,
            5,
            6,
            7,
            8,
            6,
          ], 5, 2, dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 16.2788;

          expect(norm, closeTo(expected, 0.0001));
          expect(matrix.dtype, dtype);
        });

        test(
            'should find a frobenius norm, 2x9 matrix, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            5,
            7,
            8,
            9,
            10,
            5,
            6,
            7,
            8,
            6,
            1,
            2,
            3,
            4,
          ], 9, 2, dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 24.2693;

          expect(norm, closeTo(expected, 0.0001));
          expect(matrix.dtype, dtype);
        });

        test(
            'should find a frobenius norm, 2x9 matrix, fromFlattenedList constructor, the source list has more elements than needed',
            () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            5,
            7,
            8,
            9,
            10,
            5,
            6,
            7,
            8,
            6,
            1,
            2,
            3,
            4,
            20,
            32,
            45
          ], 9, 2, dtype: dtype);

          final norm = matrix.norm(MatrixNorm.frobenius);
          final expected = 24.2693;

          expect(norm, closeTo(expected, 0.0001));
          expect(matrix.dtype, dtype);
        });
      });
    });
