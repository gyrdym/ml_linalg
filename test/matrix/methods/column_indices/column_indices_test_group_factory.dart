import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixColumnIndicesTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('columnIndices getter', () {
        test('should contain zero-based iterable of ordered column indices',
            () {
          final matrix = Matrix.fromList([
            [1, 2, 3, 4],
            [10, 20, 30, 40],
            [100, 200, 300, 400],
          ], dtype: dtype);

          expect(matrix.columnIndices, equals([0, 1, 2, 3]));
          expect(matrix.dtype, dtype);
        });

        test(
            'should contain zero-based iterable of ordered column indices, 1x1 matrix',
            () {
          final matrix = Matrix.fromList([
            [100],
          ], dtype: dtype);

          expect(matrix.columnIndices, equals([0]));
          expect(matrix.dtype, dtype);
        });

        test(
            'should contain zero-based iterable of ordered column indices, 1x5 matrix',
            () {
          final matrix = Matrix.fromList([
            [100, 200, 300, 400, 500],
          ], dtype: dtype);

          expect(matrix.columnIndices, equals([0, 1, 2, 3, 4]));
          expect(matrix.dtype, dtype);
        });

        test(
            'should contain zero-based iterable of ordered column indices, 5x1 matrix',
            () {
          final matrix = Matrix.fromList([
            [100],
            [200],
            [300],
            [400],
            [500],
          ], dtype: dtype);

          expect(matrix.columnIndices, equals([0]));
          expect(matrix.dtype, dtype);
        });

        test('should contain empty iterable if matrix is empty', () {
          final matrix = Matrix.fromList([], dtype: dtype);

          expect(matrix.columnIndices, isEmpty);
          expect(matrix.dtype, dtype);
        });
      });
    });
