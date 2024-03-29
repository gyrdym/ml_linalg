import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../dtype_to_title.dart';

void matrixEmptyConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('empty constructor', () {
        test(
            'should create a matrix with both rowCount and colCount '
            'equal 0', () {
          final matrix = Matrix.empty(dtype: dtype);

          expect(matrix.rowCount, 0);
          expect(matrix.columnCount, 0);
        });

        test(
            'should create a matrix with empty rows and columns '
            'collections', () {
          final matrix = Matrix.empty(dtype: dtype);

          expect(matrix.rows, isEmpty);
          expect(matrix.columns, isEmpty);
          expect(matrix.dtype, dtype);
        });

        test(
            'should create a matrix that throws an exception if one tries to '
            'access its elements by index', () {
          final matrix = Matrix.empty(dtype: dtype);

          expect(() => matrix.getRow(0), throwsRangeError);
          expect(() => matrix.getRow(10), throwsRangeError);
          expect(() => matrix[0], throwsRangeError);
          expect(() => matrix[10], throwsRangeError);

          expect(() => matrix.getColumn(0), throwsRangeError);
          expect(() => matrix.getColumn(20), throwsRangeError);

          expect(matrix.dtype, dtype);
        });
      });
    });
