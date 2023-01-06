import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixProdTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('prod method', () {
        test('should multiply matrix elements', () {
          final result = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
          ], dtype: dtype)
              .prod();

          expect(result, equals(2066365808640));
        });

        test('should multiply matrix elements, fromFlattenedList', () {
          final result = Matrix.fromFlattenedList([
            4.0,
            8.0,
            12.0,
            16.0,
            34.0,
            20.0,
            24.0,
            28.0,
            32.0,
            23.0,
          ], 2, 5, dtype: dtype)
              .prod();

          expect(result, equals(2066365808640));
        });

        test('should multiply matrix elements, fromFlattenedList, 5x2 matrix',
            () {
          final result = Matrix.fromFlattenedList([
            4.0,
            8.0,
            12.0,
            16.0,
            34.0,
            20.0,
            24.0,
            28.0,
            32.0,
            23.0,
          ], 5, 2, dtype: dtype)
              .prod();

          expect(result, equals(2066365808640));
        });

        test(
            'should multiply matrix elements and return 0 if at least one element is zero',
            () {
          final result = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 0.0, 32.0, 23.0],
          ], dtype: dtype)
              .prod();

          expect(result, equals(0));
        });

        test(
            'should multiply matrix elements if there is only one element, '
            'positive number', () {
          final result = Matrix.fromList([
            [4.0],
          ], dtype: dtype)
              .prod();

          expect(result, equals(4));
        });

        test(
            'should multiply matrix elements if there is only one element, '
            'negative number', () {
          final result = Matrix.fromList([
            [-1124.4],
          ], dtype: dtype)
              .prod();

          expect(result, closeTo(-1124.4, 1e-2));
        });

        test(
            'should return zero if the matrix consists of just one zero '
            'element', () {
          final result = Matrix.fromList([
            [0.0],
          ], dtype: dtype)
              .prod();

          expect(result, equals(0));
        });

        test('should return double.nan if the matrix is empty', () {
          final result = Matrix.fromList([], dtype: dtype).prod();

          expect(result, isNaN);
        });
      });
    });
