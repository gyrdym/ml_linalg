import 'package:ml_linalg/decomposition.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/common/exception/cholesky_inappropriate_matrix_exception.dart';
import 'package:ml_linalg/src/common/exception/cholesky_non_square_matrix_exception.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

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

          expect(() => matrix.decompose(),
              throwsA(isA<CholeskyNonSquareMatrixException>()));
        });
      });
    });
