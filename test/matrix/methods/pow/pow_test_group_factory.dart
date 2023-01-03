import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';
import '../../../helpers.dart';

void matrixPowTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('pow method', () {
        test('should raise all matrix elements to the provided power', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, 0.0, -2.0, -3.0],
          ], dtype: dtype);
          final raised = matrix.pow(3);

          expect(raised, [
            [1.0, 8.0, 27.0, 64.0],
            [125.0, 216.0, 343.0, 512.0],
            [729.0, 0.0, -8.0, -27.0],
          ]);
          expect(matrix.dtype, dtype);
        });

        test(
            'should raise all matrix elements to the provided power, 2x5 matrix',
            () {
          final matrix = Matrix.fromList([
            [1, 2, 3, 4, 5],
            [6, 7, 8, 9, 0],
          ], dtype: dtype);
          final raised = matrix.pow(3);

          expect(raised, [
            [1, 8, 27, 64, 125],
            [216, 343, 512, 729, 0],
          ]);

          expect(matrix.dtype, dtype);
          expect(raised, isNot(same(matrix)));
        });

        test(
            'should raise all matrix elements to the provided power, 2x5 matrix, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            0,
          ], 2, 5, dtype: dtype);
          final raised = matrix.pow(3);

          expect(raised, [
            [1, 8, 27, 64, 125],
            [216, 343, 512, 729, 0],
          ]);

          expect(matrix.dtype, dtype);
          expect(raised, isNot(same(matrix)));
        });

        test(
            'should raise all matrix elements to the provided power, 1x9 matrix, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
          ], 1, 9, dtype: dtype);
          final raised = matrix.pow(3);

          expect(raised, [
            [1, 8, 27, 64, 125, 216, 343, 512, 729],
          ]);

          expect(matrix.dtype, dtype);
          expect(raised, isNot(same(matrix)));
        });

        test(
            'should raise all matrix elements to the provided power, 9x1 matrix, fromFlattenedList constructor',
            () {
          final matrix = Matrix.fromFlattenedList([
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
          ], 9, 1, dtype: dtype);
          final raised = matrix.pow(3);

          expect(raised, [
            [1],
            [8],
            [27],
            [64],
            [125],
            [216],
            [343],
            [512],
            [729],
          ]);

          expect(matrix.dtype, dtype);
          expect(raised, isNot(same(matrix)));
        });

        test('should raise all the matrix elements to 0', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, 0.0, -2.0, -3.0],
          ], dtype: dtype);
          final raised = matrix.pow(0);

          expect(raised, [
            [1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0],
            [1.0, 1.0, 1.0, 1.0],
          ]);
          expect(matrix.dtype, dtype);
        });

        test('should raise all the matrix elements to float power', () {
          final matrix = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0],
            [5.0, 6.0, 7.0, 8.0],
            [9.0, 0.0, -2.0, -3.0],
          ], dtype: dtype);
          final raised = matrix.pow(3.75);

          expect(
              raised,
              iterable2dAlmostEqualTo([
                [1.0, 13.4543, 61.5456, 181.0193],
                [417.9626, 828.0702, 1476.1063, 2435.4961],
                [3787.9951, 0.0, double.nan, double.nan],
              ], 1e-2));
          expect(matrix.dtype, dtype);
        });

        test('should return empty matrix if the source matrix is empty', () {
          final matrix = Matrix.fromList([], dtype: dtype);
          final raised = matrix.pow(3.75);

          expect(raised.hasData, isFalse);
          expect(matrix.dtype, dtype);
        });
      });
    });
