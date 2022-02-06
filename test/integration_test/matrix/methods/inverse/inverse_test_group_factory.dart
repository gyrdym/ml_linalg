import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/inverse.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/src/common/exception/cholesky_non_square_matrix.dart';
import 'package:ml_linalg/src/common/exception/forward_substitution_non_square_matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';
import '../../../../helpers.dart';

void matrixInverseTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('inverse', () {
        test('should perform cholesky inverse, 3x3 matrix', () {
          final matrix = Matrix.fromList([
            [4, 12, -16],
            [12, 37, -43],
            [-16, -43, 98],
          ], dtype: dtype);
          final inverted = matrix.inverse(Inverse.cholesky);

          expect(
              matrix * inverted,
              iterable2dAlmostEqualTo([
                [1, 0, 0],
                [0, 1, 0],
                [0, 0, 1],
              ], 1e-4));

          expect(matrix.dtype, dtype);
        });

        test('should perform cholesky inverse, empty matrix', () {
          final matrix = Matrix.empty(dtype: dtype);
          final inverted = matrix.inverse(Inverse.cholesky);

          expect(matrix * inverted, iterable2dAlmostEqualTo([], 1e-4));

          expect(matrix.dtype, dtype);
        });

        test('should perform forward substitution inverse, 1x1 matrix', () {
          final matrix = Matrix.fromList([
            [-4],
          ], dtype: dtype);
          final inverted = matrix.inverse(Inverse.forwardSubstitution);

          expect(
              matrix * inverted,
              iterable2dAlmostEqualTo([
                [1],
              ], 1e-4));

          expect(matrix.dtype, dtype);
        });

        test('should perform forward substitution inverse, 2x2 matrix', () {
          final matrix = Matrix.fromList([
            [4, 0],
            [12, 37],
          ], dtype: dtype);
          final inverted = matrix.inverse(Inverse.forwardSubstitution);

          expect(
              matrix * inverted,
              iterable2dAlmostEqualTo([
                [1, 0],
                [0, 1],
              ], 1e-4));

          expect(matrix.dtype, dtype);
        });

        test('should perform forward substitution inverse, 3x3 matrix', () {
          final matrix = Matrix.fromList([
            [4, 0, 0],
            [12, 37, 0],
            [-16, -43, 98],
          ], dtype: dtype);
          final inverted = matrix.inverse(Inverse.forwardSubstitution);

          expect(
              matrix * inverted,
              iterable2dAlmostEqualTo([
                [1, 0, 0],
                [0, 1, 0],
                [0, 0, 1],
              ], 1e-4));

          expect(matrix.dtype, dtype);
        });

        test('should perform forward substitution inverse, 4x4 matrix', () {
          final matrix = Matrix.fromList([
            [4, 0, 0, 0],
            [12, 37, 0, 0],
            [-16, -43, 98, 0],
            [-18, 99, 233, 11],
          ], dtype: dtype);
          final inverted = matrix.inverse(Inverse.forwardSubstitution);

          expect(
              matrix * inverted,
              iterable2dAlmostEqualTo([
                [1, 0, 0, 0],
                [0, 1, 0, 0],
                [0, 0, 1, 0],
                [0, 0, 0, 1],
              ], 1e-4));

          expect(matrix.dtype, dtype);
        });

        test('should perform forward substitution inverse, empty matrix', () {
          final matrix = Matrix.empty(dtype: dtype);
          final inverted = matrix.inverse(Inverse.forwardSubstitution);

          expect(matrix * inverted, iterable2dAlmostEqualTo([], 1e-4));

          expect(matrix.dtype, dtype);
        });

        test(
            'should throw exception for cholesky inverse if matrix is not square',
            () {
          final matrix = Matrix.fromList([
            [4, 12, -16],
            [12, 37, -43],
            [-16, -43, 98],
            [-1, -4, 9],
          ], dtype: dtype);

          expect(() => matrix.inverse(Inverse.cholesky),
              throwsA(isA<CholeskyNonSquareMatrixException>()));
        });

        test(
            'should throw exception for forward substitution inverse if matrix is not square',
            () {
          final matrix = Matrix.fromList([
            [4, 12, -16],
            [12, 37, -43],
            [-16, -43, 98],
            [-1, -4, 9],
          ], dtype: dtype);

          expect(() => matrix.inverse(Inverse.forwardSubstitution),
              throwsA(isA<ForwardSubstitutionNonSquareMatrixException>()));
        });
      });
    });
