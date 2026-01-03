import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void determinantTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('determinant', () {
        test('should return 1 for 0x0 matrix', () {
          final matrix = Matrix.empty(dtype: dtype);
          expect(matrix.determinant(), equals(1.0));
        });

        test('should return 1 for identity matrix', () {
          final matrix = Matrix.identity(3, dtype: dtype);
          expect(matrix.determinant(), closeTo(1.0, 1e-3));
        });

        test('should return product of diagonals for diagonal matrix', () {
          final matrix = Matrix.diagonal([1.0, 2.0, 3.0], dtype: dtype);
          expect(matrix.determinant(), closeTo(6.0, 1e-3));
        });

        test('should compute correctly for 2x2 matrix', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0],
            [3.0, 4.0],
          ], dtype: dtype);
          expect(matrix.determinant(), closeTo(-2.0, 1e-3));
        });

        test('should return 0 for singular matrix', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0],
            [2.0, 4.0],
          ], dtype: dtype);
          expect(matrix.determinant(), closeTo(0.0, 1e-3));
        });

        test('should throw for non-square matrix', () {
          final matrix = Matrix.fromList([
            [1.0],
            [3.0],
          ], dtype: dtype);
          expect(() => matrix.determinant(), throwsA(isA<Exception>()));
        });
      });
    });