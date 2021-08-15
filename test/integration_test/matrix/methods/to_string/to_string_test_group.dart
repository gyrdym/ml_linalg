import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixToStringTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('toString method', () {
        test('should provide readable string representation', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final actual = matrix.toString();
          final expected = 'Matrix 5 x 5:\n'
              '(4.0, 8.0, 12.0, 16.0, 34.0)\n'
              '(20.0, 24.0, 28.0, 32.0, 23.0)\n'
              '(36.0, 0.0, -8.0, -12.0, 12.0)\n'
              '(16.0, 1.0, -18.0, 3.0, 11.0)\n'
              '(112.0, 10.0, 34.0, 2.0, 10.0)\n';

          expect(actual, expected);
          expect(matrix.dtype, dtype);
        });

        test(
            'should provide readable string representation for Nx1 matrix, '
            'created from iterable', () {
          final matrix = Matrix.fromList([
            [4.0],
            [20.0],
            [36.0],
            [16.0],
            [112.0],
          ], dtype: dtype);

          final actual = matrix.toString();
          final expected = 'Matrix 5 x 1:\n'
              '(4.0)\n'
              '(20.0)\n'
              '(36.0)\n'
              '(16.0)\n'
              '(112.0)\n';

          expect(actual, expected);
          expect(matrix.dtype, dtype);
        });

        test(
            'should provide readable string representation for Nx1 matrix, '
            'created from columns constructor', () {
          final vector =
              Vector.fromList([4.0, 20.0, 36.0, 16.0, 112.0], dtype: dtype);
          final matrix = Matrix.fromColumns([vector], dtype: dtype);

          final actual = matrix.toString();
          final expected = 'Matrix 5 x 1:\n'
              '(4.0)\n'
              '(20.0)\n'
              '(36.0)\n'
              '(16.0)\n'
              '(112.0)\n';

          expect(actual, expected);
          expect(matrix.dtype, dtype);
          expect(vector.dtype, dtype);
        });

        test(
            'should provide readable string representation for 1xN matrix, '
            'created from iterable', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
          ], dtype: dtype);

          final actual = matrix.toString();

          final expected = 'Matrix 1 x 5:\n'
              '(4.0, 8.0, 12.0, 16.0, 34.0)\n';

          expect(actual, expected);
          expect(matrix.dtype, dtype);
        });

        test(
            'should provide readable string representation for 1xN matrix, '
            'created from rows constructor', () {
          final vector =
              Vector.fromList([4.0, 8.0, 12.0, 16.0, 34.0], dtype: dtype);
          final matrix = Matrix.fromRows([vector], dtype: dtype);

          final actual = matrix.toString();
          final expected = 'Matrix 1 x 5:\n'
              '(4.0, 8.0, 12.0, 16.0, 34.0)\n';

          expect(actual, expected);
          expect(matrix.dtype, dtype);
          expect(vector.dtype, dtype);
        });

        test('should cut string representation of big matrices', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0, 21.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0, 12.0, 124.0],
            [36.0, .0, -8.0, -12.0, 12.0, 43.0, 78.0],
            [16.0, 1.0, -18.0, 3.0, 11.0, 21.0, 22.0],
            [112.0, 10.0, 34.0, 2.0, 10.0, 33.0, 66.0],
            [12.0, 1.0, 4.0, 2.0, 9.0, 39.0, 66.0],
            [11.0, 10.0, 34.0, 1.0, 10.0, 33.0, 16.0],
          ], dtype: dtype);

          final actual = matrix.toString();

          final expected = 'Matrix 7 x 7:\n'
              '(4.0, 8.0, 12.0, 16.0, 34.0, ...)\n'
              '(20.0, 24.0, 28.0, 32.0, 23.0, ...)\n'
              '(36.0, 0.0, -8.0, -12.0, 12.0, ...)\n'
              '(16.0, 1.0, -18.0, 3.0, 11.0, ...)\n'
              '(112.0, 10.0, 34.0, 2.0, 10.0, ...)\n'
              '...';

          expect(actual, expected);
          expect(matrix.dtype, dtype);
        });
      });
    });
