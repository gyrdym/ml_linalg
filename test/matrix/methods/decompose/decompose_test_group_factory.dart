import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/common/exception/cholesky_inappropriate_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/cholesky_non_square_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/lu_decomposition_non_square_matrix_exception.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';
import '../../../helpers.dart';

void matrixDecomposeTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('decompose', () {
        test('should perform cholesky decomposition, empty matrix', () {
          final matrix = Matrix.empty(dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.cholesky);

          expect(decomposed.first * decomposed.last, equals(matrix));
          expect(matrix.dtype, dtype);
        });

        test('should perform cholesky decomposition, 1x1 matrix', () {
          final matrix = Matrix.fromList([
            [4],
          ], dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.cholesky);

          expect(decomposed.first * decomposed.last, equals(matrix));
          expect(matrix.dtype, dtype);
        });

        test('should perform cholesky decomposition, 2x2 matrix', () {
          final matrix = Matrix.fromList([
            [4, 12],
            [12, 37],
          ], dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.cholesky);

          expect(decomposed.first * decomposed.last, equals(matrix));
          expect(matrix.dtype, dtype);
        });

        test('should perform cholesky decomposition, 3x3 matrix', () {
          final matrix = Matrix.fromList([
            [4, 12, -16],
            [12, 37, -43],
            [-16, -43, 98],
          ], dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.cholesky);

          expect(decomposed.first * decomposed.last, equals(matrix));
          expect(matrix.dtype, dtype);
        });

        test('should perform cholesky decomposition, 4x4 matrix', () {
          final matrix =
              Matrix.randomSPD(4, seed: 5, min: -100, max: 100, dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.cholesky);

          expect(decomposed.first * decomposed.last,
              iterable2dAlmostEqualTo(matrix, 0.1));
          expect(matrix.dtype, dtype);
        });

        test('should perform cholesky decomposition, 5x5 matrix', () {
          final matrix =
              Matrix.randomSPD(5, seed: 5, min: -100, max: 100, dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.cholesky);

          expect(decomposed.first * decomposed.last,
              iterable2dAlmostEqualTo(matrix, 0.1));
          expect(matrix.dtype, dtype);
        });

        test('should perform cholesky decomposition, 100x100 matrix', () {
          final matrix =
              Matrix.randomSPD(100, seed: 5, min: -100, max: 100, dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.cholesky);

          expect(decomposed.first * decomposed.last,
              iterable2dAlmostEqualTo(matrix, 0.1));
          expect(matrix.dtype, dtype);
        });

        test(
            'should throw exception while decomposing (Cholesky) if a matrix is inappropriate',
            () {
          final matrix = Matrix.fromList([
            [4, 12, 16, 1],
            [12, 37, 43, 1],
            [16, 43, 98, 1],
            [1, 1, 1, 1],
          ], dtype: dtype);

          expect(() => matrix.decompose(Decomposition.cholesky),
              throwsA(isA<CholeskyInappropriateMatrixException>()));
        });

        test('should throw exception (Cholesky) if matrix is not square', () {
          final matrix = Matrix.fromList([
            [4, 12, -16],
            [12, 37, -43],
            [-16, -43, 98],
            [-1, -4, 9],
          ], dtype: dtype);

          expect(() => matrix.decompose(Decomposition.cholesky),
              throwsA(isA<CholeskyNonSquareMatrixException>()));
        });

        test('should perform LU decomposition, empty matrix', () {
          final matrix = Matrix.empty(dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.LU);

          expect(decomposed.first * decomposed.last, equals(matrix));
          expect(matrix.dtype, dtype);
        });

        test('should perform LU decomposition, 1x1 matrix', () {
          final matrix = Matrix.fromList([
            [4],
          ], dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.LU);

          expect(decomposed.first * decomposed.last, equals(matrix));
          expect(matrix.dtype, dtype);
        });

        test('should perform LU decomposition, 2x2 matrix', () {
          final matrix = Matrix.fromList([
            [4, 12],
            [12, 37],
          ], dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.LU);

          expect(decomposed.first * decomposed.last, equals(matrix));
          expect(matrix.dtype, dtype);
        });

        test('should perform LU decomposition, 3x3 matrix', () {
          final matrix = Matrix.fromList([
            [4, 12, -16],
            [12, 37, -43],
            [-16, -43, 98],
          ], dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.LU);

          expect(decomposed.first * decomposed.last, equals(matrix));
          expect(matrix.dtype, dtype);
        });

        test('should perform LU decomposition, 4x4 matrix', () {
          final matrix = Matrix.fromList([
            [4, 12, -16, 1],
            [12, 37, -43, 1],
            [-16, -43, 98, 1],
            [1, 1, 1, 1],
          ], dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.LU);

          expect(decomposed.first * decomposed.last, equals(matrix));
          expect(matrix.dtype, dtype);
        });

        test('should perform LU decomposition, 5x5 matrix', () {
          final matrix = Matrix.fromList([
            [4, 12, -16, 1, 3],
            [12, 37, -43, 1, -4],
            [-16, -43, 98, 1, -7],
            [1, 4, 1, 222, -100],
            [73, 222.3, 11.2, 0, 67],
          ], dtype: dtype);
          final decomposed = matrix.decompose(Decomposition.LU);

          expect(decomposed.first * decomposed.last,
              iterable2dAlmostEqualTo(matrix, 1e-3));
          expect(matrix.dtype, dtype);
        });

        test('should throw exception (LU) if matrix is not square', () {
          final matrix = Matrix.fromList([
            [4, 12, -16],
            [12, 37, -43],
            [-16, -43, 98],
            [-1, -4, 9],
          ], dtype: dtype);

          expect(() => matrix.decompose(Decomposition.LU),
              throwsA(isA<LUDecompositionNonSquareMatrixException>()));
        });
      });
    });
