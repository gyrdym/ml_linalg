import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:test/test.dart';

import '../../../../dtype_to_title.dart';

void matrixFromListConstructorTestGroupFactory(DType dtype) =>
    group(dtypeToMatrixTestTitle[dtype], () {
      group('fromList constructor', () {
        test('should create an instance based on given list', () {
          final actual = Matrix.fromList([
            [1.0, 2.0, 3.0, 4.0, 5.0],
            [6.0, 7.0, 8.0, 9.0, 0.0],
          ], dtype: dtype);
          final expected = [
            [1.0, 2.0, 3.0, 4.0, 5.0],
            [6.0, 7.0, 8.0, 9.0, 0.0],
          ];

          expect(actual, equals(expected));
          expect(actual.rowCount, 2);
          expect(actual.columnCount, 5);
          expect(actual.dtype, dtype);
        });

        test(
            'should create an instance based on an empty list (`fromList` '
            'constructor)', () {
          final actual = Matrix.fromList([], dtype: dtype);
          final expected = <double>[];

          expect(actual, equals(expected));
          expect(actual.rowCount, 0);
          expect(actual.columnCount, 0);
          expect(actual.dtype, dtype);
        });

        test(
            'should throw an exception if nested lists of the source list are '
            'of different length, case 1', () {
          final source = <List<double>>[
            [1, 2, 3, 4, 5],
            [1, 2, 3, 4],
            [1, 2, 3],
          ];
          final actual = () => Matrix.fromList(source, dtype: dtype);

          expect(actual, throwsException);
        });

        test(
            'should throw an exception if nested lists of the source list are '
            'of different length, case 2', () {
          final source = <List<double>>[
            [109, 782, 13, 224, 5],
            [51, 22, 13, 4, 10],
            [111, 209, 673, 4],
          ];
          final actual = () => Matrix.fromList(source, dtype: dtype);

          expect(actual, throwsException);
        });
      });
    });
