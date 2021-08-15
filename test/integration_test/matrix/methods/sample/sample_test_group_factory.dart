import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixSampleTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('sample method', () {
        test(
            'should create a new matrix from the diffrent segments of the '
            'original matrix', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.1],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final actual = matrix.sample(
            rowIndices: [0, 1, 3],
            columnIndices: [1, 3],
          );

          final expected = [
            [8.0, 16.0],
            [24.0, 32.0],
            [1.0, 3.0],
          ];

          expect(actual, equals(expected));
          expect(actual, isNot(same(matrix)));
          expect(actual.dtype, dtype);
          expect(matrix.dtype, dtype);
        });

        test(
            'should create a new matrix from the diffrent segments of the '
            'original matrix even if there are repeating row indices in '
            '`rowIndices` parameter', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.1],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final actual = matrix.sample(
            rowIndices: [0, 1, 0, 1],
            columnIndices: [1, 3],
          );

          final expected = [
            [8.0, 16.0],
            [24.0, 32.0],
            [8.0, 16.0],
            [24.0, 32.0],
          ];

          expect(actual, equals(expected));
          expect(actual, isNot(same(matrix)));
          expect(actual.dtype, dtype);
          expect(matrix.dtype, dtype);
        });

        test(
            'should create a new matrix from the diffrent segments of the '
            'original matrix even if there are repeating column indices in '
            '`columIndices` parameter', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.1],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final actual = matrix.sample(
            rowIndices: [0, 1, 3],
            columnIndices: [1, 1],
          );

          final expected = [
            [8.0, 8.0],
            [24.0, 24.0],
            [1.0, 1.0],
          ];

          expect(actual, equals(expected));
          expect(actual, isNot(same(matrix)));
          expect(actual.dtype, dtype);
          expect(matrix.dtype, dtype);
        });

        test(
            'should throw a range error if one of the column indices is out of '
            'bound', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.1],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final actual = () => matrix.sample(
                rowIndices: [1],
                columnIndices: [1, 2, 3, 4, 5],
              );

          expect(actual, throwsRangeError);
        });

        test(
            'should create a new matrix from the diffrent segments of the '
            'original matrix if given row indices cover the whole rows range of '
            'the original matrix', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.1],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final actual = matrix.sample(
            rowIndices: [0, 1, 2, 3, 4],
            columnIndices: [1, 2],
          );

          final expected = [
            [8.0, 12.0],
            [24.0, 28.0],
            [.0, -8.0],
            [1.0, -18.0],
            [10.0, 34.0],
          ];

          expect(actual, equals(expected));
          expect(actual, isNot(same(matrix)));
          expect(actual.dtype, dtype);
        });

        test(
            'should create a new matrix from the diffrent segments of the '
            'original matrix if given column indices cover the whole columns '
            'range of the original matrix', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final actual = matrix.sample(
            rowIndices: [0, 1],
            columnIndices: [0, 1, 2, 3, 4],
          );

          final expected = [
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
          ];

          expect(actual, equals(expected));
          expect(actual, isNot(same(matrix)));
          expect(actual.dtype, dtype);
        });

        test(
            'should create a new matrix from the diffrent segments of the '
            'original matrix if columnIndices parameter is omitted', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final actual = matrix.sample(
            rowIndices: [0, 3],
          );

          final expected = [
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
          ];

          expect(actual, equals(expected));
          expect(actual, isNot(same(matrix)));
          expect(actual.dtype, dtype);
        });

        test(
            'should create a new matrix from the diffrent segments of the '
            'original matrix if rowIndices parameter is omitted', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final actual = matrix.sample(
            columnIndices: [0, 3],
          );

          final expected = [
            [4.0, 16.0],
            [20.0, 32.0],
            [36.0, -12.0],
            [16.0, 3.0],
            [112.0, 2.0],
          ];

          expect(actual, equals(expected));
          expect(actual, isNot(same(matrix)));
          expect(actual.dtype, dtype);
        });

        test(
            'should create a new matrix from the diffrent segments of the '
            'original matrix if both rowIndices and columnIndices parameters are '
            'omitted', () {
          final matrix = Matrix.fromList([
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ], dtype: dtype);

          final actual = matrix.sample();

          final expected = [
            [4.0, 8.0, 12.0, 16.0, 34.0],
            [20.0, 24.0, 28.0, 32.0, 23.0],
            [36.0, .0, -8.0, -12.0, 12.0],
            [16.0, 1.0, -18.0, 3.0, 11.0],
            [112.0, 10.0, 34.0, 2.0, 10.0],
          ];

          expect(actual, equals(expected));
          expect(actual, isNot(same(matrix)));
          expect(actual.dtype, dtype);
        });
      });
    });
