import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixFromColumnsConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('fromColumns constructor', () {
        test(
            'should create an instance with predefined vectors as matrix '
            'columns', () {
          final actual = Matrix.fromColumns([
            Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0], dtype: dtype),
            Vector.fromList([6.0, 7.0, 8.0, 9.0, 0.0], dtype: dtype),
          ], dtype: dtype);

          final expected = [
            [1.0, 6.0],
            [2.0, 7.0],
            [3.0, 8.0],
            [4.0, 9.0],
            [5.0, 0.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 5);
          expect(actual.columnCount, 2);
          expect(actual.dtype, dtype);
        });

        test('should create an instance based on an empty list', () {
          final actual = Matrix.fromColumns([], dtype: dtype);
          final expected = <double>[];

          expect(actual, equals(expected));
          expect(actual.rowCount, 0);
          expect(actual.columnCount, 0);
          expect(actual.dtype, dtype);
        });

        test(
            'should throw an exception if list of vectors of not the same '
            'length is provided', () {
          final source = [
            Vector.fromList([1, 2, 3], dtype: dtype),
            Vector.fromList([1, 2, 3, 4], dtype: dtype),
            Vector.fromList([9, 8, 7], dtype: dtype),
          ];

          expect(
              () => Matrix.fromColumns(source, dtype: dtype), throwsException);
        });

        test('should not use reference to a source list for the cache ', () {
          final source = [
            Vector.fromList([1, 2, 3], dtype: dtype),
            Vector.fromList([1, 2, 3], dtype: dtype),
            Vector.fromList([9, 8, 7], dtype: dtype),
          ];
          final matrix1 = Matrix.fromColumns(source, dtype: dtype);

          source[1] = Vector.fromList([100, 200, 300], dtype: dtype);

          final matrix2 = Matrix.fromColumns(source, dtype: dtype);
          final result = [
            matrix1.getColumn(0) + matrix2.getColumn(0),
            matrix1.getColumn(1) + matrix2.getColumn(1),
            matrix1.getColumn(2) + matrix2.getColumn(2),
          ];

          expect(result, [
            [2, 4, 6],
            [101, 202, 303],
            [18, 16, 14],
          ]);
        });
      });
    });
