import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void traceTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('trace', () {
        test('should return 0 for 0x0 matrix', () {
          final matrix = Matrix.empty(dtype: dtype);
          expect(matrix.trace(), equals(0.0));
        });

        test('should return size for identity matrix', () {
          final matrix = Matrix.identity(3, dtype: dtype);
          expect(matrix.trace(), closeTo(3.0, 1e-3));
        });

        test('should return sum of diagonals for diagonal matrix', () {
          final matrix = Matrix.diagonal([1.0, 2.0, 3.0], dtype: dtype);
          expect(matrix.trace(), closeTo(6.0, 1e-3));
        });

        test('should compute correctly for general square matrix', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0],
            [3.0, 4.0],
          ], dtype: dtype);
          expect(matrix.trace(), closeTo(5.0, 1e-3));
        });

        test('should return 0 for zero diagonal matrix', () {
          final matrix = Matrix.fromList([
            [0.0, 1.0],
            [1.0, 0.0],
          ], dtype: dtype);
          expect(matrix.trace(), closeTo(0.0, 1e-3));
        });

        test('should throw for non-square matrix', () {
          final matrix = Matrix.fromList([
            [1.0],
            [3.0],
          ], dtype: dtype);
          expect(() => matrix.trace(), throwsA(isA<Exception>()));
        });
      });
    });