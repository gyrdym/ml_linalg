import 'package:ml_linalg/axis.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/sort_direction.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixSortTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('sort method', () {
        test('should sort matrix row-wise by asc direction', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final expected = [
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ];

          final actual = matrix.sort((vector) => vector[2], Axis.rows,
              SortDirection.asc);

          expect(actual, equals(expected));
          expect(matrix, isNot(same(actual)));
          expect(actual.dtype, dtype);
          expect(matrix.dtype, dtype);
        });

        test('should sort matrix column-wise by asc direction', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final expected = [
            [16.0, 12.0, 8.0, 34.0, 4.0],
            [32.0, 28.0, 24.0, 23.0, 20.0],
            [-12.0, -8.0, 0.0, 12.0, 36.0],
            [3.0, -18.0, 1.0, 11.0, 16.0],
            [2.0, 34.0, 10.0, 10.0, 112.0],
          ];

          final actual = matrix.sort((vector) => vector[2], Axis.columns,
              SortDirection.asc);

          expect(actual, equals(expected));
          expect(matrix, isNot(same(actual)));
          expect(actual.dtype, dtype);
          expect(matrix.dtype, dtype);
        });

        test('should sort matrix row-wise by desc direction', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final expected = [
            [112.0, 10.0, 34.0, 2.0, 10.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
          ];

          final actual = matrix.sort((vector) => vector[2], Axis.rows,
              SortDirection.desc);

          expect(actual, equals(expected));
          expect(matrix, isNot(same(actual)));
          expect(actual.dtype, dtype);
          expect(matrix.dtype, dtype);
        });

        test('should sort matrix column-wise by desc direction', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final expected = [
            [4.0, 34.0, 8.0, 12.0, 16.0],
            [20.0, 23.0, 24.0, 28.0, 32.0],
            [36.0, 12.0, 0.0, -8.0, -12.0],
            [16.0, 11.0, 1.0, -18.0, 3.0],
            [112.0, 10.0, 10.0, 34.0, 2.0],
          ];

          final actual = matrix.sort((vector) => vector[2], Axis.columns,
              SortDirection.desc);

          expect(actual, equals(expected));
          expect(matrix, isNot(same(actual)));
          expect(actual.dtype, dtype);
          expect(matrix.dtype, dtype);
        });
      });
    });
